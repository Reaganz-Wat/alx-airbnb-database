-- Initial query
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
INNER JOIN payments AS py ON b.booking_id = py.booking_id;

-- Optimization: Add index to improve join performance
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
