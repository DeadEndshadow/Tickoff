const admin = require('firebase-admin');
const logger = require('../../shared/logger');

let messaging;

function getMessaging() {
  if (!messaging) {
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    messaging = admin.messaging();
  }
  return messaging;
}

/**
 * Send a push notification via FCM to a single device token.
 */
async function sendToDevice(deviceToken, title, body, data = {}) {
  try {
    const message = {
      token: deviceToken,
      notification: { title, body },
      data,
      android: { priority: 'high' },
      apns: { payload: { aps: { sound: 'default' } } },
    };
    const response = await getMessaging().send(message);
    logger.info('FCM notification sent', { messageId: response, token: deviceToken });
    return { success: true, messageId: response };
  } catch (err) {
    logger.error('FCM send error', { error: err.message, token: deviceToken });
    return { success: false, error: err.message };
  }
}

/**
 * Send a push notification to a topic (e.g. 'hotspot-alerts').
 */
async function sendToTopic(topic, title, body, data = {}) {
  try {
    const message = {
      topic,
      notification: { title, body },
      data,
    };
    const response = await getMessaging().send(message);
    logger.info('FCM topic notification sent', { messageId: response, topic });
    return { success: true, messageId: response };
  } catch (err) {
    logger.error('FCM topic send error', { error: err.message, topic });
    return { success: false, error: err.message };
  }
}

module.exports = { sendToDevice, sendToTopic };
