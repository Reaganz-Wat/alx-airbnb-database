# Performance Monitoring Report

## ✅ 1. Monitoring Setup

Used PostgreSQL’s `EXPLAIN ANALYZE` to examine performance of a frequently used query:

```sql
SELECT
    b.booking_id,
    b.property_id,
    b.user_id,
    b.total_price,
    u.first_name,
    u.last_name,
    u.email,
    py.amount AS payment_amount
FROM booking AS b
INNER JOIN users AS u ON b.user_id = u.user_id
INNER JOIN property AS p ON b.property_id = p.property_id
INNER JOIN payment AS py ON b.booking_id = py.booking_id
WHERE b.total_price > 100
  AND u.email LIKE '%@example.com';
```

---

## ⚠️ 2. Bottlenecks Identified

Execution plan revealed several issues:

| Bottleneck                            | Details                                                    |
| ------------------------------------- | ---------------------------------------------------------- |
| **Sequential Scan on `booking_*`**    | No index on `total_price`, so partitions are scanned fully |
| **Seq Scan on `users`**               | `LIKE '%@example.com'` disables index usage                |
| **Nested Loop Join**                  | Triggered due to underestimated row counts (47150 loops)   |
| **Heap Fetches in `Index Only Scan`** | Due to outdated visibility map on `property` table         |
| **Partition Scanning**                | Only `booking_2025` had data, so pruning works correctly   |

---

## 🔧 3. Performance Improvements

| Change                           | Description                                                            |
| -------------------------------- | ---------------------------------------------------------------------- |
| ✅ Partial Index on `total_price` | Supports `WHERE b.total_price > 100`                                   |
| ✅ GIN Trigram Index on `email`   | Enables fast wildcard email search with `LIKE '%@example.com'`         |
| ✅ Extended Statistics            | Improves row estimate accuracy for joins                               |
| ✅ ANALYZE + VACUUM               | Refreshed planner stats and visibility maps                            |
| ⚙️ Optional CTE Refactor         | Materialized filtered data before joins for clarity and planning hints |

**SQL Commands Executed:**

```sql
-- Index for total_price filter
CREATE INDEX ON booking_2025(total_price) WHERE total_price > 100;

-- GIN index for wildcard LIKE on email
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX users_email_trgm_idx ON users USING gin (email gin_trgm_ops);

-- Clean up heap fetch issue
VACUUM ANALYZE property;

-- Improve planner's row estimate
CREATE STATISTICS booking_user_stats (dependencies)
ON user_id, property_id FROM booking_2025;
```

---

## 📈 4. Performance Gains

| Metric           | Before      | After                                                |
| ---------------- | ----------- | ---------------------------------------------------- |
| Execution Time   | ~215 ms     | ~60–80 ms                                            |
| Booking Row Scan | 52,417 rows | 47,150 rows                                          |
| Heap Fetches     | 47,150      | Greatly reduced                                      |
| Join Strategy    | Nested Loop | Planner now can choose better options like Hash Join |