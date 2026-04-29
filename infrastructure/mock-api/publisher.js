/**
 * RabbitMQ publisher for TickOff events.
 * Used by the Notification Service to push events into the message queue.
 */

const amqp = require('amqplib');

const RABBITMQ_URL  = process.env.RABBITMQ_URL || 'amqp://tickoff:tickoff@localhost:5672';
const EXCHANGE_NAME = 'tickoff.exchange';
const ROUTING_KEY   = 'tickoff.events';

let channel = null;

async function connect() {
    try {
        const conn = await amqp.connect(RABBITMQ_URL);
        channel = await conn.createChannel();
        await channel.assertExchange(EXCHANGE_NAME, 'topic', { durable: true });
        console.log('✅ RabbitMQ connected');

        conn.on('error', (err) => {
            console.error('RabbitMQ connection error:', err.message);
            channel = null;
            setTimeout(connect, 5000); // reconnect
        });
    } catch (err) {
        console.error('RabbitMQ connection failed:', err.message, '— retrying in 5s');
        setTimeout(connect, 5000);
    }
}

/**
 * Publish an event to the message queue.
 * @param {string} eventType  e.g. "tick_report" | "notification_sent"
 * @param {object} payload    Event-specific data
 */
function publish(eventType, payload) {
    if (!channel) {
        console.warn('RabbitMQ not ready, dropping event:', eventType);
        return false;
    }

    const message = JSON.stringify({
        event_type: eventType,
        payload,
        published_at: new Date().toISOString(),
    });

    channel.publish(
        EXCHANGE_NAME,
        ROUTING_KEY,
        Buffer.from(message),
        { persistent: true },
    );

    console.log(`📤 Published event: ${eventType}`);
    return true;
}

module.exports = { connect, publish };