SELECT
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

SELECT
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