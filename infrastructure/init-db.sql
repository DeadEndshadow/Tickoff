-- Initialize TickOff Database

-- ─── User & Auth Tables ──────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS refresh_tokens (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_preferences (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    language VARCHAR(10) DEFAULT 'de',
    notifications_enabled BOOLEAN DEFAULT TRUE,
    theme VARCHAR(20) DEFAULT 'system',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS device_tokens (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token TEXT UNIQUE NOT NULL,
    platform VARCHAR(20) DEFAULT 'unknown',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for auth tables
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user ON refresh_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_token ON refresh_tokens(token);
CREATE INDEX IF NOT EXISTS idx_device_tokens_user ON device_tokens(user_id);

-- ─── Test / legacy tables (kept for backward compatibility) ──────────────────

CREATE TABLE IF NOT EXISTS test_hotspots (
    id VARCHAR(50) PRIMARY KEY,
    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,
    city VARCHAR(100),
    region VARCHAR(100),
    risk_level VARCHAR(20),
    report_count INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN DEFAULT FALSE,
    radius INTEGER
);

CREATE TABLE IF NOT EXISTS test_tick_reports (
    id VARCHAR(50) PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,
    risk_level VARCHAR(20),
    verified BOOLEAN DEFAULT FALSE,
    description TEXT,
    environment VARCHAR(50),
    weather VARCHAR(50),
    temperature INTEGER,
    anonymized BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS test_first_aid (
    id VARCHAR(50) PRIMARY KEY,
    step INTEGER,
    title_de TEXT,
    title_en TEXT,
    title_fr TEXT,
    description_de TEXT,
    description_en TEXT,
    description_fr TEXT,
    image_url TEXT,
    duration VARCHAR(50)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_hotspots_location ON test_hotspots(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_hotspots_risk ON test_hotspots(risk_level);
CREATE INDEX IF NOT EXISTS idx_reports_location ON test_tick_reports(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_reports_timestamp ON test_tick_reports(timestamp);

-- Insert sample data (optional - can be loaded from JSON fixtures)
INSERT INTO test_hotspots (id, latitude, longitude, city, region, risk_level, report_count, verified, radius)
VALUES 
    ('hotspot_001', 47.3769, 8.5417, 'Zürich', 'Zürich', 'high', 25, TRUE, 500),
    ('hotspot_002', 46.9480, 7.4474, 'Bern', 'Bern', 'medium', 12, TRUE, 300),
    ('hotspot_003', 47.5596, 7.5886, 'Basel', 'Basel-Stadt', 'low', 5, FALSE, 200)
ON CONFLICT (id) DO NOTHING;

-- Grant permissions (adjust username as needed)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO tickoff_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO tickoff_user;

-- Log initialization
DO $$
BEGIN
    RAISE NOTICE 'TickOff test database initialized successfully';
END $$;
