const express = require('express');
const { getFirestore } = require('../services/firebase');
const authMiddleware = require('../../shared/auth-middleware');
const logger = require('../../shared/logger');

const router = express.Router();

// GET /api/reports
router.get('/', async (req, res) => {
  try {
    const db = getFirestore();
    let query = db.collection('tick_reports');

    const { riskLevel, verified } = req.query;
    if (riskLevel) query = query.where('riskLevel', '==', riskLevel);
    if (verified !== undefined) query = query.where('verified', '==', verified === 'true');

    const snapshot = await query.orderBy('timestamp', 'desc').limit(200).get();
    const reports = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    res.json(reports);
  } catch (err) {
    logger.error('Get reports error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /api/reports  – anonymized, DSGVO-compliant (no auth required for reporting)
router.post('/', async (req, res) => {
  try {
    const { latitude, longitude, riskLevel, environment, weather, temperature, description } =
      req.body;

    if (latitude === undefined || longitude === undefined) {
      return res.status(400).json({ error: 'latitude and longitude are required' });
    }

    // Enforce anonymisation – reject any PII fields
    if (req.body.userId || req.body.email || req.body.name) {
      return res
        .status(400)
        .json({ error: 'Personal data not allowed. Reports must be anonymized.' });
    }

    const report = {
      latitude,
      longitude,
      riskLevel: riskLevel || 'medium',
      environment: environment || null,
      weather: weather || null,
      temperature: temperature || null,
      description: description || null,
      anonymized: true,
      verified: false,
      timestamp: new Date().toISOString(),
    };

    const db = getFirestore();
    const ref = await db.collection('tick_reports').add(report);
    logger.info('Tick report submitted', { id: ref.id });
    res.status(201).json({ id: ref.id, ...report });
  } catch (err) {
    logger.error('Submit report error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
