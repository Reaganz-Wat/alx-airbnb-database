# 🧩 Partitioning Performance Report for `booking` Table

## ✅ Objective
Optimize slow queries on the large `booking` table by implementing **range-based partitioning** on the `start_date` column.

## 📌 Background
The `booking` table stores millions of records. Querying by date range was becoming increasingly inefficient, resulting in full table scans and slow response times. We solved this using **PostgreSQL native table partitioning**.

---

## 🛠️ Implementation Summary

### 🔸 Partition Strategy
- **Method**: Range partitioning
- **Partition Key**: `start_date`
- **Granularity**: Yearly
- **Partitions**:
  - `booking_2023`: Bookings from 2023
  - `booking_2024`: Bookings from 2024
  - `booking_2025`: Bookings from 2025

### 🔸 Schema Adjustments
- The `booking` table was restructured to be partitioned.
- Composite primary key used: `(booking_id, start_date)` (required for partitioned tables).
- 50K+ rows were inserted into the 2025 partition for testing.

---

## 🧪 Performance Testing

### ✅ Query Tested
```sql
SELECT * FROM booking
WHERE start_date BETWEEN '2025-06-01' AND '2025-06-30';
```

### 📊 Performance Results

#### Before Partitioning
| Metric | Value |
|--------|-------|
| Plan Type | Parallel Seq Scan |
| Partitions Scanned | Entire booking table |
| Rows Removed | ~102,000 |
| Execution Time | ~59.7 ms |
| Optimization | None |

**Execution Plan:**
```
Gather
 → Parallel Seq Scan on booking
Filter: start_date BETWEEN '2025-06-01' AND '2025-06-30'
Rows Removed by Filter: 102240
Execution Time: 59.698 ms
```

#### After Partitioning (No Index)
| Metric | Value |
|--------|-------|
| Plan Type | Seq Scan on partition |
| Partition Accessed | `booking_2025` only |
| Rows Removed | ~48,000 |
| Execution Time | ~20.7 ms |
| Optimization | Partition Pruning |

**Execution Plan:**
```
Seq Scan on booking_2025
Filter: start_date BETWEEN '2025-06-01' AND '2025-06-30'
Rows Removed by Filter: 48097
Execution Time: 20.767 ms
```

#### After Partitioning + Indexing
**Index Created:**
```sql
CREATE INDEX idx_booking_2025_start_date ON booking_2025(start_date);
```

| Metric | Value |
|--------|-------|
| Plan Type | Bitmap Index Scan |
| Partition Accessed | `booking_2025` only |
| Rows Removed | 0 |
| Execution Time | ~0.06 ms |
| Optimization | Partition Pruning + Indexing |

**Execution Plan:**
```
Bitmap Heap Scan on booking_2025
 → Bitmap Index Scan on idx_booking_2025_start_date
Index Cond: start_date BETWEEN '2025-06-01' AND '2025-06-30'
Execution Time: 0.065 ms
```

### 📈 Performance Comparison Summary

| Scenario | Partitions Scanned | Plan Type | Time (ms) |
|----------|-------------------|-----------|-----------|
| Before Partitioning | All (1 big table) | Parallel Seq Scan | ~59.7 |
| After Partitioning | Only `booking_2025` | Seq Scan | ~20.7 |
| Partitioning + Indexing | Only `booking_2025` | Bitmap Index Scan | ~0.06 |

## 🚀 Key Improvements
- **918x faster** query execution with partitioning + indexing
- **Partition pruning** eliminates unnecessary table scans
- **Targeted indexing** on specific partitions for optimal performance
- **Scalable architecture** for future data growth