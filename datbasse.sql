CREATE DATABASE IF NOT EXISTS travel_agency1;
USE travel_agency1;

DROP TABLE IF EXISTS login_logs;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customerid INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,  -- Prevents duplicate profiles
    phone_number VARCHAR(15),
    address TEXT,
    mode_of_travel VARCHAR(50) DEFAULT 'Train',
    departure_time DATETIME,
    arrival_time DATETIME,                -- Tracks arrival bounds
    train_number VARCHAR(20),             -- Stores reservation numbers
    total_seats INT DEFAULT 1,            -- Maps count matrix
    female_passengers INT DEFAULT 0,
    status VARCHAR(100)                   -- Saves Deck location and seat list
);

CREATE TABLE login_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15),
    address TEXT,
    login_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Safely clear out old system rows
TRUNCATE TABLE customers;