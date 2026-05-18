/**
 * TickOff TickMap Service
 *
 * Manages tick hotspots and tick reports. All write operations require a valid
 * JWT issued by the Auth Service (verified via GET /auth/verify).
 *
 * Endpoints
 *   GET    /health                  – liveness probe
 *   GET    /api/hotspots            – list hotspots (public, optional filters)
 *   GET    /api/hotspots/:id        – get single hotspot (public)
 *   POST   /api/hotspots            – create hotspot         [JWT required]
 *   PUT    /api/hotspots/:id        – idempotent update      [JWT required]
 *   DELETE /api/hotspots/:id        – remove hotspot         [JWT required]
 *   GET    /api/reports             – list tick reports (public)
 *   POST   /api/reports             – submit anonymised report (public)
 *
 * Idempotency
 *   PUT /api/hotspots/:id uses "INSERT … ON CONFLICT DO UPDATE" so that
 *   repeating the same call always produces the same database state.
 *   DELETE is also idempotent: deleting a non-existent resource returns 204.
 */

'use strict';

const express = require('express');
const cors    = require('cors');
const axios   = require('axios');
const { Pool }  = require('pg');
const { Kafka } = require('kafkajs');

// ── Config ─────────────────────────────────────────────────────────────────────
const PORT          = parseInt(process.env.PORT   || '3002', 10);
const POSTGRES_URL  = process.env.POSTGRES_URL    || 'postgresql://tickoff_user:tickoff_password@localhost:5432/tickoff';
const KAFKA_BROKERS = (process.env.KAFKA_BROKERS  || 'localhost:9092').split(',');
const KAFKA_TOPIC   = process.env.KAFKA_TOPIC     || 'tickoff.events';
const AUTH_SERVICE_URL = process.env.AUTH_SERVICE_URL || 'http://auth-service:3001';

// ── Database ───────────────────────────────────────────────────────────────────
const pool = new Pool({ connectionString: POSTGRES_URL });

async function initDb() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS hotspots (
      id          VARCHAR(50)    PRIMARY KEY,
      latitude    DECIMAL(10,7)  NOT NULL,
      longitude   DECIMAL(10,7)  NOT NULL,
      city        VARCHAR(100),
      region      VARCHAR(100),
      risk_level  VARCHAR(20)    DEFAULT 'low',
      report_count INTEGER       DEFAULT 0,
      verified    BOOLEAN        DEFAULT FALSE,
      radius      INTEGER        DEFAULT 200,
      last_updated TIMESTAMP     DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS tick_reports (
      id          VARCHAR(50)    PRIMARY KEY,
      latitude    DECIMAL(10,7)  NOT NULL,
      longitude   DECIMAL(10,7)  NOT NULL,
      region      VARCHAR(100),
      risk_level  VARCHAR(20)    DEFAULT 'low',
      environment VARCHAR(50),
      weather     VARCHAR(50),
      temperature INTEGER,
      description TEXT,
      verified    BOOLEAN        DEFAULT FALSE,
      anonymized  BOOLEAN        DEFAULT TRUE,
      timestamp   TIMESTAMP      DEFAULT NOW()
    );

    CREATE INDEX IF NOT EXISTS idx_hotspots_risk   ON hotspots(risk_level);
    CREATE INDEX IF NOT EXISTS idx_reports_region  ON tick_reports(region);
  `);
  console.log('[tickmap] DB tables ready');
}

// ── Kafka ──────────────────────────────────────────────────────────────────────
const kafka    = new Kafka({ clientId: 'tickmap-service', brokers: KAFKA_BROKERS });
const producer = kafka.producer();
let kafkaReady = false;

async function connectKafka() {
  try {
    await producer.connect();
    kafkaReady = true;
    console.log('[tickmap] Kafka producer connected');
  } catch (err) {
    console.error('[tickmap] Kafka connection failed – retrying in 5 s:', err.message);
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
    console.log(`[tickmap] Published event: ${eventType}`);
  } catch (err) {
    console.error('[tickmap] Failed to publish event:', err.message);
  }
}

// ── Auth Middleware ────────────────────────────────────────────────────────────
/**
 * Validates JWT by calling the Auth Service's /auth/verify endpoint.
 * This ensures a single source of truth for authentication – no secret is
 * duplicated across services.
 */
async function requireAuth(req, res, next) {
  const authHeader = req.headers.authorization || '';
  if (!authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Authentication required' });
  }

  try {
    const { data } = await axios.get(`${AUTH_SERVICE_URL}/auth/verify`, {
      headers: { Authorization: authHeader },
    });

    if (!data.valid) {
      return res.status(401).json({ error: 'Invalid token' });
    }

    req.user = data.user;
    next();
  } catch (err) {
    if (err.response && err.response.status === 401) {
      return res.status(401).json({ error: 'Invalid or expired token' });
    }
    console.error('[tickmap] Auth service error:', err.message);
    return res.status(503).json({ error: 'Auth service unavailable' });
  }
}

// ── Express App ────────────────────────────────────────────────────────────────
const app = express();

app.use(cors());
app.use(express.json());

app.use((req, _res, next) => {
  console.log(`[tickmap] ${req.method} ${req.path}`);
  next();
});

// ── Health ─────────────────────────────────────────────────────────────────────
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'tickmap-service', timestamp: new Date().toISOString() });
});

// ── GET /api/hotspots ──────────────────────────────────────────────────────────
app.get('/api/hotspots', async (req, res) => {
  const { riskLevel, verified, region } = req.query;
  const conditions = [];
  const values     = [];

  if (riskLevel)            { conditions.push(`risk_level = $${conditions.length + 1}`);  values.push(riskLevel); }
  if (verified !== undefined){ conditions.push(`verified = $${conditions.length + 1}`);   values.push(verified === 'true'); }
  if (region)               { conditions.push(`region ILIKE $${conditions.length + 1}`);  values.push(`%${region}%`); }

  const where = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

  try {
    const result = await pool.query(
      `SELECT id, latitude, longitude, city, region, risk_level AS "riskLevel",
              report_count AS "reportCount", verified, radius,
              last_updated AS "lastUpdated"
       FROM hotspots ${where} ORDER BY last_updated DESC`,
      values,
    );
    res.json(result.rows);
  } catch (err) {
    console.error('[tickmap] GET /api/hotspots error:', err.message);
    res.status(500).json({ error: 'Failed to fetch hotspots' });
  }
});

// ── GET /api/hotspots/:id ──────────────────────────────────────────────────────
app.get('/api/hotspots/:id', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, latitude, longitude, city, region, risk_level AS "riskLevel",
              report_count AS "reportCount", verified, radius,
              last_updated AS "lastUpdated"
       FROM hotspots WHERE id = $1`,
      [req.params.id],
    );

    if (result.rowCount === 0) return res.status(404).json({ error: 'Hotspot not found' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error('[tickmap] GET /api/hotspots/:id error:', err.message);
    res.status(500).json({ error: 'Failed to fetch hotspot' });
  }
});

// ── POST /api/hotspots ─────────────────────────────────────────────────────────
app.post('/api/hotspots', requireAuth, async (req, res) => {
  const { latitude, longitude, city, region, riskLevel, radius } = req.body;

  if (latitude == null || longitude == null) {
    return res.status(400).json({ error: 'latitude and longitude are required' });
  }

  const id = `hotspot_${Date.now()}_${Math.random().toString(36).slice(2, 7)}`;

  try {
    const result = await pool.query(
      `INSERT INTO hotspots (id, latitude, longitude, city, region, risk_level, radius)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING id, latitude, longitude, city, region,
                 risk_level AS "riskLevel", report_count AS "reportCount",
                 verified, radius, last_updated AS "lastUpdated"`,
      [id, latitude, longitude, city || null, region || null, riskLevel || 'low', radius || 200],
    );

    await publishEvent('hotspot_created', { id, region, riskLevel });

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('[tickmap] POST /api/hotspots error:', err.message);
    res.status(500).json({ error: 'Failed to create hotspot' });
  }
});

// ── PUT /api/hotspots/:id ──────────────────────────────────────────────────────
/**
 * Idempotent upsert: calling this endpoint multiple times with the same body
 * always results in the same database state.  Uses INSERT … ON CONFLICT DO UPDATE.
 */
app.put('/api/hotspots/:id', requireAuth, async (req, res) => {
  const { id } = req.params;
  const { latitude, longitude, city, region, riskLevel, verified, radius } = req.body;

  if (latitude == null || longitude == null) {
    return res.status(400).json({ error: 'latitude and longitude are required' });
  }

  try {
    const result = await pool.query(
      `INSERT INTO hotspots (id, latitude, longitude, city, region, risk_level, verified, radius, last_updated)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW())
       ON CONFLICT (id) DO UPDATE SET
         latitude     = EXCLUDED.latitude,
         longitude    = EXCLUDED.longitude,
         city         = EXCLUDED.city,
         region       = EXCLUDED.region,
         risk_level   = EXCLUDED.risk_level,
         verified     = EXCLUDED.verified,
         radius       = EXCLUDED.radius,
         last_updated = NOW()
       RETURNING id, latitude, longitude, city, region,
                 risk_level AS "riskLevel", report_count AS "reportCount",
                 verified, radius, last_updated AS "lastUpdated"`,
      [id, latitude, longitude, city || null, region || null,
       riskLevel || 'low', verified || false, radius || 200],
    );

    res.json(result.rows[0]);
  } catch (err) {
    console.error('[tickmap] PUT /api/hotspots/:id error:', err.message);
    res.status(500).json({ error: 'Failed to update hotspot' });
  }
});

// ── DELETE /api/hotspots/:id ───────────────────────────────────────────────────
/** Idempotent: deleting a non-existent resource is still 204. */
app.delete('/api/hotspots/:id', requireAuth, async (req, res) => {
  try {
    await pool.query('DELETE FROM hotspots WHERE id = $1', [req.params.id]);
    res.status(204).send();
  } catch (err) {
    console.error('[tickmap] DELETE /api/hotspots/:id error:', err.message);
    res.status(500).json({ error: 'Failed to delete hotspot' });
  }
});

// ── GET /api/reports ───────────────────────────────────────────────────────────
app.get('/api/reports', async (req, res) => {
  const { riskLevel, region } = req.query;
  const conditions = [];
  const values     = [];

  if (riskLevel) { conditions.push(`risk_level = $${conditions.length + 1}`); values.push(riskLevel); }
  if (region)    { conditions.push(`region ILIKE $${conditions.length + 1}`); values.push(`%${region}%`); }

  const where = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

  try {
    const result = await pool.query(
      `SELECT id, latitude, longitude, region, risk_level AS "riskLevel",
              environment, weather, temperature, description,
              verified, anonymized, timestamp
       FROM tick_reports ${where} ORDER BY timestamp DESC LIMIT 200`,
      values,
    );
    res.json(result.rows);
  } catch (err) {
    console.error('[tickmap] GET /api/reports error:', err.message);
    res.status(500).json({ error: 'Failed to fetch reports' });
  }
});

// ── POST /api/reports ──────────────────────────────────────────────────────────
app.post('/api/reports', async (req, res) => {
  // Anonymisation guard – no personal data allowed
  if (req.body.userId || req.body.email || req.body.name) {
    return res.status(400).json({ error: 'Personal data not allowed. Reports must be anonymised.' });
  }

  const { latitude, longitude, region, riskLevel, environment, weather, temperature, description } = req.body;

  if (latitude == null || longitude == null) {
    return res.status(400).json({ error: 'latitude and longitude are required' });
  }

  const id = `report_${Date.now()}_${Math.random().toString(36).slice(2, 7)}`;

  try {
    const result = await pool.query(
      `INSERT INTO tick_reports
         (id, latitude, longitude, region, risk_level, environment, weather, temperature, description)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING id, latitude, longitude, region, risk_level AS "riskLevel",
                 environment, weather, temperature, description,
                 verified, anonymized, timestamp`,
      [id, latitude, longitude, region || null, riskLevel || 'low',
       environment || null, weather || null, temperature || null, description || null],
    );

    await publishEvent('tick_report', { region, riskLevel });

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('[tickmap] POST /api/reports error:', err.message);
    res.status(500).json({ error: 'Failed to create report' });
  }
});

// ── 404 / Error handlers ───────────────────────────────────────────────────────
app.use((req, res) => res.status(404).json({ error: 'Endpoint not found' }));

app.use((err, _req, res, _next) => {
  console.error('[tickmap] Unhandled error:', err.message);
  res.status(500).json({ error: 'Internal server error' });
});

// ── Start ──────────────────────────────────────────────────────────────────────
(async () => {
  await initDb();
  await connectKafka();
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`[tickmap] TickMap Service running on port ${PORT}`);
  });
})();
