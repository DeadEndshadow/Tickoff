const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// Middleware
app.use(cors());
app.use(bodyParser.json());

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
let hotspots = loadTestData('test_hotspots.json');
let tickReports = loadTestData('test_tick_reports.json');
let firstAid = loadTestData('test_first_aid.json');

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Get all hotspots
app.get('/api/hotspots', (req, res) => {
  const { riskLevel, verified } = req.query;
  
  let filtered = [...hotspots];
  
  if (riskLevel) {
    filtered = filtered.filter(h => h.riskLevel === riskLevel);
  }
  
  if (verified !== undefined) {
    const isVerified = verified === 'true';
    filtered = filtered.filter(h => h.verified === isVerified);
  }
  
  res.json(filtered);
});

// Get single hotspot
app.get('/api/hotspots/:id', (req, res) => {
  const hotspot = hotspots.find(h => h.id === req.params.id);
  
  if (!hotspot) {
    return res.status(404).json({ error: 'Hotspot not found' });
  }
  
  res.json(hotspot);
});

// Create new hotspot
app.post('/api/hotspots', (req, res) => {
  const newHotspot = {
    id: `hotspot_${Date.now()}`,
    ...req.body,
    lastUpdated: new Date().toISOString(),
    verified: false,
  };
  
  hotspots.push(newHotspot);
  res.status(201).json(newHotspot);
});

// Get all tick reports
app.get('/api/reports', (req, res) => {
  const { riskLevel, verified } = req.query;
  
  let filtered = [...tickReports];
  
  if (riskLevel) {
    filtered = filtered.filter(r => r.riskLevel === riskLevel);
  }
  
  if (verified !== undefined) {
    const isVerified = verified === 'true';
    filtered = filtered.filter(r => r.verified === isVerified);
  }
  
  res.json(filtered);
});

// Create new tick report
app.post('/api/reports', (req, res) => {
  // Ensure data is anonymized
  if (req.body.userId || req.body.email || req.body.name) {
    return res.status(400).json({ 
      error: 'Personal data not allowed. Reports must be anonymized.' 
    });
  }
  
  const newReport = {
    id: `report_${Date.now()}`,
    ...req.body,
    timestamp: new Date().toISOString(),
    verified: false,
    anonymized: true,
  };
  
  tickReports.push(newReport);
  res.status(201).json(newReport);
});

// Get first aid information
app.get('/api/first-aid', (req, res) => {
  const { language } = req.query;
  
  if (language) {
    // Filter by language (title_de, title_en, title_fr)
    const langField = `title_${language}`;
    const hasLang = firstAid.every(item => item[langField]);
    
    if (!hasLang) {
      return res.status(400).json({ error: 'Language not supported' });
    }
  }
  
  res.json(firstAid);
});

// Get specific first aid step
app.get('/api/first-aid/:step', (req, res) => {
  const step = parseInt(req.params.step);
  const item = firstAid.find(i => i.step === step);
  
  if (!item) {
    return res.status(404).json({ error: 'First aid step not found' });
  }
  
  res.json(item);
});

// Simulate location-based hotspot search
app.post('/api/hotspots/nearby', (req, res) => {
  const { latitude, longitude, radius = 5 } = req.body;
  
  if (!latitude || !longitude) {
    return res.status(400).json({ error: 'Latitude and longitude required' });
  }
  
  // Simple distance calculation (not accurate, just for testing)
  const nearby = hotspots.filter(h => {
    const latDiff = Math.abs(h.location.lat - latitude);
    const lonDiff = Math.abs(h.location.lon - longitude);
    const distance = Math.sqrt(latDiff * latDiff + lonDiff * lonDiff);
    return distance < radius / 100; // Rough approximation
  });
  
  res.json(nearby);
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Mock API server running on port ${PORT}`);
  console.log(`📍 Health check: http://localhost:${PORT}/health`);
  console.log(`🗺️  Hotspots: http://localhost:${PORT}/api/hotspots`);
  console.log(`📊 Reports: http://localhost:${PORT}/api/reports`);
  console.log(`🏥 First Aid: http://localhost:${PORT}/api/first-aid`);
});
