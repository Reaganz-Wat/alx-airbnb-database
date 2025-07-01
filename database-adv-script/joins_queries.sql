-- 1. INNER JOIN: Get bookings and the users who made them
SELECT * 
FROM users AS u 
INNER JOIN bookings AS b ON u.user_id = b.user_id;

-- 2. LEFT JOIN: Get all properties and their reviews (even if no review)
SELECT * 
FROM properties 
LEFT JOIN reviews ON properties.property_id = reviews.property_id 
ORDER BY properties.property_id;

-- 3. FULL OUTER JOIN: Get all users and bookings (even if not linked)
SELECT * 
FROM users 
FULL OUTER JOIN bookings ON users.user_id = bookings.user_id;