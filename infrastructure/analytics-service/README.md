# Analytics Service

**Owner:** Sebastian Bürgi  
**Role in architecture:** Consumes events from the Message Queue, stores analytics data in PostgreSQL, and exposes a read-only REST API.

---

## How it fits in

```
Notification Service
      │
      ▼  POST /api/events/publish
  Mock API  ──────────────────────▶  RabbitMQ (tickoff.exchange)
                                          │
                                          ▼
                                  Analytics Service (this)
                                          │
                                          ▼
                                      PostgreSQL
```

---

## Running locally

Everything runs via docker-compose from the `infrastructure/` folder:

```bash
cd infrastructure
docker-compose up --build
```

Services:
| Service            | URL                        |
|--------------------|----------------------------|
| Analytics REST API | http://localhost:8090       |
| RabbitMQ UI        | http://localhost:15672      |
| Mock API           | http://localhost:8080       |

RabbitMQ login: `tickoff` / `tickoff`

---

## REST Endpoints

### `GET /health`
Returns service status.

### `GET /api/analytics/events`
Returns the last 100 raw events received from the queue.

```json
[
  {
    "id": 1,
    "event_type": "tick_report",
    "payload": { "region": "Bern", "riskLevel": "high" },
    "received_at": "2026-04-29T10:00:00"
  }
]
```

### `GET /api/analytics/tick-reports`
Returns tick report counts grouped by region and risk level.

### `GET /api/analytics/notifications`
Returns notification counts grouped by type.

---

## Publishing events (for Tharun / Notification Service)

Send a POST to the mock-api publish endpoint:

```bash
curl -X POST http://localhost:8080/api/events/publish \
  -H "Content-Type: application/json" \
  -d '{
    "event_type": "notification_sent",
    "payload": {
      "type": "tick_alert",
      "region": "Bern"
    }
  }'
```

Supported event types:
- `tick_report` — a new tick sighting was reported
- `notification_sent` — a push notification was sent
- `user_registered` — a new user signed up
- `hotspot_created` — a new hotspot was created

---

## Event format

Every message on the queue has this structure:

```json
{
  "event_type": "tick_report",
  "payload": { ... },
  "published_at": "2026-04-29T10:00:00.000Z"
}
```

---

## Adding a new event type

1. Add the type to `ALLOWED_EVENTS` in `mock-api/server.js`
2. Add a handler function in `analytics-service/main.py` under `EVENT_HANDLERS`
3. Add a DB table in `init_db()` if needed