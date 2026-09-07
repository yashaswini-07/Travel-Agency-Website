USE travel_agency1;

DROP TABLE IF EXISTS login_logs;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customerid INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15),
    address TEXT,
    mode_of_travel VARCHAR(50) DEFAULT 'Train',
    departure_time DATETIME,
    status VARCHAR(20)
);

CREATE TABLE login_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15),
    address TEXT,
    login_time DATETIME NOT NULL
);
USE travel_agency1;

-- This adds only the new seat preference columns without touching your old data
ALTER TABLE customers 
ADD COLUMN total_seats INT DEFAULT 1,
ADD COLUMN female_passengers INT DEFAULT 0,
ADD COLUMN train_number VARCHAR(20),
ADD COLUMN arrival_time DATETIME;
