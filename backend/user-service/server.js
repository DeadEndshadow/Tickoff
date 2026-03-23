require('dotenv').config();
const express = require('express');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const usersRouter = require('./routes/users');
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
  res.json({ service: 'user-service', status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/api/users', usersRouter);

app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

app.use((err, req, res, _next) => {
  logger.error('Unhandled error', { error: err.message });
  res.status(500).json({ error: 'Internal server error' });
});

const PORT = config.services.userPort;
app.listen(PORT, '0.0.0.0', () => {
  logger.info(`User Service running on port ${PORT}`);
});

module.exports = app;
