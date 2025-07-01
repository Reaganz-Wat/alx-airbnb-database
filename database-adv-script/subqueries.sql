-- This is a SQL script that demonstrates the use of subqueries to filter properties based on average ratings from reviews.
SELECT
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

SELECT
    *
FROM
    users
    RIGHT JOIN (
        SELECT
            user_id,
            count(*) AS booking_times
        FROM
            bookings
        GROUP BY
            user_id
        HAVING
            count(*) > 1
    ) AS tb ON users.user_id = tb.user_id;