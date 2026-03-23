const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { User } = require('../models/user');
const config = require('../../shared/config');
const logger = require('../../shared/logger');
const { validate } = require('../middleware/validate');

const router = express.Router();
const SALT_ROUNDS = parseInt(process.env.BCRYPT_SALT_ROUNDS || '12', 10);

function generateAccessToken(userId, email) {
  return jwt.sign({ sub: userId, email }, config.jwt.secret, {
    expiresIn: config.jwt.expiry,
  });
}

function generateRefreshToken(userId) {
  return jwt.sign({ sub: userId, type: 'refresh' }, config.jwt.refreshSecret, {
    expiresIn: config.jwt.refreshExpiry,
  });
}

function refreshTokenExpiresAt() {
  // Parse JWT_REFRESH_EXPIRY (e.g. "7d") into a Date
  const raw = config.jwt.refreshExpiry;
  const match = String(raw).match(/^(\d+)([smhd])$/);
  if (!match) return new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  const value = parseInt(match[1], 10);
  const unit = match[2];
  const ms = { s: 1000, m: 60000, h: 3600000, d: 86400000 }[unit];
  return new Date(Date.now() + value * ms);
}

// POST /auth/register
router.post(
  '/register',
  validate({
    email: { required: true, type: 'string', pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/ },
    password: { required: true, type: 'string', minLength: 8 },
  }),
  async (req, res) => {
    try {
      const { email, password } = req.body;

      const existing = await User.findByEmail(email);
      if (existing) {
        return res.status(409).json({ error: 'Email already registered' });
      }

      const passwordHash = await bcrypt.hash(password, SALT_ROUNDS);
      const user = await User.create(email, passwordHash);

      const accessToken = generateAccessToken(user.id, user.email);
      const refreshToken = generateRefreshToken(user.id);
      await User.saveRefreshToken(user.id, refreshToken, refreshTokenExpiresAt());

      logger.info('User registered', { userId: user.id });
      return res.status(201).json({ accessToken, refreshToken, userId: user.id });
    } catch (err) {
      logger.error('Register error', { error: err.message });
      return res.status(500).json({ error: 'Internal server error' });
    }
  },
);

// POST /auth/login
router.post(
  '/login',
  validate({
    email: { required: true, type: 'string' },
    password: { required: true, type: 'string' },
  }),
  async (req, res) => {
    try {
      const { email, password } = req.body;

      const user = await User.findByEmail(email);
      if (!user) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      const valid = await bcrypt.compare(password, user.password_hash);
      if (!valid) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      const accessToken = generateAccessToken(user.id, user.email);
      const refreshToken = generateRefreshToken(user.id);
      await User.saveRefreshToken(user.id, refreshToken, refreshTokenExpiresAt());

      logger.info('User logged in', { userId: user.id });
      return res.json({ accessToken, refreshToken, userId: user.id });
    } catch (err) {
      logger.error('Login error', { error: err.message });
      return res.status(500).json({ error: 'Internal server error' });
    }
  },
);

// POST /auth/refresh
router.post('/refresh', async (req, res) => {
  const { refreshToken } = req.body;
  if (!refreshToken) {
    return res.status(400).json({ error: 'refreshToken required' });
  }

  try {
    const decoded = jwt.verify(refreshToken, config.jwt.refreshSecret);
    if (decoded.type !== 'refresh') {
      return res.status(401).json({ error: 'Invalid token type' });
    }

    const record = await User.findRefreshToken(refreshToken);
    if (!record) {
      return res.status(401).json({ error: 'Refresh token not found or expired' });
    }

    // Rotation: delete old token, issue new pair
    await User.deleteRefreshToken(refreshToken);

    const user = await User.findById(decoded.sub);
    if (!user) {
      return res.status(401).json({ error: 'User not found' });
    }

    const newAccessToken = generateAccessToken(user.id, user.email);
    const newRefreshToken = generateRefreshToken(user.id);
    await User.saveRefreshToken(user.id, newRefreshToken, refreshTokenExpiresAt());

    return res.json({ accessToken: newAccessToken, refreshToken: newRefreshToken });
  } catch (err) {
    logger.warn('Refresh token error', { error: err.message });
    return res.status(401).json({ error: 'Invalid or expired refresh token' });
  }
});

// POST /auth/logout
router.post('/logout', async (req, res) => {
  const { refreshToken } = req.body;
  if (refreshToken) {
    await User.deleteRefreshToken(refreshToken).catch(() => {});
  }
  return res.json({ message: 'Logged out' });
});

// GET /auth/verify
router.get('/verify', (req, res) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ valid: false, error: 'No token provided' });
  }

  const token = authHeader.slice(7);
  try {
    const decoded = jwt.verify(token, config.jwt.secret);
    return res.json({ valid: true, userId: decoded.sub, email: decoded.email });
  } catch (err) {
    return res.status(401).json({ valid: false, error: err.message });
  }
});

module.exports = router;
