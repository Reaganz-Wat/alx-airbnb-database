# 🧠 Database Normalization – ALX Airbnb Database

## 🎯 Objective

This document explains how the Airbnb-style database design follows normalization principles up to the **Third Normal Form (3NF)** to eliminate redundancy, ensure data integrity, and optimize relational structure.

---

## 🔍 What is Normalization?

Normalization is the process of organizing data to reduce redundancy and improve data integrity. The standard levels of normalization include:

- **1NF (First Normal Form):** No repeating groups; all fields contain atomic (indivisible) values.
- **2NF (Second Normal Form):** Every non-key attribute is fully functionally dependent on the entire primary key.
- **3NF (Third Normal Form):** No transitive dependencies — non-key attributes must not depend on other non-key attributes.

---

## ✅ Normalization Process

### 1️⃣ First Normal Form (1NF)

**Rule:** Eliminate repeating groups and ensure atomicity.

- All attributes in all tables store **atomic values**.
- No lists, arrays, or multiple values in a single column.
- ✅ **Achieved** in all tables.

---

### 2️⃣ Second Normal Form (2NF)

**Rule:** Eliminate partial dependencies (non-key attributes must depend on the full primary key).

- No composite primary keys exist in this schema — each table has a **single-column primary key**.
- All non-key fields depend entirely on the primary key.
- ✅ **Achieved** across all entities.

---

### 3️⃣ Third Normal Form (3NF)

**Rule:** Eliminate transitive dependencies (non-key fields should not depend on other non-key fields).

#### Example Review:
- In `Booking`, `total_price` could technically be derived from `start_date`, `end_date`, and `pricepernight`, **but is retained for historical pricing integrity**.
  - This is acceptable for denormalization **by design**, not by mistake.

- No non-key attribute in any table depends on another non-key attribute.
- All foreign keys are correctly placed to maintain relational integrity.
- ✅ **Achieved** across all tables.

---

## 📋 Table-by-Table Summary

| Table     | 1NF | 2NF | 3NF | Notes |
|-----------|-----|-----|-----|-------|
| User      | ✅  | ✅  | ✅  | No redundancy or derived fields |
| Property  | ✅  | ✅  | ✅  | All attributes depend on `property_id` |
| Booking   | ✅  | ✅  | ✅  | `total_price` retained intentionally |
| Payment   | ✅  | ✅  | ✅  | Linked cleanly to booking |
| Review    | ✅  | ✅  | ✅  | Properly references user and property |
| Message   | ✅  | ✅  | ✅  | Dual FK to user for sender/recipient |

---

## ✅ Conclusion

The Airbnb database schema has been carefully reviewed and designed to conform to the rules of **1NF**, **2NF**, and **3NF**:

- ✅ **No redundant or repeating fields**
- ✅ **All non-key attributes depend fully on their primary key**
- ✅ **No transitive dependencies**
- ✅ **All foreign keys are appropriately defined**

> This normalized design ensures data consistency, avoids anomalies, and improves query efficiency.