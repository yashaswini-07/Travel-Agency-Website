USE travel_agency1;

CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_email VARCHAR(100) NOT NULL,
    passenger_name VARCHAR(100) NOT NULL,
    train_name VARCHAR(100) NOT NULL,
    train_number VARCHAR(20) NOT NULL,
    source VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    departure VARCHAR(50) NOT NULL,
    seats_reserved INT NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'CONFIRMED'
);