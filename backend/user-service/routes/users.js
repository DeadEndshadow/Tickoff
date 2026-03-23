const express = require('express');
const { UserModel } = require('../models/user');
const authMiddleware = require('../../shared/auth-middleware');
const { createProducer } = require('../../shared/kafka');
const { TOPICS } = require('../../kafka/topics');
const logger = require('../../shared/logger');

const router = express.Router();
let producer;

async function getProducer() {
  if (!producer) {
    producer = await createProducer('user-service').catch(() => null);
  }
  return producer;
}

// GET /api/users/:id
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    if (req.user.sub !== req.params.id) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    const user = await UserModel.findById(req.params.id);
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json(user);
  } catch (err) {
    logger.error('Get user error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// PUT /api/users/:id
router.put('/:id', authMiddleware, async (req, res) => {
  try {
    if (req.user.sub !== req.params.id) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    const updated = await UserModel.update(req.params.id, req.body);
    if (!updated) return res.status(404).json({ error: 'User not found' });

    const prod = await getProducer();
    if (prod) {
      await prod.send(TOPICS.USER_EVENTS, { key: req.params.id, value: { type: 'user_updated', userId: req.params.id } });
    }

    res.json(updated);
  } catch (err) {
    logger.error('Update user error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/users/:id/preferences
router.get('/:id/preferences', authMiddleware, async (req, res) => {
  try {
    if (req.user.sub !== req.params.id) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    const prefs = await UserModel.getPreferences(req.params.id);
    res.json(prefs);
  } catch (err) {
    logger.error('Get preferences error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// PUT /api/users/:id/preferences
router.put('/:id/preferences', authMiddleware, async (req, res) => {
  try {
    if (req.user.sub !== req.params.id) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    const prefs = await UserModel.upsertPreferences(req.params.id, req.body);
    res.json(prefs);
  } catch (err) {
    logger.error('Update preferences error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// DELETE /api/users/:id  (DSGVO-compliant account deletion)
router.delete('/:id', authMiddleware, async (req, res) => {
  try {
    if (req.user.sub !== req.params.id) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    await UserModel.delete(req.params.id);

    const prod = await getProducer();
    if (prod) {
      await prod.send(TOPICS.USER_EVENTS, { key: req.params.id, value: { type: 'user_deleted', userId: req.params.id } });
    }

    logger.info('User deleted (DSGVO)', { userId: req.params.id });
    res.json({ message: 'Account deleted' });
  } catch (err) {
    logger.error('Delete user error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
