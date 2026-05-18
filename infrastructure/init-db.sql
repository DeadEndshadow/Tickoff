-- Initialize TickOff Test Database

-- ── Auth Service tables ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id            SERIAL PRIMARY KEY,
    email         VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    display_name  VARCHAR(100),
    role          VARCHAR(50)  DEFAULT 'user',
    created_at    TIMESTAMP    DEFAULT NOW(),
    updated_at    TIMESTAMP    DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ── TickMap Service tables ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS hotspots (
    id           VARCHAR(50)   PRIMARY KEY,
    latitude     DECIMAL(10,7) NOT NULL,
    longitude    DECIMAL(10,7) NOT NULL,
    city         VARCHAR(100),
    region       VARCHAR(100),
    risk_level   VARCHAR(20)   DEFAULT 'low',
    report_count INTEGER       DEFAULT 0,
    verified     BOOLEAN       DEFAULT FALSE,
    radius       INTEGER       DEFAULT 200,
    last_updated TIMESTAMP     DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tick_reports (
    id           VARCHAR(50)   PRIMARY KEY,
    latitude     DECIMAL(10,7) NOT NULL,
    longitude    DECIMAL(10,7) NOT NULL,
    region       VARCHAR(100),
    risk_level   VARCHAR(20)   DEFAULT 'low',
    environment  VARCHAR(50),
    weather      VARCHAR(50),
    temperature  INTEGER,
    description  TEXT,
    verified     BOOLEAN       DEFAULT FALSE,
    anonymized   BOOLEAN       DEFAULT TRUE,
    timestamp    TIMESTAMP     DEFAULT NOW()
);

-- ── Analytics Service tables (also created by analytics-service itself) ────────
CREATE TABLE IF NOT EXISTS analytics_events (
    id          SERIAL PRIMARY KEY,
    event_type  VARCHAR(100) NOT NULL,
    payload     JSONB,
    received_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tick_report_stats (
    id           SERIAL PRIMARY KEY,
    region       VARCHAR(200),
    risk_level   VARCHAR(50),
    report_count INTEGER DEFAULT 1,
    recorded_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS notification_stats (
    id                SERIAL PRIMARY KEY,
    notification_type VARCHAR(100),
    sent_count        INTEGER DEFAULT 1,
    recorded_at       TIMESTAMP DEFAULT NOW()
);

-- ── Indexes ───────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_hotspots_risk     ON hotspots(risk_level);
CREATE INDEX IF NOT EXISTS idx_hotspots_location ON hotspots(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_reports_region    ON tick_reports(region);
CREATE INDEX IF NOT EXISTS idx_reports_timestamp ON tick_reports(timestamp);

-- ── Sample data ───────────────────────────────────────────────────────────────
INSERT INTO hotspots (id, latitude, longitude, city, region, risk_level, report_count, verified, radius)
VALUES
    ('hotspot_001', 47.3769, 8.5417, 'Zürich',    'Zürich',      'high',   25, TRUE,  500),
    ('hotspot_002', 46.9480, 7.4474, 'Bern',      'Bern',        'medium', 12, TRUE,  300),
    ('hotspot_003', 47.5596, 7.5886, 'Basel',     'Basel-Stadt', 'low',     5, FALSE, 200)
ON CONFLICT (id) DO NOTHING;

-- ── Permissions ───────────────────────────────────────────────────────────────
GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public TO tickoff_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO tickoff_user;

-- ── Done ──────────────────────────────────────────────────────────────────────
DO $$
BEGIN
    RAISE NOTICE 'TickOff database initialized successfully';
END $$;
