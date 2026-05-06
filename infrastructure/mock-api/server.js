const express    = require('express');
const cors       = require('cors');
const bodyParser = require('body-parser');
const fs         = require('fs');
const path       = require('path');
const publisher  = require('./publisher');

const app  = express();
const PORT = process.env.PORT || 8080;

app.use(cors());
app.use(bodyParser.json());

// Connect to Kafka on startup
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

let hotspots    = loadTestData('test_hotspots.json');
let tickReports = loadTestData('test_tick_reports.json');
let firstAid    = loadTestData('test_first_aid.json');

// ── Health ─────────────────────────────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ── Publish endpoint (for Notification Service / Tharun) ───────────────────────
// POST /api/events/publish
// Body: { "event_type": "notification_sent", "payload": { ... } }
app.post('/api/events/publish', async (req, res) => {
  const { event_type, payload } = req.body;

  if (!event_type) {
    return res.status(400).json({ error: 'event_type is required' });
  }

  const ALLOWED = ['tick_report', 'notification_sent', 'user_registered', 'hotspot_created'];
  if (!ALLOWED.includes(event_type)) {
    return res.status(400).json({
      error: `Unknown event_type. Allowed: ${ALLOWED.join(', ')}`,
    });
  }

  const ok = await publisher.publish(event_type, payload || {});
  ok
      ? res.status(202).json({ status: 'queued', event_type })
      : res.status(503).json({ error: 'Kafka unavailable, try again shortly.' });
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

app.post('/api/hotspots', async (req, res) => {
  const newHotspot = {
    id: `hotspot_${Date.now()}`,
    ...req.body,
    lastUpdated: new Date().toISOString(),
    verified: false,
  };
  hotspots.push(newHotspot);
  await publisher.publish('hotspot_created', { id: newHotspot.id, riskLevel: newHotspot.riskLevel });
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

app.post('/api/reports', async (req, res) => {
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
  await publisher.publish('tick_report', { region: newReport.region, riskLevel: newReport.riskLevel });
  res.status(201).json(newReport);
});

// ── First Aid ──────────────────────────────────────────────────────────────────
app.get('/api/first-aid', (req, res) => {
  const { language } = req.query;
  if (language && !firstAid.every(item => item[`title_${language}`])) {
    return res.status(400).json({ error: 'Language not supported' });
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
  if (!latitude || !longitude) return res.status(400).json({ error: 'Latitude and longitude required' });
  const nearby = hotspots.filter(h => {
    const d = Math.sqrt(Math.pow(h.location.lat - latitude, 2) + Math.pow(h.location.lon - longitude, 2));
    return d < radius / 100;
  });
  res.json(nearby);
});

// ── Error handling ─────────────────────────────────────────────────────────────
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error' });
});

app.use((req, res) => res.status(404).json({ error: 'Endpoint not found' }));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Mock API running on port ${PORT}`);
  console.log(`📤 Publish: http://localhost:${PORT}/api/events/publish`);
});