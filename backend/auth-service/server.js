/**
 * TickOff Auth Service
 *
 * Provides centralised authentication for all TickOff microservices.
 * Endpoints
 *   POST /auth/register   – create account, return JWT
 *   POST /auth/login      – validate credentials, return JWT
 *   GET  /auth/verify     – validate a Bearer token (used by other services)
 *   GET  /auth/me         – return profile of authenticated user
 *   GET  /health          – liveness probe
 *
 * Security
 *   - Passwords are hashed with bcrypt (salt rounds = 12)
 *   - JWT is signed with HS256 using JWT_SECRET env variable
 *   - POST /auth/register and POST /auth/login are idempotent-safe:
 *     registering twice with the same e-mail returns 409; login always
 *     produces a fresh token (stateless, no side-effects on DB).
 */

'use strict';

const express = require('express');
const cors    = require('cors');
const bcrypt  = require('bcryptjs');
const jwt     = require('jsonwebtoken');
const { Pool } = require('pg');
const { Kafka } = require('kafkajs');

// ── Config ─────────────────────────────────────────────────────────────────────
const PORT         = parseInt(process.env.PORT  || '3001', 10);
const JWT_SECRET   = process.env.JWT_SECRET     || 'changeme-in-production';
const JWT_EXPIRES  = process.env.JWT_EXPIRES_IN || '24h';
const POSTGRES_URL = process.env.POSTGRES_URL   || 'postgresql://tickoff_user:tickoff_password@localhost:5432/tickoff';
const KAFKA_BROKERS = (process.env.KAFKA_BROKERS || 'localhost:9092').split(',');
const KAFKA_TOPIC   = process.env.KAFKA_TOPIC   || 'tickoff.events';
const BCRYPT_ROUNDS = 12;

// ── Database ───────────────────────────────────────────────────────────────────
const pool = new Pool({ connectionString: POSTGRES_URL });

async function initDb() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS users (
      id          SERIAL PRIMARY KEY,
      email       VARCHAR(255) UNIQUE NOT NULL,
      password_hash VARCHAR(255) NOT NULL,
      display_name  VARCHAR(100),
      role          VARCHAR(50)  DEFAULT 'user',
      created_at    TIMESTAMP    DEFAULT NOW(),
      updated_at    TIMESTAMP    DEFAULT NOW()
    );
    CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
  `);
  console.log('[auth] DB tables ready');
}

// ── Kafka ──────────────────────────────────────────────────────────────────────
const kafka    = new Kafka({ clientId: 'auth-service', brokers: KAFKA_BROKERS });
const producer = kafka.producer();
let kafkaReady = false;

async function connectKafka() {
  try {
    await producer.connect();
    kafkaReady = true;
    console.log('[auth] Kafka producer connected');
  } catch (err) {
    console.error('[auth] Kafka connection failed – retrying in 5 s:', err.message);
    setTimeout(connectKafka, 5000);
  }
}

async function publishEvent(eventType, payload) {
  if (!kafkaReady) return;
  try {
    await producer.send({
      topic:    KAFKA_TOPIC,
      messages: [{ value: JSON.stringify({ event_type: eventType, payload, published_at: new Date().toISOString() }) }],
    });
    console.log(`[auth] Published event: ${eventType}`);
  } catch (err) {
    console.error('[auth] Failed to publish event:', err.message);
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────────
function signToken(user) {
  return jwt.sign(
    { sub: user.id, email: user.email, role: user.role },
    JWT_SECRET,
    { expiresIn: JWT_EXPIRES, algorithm: 'HS256' },
  );
}

// ── Express App ────────────────────────────────────────────────────────────────
const app = express();

app.use(cors());
app.use(express.json());

// Request logging
app.use((req, _res, next) => {
  console.log(`[auth] ${req.method} ${req.path}`);
  next();
});

// ── Health ─────────────────────────────────────────────────────────────────────
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'auth-service', timestamp: new Date().toISOString() });
});

// ── POST /auth/register ────────────────────────────────────────────────────────
/**
 * Body: { email, password, displayName? }
 * Response 201: { token, user: { id, email, displayName, role } }
 * Response 409: if e-mail already registered
 */
app.post('/auth/register', async (req, res) => {
  const { email, password, displayName } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'email and password are required' });
  }
  if (password.length < 8) {
    return res.status(400).json({ error: 'password must be at least 8 characters' });
  }

  try {
    const existing = await pool.query('SELECT id FROM users WHERE email = $1', [email.toLowerCase()]);
    if (existing.rowCount > 0) {
      return res.status(409).json({ error: 'Email already registered' });
    }

    const hash = await bcrypt.hash(password, BCRYPT_ROUNDS);
    const result = await pool.query(
      `INSERT INTO users (email, password_hash, display_name)
       VALUES ($1, $2, $3)
       RETURNING id, email, display_name AS "displayName", role, created_at AS "createdAt"`,
      [email.toLowerCase(), hash, displayName || null],
    );

    const user  = result.rows[0];
    const token = signToken(user);

    await publishEvent('user_registered', { userId: user.id, email: user.email });

    return res.status(201).json({ token, user });
  } catch (err) {
    console.error('[auth] register error:', err.message);
    return res.status(500).json({ error: 'Registration failed' });
  }
});

// ── POST /auth/login ───────────────────────────────────────────────────────────
/**
 * Body: { email, password }
 * Response 200: { token, user: { id, email, displayName, role } }
 * Response 401: if credentials invalid
 * Idempotency: login is a read + token issuance; the DB is never mutated.
 *   Calling login multiple times with valid credentials always returns a fresh
 *   token without any unintended side-effects.
 */
app.post('/auth/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'email and password are required' });
  }

  try {
    const result = await pool.query(
      `SELECT id, email, password_hash, display_name AS "displayName", role
       FROM users WHERE email = $1`,
      [email.toLowerCase()],
    );

    if (result.rowCount === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const user = result.rows[0];
    const valid = await bcrypt.compare(password, user.password_hash);
    if (!valid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = signToken(user);
    const { password_hash, ...safeUser } = user;

    return res.json({ token, user: safeUser });
  } catch (err) {
    console.error('[auth] login error:', err.message);
    return res.status(500).json({ error: 'Login failed' });
  }
});

// ── GET /auth/verify ───────────────────────────────────────────────────────────
/**
 * Header: Authorization: Bearer <token>
 * Response 200: { valid: true, user: { sub, email, role } }
 * Response 401: if token missing or invalid
 *
 * Used by other services to validate tokens without sharing the secret.
 */
app.get('/auth/verify', (req, res) => {
  const authHeader = req.headers.authorization || '';
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;

  if (!token) {
    return res.status(401).json({ valid: false, error: 'No token provided' });
  }

  try {
    const payload = jwt.verify(token, JWT_SECRET, { algorithms: ['HS256'] });
    return res.json({ valid: true, user: { sub: payload.sub, email: payload.email, role: payload.role } });
  } catch (err) {
    return res.status(401).json({ valid: false, error: 'Invalid or expired token' });
  }
});

// ── GET /auth/me ───────────────────────────────────────────────────────────────
/**
 * Header: Authorization: Bearer <token>
 * Response 200: { id, email, displayName, role, createdAt }
 */
app.get('/auth/me', async (req, res) => {
  const authHeader = req.headers.authorization || '';
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;

  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }

  try {
    const payload = jwt.verify(token, JWT_SECRET, { algorithms: ['HS256'] });
    const result  = await pool.query(
      `SELECT id, email, display_name AS "displayName", role, created_at AS "createdAt"
       FROM users WHERE id = $1`,
      [payload.sub],
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    return res.json(result.rows[0]);
  } catch (err) {
    if (err.name === 'JsonWebTokenError' || err.name === 'TokenExpiredError') {
      return res.status(401).json({ error: 'Invalid or expired token' });
    }
    console.error('[auth] /me error:', err.message);
    return res.status(500).json({ error: 'Failed to fetch user' });
  }
});

// ── 404 handler ────────────────────────────────────────────────────────────────
app.use((req, res) => res.status(404).json({ error: 'Endpoint not found' }));

// ── Error handler ──────────────────────────────────────────────────────────────
app.use((err, _req, res, _next) => {
  console.error('[auth] Unhandled error:', err.message);
  res.status(500).json({ error: 'Internal server error' });
});

// ── Start ──────────────────────────────────────────────────────────────────────
(async () => {
  await initDb();
  await connectKafka();
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`[auth] Auth Service running on port ${PORT}`);
  });
})();
