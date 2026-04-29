const express    = require('express');
const cors       = require('cors');
const bodyParser = require('body-parser');
const fs         = require('fs');
const path       = require('path');
const publisher  = require('./publisher');

const app  = express();
const PORT = process.env.PORT || 8080;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Connect to RabbitMQ on startup
publisher.connect();

// Load test data
const loadTestData = (filename) => {
  try {
    const filePath = path.join(__dirname, '../../tickoff/test/fixtures', filename);
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch (error) {
    console.error(`Error loading ${filename}:`, error.message);
    return [];
  }
};

// In-memory data storage
let hotspots   = loadTestData('test_hotspots.json');
let tickReports = loadTestData('test_tick_reports.json');
let firstAid   = loadTestData('test_first_aid.json');

// ── Health check ───────────────────────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ── Message Queue publish endpoint ─────────────────────────────────────────────
// Tharun's Notification Service calls this to push events into the queue.
// POST /api/events/publish
// Body: { "event_type": "notification_sent", "payload": { "type": "tick_alert", ... } }
app.post('/api/events/publish', (req, res) => {
  const { event_type, payload } = req.body;

  if (!event_type) {
    return res.status(400).json({ error: 'event_type is required' });
  }

  const ALLOWED_EVENTS = ['tick_report', 'notification_sent', 'user_registered', 'hotspot_created'];
  if (!ALLOWED_EVENTS.includes(event_type)) {
    return res.status(400).json({
      error: `Unknown event_type. Allowed: ${ALLOWED_EVENTS.join(', ')}`,
    });
  }

  const ok = publisher.publish(event_type, payload || {});

  if (ok) {
    res.status(202).json({ status: 'queued', event_type });
  } else {
    res.status(503).json({ error: 'Message queue unavailable, try again shortly.' });
  }
});

// ── Hotspots ───────────────────────────────────────────────────────────────────
app.get('/api/hotspots', (req, res) => {
  const { riskLevel, verified } = req.query;
  let filtered = [...hotspots];
  if (riskLevel) filtered = filtered.filter(h => h.riskLevel === riskLevel);
  if (verified !== undefined) filtered = filtered.filter(h => h.verified === (verified === 'true'));
  res.json(filtered);
});

app.get('/api/hotspots/:id', (req, res) => {
  const hotspot = hotspots.find(h => h.id === req.params.id);
  if (!hotspot) return res.status(404).json({ error: 'Hotspot not found' });
  res.json(hotspot);
});

app.post('/api/hotspots', (req, res) => {
  const newHotspot = {
    id: `hotspot_${Date.now()}`,
    ...req.body,
    lastUpdated: new Date().toISOString(),
    verified: false,
  };
  hotspots.push(newHotspot);

  // Also publish an event to the queue
  publisher.publish('hotspot_created', { id: newHotspot.id, riskLevel: newHotspot.riskLevel });

  res.status(201).json(newHotspot);
});

// ── Tick Reports ───────────────────────────────────────────────────────────────
app.get('/api/reports', (req, res) => {
  const { riskLevel, verified } = req.query;
  let filtered = [...tickReports];
  if (riskLevel) filtered = filtered.filter(r => r.riskLevel === riskLevel);
  if (verified !== undefined) filtered = filtered.filter(r => r.verified === (verified === 'true'));
  res.json(filtered);
});

app.post('/api/reports', (req, res) => {
  if (req.body.userId || req.body.email || req.body.name) {
    return res.status(400).json({ error: 'Personal data not allowed. Reports must be anonymized.' });
  }

  const newReport = {
    id: `report_${Date.now()}`,
    ...req.body,
    timestamp: new Date().toISOString(),
    verified: false,
    anonymized: true,
  };
  tickReports.push(newReport);

  // Publish to analytics queue
  publisher.publish('tick_report', {
    region:    newReport.region,
    riskLevel: newReport.riskLevel,
  });

  res.status(201).json(newReport);
});

// ── First Aid ──────────────────────────────────────────────────────────────────
app.get('/api/first-aid', (req, res) => {
  const { language } = req.query;
  if (language) {
    const langField = `title_${language}`;
    if (!firstAid.every(item => item[langField])) {
      return res.status(400).json({ error: 'Language not supported' });
    }
  }
  res.json(firstAid);
});

app.get('/api/first-aid/:step', (req, res) => {
  const item = firstAid.find(i => i.step === parseInt(req.params.step));
  if (!item) return res.status(404).json({ error: 'First aid step not found' });
  res.json(item);
});

// ── Nearby Hotspots ────────────────────────────────────────────────────────────
app.post('/api/hotspots/nearby', (req, res) => {
  const { latitude, longitude, radius = 5 } = req.body;
  if (!latitude || !longitude) {
    return res.status(400).json({ error: 'Latitude and longitude required' });
  }
  const nearby = hotspots.filter(h => {
    const latDiff = Math.abs(h.location.lat - latitude);
    const lonDiff = Math.abs(h.location.lon - longitude);
    return Math.sqrt(latDiff * latDiff + lonDiff * lonDiff) < radius / 100;
  });
  res.json(nearby);
});

// ── Error handling ─────────────────────────────────────────────────────────────
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error' });
});

app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Mock API running on port ${PORT}`);
  console.log(`📍 Health:    http://localhost:${PORT}/health`);
  console.log(`🗺️  Hotspots:  http://localhost:${PORT}/api/hotspots`);
  console.log(`📊 Reports:   http://localhost:${PORT}/api/reports`);
  console.log(`🏥 First Aid: http://localhost:${PORT}/api/first-aid`);
  console.log(`📤 Publish:   http://localhost:${PORT}/api/events/publish`);
});