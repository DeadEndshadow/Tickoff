/**
 * Kafka publisher for TickOff events.
 * Used by the Notification Service to push events into the message queue.
 */

const { Kafka } = require('kafkajs');

const KAFKA_BROKERS = (process.env.KAFKA_BROKERS || 'localhost:9092').split(',');
const TOPIC         = 'tickoff.events';

const kafka    = new Kafka({ clientId: 'mock-api', brokers: KAFKA_BROKERS });
const producer = kafka.producer();

let connected = false;

async function connect() {
    try {
        await producer.connect();
        connected = true;
        console.log('✅ Kafka producer connected');
    } catch (err) {
        console.error('Kafka connection failed:', err.message, '— retrying in 5s');
        setTimeout(connect, 5000);
    }
}

/**
 * Publish an event to the Kafka topic.
 * @param {string} eventType  e.g. "tick_report" | "notification_sent"
 * @param {object} payload    Event-specific data
 */
async function publish(eventType, payload) {
    if (!connected) {
        console.warn('Kafka not ready, dropping event:', eventType);
        return false;
    }

    const message = JSON.stringify({
        event_type:   eventType,
        payload,
        published_at: new Date().toISOString(),
    });

    await producer.send({
        topic:    TOPIC,
        messages: [{ value: message }],
    });

    console.log(`📤 Published event: ${eventType}`);
    return true;
}

module.exports = { connect, publish };