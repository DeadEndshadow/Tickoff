-- Initialize TickOff Test Database

-- Create tables for test data
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
