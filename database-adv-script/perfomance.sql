-- Optimized query with filtering
SELECT
    b.booking_id,
    b.property_id,
    b.user_id,
    b.total_price,
    u.first_name,
    u.last_name,
    u.email,
    py.amount AS payment_amount
FROM bookings AS b
INNER JOIN users AS u ON b.user_id = u.user_id
INNER JOIN properties AS p ON b.property_id = p.property_id
INNER JOIN payments AS py ON b.booking_id = py.booking_id
WHERE b.total_price > 100
  AND u.email LIKE '%@example.com';

-- Explanation:
-- This query retrieves booking details along with user information and payment amounts.
-- It filters bookings with a total price greater than 100 and users with emails containing '@example.com'.
-- The use of INNER JOIN ensures that only records with matching entries in all tables are returned.
-- The query is optimized for performance by ensuring that the joins are efficient and relevant indexes are used.
-- The EXPLAIN statement is used to analyze the query execution plan, which helps identify potential performance bottlenecks and areas for optimization.
EXPLAIN SELECT
    b.booking_id,
    b.property_id,
    b.user_id,
    b.total_price,
    u.first_name,
    u.last_name,
    u.email,
    py.amount AS payment_amount
FROM bookings AS b
INNER JOIN users AS u ON b.user_id = u.user_id
INNER JOIN properties AS p ON b.property_id = p.property_id
INNER JOIN payments AS py ON b.booking_id = py.booking_id
WHERE b.total_price > 100
  AND u.email LIKE '%@example.com';

-- Optimization: Add index to improve join performance
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
