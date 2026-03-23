require('dotenv').config();
const express = require('express');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const authRoutes = require('./routes/auth');
const config = require('../shared/config');
const logger = require('../shared/logger');

const app = express();

app.use(cors());
app.use(express.json());

// Global rate limit – 100 requests per IP per 15 minutes
app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    standardHeaders: true,
    legacyHeaders: false,
    message: { error: 'Too many requests, please try again later.' },
  }),
);

// Stricter rate limit for auth endpoints (20 per 15 min)
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many authentication attempts, please try again later.' },
});

// Health check
app.get('/health', (req, res) => {
  res.json({ service: 'auth-service', status: 'ok', timestamp: new Date().toISOString() });
});

// Auth routes (with stricter rate limiting)
app.use('/auth', authLimiter, authRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

// Error handler
app.use((err, req, res, _next) => {
  logger.error('Unhandled error', { error: err.message });
  res.status(500).json({ error: 'Internal server error' });
});

const PORT = config.services.authPort;
app.listen(PORT, '0.0.0.0', () => {
  logger.info(`Auth Service running on port ${PORT}`);
});

module.exports = app;
