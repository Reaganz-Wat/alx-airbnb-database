-- Insert Users
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES
  ('a1b2c3d4-e5f6-7a8b-9c0d-e1f2a3b4c5d6', 'Reagan', 'Watmon', 'reagan@example.com', 'hashed_pw1', '+15555550101', 'host', NOW()),
  ('b2c3d4e5-f6a7-8b9c-0de1-f2a3b4c5d6e7', 'Bob', 'Smith', 'bob@example.com', 'hashed_pw2', '+15555550202', 'guest', NOW()),
  ('c3d4e5f6-a7b8-9c0d-e1f2-a3b4c5d6e7f8', 'John', 'Davis', 'john@example.com', 'hashed_pw3', NULL, 'admin', NOW());

-- Insert Properties
INSERT INTO property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
VALUES
  ('d4e5f6a7-b8c9-0def-1234-56789abcdef0', 'a1b2c3d4-e5f6-7a8b-9c0d-e1f2a3b4c5d6', 'Cozy Downtown Apartment', 'A cozy apartment located in the heart of the city.', 'New York, NY', 75.00, NOW(), NOW()),
  ('e5f6a7b8-c9d0-1ef2-3456-789abcdef012', 'a1b2c3d4-e5f6-7a8b-9c0d-e1f2a3b4c5d6', 'Modern Beach House', 'Beautiful modern house near the beach.', 'Miami, FL', 150.00, NOW(), NOW()),
  ('f6a7b8c9-d0e1-2f34-5678-9abcdef01234', 'a1b2c3d4-e5f6-7a8b-9c0d-e1f2a3b4c5d6', 'Mountain Cabin Retreat', 'Secluded cabin in the mountains with stunning views.', 'Denver, CO', 100.00, NOW(), NOW());

-- Insert Bookings
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
VALUES
  ('a7b8c9d0-e1f2-3456-789a-bcdef0123456', 'd4e5f6a7-b8c9-0def-1234-56789abcdef0', 'b2c3d4e5-f6a7-8b9c-0de1-f2a3b4c5d6e7', '2025-07-01', '2025-07-05', 300.00, 'confirmed', NOW()),
  ('b8c9d0e1-f234-5678-9abc-def012345678', 'e5f6a7b8-c9d0-1ef2-3456-789abcdef012', 'b2c3d4e5-f6a7-8b9c-0de1-f2a3b4c5d6e7', '2025-08-10', '2025-08-15', 750.00, 'pending', NOW()),
  ('c9d0e1f2-3456-789a-bcde-f0123456789a', 'f6a7b8c9-d0e1-2f34-5678-9abcdef01234', 'c3d4e5f6-a7b8-9c0d-e1f2-a3b4c5d6e7f8', '2025-09-20', '2025-09-22', 200.00, 'canceled', NOW());

-- Insert Payments
INSERT INTO payment (payment_id, booking_id, amount, payment_date, payment_method)
VALUES
  ('d0e1f234-5678-9abc-def0-123456789abc', 'a7b8c9d0-e1f2-3456-789a-bcdef0123456', 300.00, NOW(), 'credit_card'),
  ('e1f23456-789a-bcde-f012-3456789abcde', 'b8c9d0e1-f234-5678-9abc-def012345678', 750.00, NOW(), 'paypal'),
  ('f2345678-9abc-def0-1234-56789abcdef0', 'c9d0e1f2-3456-789a-bcde-f0123456789a', 200.00, NOW(), 'stripe');

-- Insert Reviews
INSERT INTO review (review_id, property_id, user_id, rating, comment, created_at)
VALUES
  ('123e4567-e89b-12d3-a456-426614174000', 'd4e5f6a7-b8c9-0def-1234-56789abcdef0', 'b2c3d4e5-f6a7-8b9c-0de1-f2a3b4c5d6e7', 5, 'Fantastic stay, very clean and close to everything!', NOW()),
  ('223e4567-e89b-12d3-a456-426614174001', 'e5f6a7b8-c9d0-1ef2-3456-789abcdef012', 'c3d4e5f6-a7b8-9c0d-e1f2-a3b4c5d6e7f8', 4, 'Loved the location and the beach view.', NOW());

-- Insert Messages
INSERT INTO message (message_id, sender_id, recipient_id, message_body, sent_at)
VALUES
  ('323e4567-e89b-12d3-a456-426614174002', 'b2c3d4e5-f6a7-8b9c-0de1-f2a3b4c5d6e7', 'a1b2c3d4-e5f6-7a8b-9c0d-e1f2a3b4c5d6', 'Hi Alice, I have a question about your property.', NOW()),
  ('423e4567-e89b-12d3-a456-426614174003', 'a1b2c3d4-e5f6-7a8b-9c0d-e1f2a3b4c5d6', 'b2c3d4e5-f6a7-8b9c-0de1-f2a3b4c5d6e7', 'Sure Bob, how can I help you?', NOW());
