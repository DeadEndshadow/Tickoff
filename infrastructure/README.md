# TickOff Test Infrastructure

This directory contains all infrastructure setup files for the TickOff test environment.

## Contents

### Docker Configuration
- **docker-compose.yml**: Multi-container setup for test environment
- **nginx.conf**: Reverse proxy configuration

### Firebase Configuration
- **firebase.json**: Firebase emulator configuration
- **firestore.rules**: Firestore security rules
- **firestore.indexes.json**: Firestore indexes for queries
- **storage.rules**: Firebase Storage security rules

### Server Setup
- **setup_server.sh**: Automated server installation script
- **init-db.sql**: PostgreSQL database initialization

### Mock API
- **mock-api/**: Node.js Express server for API testing
  - `package.json`: Dependencies
  - `server.js`: API server implementation

## Quick Start

### Option 1: Docker (Recommended for Local Testing)

```bash
cd infrastructure
docker-compose up -d
```

This starts:
- Firebase Emulator Suite (ports 4000, 9099, 9199, 5001, 8085)
- Mock API Server (port 8080)
- PostgreSQL Database (port 5432)
- Nginx Reverse Proxy (port 80)

### Option 2: Firebase Emulator Only

```bash
cd infrastructure
firebase emulators:start
```

Access Emulator UI at: http://localhost:4000

### Option 3: Server Setup (For Remote Server)

```bash
cd infrastructure
chmod +x setup_server.sh
./setup_server.sh
```

## Services

### Firebase Emulator Suite
- **UI**: http://localhost:4000
- **Firestore**: localhost:9099
- **Auth**: localhost:8085
- **Storage**: localhost:9199
- **Functions**: localhost:5001

### Mock API Server
- **Base URL**: http://localhost:8080
- **Health**: http://localhost:8080/health
- **Hotspots**: http://localhost:8080/api/hotspots
- **Reports**: http://localhost:8080/api/reports
- **First Aid**: http://localhost:8080/api/first-aid

### PostgreSQL Database
- **Host**: localhost
- **Port**: 5432
- **Database**: tickoff_test
- **User**: tickoff_user
- **Password**: tickoff_password

## API Endpoints

### Hotspots
- `GET /api/hotspots` - Get all hotspots
- `GET /api/hotspots/:id` - Get single hotspot
- `POST /api/hotspots` - Create new hotspot
- `POST /api/hotspots/nearby` - Find nearby hotspots

### Reports
- `GET /api/reports` - Get all reports
- `POST /api/reports` - Create new report (anonymized)

### First Aid
- `GET /api/first-aid` - Get all first aid steps
- `GET /api/first-aid/:step` - Get specific step

## Configuration

### Environment Variables

Create a `.env` file in this directory:

```env
# Firebase
FIREBASE_PROJECT_ID=tickoff-test

# PostgreSQL
POSTGRES_DB=tickoff_test
POSTGRES_USER=tickoff_user
POSTGRES_PASSWORD=tickoff_password

# API
API_PORT=8080
NODE_ENV=development
```

## Troubleshooting

### Port Conflicts

If ports are already in use:

```bash
# Check what's using the port
lsof -i :9099

# Stop containers and restart
docker-compose down
docker-compose up -d
```

### Firebase Emulator Issues

```bash
# Clear emulator data
firebase emulators:exec --clear "echo 'Cleared'"

# Update Firebase CLI
npm install -g firebase-tools
```

### Docker Issues

```bash
# View logs
docker-compose logs

# Rebuild containers
docker-compose up --build

# Remove all containers and volumes
docker-compose down -v
```

## Security Notes

⚠️ **Important**: These configurations are for testing only!

- All data is anonymized (no PII)
- DSGVO/GDPR compliant test data
- Firestore rules prevent personal data storage
- Mock API validates anonymization

## Maintenance

### Regular Tasks

**Daily**:
- Check container health: `docker-compose ps`
- Review logs: `docker-compose logs --tail=100`

**Weekly**:
- Update Docker images: `docker-compose pull`
- Clear test data: `docker-compose down -v && docker-compose up -d`

**Monthly**:
- Update Firebase CLI: `npm update -g firebase-tools`
- Review and update security rules

## Additional Resources

- [Firebase Emulator Suite Docs](https://firebase.google.com/docs/emulator-suite)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Express.js Docs](https://expressjs.com/)

## Support

For issues or questions:
1. Check the logs: `docker-compose logs [service-name]`
2. Review [TESTUMGEBUNG.md](../doc/TESTUMGEBUNG.md)
3. Create an issue on GitHub

---

**Version**: 1.0.0
**Last Updated**: December 2024
