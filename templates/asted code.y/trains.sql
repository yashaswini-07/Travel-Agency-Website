USE travel_agency1;

-- Clear any old partial data safely
TRUNCATE TABLE trains;

-- Insert the complete 22-route real-time network
INSERT INTO trains (train_name, train_number, source, destination, departure_time, price) VALUES
('Siddhaganga Express', '12726', 'Davanagere', 'Bengaluru', '05:15 AM', 180),
('Vande Bharat Express', '20662', 'Davanagere', 'Bengaluru', '05:10 PM', 450),
('Harihar Intercity Exp', '16582', 'Harihar', 'Bengaluru', '06:15 AM', 175),
('Rani Chennamma Exp', '16590', 'Hubli', 'Davanagere', '11:30 PM', 120),
('Janshatabdi Express', '12080', 'Hubli', 'Bengaluru', '01:40 PM', 210),
('GolGumbaz Express', '16536', 'Mysuru', 'Hubli', '07:45 PM', 310),
('Shatabdi Express', '12008', 'Bengaluru', 'Chennai', '04:20 PM', 680),
('Brindavan Express', '12640', 'Bengaluru', 'Chennai', '03:10 PM', 145),
('Lalbagh Express', '12607', 'Chennai', 'Bengaluru', '03:30 PM', 190),
('Udyan Express', '11302', 'Bengaluru', 'Mumbai', '08:40 PM', 520),
('Chalukya Express', '11006', 'Hubli', 'Mumbai', '11:20 PM', 480),
('Hussainsagar Exp', '12702', 'Hyderabad', 'Mumbai', '02:45 PM', 410),
('Charminar Express', '12760', 'Hyderabad', 'Chennai', '06:00 PM', 380),
('Kachiguda Express', '12785', 'Bengaluru', 'Hyderabad', '06:20 PM', 390),
('Goa Express', '12780', 'Hubli', 'Goa', '04:15 PM', 200),
('Vasco Da Gama Exp', '17310', 'Goa', 'Hubli', '10:55 PM', 185),
('Konkan Kanya Exp', '10112', 'Goa', 'Mumbai', '06:00 PM', 440),
('Rajdhani Express', '22691', 'Bengaluru', 'Delhi', '08:00 PM', 2450),
('Karnataka Express', '12627', 'Davanagere', 'Delhi', '11:15 PM', 850),
('Malabar Fast Passenger', '16348', 'Mangaluru', 'Thiruvananthapuram', '05:20 PM', 290),
('Netravati Express', '16345', 'Mangaluru', 'Mumbai', '04:10 PM', 580),
('Karwar Express', '16514', 'Karwar', 'Bengaluru', '02:40 PM', 340);

-- Force save and finish the transaction
COMMIT;