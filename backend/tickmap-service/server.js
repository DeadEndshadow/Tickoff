require('dotenv').config();
const express = require('express');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const hotspotsRouter = require('./routes/hotspots');
const reportsRouter = require('./routes/reports');
const config = require('../shared/config');
const logger = require('../shared/logger');

const app = express();

app.use(cors());
app.use(express.json());

// Rate limiting – 200 requests per IP per 15 minutes
app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 200,
    standardHeaders: true,
    legacyHeaders: false,
    message: { error: 'Too many requests, please try again later.' },
  }),
);

app.get('/health', (req, res) => {
  res.json({ service: 'tickmap-service', status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/api/hotspots', hotspotsRouter);
app.use('/api/reports', reportsRouter);

app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

app.use((err, req, res, _next) => {
  logger.error('Unhandled error', { error: err.message });
  res.status(500).json({ error: 'Internal server error' });
});

const PORT = config.services.tickmapPort;
app.listen(PORT, '0.0.0.0', () => {
  logger.info(`TickMap Service running on port ${PORT}`);
});

module.exports = app;
