# 📘 SQL Joins Practice: Bookings System

This project demonstrates the use of different types of SQL joins — `INNER JOIN`, `LEFT JOIN`, and `FULL OUTER JOIN` — using a hypothetical booking system. The goal is to write and understand complex SQL queries that accurately reflect real-world relationships between users, properties, bookings, and reviews.

---

## 🧠 Objective

Master SQL joins and subqueries by writing and testing queries across related tables in a normalized relational database.

---

## 📁 Tables Used

This project uses the following tables from the database schema:

- `users`
- `properties`
- `bookings`
- `reviews`

---

## 🧪 SQL Join Queries

### 1. 🔗 INNER JOIN: Bookings and Users

```sql
-- 1. INNER JOIN: Get bookings and the users who made them
SELECT * 
FROM users AS u 
INNER JOIN bookings AS b ON u.user_id = b.user_id;
```

📌 **Purpose:**  
Retrieves all bookings that are linked to a user. Only users who have made at least one booking will appear in the result.

---

### 2. 🧩 LEFT JOIN: Properties and Their Reviews

```sql
-- 2. LEFT JOIN: Get all properties and their reviews (even if no review)
SELECT * 
FROM properties 
LEFT JOIN reviews ON properties.property_id = reviews.property_id 
ORDER BY properties.property_id;
```

📌 **Purpose:**  
Retrieves all properties, including those that have no reviews. If a property has no review, the review-related fields will be `NULL`.

---

### 3. 🌐 FULL OUTER JOIN: Users and Bookings

```sql
-- 3. FULL OUTER JOIN: Get all users and bookings (even if not linked)
SELECT * 
FROM users 
FULL OUTER JOIN bookings ON users.user_id = bookings.user_id;
```

📌 **Purpose:**  
Retrieves all users and all bookings — including:
- Users who haven’t made any bookings
- Bookings not linked to any user (if such cases exist)

📌 **Note:**  
If you're using MySQL or MariaDB, you must emulate `FULL OUTER JOIN` as it's not supported natively:

```sql
-- Simulated FULL OUTER JOIN in MySQL/MariaDB
SELECT * 
FROM users 
LEFT JOIN bookings ON users.user_id = bookings.user_id

UNION

SELECT * 
FROM users 
RIGHT JOIN bookings ON users.user_id = bookings.user_id;
```

---

## 🔎 Subquery Examples

### 4. 📈 Subquery: Properties with Average Rating > 4.0

```sql
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
```

📌 **Purpose:**  
Selects all properties whose average review rating is greater than 4.0. This uses a non-correlated subquery.

---

### 5. 🧑‍💼 Subquery with JOIN: Users Who Booked More Than Once

```sql
SELECT
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
            COUNT(*) > 1
    ) AS tb ON users.user_id = tb.user_id;
```

📌 **Purpose:**  
This query finds users who have made more than one booking by aggregating bookings and then joining the result with the users table to retrieve user information.

---

## ✅ Requirements

- SQL-compliant database (e.g. PostgreSQL, MySQL, MariaDB)
- A schema with the appropriate foreign key relationships defined
- Basic understanding of JOIN operations and subqueries