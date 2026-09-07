DROP DATABASE travel_agency;
CREATE DATABASE travel_agency;
USE travel_agency;

-- CUSTOMER TABLE
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_no VARCHAR(20),
    address TEXT
);

-- TRAIN TABLE
CREATE TABLE trains (
    train_id INT AUTO_INCREMENT PRIMARY KEY,
    train_number VARCHAR(20) NOT NULL,
    train_name VARCHAR(100),
    source_station VARCHAR(100),
    destination_station VARCHAR(100),
    departure_time DATETIME,
    arrival_time DATETIME,
    available_seats INT,
    ticket_price DECIMAL(10,2)
);

-- BOOKINGS TABLE
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    train_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    journey_date DATE,
    seats_booked INT,
    booking_status ENUM('Confirmed','Pending','Cancelled') DEFAULT 'Pending',

    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (train_id) REFERENCES trains(train_id)
);

-- PAYMENT TABLE
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_status ENUM('Paid','Pending','Failed') DEFAULT 'Pending',

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- INSERT CUSTOMER DATA
INSERT INTO customer (full_name, email, phone_no, address)
VALUES
('John Doe', 'john@email.com', '9876543210', 'Delhi'),
('Jane Smith', 'jane@email.com', '9876543211', 'Mumbai'),
('Alex Roy', 'alex@email.com', '9876543212', 'Bangalore');

-- INSERT TRAIN DATA
INSERT INTO trains (
    train_number,
    train_name,
    source_station,
    destination_station,
    departure_time,
    arrival_time,
    available_seats,
    ticket_price
)
VALUES
('TR101', 'Rajdhani Express', 'Delhi', 'Mumbai',
'2026-05-15 06:00:00',
'2026-05-15 18:00:00',
120, 1500.00),

('TR202', 'Shatabdi Express', 'Bangalore', 'Chennai',
'2026-05-16 08:00:00',
'2026-05-16 14:00:00',
90, 950.00),

('TR303', 'Duronto Express', 'Kolkata', 'Delhi',
'2026-05-17 09:30:00',
'2026-05-17 22:00:00',
100, 1800.00);

-- INSERT BOOKINGS
INSERT INTO bookings (
    customer_id,
    train_id,
    journey_date,
    seats_booked,
    booking_status
)
VALUES
(1, 1, '2026-05-15', 2, 'Confirmed'),
(2, 2, '2026-05-16', 1, 'Pending'),
(3, 3, '2026-05-17', 3, 'Confirmed');

-- INSERT PAYMENTS
INSERT INTO payments (
    booking_id,
    payment_amount,
    payment_method,
    payment_status
)
VALUES
(1, 3000.00, 'UPI', 'Paid'),
(2, 950.00, 'Card', 'Pending'),
(3, 5400.00, 'Net Banking', 'Paid');

-- VIEW TABLES
SELECT * FROM customer;
SELECT * FROM trains;
SELECT * FROM bookings;
SELECT * FROM payments;CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_no VARCHAR(20),
    address TEXT
);
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_no VARCHAR(20),
    address TEXT
);
