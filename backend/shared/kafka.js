const { Kafka, logLevel } = require('kafkajs');
const config = require('./config');
const logger = require('./logger');

const kafka = new Kafka({
  clientId: config.kafka.clientId,
  brokers: config.kafka.brokers,
  logLevel: logLevel.WARN,
});

/**
 * Creates a Kafka producer, connects it, and returns a sendMessage helper.
 * @param {string} clientSuffix - Optional suffix to make the client ID unique.
 */
async function createProducer(clientSuffix = '') {
  const producer = kafka.producer();
  await producer.connect();
  logger.info(`Kafka producer connected${clientSuffix ? ' (' + clientSuffix + ')' : ''}`);

  return {
    send: async (topic, messages) => {
      const payload = Array.isArray(messages) ? messages : [messages];
      await producer.send({
        topic,
        messages: payload.map((m) => ({
          key: m.key ? String(m.key) : null,
          value: typeof m.value === 'string' ? m.value : JSON.stringify(m.value),
        })),
      });
    },
    disconnect: () => producer.disconnect(),
  };
}

/**
 * Creates a Kafka consumer for the given groupId, subscribes to topics,
 * and starts consuming with the provided handler.
 * @param {string} groupId
 * @param {string[]} topics
 * @param {(topic: string, partition: number, message: object) => void} handler
 */
async function createConsumer(groupId, topics, handler) {
  const consumer = kafka.consumer({ groupId });
  await consumer.connect();

  for (const topic of topics) {
    await consumer.subscribe({ topic, fromBeginning: false });
  }

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      try {
        const value = message.value ? JSON.parse(message.value.toString()) : null;
        await handler(topic, partition, value);
      } catch (err) {
        logger.error('Kafka message handling error', { topic, error: err.message });
      }
    },
  });

  logger.info('Kafka consumer running', { groupId, topics });
  return { disconnect: () => consumer.disconnect() };
}

module.exports = { createProducer, createConsumer };
