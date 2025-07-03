
-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Drop old booking table if it exists
DROP TABLE IF EXISTS booking CASCADE;

-- Create partitioned parent table
CREATE TABLE booking (
  booking_id UUID,
  user_id UUID NOT NULL,
  property_id UUID NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price NUMERIC NOT NULL,
  status TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (booking_id, start_date),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (property_id) REFERENCES property(property_id)
) PARTITION BY RANGE (start_date);

-- Create yearly partitions
CREATE TABLE booking_2023 PARTITION OF booking
  FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE booking_2024 PARTITION OF booking
  FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE booking_2025 PARTITION OF booking
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Insert dummy bookings into 2025
INSERT INTO booking (booking_id, user_id, property_id, start_date, end_date, total_price, status)
SELECT
  gen_random_uuid(),
  (SELECT user_id FROM users ORDER BY random() LIMIT 1),
  (SELECT property_id FROM property ORDER BY random() LIMIT 1),
  d::DATE,
  (d + interval '3 days')::DATE,
  (RANDOM() * 1000)::numeric(10,2),
  'confirmed'
FROM generate_series('2025-01-01'::timestamp, '2025-12-31'::timestamp, '10 minutes'::interval) AS d;

-- Optional: Improve query performance with an index on the 2025 partition
CREATE INDEX idx_booking_2025_start_date ON booking_2025(start_date);
