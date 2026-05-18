"""
TickOff Analytics Service
Consumes events from Kafka and stores analytics data in PostgreSQL.
Exposes Prometheus metrics at /metrics.
"""

import os
import json
import logging
import threading
from datetime import datetime

from confluent_kafka import Consumer, KafkaError
import psycopg2
import psycopg2.extras
from flask import Flask, jsonify
from flask_cors import CORS
from prometheus_client import Counter, Histogram, make_wsgi_app, REGISTRY
from werkzeug.middleware.dispatcher import DispatcherMiddleware
import time

# ── Logging ────────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
log = logging.getLogger(__name__)

# ── Config ─────────────────────────────────────────────────────────────────────
KAFKA_BROKERS = os.getenv("KAFKA_BROKERS", "localhost:9092")
KAFKA_TOPIC   = os.getenv("KAFKA_TOPIC",   "tickoff.events")
POSTGRES_URL  = os.getenv("POSTGRES_URL",  "postgresql://tickoff_user:tickoff_password@localhost:5432/tickoff")
PORT          = int(os.getenv("PORT", 8090))

# ── Prometheus Metrics ─────────────────────────────────────────────────────────
EVENTS_RECEIVED = Counter(
    "tickoff_events_received_total",
    "Total number of events received from Kafka",
    ["event_type"],
)
PROCESSING_ERRORS = Counter(
    "tickoff_processing_errors_total",
    "Total number of event processing errors",
)
EVENT_PROCESSING_TIME = Histogram(
    "tickoff_event_processing_seconds",
    "Time spent processing a Kafka event",
    ["event_type"],
)
HTTP_REQUESTS = Counter(
    "flask_http_request_total",
    "Total HTTP requests to the analytics API",
    ["method", "endpoint", "status"],
)
HTTP_REQUEST_DURATION = Histogram(
    "flask_http_request_duration_seconds",
    "HTTP request duration",
    ["method", "endpoint"],
)

# ── Database ───────────────────────────────────────────────────────────────────
def get_db():
    return psycopg2.connect(POSTGRES_URL)


def init_db():
    conn = get_db()
    with conn:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS analytics_events (
                    id          SERIAL PRIMARY KEY,
                    event_type  VARCHAR(100) NOT NULL,
                    payload     JSONB,
                    received_at TIMESTAMP DEFAULT NOW()
                );

                CREATE TABLE IF NOT EXISTS tick_report_stats (
                    id           SERIAL PRIMARY KEY,
                    region       VARCHAR(200),
                    risk_level   VARCHAR(50),
                    report_count INTEGER DEFAULT 1,
                    recorded_at  TIMESTAMP DEFAULT NOW()
                );

                CREATE TABLE IF NOT EXISTS notification_stats (
                    id                SERIAL PRIMARY KEY,
                    notification_type VARCHAR(100),
                    sent_count        INTEGER DEFAULT 1,
                    recorded_at       TIMESTAMP DEFAULT NOW()
                );
            """)
    conn.close()
    log.info("Database tables ready.")


# ── Event Handlers ─────────────────────────────────────────────────────────────
def handle_tick_report(payload: dict, conn):
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO tick_report_stats (region, risk_level) VALUES (%s, %s)",
            (payload.get("region", "unknown"), payload.get("riskLevel", "unknown")),
        )
    log.info("tick_report stored: region=%s risk=%s",
             payload.get("region"), payload.get("riskLevel"))


def handle_notification_sent(payload: dict, conn):
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO notification_stats (notification_type) VALUES (%s)",
            (payload.get("type", "unknown"),),
        )
    log.info("notification_sent stored: type=%s", payload.get("type"))


EVENT_HANDLERS = {
    "tick_report":       handle_tick_report,
    "notification_sent": handle_notification_sent,
}


# ── Kafka Consumer ─────────────────────────────────────────────────────────────
def process_message(data: dict):
    event_type = data.get("event_type", "unknown")
    payload    = data.get("payload", {})

    log.info("Received event: %s", event_type)
    EVENTS_RECEIVED.labels(event_type=event_type).inc()

    start = time.time()
    try:
        conn = get_db()
        with conn:
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO analytics_events (event_type, payload) VALUES (%s, %s)",
                    (event_type, json.dumps(payload)),
                )
            handler = EVENT_HANDLERS.get(event_type)
            if handler:
                handler(payload, conn)
            else:
                log.warning("No handler for event type: %s", event_type)
        conn.close()
    except Exception as e:
        PROCESSING_ERRORS.inc()
        log.error("Failed to process message: %s", e)
        raise
    finally:
        EVENT_PROCESSING_TIME.labels(event_type=event_type).observe(time.time() - start)


def start_consumer():
    consumer = Consumer({
        "bootstrap.servers": KAFKA_BROKERS,
        "group.id":          "analytics-service",
        "auto.offset.reset": "earliest",
    })
    consumer.subscribe([KAFKA_TOPIC])
    log.info("Kafka consumer started, subscribed to topic: %s", KAFKA_TOPIC)

    while True:
        try:
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    continue
                log.error("Kafka error: %s", msg.error())
                continue
            data = json.loads(msg.value().decode("utf-8"))
            process_message(data)
        except Exception as e:
            log.error("Consumer error: %s", e)


# ── REST API ───────────────────────────────────────────────────────────────────
app = Flask(__name__)
CORS(app)  # Allow cross-origin requests from all origins


@app.before_request
def start_timer():
    from flask import g, request
    g.start_time = time.time()


@app.after_request
def record_request_metrics(response):
    from flask import g, request
    duration = time.time() - g.get("start_time", time.time())
    HTTP_REQUESTS.labels(
        method=request.method,
        endpoint=request.path,
        status=response.status_code,
    ).inc()
    HTTP_REQUEST_DURATION.labels(
        method=request.method,
        endpoint=request.path,
    ).observe(duration)
    return response


@app.get("/health")
def health():
    return jsonify({"status": "ok", "timestamp": datetime.utcnow().isoformat()})


@app.get("/api/analytics/events")
def get_events():
    conn = get_db()
    with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
        cur.execute("""
            SELECT id, event_type, payload, received_at
            FROM analytics_events
            ORDER BY received_at DESC
            LIMIT 100
        """)
        rows = cur.fetchall()
    conn.close()
    return jsonify([dict(r) for r in rows])


@app.get("/api/analytics/tick-reports")
def get_tick_report_stats():
    conn = get_db()
    with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
        cur.execute("""
            SELECT region, risk_level, COUNT(*) AS total
            FROM tick_report_stats
            GROUP BY region, risk_level
            ORDER BY total DESC
        """)
        rows = cur.fetchall()
    conn.close()
    return jsonify([dict(r) for r in rows])


@app.get("/api/analytics/notifications")
def get_notification_stats():
    conn = get_db()
    with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
        cur.execute("""
            SELECT notification_type, COUNT(*) AS total
            FROM notification_stats
            GROUP BY notification_type
            ORDER BY total DESC
        """)
        rows = cur.fetchall()
    conn.close()
    return jsonify([dict(r) for r in rows])


# ── Entry Point ────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    init_db()

    consumer_thread = threading.Thread(target=start_consumer, daemon=True)
    consumer_thread.start()

    # Mount /metrics endpoint via Prometheus WSGI middleware
    app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
        "/metrics": make_wsgi_app()
    })

    log.info("Analytics API starting on port %d", PORT)
    from werkzeug.serving import run_simple
    run_simple("0.0.0.0", PORT, app.wsgi_app)