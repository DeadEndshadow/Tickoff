const express = require('express');
const { Pool } = require('pg');
const { sendToDevice, sendToTopic } = require('../services/fcm');
const authMiddleware = require('../../shared/auth-middleware');
const config = require('../../shared/config');
const logger = require('../../shared/logger');

const router = express.Router();
const pool = new Pool(config.postgres);

// POST /api/notifications/register-device
router.post('/register-device', authMiddleware, async (req, res) => {
  try {
    const { deviceToken, platform } = req.body;
    if (!deviceToken) {
      return res.status(400).json({ error: 'deviceToken is required' });
    }

    const userId = req.user.sub;
    await pool.query(
      `INSERT INTO device_tokens (user_id, token, platform, updated_at)
       VALUES ($1, $2, $3, NOW())
       ON CONFLICT (token) DO UPDATE SET user_id = $1, platform = $3, updated_at = NOW()`,
      [userId, deviceToken, platform || 'unknown'],
    );

    logger.info('Device token registered', { userId });
    res.json({ message: 'Device token registered' });
  } catch (err) {
    logger.error('Register device error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /api/notifications/send  (authenticated)
router.post('/send', authMiddleware, async (req, res) => {
  try {
    const { deviceToken, topic, title, body, data } = req.body;
    if (!title || !body) {
      return res.status(400).json({ error: 'title and body are required' });
    }

    let result;
    if (deviceToken) {
      result = await sendToDevice(deviceToken, title, body, data);
    } else if (topic) {
      result = await sendToTopic(topic, title, body, data);
    } else {
      return res.status(400).json({ error: 'deviceToken or topic required' });
    }

    if (!result.success) {
      return res.status(502).json({ error: result.error });
    }

    res.json({ message: 'Notification sent', messageId: result.messageId });
  } catch (err) {
    logger.error('Send notification error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// DELETE /api/notifications/unregister-device
router.delete('/unregister-device', authMiddleware, async (req, res) => {
  try {
    const { deviceToken } = req.body;
    if (!deviceToken) {
      return res.status(400).json({ error: 'deviceToken is required' });
    }

    await pool.query('DELETE FROM device_tokens WHERE token = $1 AND user_id = $2', [
      deviceToken,
      req.user.sub,
    ]);

    res.json({ message: 'Device token removed' });
  } catch (err) {
    logger.error('Unregister device error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
