const express = require('express');
const { getFirestore } = require('../services/firebase');
const authMiddleware = require('../../shared/auth-middleware');
const { createProducer } = require('../../shared/kafka');
const { TOPICS } = require('../../kafka/topics');
const logger = require('../../shared/logger');

const router = express.Router();
let producer;

// Lazy-init Kafka producer
async function getProducer() {
  if (!producer) {
    producer = await createProducer('tickmap-hotspots');
  }
  return producer;
}

// GET /api/hotspots
router.get('/', async (req, res) => {
  try {
    const db = getFirestore();
    let query = db.collection('hotspots');

    const { riskLevel, verified } = req.query;
    if (riskLevel) query = query.where('riskLevel', '==', riskLevel);
    if (verified !== undefined) query = query.where('verified', '==', verified === 'true');

    const snapshot = await query.get();
    const hotspots = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    res.json(hotspots);
  } catch (err) {
    logger.error('Get hotspots error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/hotspots/:id
router.get('/:id', async (req, res) => {
  try {
    const db = getFirestore();
    const doc = await db.collection('hotspots').doc(req.params.id).get();
    if (!doc.exists) {
      return res.status(404).json({ error: 'Hotspot not found' });
    }
    res.json({ id: doc.id, ...doc.data() });
  } catch (err) {
    logger.error('Get hotspot error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /api/hotspots  (authenticated)
router.post('/', authMiddleware, async (req, res) => {
  try {
    const db = getFirestore();
    const { latitude, longitude, city, region, riskLevel, radius } = req.body;

    if (latitude === undefined || longitude === undefined) {
      return res.status(400).json({ error: 'latitude and longitude are required' });
    }

    const hotspot = {
      latitude,
      longitude,
      city: city || null,
      region: region || null,
      riskLevel: riskLevel || 'medium',
      radius: radius || 300,
      reportCount: 0,
      verified: false,
      createdBy: req.user.sub,
      lastUpdated: new Date().toISOString(),
    };

    const ref = await db.collection('hotspots').add(hotspot);
    const created = { id: ref.id, ...hotspot };

    // Publish event to Kafka
    const prod = await getProducer().catch(() => null);
    if (prod) {
      await prod.send(TOPICS.HOTSPOT_EVENTS, { key: ref.id, value: { type: 'hotspot_created', data: created } });
    }

    logger.info('Hotspot created', { id: ref.id });
    res.status(201).json(created);
  } catch (err) {
    logger.error('Create hotspot error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /api/hotspots/nearby
router.post('/nearby', async (req, res) => {
  try {
    const { latitude, longitude, radius = 5 } = req.body;
    if (latitude === undefined || longitude === undefined) {
      return res.status(400).json({ error: 'latitude and longitude are required' });
    }

    const db = getFirestore();
    const snapshot = await db.collection('hotspots').get();
    const all = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));

    // Simple bounding-box filter using degrees approximation.
    // 1 degree of latitude ≈ 111 km; longitude spacing varies by latitude
    // (accurate enough for the ~10 km radii used in this app).
    const degreeRadius = radius / 111;
    const nearby = all.filter((h) => {
      return (
        Math.abs(h.latitude - latitude) <= degreeRadius &&
        Math.abs(h.longitude - longitude) <= degreeRadius
      );
    });

    res.json(nearby);
  } catch (err) {
    logger.error('Nearby hotspots error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
