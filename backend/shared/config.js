require('dotenv').config();

module.exports = {
  jwt: {
    secret: process.env.JWT_SECRET || 'tickoff-jwt-secret-dev',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'tickoff-refresh-secret-dev',
    expiry: process.env.JWT_EXPIRY || '15m',
    refreshExpiry: process.env.JWT_REFRESH_EXPIRY || '7d',
  },
  postgres: {
    host: process.env.POSTGRES_HOST || 'localhost',
    port: parseInt(process.env.POSTGRES_PORT || '5432', 10),
    database: process.env.POSTGRES_DB || 'tickoff',
    user: process.env.POSTGRES_USER || 'tickoff_user',
    password: process.env.POSTGRES_PASSWORD || 'tickoff_password',
  },
  kafka: {
    brokers: (process.env.KAFKA_BROKERS || 'localhost:9092').split(','),
    clientId: process.env.KAFKA_CLIENT_ID || 'tickoff-service',
  },
  firebase: {
    projectId: process.env.FIREBASE_PROJECT_ID || 'tickoff-test',
    emulatorHost: process.env.FIRESTORE_EMULATOR_HOST || null,
  },
  services: {
    authPort: parseInt(process.env.AUTH_SERVICE_PORT || '3001', 10),
    tickmapPort: parseInt(process.env.TICKMAP_SERVICE_PORT || '3002', 10),
    pushPort: parseInt(process.env.PUSH_SERVICE_PORT || '3003', 10),
    userPort: parseInt(process.env.USER_SERVICE_PORT || '3004', 10),
  },
  fcm: {
    serverKey: process.env.FCM_SERVER_KEY || '',
  },
};
