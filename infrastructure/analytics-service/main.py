"""
TickOff Analytics Service
Consumes events from RabbitMQ and stores analytics data in PostgreSQL.
"""

import os
import json
import logging
import threading
from datetime import datetime

import pika
import psycopg2
import psycopg2.extras
from flask import Flask, jsonify
from urllib.parse import urlparse

# ── Logging ────────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
log = logging.getLogger(__name__)

# ── Config ─────────────────────────────────────────────────────────────────────
RABBITMQ_URL  = os.getenv("RABBITMQ_URL",  "amqp://tickoff:tickoff@localhost:5672")
POSTGRES_URL  = os.getenv("POSTGRES_URL",  "postgresql://tickoff_user:tickoff_password@localhost:5432/tickoff_test")
PORT          = int(os.getenv("PORT", 8090))

QUEUE_NAME    = "tickoff.events"      # Notification Service publishes here
EXCHANGE_NAME = "tickoff.exchange"    # Topic exchange

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
            """
            INSERT INTO tick_report_stats (region, risk_level)
            VALUES (%s, %s)
            """,
            (
                payload.get("region", "unknown"),
                payload.get("riskLevel", "unknown"),
            ),
        )
    log.info("tick_report stored: region=%s risk=%s",
             payload.get("region"), payload.get("riskLevel"))


def handle_notification_sent(payload: dict, conn):
    """Store stats when a push notification is sent."""
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO notification_stats (notification_type)
            VALUES (%s)
            """,
            (payload.get("type", "unknown"),),
        )
    log.info("notification_sent stored: type=%s", payload.get("type"))


EVENT_HANDLERS = {
    "tick_report":       handle_tick_report,
    "notification_sent": handle_notification_sent,
}


# ── RabbitMQ Consumer ──────────────────────────────────────────────────────────
def on_message(channel, method, properties, body):
    """Called for every message received from the queue."""
    try:
        data       = json.loads(body)
        event_type = data.get("event_type", "unknown")
        payload    = data.get("payload", {})

        log.info("Received event: %s", event_type)

        conn = get_db()
        with conn:
            # Always log the raw event
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO analytics_events (event_type, payload) VALUES (%s, %s)",
                    (event_type, json.dumps(payload)),
                )

            # Run the specific handler if we have one
            handler = EVENT_HANDLERS.get(event_type)
            if handler:
                handler(payload, conn)
            else:
                log.warning("No handler for event type: %s", event_type)

        conn.close()
        channel.basic_ack(delivery_tag=method.delivery_tag)

    except Exception as e:
        log.error("Failed to process message: %s", e)
        # Negative-ack so RabbitMQ requeues the message
        channel.basic_nack(delivery_tag=method.delivery_tag, requeue=False)


def start_consumer():
    """Connect to RabbitMQ and start consuming in a background thread."""
    params = pika.URLParameters(RABBITMQ_URL)
    params.heartbeat = 60

    while True:
        try:
            connection = pika.BlockingConnection(params)
            channel    = connection.channel()

            channel.exchange_declare(
                exchange=EXCHANGE_NAME,
                exchange_type="topic",
                durable=True,
            )
            channel.queue_declare(queue=QUEUE_NAME, durable=True)
            channel.queue_bind(
                queue=QUEUE_NAME,
                exchange=EXCHANGE_NAME,
                routing_key="tickoff.#",
            )

            channel.basic_qos(prefetch_count=1)
            channel.basic_consume(queue=QUEUE_NAME, on_message_callback=on_message)

            log.info("Analytics consumer started, waiting for events...")
            channel.start_consuming()

        except pika.exceptions.AMQPConnectionError as e:
            log.error("RabbitMQ connection lost: %s — retrying in 5s", e)
            import time; time.sleep(5)


# ── REST API (read-only analytics endpoints) ───────────────────────────────────
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

    # Start RabbitMQ consumer in background thread
    consumer_thread = threading.Thread(target=start_consumer, daemon=True)
    consumer_thread.start()

    # Start Flask API
    log.info("Analytics API starting on port %d", PORT)
    app.run(host="0.0.0.0", port=PORT)