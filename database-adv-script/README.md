```markdown
# SQL Joins Queries

## 📁 Directory: `database-adv-script`
## 📄 File: `joins_queries.sql`

This project demonstrates mastery of SQL joins by writing complex queries using **INNER JOIN**, **LEFT JOIN**, and a simulated **FULL OUTER JOIN** in MariaDB (which does not support it natively).

---

## 📘 Queries Explained

### 1. 🔗 INNER JOIN: Retrieve all bookings and the respective users who made those bookings

```sql
-- Simple version
SELECT * 
FROM users AS u 
INNER JOIN bookings AS b 
ON u.user_id = b.user_id;

-- Detailed version
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
FROM 
    bookings b 
INNER JOIN 
    users u 
ON 
    b.user_id = u.user_id;
```

This query joins the `bookings` and `users` tables to display booking details along with the user information. Only bookings with an associated user are included.

---

### 2. 🡸 LEFT JOIN: Retrieve all properties and their reviews, including those with no reviews

```sql
SELECT 
    p.property_id, 
    p.name, 
    r.review_id, 
    r.comment 
FROM 
    properties p 
LEFT JOIN 
    reviews r 
ON 
    p.property_id = r.property_id;
```

This query ensures all properties are shown, even if they have no review. Review fields will appear as `NULL` if a property has not been reviewed.

---

### 3. 🔁 Simulated FULL OUTER JOIN: Retrieve all users and all bookings, including unmatched ones

MariaDB does **not support `FULL OUTER JOIN`**, so we simulate it using `UNION` of `LEFT JOIN` and `RIGHT JOIN`.

```sql
SELECT 
    u.first_name, 
    u.email, 
    b.total_price, 
    b.status 
FROM 
    users u 
LEFT JOIN 
    bookings b 
ON 
    u.user_id = b.user_id

UNION

SELECT 
    u.first_name, 
    u.email, 
    b.total_price, 
    b.status 
FROM 
    users u 
RIGHT JOIN 
    bookings b 
ON 
    u.user_id = b.user_id;
```

This query returns:
- All users (with or without bookings)
- All bookings (with or without user info)

It ensures full coverage of both tables, even when relationships are missing.

---

## 💡 Notes

- Aliases (`u`, `b`, `p`, `r`) are used to improve readability.
- `UNION` is used instead of `UNION ALL` to avoid duplicate rows in the full outer join simulation.
- Ensure your tables (`users`, `bookings`, `properties`, `reviews`) are properly populated for meaningful results.
- **MariaDB and MySQL do not support FULL OUTER JOIN directly**, so we simulate it using a combination of `LEFT JOIN` and `RIGHT JOIN` with `UNION`.