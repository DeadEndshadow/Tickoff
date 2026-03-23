require('dotenv').config();
const express = require('express');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const notificationsRouter = require('./routes/notifications');
const { createConsumer } = require('../shared/kafka');
const { TOPICS } = require('../kafka/topics');
const { sendToTopic } = require('./services/fcm');
const config = require('../shared/config');
const logger = require('../shared/logger');

const app = express();

app.use(cors());
app.use(express.json());

// Rate limiting – 100 requests per IP per 15 minutes
app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    standardHeaders: true,
    legacyHeaders: false,
    message: { error: 'Too many requests, please try again later.' },
  }),
);

app.get('/health', (req, res) => {
  res.json({ service: 'push-service', status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/api/notifications', notificationsRouter);

app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

app.use((err, req, res, _next) => {
  logger.error('Unhandled error', { error: err.message });
  res.status(500).json({ error: 'Internal server error' });
});

// Start Kafka consumer for hotspot-events
createConsumer('push-service-group', [TOPICS.HOTSPOT_EVENTS], async (topic, _partition, message) => {
  if (topic === TOPICS.HOTSPOT_EVENTS && message && message.type === 'hotspot_created') {
    const { data } = message;
    const riskLabel = data.riskLevel || 'medium';
    await sendToTopic('hotspot-alerts', 'Neuer Zecken-Hotspot', `Risikogebiet (${riskLabel}) in ${data.city || 'deiner Nähe'} gemeldet.`, {
      hotspotId: data.id,
      riskLevel: riskLabel,
    }).catch(() => {});
  }
}).catch((err) => {
  logger.warn('Kafka consumer not available', { error: err.message });
});

const PORT = config.services.pushPort;
app.listen(PORT, '0.0.0.0', () => {
  logger.info(`Push Service running on port ${PORT}`);
});

module.exports = app;
