const admin = require('firebase-admin');
const config = require('../../shared/config');
const logger = require('../../shared/logger');

// If running against the Firebase Emulator, point the SDK at it
if (config.firebase.emulatorHost) {
  process.env.FIRESTORE_EMULATOR_HOST = config.firebase.emulatorHost;
}

let db;

function getFirestore() {
  if (!db) {
    if (!admin.apps.length) {
      admin.initializeApp({
        projectId: config.firebase.projectId,
        // In production supply a service account via GOOGLE_APPLICATION_CREDENTIALS
        // or by passing credential: admin.credential.cert(serviceAccount)
      });
    }
    db = admin.firestore();
    logger.info('Firebase Admin SDK initialised', { projectId: config.firebase.projectId });
  }
  return db;
}

module.exports = { getFirestore };
