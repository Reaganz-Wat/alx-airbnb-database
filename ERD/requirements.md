# 🏠 ALX Airbnb Database – ER Diagram Documentation

## 🎯 Objective

This document outlines the design of the Entity-Relationship Diagram (ERD) for the Airbnb-style database system. It describes all entities, attributes (with data types), constraints, and relationships that are part of the system.

---

## 📦 Entities and Attributes (with Data Types)

### 1. **User**

Represents platform users (both hosts and guests).

| Attribute        | Data Type             | Constraints                            |
|------------------|-----------------------|----------------------------------------|
| `user_id`        | UUID                  | Primary Key, Indexed                   |
| `first_name`     | VARCHAR               | NOT NULL                               |
| `last_name`      | VARCHAR               | NOT NULL                               |
| `email`          | VARCHAR               | UNIQUE, NOT NULL, Indexed              |
| `password_hash`  | VARCHAR               | NOT NULL                               |
| `phone_number`   | VARCHAR               | NULL                                   |
| `role`           | ENUM (guest, host, admin) | NOT NULL                          |
| `created_at`     | TIMESTAMP             | DEFAULT CURRENT_TIMESTAMP              |

---

### 2. **Property**

Represents a listing created by a host.

| Attribute        | Data Type             | Constraints                            |
|------------------|-----------------------|----------------------------------------|
| `property_id`    | UUID                  | Primary Key, Indexed                   |
| `host_id`        | UUID                  | Foreign Key → `User.user_id`          |
| `name`           | VARCHAR               | NOT NULL                               |
| `description`    | TEXT                  | NOT NULL                               |
| `location`       | VARCHAR               | NOT NULL                               |
| `pricepernight`  | DECIMAL               | NOT NULL                               |
| `created_at`     | TIMESTAMP             | DEFAULT CURRENT_TIMESTAMP              |
| `updated_at`     | TIMESTAMP             | ON UPDATE CURRENT_TIMESTAMP            |

---

### 3. **Booking**

Represents a reservation made by a user.

| Attribute        | Data Type             | Constraints                            |
|------------------|-----------------------|----------------------------------------|
| `booking_id`     | UUID                  | Primary Key, Indexed                   |
| `property_id`    | UUID                  | Foreign Key → `Property.property_id`  |
| `user_id`        | UUID                  | Foreign Key → `User.user_id`          |
| `start_date`     | DATE                  | NOT NULL                               |
| `end_date`       | DATE                  | NOT NULL                               |
| `total_price`    | DECIMAL               | NOT NULL                               |
| `status`         | ENUM (pending, confirmed, canceled) | NOT NULL             |
| `created_at`     | TIMESTAMP             | DEFAULT CURRENT_TIMESTAMP              |

---

### 4. **Payment**

Records payments made for bookings.

| Attribute        | Data Type             | Constraints                            |
|------------------|-----------------------|----------------------------------------|
| `payment_id`     | UUID                  | Primary Key, Indexed                   |
| `booking_id`     | UUID                  | Foreign Key → `Booking.booking_id`    |
| `amount`         | DECIMAL               | NOT NULL                               |
| `payment_date`   | TIMESTAMP             | DEFAULT CURRENT_TIMESTAMP              |
| `payment_method` | ENUM (credit_card, paypal, stripe) | NOT NULL             |

---

### 5. **Review**

Represents feedback left by users on properties.

| Attribute        | Data Type             | Constraints                            |
|------------------|-----------------------|----------------------------------------|
| `review_id`      | UUID                  | Primary Key, Indexed                   |
| `property_id`    | UUID                  | Foreign Key → `Property.property_id`  |
| `user_id`        | UUID                  | Foreign Key → `User.user_id`          |
| `rating`         | INTEGER               | NOT NULL, CHECK: 1 ≤ rating ≤ 5        |
| `comment`        | TEXT                  | NOT NULL                               |
| `created_at`     | TIMESTAMP             | DEFAULT CURRENT_TIMESTAMP              |

---

### 6. **Message**

Captures communication between users.

| Attribute        | Data Type             | Constraints                            |
|------------------|-----------------------|----------------------------------------|
| `message_id`     | UUID                  | Primary Key, Indexed                   |
| `sender_id`      | UUID                  | Foreign Key → `User.user_id`          |
| `recipient_id`   | UUID                  | Foreign Key → `User.user_id`          |
| `message_body`   | TEXT                  | NOT NULL                               |
| `sent_at`        | TIMESTAMP             | DEFAULT CURRENT_TIMESTAMP              |

---

## 🔗 Relationships Summary

| From Entity | To Entity   | Relationship Type         | Description                                |
|-------------|-------------|---------------------------|--------------------------------------------|
| User        | Property     | One-to-Many                | A host can list many properties            |
| User        | Booking      | One-to-Many                | A guest can make many bookings             |
| Property    | Booking      | One-to-Many                | A property can be booked many times        |
| Booking     | Payment      | One-to-One or One-to-Many | A booking may have one or more payments    |
| User        | Review       | One-to-Many                | A user can leave multiple reviews          |
| Property    | Review       | One-to-Many                | A property can have multiple reviews       |
| User        | Message      | One-to-Many (as sender)    | A user can send many messages              |
| User        | Message      | One-to-Many (as recipient) | A user can receive many messages           |

---

## 🖼️ ER Diagram

The ER diagram is provided in the `ERD/` folder.

📄 **Diagram file:** [`ERD/ERD.png`](./ERD/ERD.png)

> The diagram visually displays all entities, attributes, and relationships defined above using standard crow’s foot notation.

---

## 🔒 Constraints

### User Table
- `email`: must be unique.
- Required fields: `first_name`, `last_name`, `email`, `password_hash`, `role`.

### Property Table
- `host_id`: must exist in `User`.
- Required fields: `name`, `description`, `location`, `pricepernight`.

### Booking Table
- Foreign key constraints on `property_id` and `user_id`.
- `status` must be one of: `pending`, `confirmed`, `canceled`.

### Payment Table
- `booking_id`: must exist in `Booking`.

### Review Table
- `rating`: must be an integer between 1 and 5.
- Foreign keys: `property_id`, `user_id`.

### Message Table
- Both `sender_id` and `recipient_id` must exist in `User`.

---

## ⚙️ Indexing

- All **Primary Keys** are indexed by default.
- Additional indexed fields:
  - `User.email` (for fast login/search)
  - `Property.property_id`
  - `Booking.booking_id`
  - `Payment.booking_id`

---

## 📁 Folder Structure

alx-airbnb-database/
├── requirements.md
└── ERD/
    └── ERD.png

---

## ✅ Status

✔️ ER diagram completed and verified  
✔️ All entities and relationships defined  
✔️ Data types, constraints, and indexes specified  
✔️ Schema normalized up to 3NF 