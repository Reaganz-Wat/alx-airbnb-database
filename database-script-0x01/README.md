# 📦 Database Schema – ALX Airbnb Database

## 🎯 Objective

This schema defines the Airbnb-style relational database, implementing normalized tables with all necessary keys, constraints, and indexes.

---

## 🏗️ Tables & Relationships

### 🔹 User
- Stores platform users (guests, hosts, admins).
- `user_id` is the primary key.
- `email` is unique and indexed.
- `role` is enforced by ENUM.

### 🔹 Property
- Owned by a user (`host_id`).
- Linked to `User` via foreign key.
- Includes details like name, description, location, and price.

### 🔹 Booking
- Links users to property reservations.
- References both `User` and `Property`.
- Includes reservation period, price, and status ENUM.

### 🔹 Payment
- Attached to a booking.
- Includes amount, payment method, and timestamp.

### 🔹 Review
- Allows users to rate and comment on properties.
- Rating is restricted to values between 1 and 5.

### 🔹 Message
- Represents communication between users.
- Contains sender and recipient foreign keys.

---

## 🔐 Constraints & Data Integrity

- All foreign keys enforce referential integrity.
- ENUM types restrict roles, statuses, and payment methods to valid options.
- `CHECK` constraint on `rating` ensures value is within [1–5].

---

## ⚡ Indexing

| Table     | Column(s)         | Purpose                     |
|-----------|-------------------|-----------------------------|
| User      | `email`           | For quick user lookup       |
| Property  | `host_id`         | Filter properties by host   |
| Booking   | `property_id`     | Retrieve bookings per unit  |
| Booking   | `user_id`         | View user booking history   |
| Payment   | `booking_id`      | Link payment to booking     |

---

## ✅ Notes

- Schema is normalized up to **Third Normal Form (3NF)**.
- Designed for efficient querying, minimal redundancy, and clear relationships.
- All `UUID` primary keys are assumed to be auto-generated in application logic.

---

## 📂 Files.

```
alx-airbnb-database/
└── database-script-0x01/
    ├── schema.sql
    └── README.md
```

- `schema.sql`: DDL statements to create all tables and indexes.
- `README.md`: This documentation file.