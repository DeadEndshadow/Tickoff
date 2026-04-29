"""
TickOff Analytics Service
Consumes events from Kafka and stores analytics data in PostgreSQL.
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

# ── Database ───────────────────────────────────────────────────────────────────
def get_db():
    """Open a new PostgreSQL connection."""
    return psycopg2.connect(POSTGRES_URL)


def init_db():
    """Create analytics tables if they don't exist yet."""
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
    """Store stats when a new tick report is submitted."""
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO tick_report_stats (region, risk_level) VALUES (%s, %s)",
            (payload.get("region", "unknown"), payload.get("riskLevel", "unknown")),
        )
    log.info("tick_report stored: region=%s risk=%s",
             payload.get("region"), payload.get("riskLevel"))


def handle_notification_sent(payload: dict, conn):
    """Store stats when a push notification is sent."""
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
    """Process a single decoded Kafka message."""
    event_type = data.get("event_type", "unknown")
    payload    = data.get("payload", {})

    log.info("Received event: %s", event_type)

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


def start_consumer():
    """Connect to Kafka and consume messages in a background thread."""
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
            log.error("Failed to process message: %s", e)


# ── REST API ───────────────────────────────────────────────────────────────────
app = Flask(__name__)


@app.get("/health")
def health():
    return jsonify({"status": "ok", "timestamp": datetime.utcnow().isoformat()})


@app.get("/api/analytics/events")
def get_events():
    """Return the last 100 raw analytics events."""
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
    """Return tick report counts grouped by region and risk level."""
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
    """Return notification counts grouped by type."""
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

    log.info("Analytics API starting on port %d", PORT)
    app.run(host="0.0.0.0", port=PORT)