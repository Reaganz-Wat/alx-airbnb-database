
-- Ths SQL Querry uses inner join
SELECT * FROM users AS u INNER JOIN bookings AS b ON u.user_id = b.user_id;

-- More detaid one here
SELECT 
b.booking_id, 
b.property_id, 
u.first_name, 
u.last_name, 
b.start_date, 
b.end_date, 
b.total_price, 
b.status, 
b.created_at 
FROM bookings b INNER JOIN users u ON b.user_id = u.user_id;


-- This is used for left join
SELECT * FROM properties LEFT JOIN reviews ON properties.host_id = reviews.user_id;

SELECT users.first_name, users.email, bookings.total_price, bookings.status FROM users LEFT JOIN bookings ON users.user_id = bookings.user_id UNION SELECT users.first_name, users.email, bookings.total_price, bookings.status FROM users RIGHT JOIN bookings ON users.user_id = bookings.user_id;
