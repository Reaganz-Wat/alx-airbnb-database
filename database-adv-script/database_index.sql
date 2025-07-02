-- Database Index Creation Script
-- File: database_index.sql
-- Purpose: Create indexes to optimize query performance for Airbnb clone database

-- =====================================================
-- PRIMARY KEY INDEXES (Usually created automatically)
-- =====================================================
-- These are typically created when tables are created with PRIMARY KEY constraints
-- ALTER TABLE users ADD PRIMARY KEY (user_id);
-- ALTER TABLE properties ADD PRIMARY KEY (property_id);
-- ALTER TABLE bookings ADD PRIMARY KEY (booking_id);
-- ALTER TABLE reviews ADD PRIMARY KEY (review_id);

-- =====================================================
-- FOREIGN KEY INDEXES
-- =====================================================
-- Index on bookings.user_id for JOIN operations with users table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);

-- Index on bookings.property_id for JOIN operations with properties table
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- Index on reviews.property_id for JOIN operations with properties table
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

-- Index on reviews.user_id for JOIN operations with users table (if exists)
CREATE INDEX idx_reviews_user_id ON reviews(user_id);

-- =====================================================
-- SINGLE COLUMN INDEXES
-- =====================================================
-- Index on user email for login/authentication queries
CREATE INDEX idx_users_email ON users(email);

-- Index on user role for filtering by user type
CREATE INDEX idx_users_role ON users(role);

-- Index on booking status for filtering active/cancelled bookings
CREATE INDEX idx_bookings_status ON bookings(status);

-- Index on booking dates for date range queries
CREATE INDEX idx_bookings_start_date ON bookings(start_date);
CREATE INDEX idx_bookings_end_date ON bookings(end_date);

-- Index on property location for location-based searches
CREATE INDEX idx_properties_location ON properties(location);

-- Index on property price for price range filtering
CREATE INDEX idx_properties_pricepernight ON properties(pricepernight);

-- Index on review rating for filtering by rating
CREATE INDEX idx_reviews_rating ON reviews(rating);

-- Index on created_at columns for sorting by creation time
CREATE INDEX idx_users_created_at ON users(created_at);
CREATE INDEX idx_bookings_created_at ON bookings(created_at);
CREATE INDEX idx_reviews_created_at ON reviews(created_at);

-- =====================================================
-- COMPOSITE INDEXES
-- =====================================================
-- Composite index for date range queries on bookings
CREATE INDEX idx_bookings_dates_range ON bookings(start_date, end_date);

-- Composite index for property location and price filtering
CREATE INDEX idx_properties_location_price ON properties(location, pricepernight);

-- Composite index for user role and status queries
CREATE INDEX idx_users_role_created ON users(role, created_at);

-- Composite index for reviews by property and rating
CREATE INDEX idx_reviews_property_rating ON reviews(property_id, rating);

-- Composite index for bookings by user and status
CREATE INDEX idx_bookings_user_status ON bookings(user_id, status);

-- Composite index for bookings by property and dates
CREATE INDEX idx_bookings_property_dates ON bookings(property_id, start_date, end_date);

-- =====================================================
-- COVERING INDEXES (for specific query optimization)
-- =====================================================
-- Covering index for booking count queries (includes all needed columns)
CREATE INDEX idx_bookings_user_count_covering ON bookings(user_id, booking_id, created_at);

-- Covering index for property booking statistics
CREATE INDEX idx_bookings_property_count_covering ON bookings(property_id, booking_id, status);

-- =====================================================
-- PARTIAL INDEXES (MySQL 8.0+ or filtered indexes)
-- =====================================================
-- Note: MySQL doesn't support partial indexes like PostgreSQL
-- But we can create functional indexes in MySQL 8.0+

-- For MySQL 8.0+: Functional index on active bookings only
-- CREATE INDEX idx_bookings_active ON bookings((CASE WHEN status = 'confirmed' THEN user_id END));

-- =====================================================
-- ADDITIONAL OPTIMIZATION INDEXES
-- =====================================================
-- Index for full-text search on property descriptions (if needed)
-- ALTER TABLE properties ADD FULLTEXT(name, description);

-- Index for spatial queries (if using geographic data)
-- CREATE SPATIAL INDEX idx_properties_coordinates ON properties(coordinates);

-- =====================================================
-- PERFORMANCE MEASUREMENT QUERIES
-- =====================================================
-- Note: MySQL uses EXPLAIN instead of EXPLAIN ANALYZE
-- These queries demonstrate performance before and after indexing

-- Query 1: Users with booking count (Before and After Index)
-- Before indexing (run this first, then create indexes, then run again)
EXPLAIN ANALYZE SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at,
    b.book_count
FROM
    users AS u
INNER JOIN (
    SELECT
        user_id,
        COUNT(*) AS book_count
    FROM
        bookings
    GROUP BY
        user_id
) AS b ON u.user_id = b.user_id;

-- Query 2: Properties with booking rankings
EXPLAIN ANALYZE SELECT
    *
FROM
    properties AS p
INNER JOIN (
    SELECT
        property_id,
        booking_count,
        RANK() OVER (
            ORDER BY
                booking_count DESC
        ) AS booking_rank
    FROM
        (
            SELECT
                property_id,
                COUNT(*) AS booking_count
            FROM
                bookings
            GROUP BY
                property_id
        ) AS booking_summary
) AS r ON p.property_id = r.property_id;

-- Query 3: ROW_NUMBER ranking
EXPLAIN ANALYZE SELECT
    property_id,
    booking_count,
    ROW_NUMBER() OVER (
        ORDER BY booking_count DESC
    ) AS booking_position
FROM (
    SELECT
        property_id,
        COUNT(*) AS booking_count
    FROM bookings
    GROUP BY property_id
) AS booking_summary;

-- Query 4: Simple JOIN between users and bookings
EXPLAIN ANALYZE SELECT * 
FROM users AS u 
INNER JOIN bookings AS b ON u.user_id = b.user_id;

-- Query 5: Properties with reviews (LEFT JOIN)
EXPLAIN ANALYZE SELECT * 
FROM properties 
LEFT JOIN reviews ON properties.property_id = reviews.property_id 
ORDER BY properties.property_id;

-- Query 6: Properties with high-rated reviews
EXPLAIN ANALYZE SELECT
    *
FROM
    properties
WHERE
    property_id IN (
        SELECT
            property_id
        FROM
            reviews
        GROUP BY
            property_id
        HAVING
            AVG(rating) > 4.0
    );

-- Query 7: RIGHT JOIN with booking counts
EXPLAIN ANALYZE SELECT
    *
FROM
    users
RIGHT JOIN (
    SELECT
        user_id,
        COUNT(*) AS booking_times
    FROM
        bookings
    GROUP BY
        user_id
    HAVING
        COUNT(*) > 3
) AS tb ON users.user_id = tb.user_id;

-- =====================================================
-- NOTES FOR MAINTENANCE
-- =====================================================
/*
1. Monitor index usage with:
   SELECT * FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'your_database_name';

2. Check index efficiency with:
   SHOW INDEX FROM table_name;

3. Remove unused indexes:
   DROP INDEX index_name ON table_name;

4. Analyze table statistics after creating indexes:
   ANALYZE TABLE table_name;

5. Performance measurement:
   - Run EXPLAIN ANALYZE queries before creating indexes
   - Create the indexes above
   - Run EXPLAIN ANALYZE queries again to compare
   - Document the differences in execution time and query plans

6. Consider the trade-offs:
   - Indexes speed up SELECT queries but slow down INSERT/UPDATE/DELETE
   - Each index requires additional storage space
   - Too many indexes can hurt overall performance

7. MySQL vs PostgreSQL:
   - This file uses EXPLAIN ANALYZE for compatibility
   - In MySQL, you can use EXPLAIN or EXPLAIN FORMAT=JSON for detailed analysis
   - EXPLAIN ANALYZE provides actual execution times and row counts
*/