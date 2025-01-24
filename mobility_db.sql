CREATE DATABASE MobilityServiceDB;
use MobilityServiceDB;



-- Table Creation 
CREATE TABLE roles (
    role_id INTEGER PRIMARY KEY AUTO_INCREMENT, 
    role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE login_details (
    user_id INTEGER PRIMARY KEY AUTO_INCREMENT,  
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    last_login_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role_id INTEGER NOT NULL,  -- Ensure role_id is INTEGER
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE  
);



CREATE TABLE vehicles (
    vehicle_id INTEGER PRIMARY KEY AUTO_INCREMENT,  
    vehicle_type VARCHAR(20) NOT NULL,
    capacity INTEGER NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    model VARCHAR(50) NOT NULL,
    make VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL
);




CREATE TABLE drivers (
    driver_id INTEGER PRIMARY KEY,  
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    vehicle_id INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES login_details(user_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE SET NULL
);



CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,  
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    date_registered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (customer_id) REFERENCES login_details(user_id) ON DELETE CASCADE
);



CREATE TABLE rides (
    ride_id INTEGER PRIMARY KEY AUTO_INCREMENT,  
    driver_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    pickup_location VARCHAR(255) NOT NULL,
    drop_location VARCHAR(255) NOT NULL,
    distance FLOAT NOT NULL,
    fare FLOAT NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    customer_rating FLOAT,
    comments TEXT,
    status VARCHAR(50) CHECK (status IN ('InTransit', 'Completed', 'Cancelled')) NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);



CREATE TABLE ride_geolocations (
    route_id INTEGER PRIMARY KEY AUTO_INCREMENT,  
    ride_id INTEGER NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id) ON DELETE CASCADE
);



CREATE TABLE payment_details (
    payment_id INTEGER PRIMARY KEY AUTO_INCREMENT,  
    ride_id INTEGER NOT NULL,
    payment_method VARCHAR(20) CHECK (payment_method IN ('Cash', 'CreditCard', 'DebitCard', 'Wallet')) NOT NULL,
    amount FLOAT NOT NULL,
    transaction_status VARCHAR(20) CHECK (transaction_status IN ('Pending', 'Completed', 'Failed')) NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id) ON DELETE CASCADE
);


CREATE TABLE rewards (
    reward_id INTEGER PRIMARY KEY AUTO_INCREMENT,  
    user_id INTEGER NOT NULL,
    points_earned INTEGER NOT NULL,
    category VARCHAR(20) CHECK (category IN ('Ride', 'Referral', 'Promotion')) NOT NULL,
    description TEXT,
    date_earned TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES login_details(user_id) ON DELETE CASCADE
);

-- Index Creation
-- CREATE INDEX idx_role_name ON roles (role_name);
-- CREATE INDEX idx_username ON login_details (username);
-- CREATE INDEX idx_role_id ON login_details (role_id);
-- CREATE INDEX idx_license_plate ON vehicles (license_plate);
-- CREATE INDEX idx_vehicle_type ON vehicles (vehicle_type);
-- CREATE INDEX idx_license_number ON drivers (license_number);
-- CREATE INDEX idx_vehicle_id ON drivers (vehicle_id);
-- CREATE INDEX idx_customer_email ON customers (email);
-- CREATE INDEX idx_driver_id ON rides (driver_id);
-- CREATE INDEX idx_customer_id ON rides (customer_id);
-- CREATE INDEX idx_status ON rides (status);
-- CREATE INDEX idx_ride_id ON ride_geolocations (ride_id);
-- CREATE INDEX idx_ride_id_payment ON payment_details (ride_id);
-- CREATE INDEX idx_transaction_status ON payment_details (transaction_status);
-- CREATE INDEX idx_payment_method ON payment_details (payment_method);
-- CREATE INDEX idx_user_id ON rewards (user_id);
-- CREATE INDEX idx_category ON rewards (category);



-- Data insert statements 

INSERT INTO roles (role_name) VALUES ('Admin'), ('Driver'), ('Customer');


INSERT INTO vehicles (vehicle_type, capacity, license_plate, model, make, year)
VALUES
('Truck', 2, 'US-TRK001', 'Model X', 'Tesla', 2023),
('Van', 8, 'US-VAN002', 'Transit', 'Ford', 2022),
('Truck', 4, 'US-TRK003', 'F-150', 'Ford', 2021),
('Van', 10, 'US-VAN004', 'Odyssey', 'Honda', 2020),
('Truck', 3, 'US-TRK005', 'RAM 1500', 'Dodge', 2023),
('Van', 12, 'US-VAN006', 'Pacifica', 'Chrysler', 2021),
('Truck', 5, 'US-TRK007', 'Silverado', 'Chevrolet', 2020),
('Van', 9, 'US-VAN008', 'Sienna', 'Toyota', 2021),
('Truck', 6, 'US-TRK009', 'Tundra', 'Toyota', 2022),
('Van', 7, 'US-VAN010', 'Sprinter', 'Mercedes-Benz', 2023),
('Truck', 2, 'US-TRK011', 'Ram 2500', 'Dodge', 2022),
('Van', 10, 'US-VAN012', 'Viano', 'Mercedes-Benz', 2020),
('Truck', 3, 'US-TRK013', 'Hino 300', 'Hino', 2021),
('Van', 8, 'US-VAN014', 'Metris', 'Mercedes-Benz', 2022),
('Truck', 4, 'US-TRK015', 'Isuzu D-Max', 'Isuzu', 2020),
('Van', 6, 'US-VAN016', 'Transit Connect', 'Ford', 2023),
('Truck', 5, 'US-TRK017', 'Ford Ranger', 'Ford', 2021),
('Van', 9, 'US-VAN018', 'Express 3500', 'Chevrolet', 2020),
('Truck', 7, 'US-TRK019', 'Freightliner M2', 'Freightliner', 2023),
('Van', 8, 'US-VAN020', 'NV3500', 'Nissan', 2022);

-- Inserting login details for drivers with passwords based on username and special characters
INSERT INTO login_details (username, password, role_id)
VALUES
('john_doe', 'john_doe@123', 2),
('jane_smith', 'jane_smith#456', 2),
('michael_johnson', 'michael_johnson!789', 2),
('emily_williams', 'emily_williams$012', 2),
('david_brown', 'david_brown%345', 2),
('sophia_jones', 'sophia_jones^678', 2),
('james_miller', 'james_miller&910', 2),
('isabella_davis', 'isabella_davis*112', 2),
('william_garcia', 'william_garcia+131', 2),
('olivia_martinez', 'olivia_martinez@141', 2),
('benjamin_hernandez', 'benjamin_hernandez#151', 2),
('mia_lopez', 'mia_lopez$161', 2),
('lucas_gonzalez', 'lucas_gonzalez^171', 2),
('charlotte_perez', 'charlotte_perez!181', 2),
('alexander_wilson', 'alexander_wilson@191', 2),
('amelia_anderson', 'amelia_anderson#202', 2),
('ethan_thomas', 'ethan_thomas*212', 2),
('harper_taylor', 'harper_taylor+222', 2),
('logan_moore', 'logan_moore$232', 2),
('grace_jackson', 'grace_jackson!242', 2);

-- Inserting login details for customers with passwords based on username and special characters
INSERT INTO login_details (username, password, role_id)
VALUES
('liam_parker', 'liam_parker@252', 3),
('emma_roberts', 'emma_roberts#262', 3),
('aiden_mitchell', 'aiden_mitchell!272', 3),
('olivia_harris', 'olivia_harris$282', 3),
('noah_thompson', 'noah_thompson^292', 3),
('mia_garcia', 'mia_garcia*302', 3),
('ethan_lee', 'ethan_lee+312', 3),
('sophia_martin', 'sophia_martin@322', 3),
('lucas_taylor', 'lucas_taylor#332', 3),
('charlotte_young', 'charlotte_young!342', 3),
('jackson_moore', 'jackson_moore$352', 3),
('amelia_adams', 'amelia_adams^362', 3),
('oliver_carter', 'oliver_carter*372', 3),
('harper_baker', 'harper_baker+382', 3),
('evan_scott', 'evan_scott@392', 3),
('chloe_nelson', 'chloe_nelson#402', 3),
('mason_hill', 'mason_hill!412', 3),
('ella_green', 'ella_green$422', 3),
('gabriel_king', 'gabriel_king^432', 3),
('grace_wright', 'grace_wright*442', 3);


INSERT INTO drivers (driver_id, first_name, middle_name, last_name, email, phone_number, license_number, vehicle_id, is_active, date_joined)
VALUES
(1, 'John', 'M', 'Doe', 'john.doe@gmail.com', '1234567890', 'ABC12345', 1, TRUE, NOW()),
(2, 'Jane', 'A', 'Smith', 'jane.smith@gmail.com', '2345678901', 'DEF67890', 2, TRUE, NOW()),
(3, 'Michael', 'B', 'Johnson', 'michael.johnson@gmail.com', '3456789012', 'GHI13579', 3, TRUE, NOW()),
(4, 'Emily', 'C', 'Williams', 'emily.williams@gmail.com', '4567890123', 'JKL24680', 4, TRUE, NOW()),
(5, 'David', 'D', 'Brown', 'david.brown@gmail.com', '5678901234', 'MNO35791', 5, TRUE, NOW()),
(6, 'Sophia', 'E', 'Jones', 'sophia.jones@gmail.com', '6789012345', 'PQR46802', 6, TRUE, NOW()),
(7, 'James', 'F', 'Miller', 'james.miller@gmail.com', '7890123456', 'STU57913', 7, TRUE, NOW()),
(8, 'Isabella', 'G', 'Davis', 'isabella.davis@gmail.com', '8901234567', 'VWX68024', 8, TRUE, NOW()),
(9, 'William', 'H', 'Garcia', 'william.garcia@gmail.com', '9012345678', 'YZA79135', 9, TRUE, NOW()),
(10, 'Olivia', 'I', 'Martinez', 'olivia.martinez@gmail.com', '0123456789', 'BCD80246', 10, TRUE, NOW()),
(11, 'Benjamin', 'J', 'Hernandez', 'benjamin.hernandez@gmail.com', '1234567890', 'EFG91357', 11, TRUE, NOW()),
(12, 'Mia', 'K', 'Lopez', 'mia.lopez@gmail.com', '2345678901', 'HIJ02468', 12, TRUE, NOW()),
(13, 'Lucas', 'L', 'Gonzalez', 'lucas.gonzalez@gmail.com', '3456789012', 'KLM13579', 13, TRUE, NOW()),
(14, 'Charlotte', 'M', 'Perez', 'charlotte.perez@gmail.com', '4567890123', 'NOP24680', 14, TRUE, NOW()),
(15, 'Alexander', 'N', 'Wilson', 'alexander.wilson@gmail.com', '5678901234', 'QRS35791', 15, TRUE, NOW()),
(16, 'Amelia', 'O', 'Anderson', 'amelia.anderson@gmail.com', '6789012345', 'TUV46802', 16, TRUE, NOW()),
(17, 'Ethan', 'P', 'Thomas', 'ethan.thomas@gmail.com', '7890123456', 'WXY57913', 17, TRUE, NOW()),
(18, 'Harper', 'Q', 'Taylor', 'harper.taylor@gmail.com', '8901234567', 'ZAB68024', 18, TRUE, NOW()),
(19, 'Logan', 'R', 'Moore', 'logan.moore@gmail.com', '9012345678', 'CDE79135', 19, TRUE, NOW()),
(20, 'Grace', 'S', 'Jackson', 'grace.jackson@gmail.com', '0123456789', 'FGH80246', 20, TRUE, NOW());

INSERT INTO customers (customer_id, first_name, middle_name, last_name, email, phone_number, date_registered, is_active)
VALUES
(21, 'Liam', 'B', 'Harrison', 'liam.harrison@gmail.com', '5678901234', NOW(), TRUE),
(22, 'Emma', 'C', 'Wells', 'emma.wells@gmail.com', '6789012345', NOW(), TRUE),
(23, 'Aiden', 'M', 'Hughes', 'aiden.hughes@gmail.com', '7890123456', NOW(), TRUE),
(24, 'Olivia', 'P', 'Foster', 'olivia.foster@gmail.com', '8901234567', NOW(), TRUE),
(25, 'Noah', 'T', 'Stewart', 'noah.stewart@gmail.com', '9012345678', NOW(), TRUE),
(26, 'Mia', 'R', 'Greenwood', 'mia.greenwood@gmail.com', '0123456789', NOW(), TRUE),
(27, 'Ethan', 'V', 'Pierce', 'ethan.pierce@gmail.com', '1234567890', NOW(), TRUE),
(28, 'Sophia', 'J', 'Carlson', 'sophia.carlson@gmail.com', '2345678901', NOW(), TRUE),
(29, 'Lucas', 'K', 'Dunn', 'lucas.dunn@gmail.com', '3456789012', NOW(), TRUE),
(30, 'Charlotte', 'N', 'Manning', 'charlotte.manning@gmail.com', '4567890123', NOW(), TRUE),
(31, 'Jackson', 'F', 'Wagner', 'jackson.wagner@gmail.com', '5678901234', NOW(), TRUE),
(32, 'Amelia', 'S', 'Burns', 'amelia.burns@gmail.com', '6789012345', NOW(), TRUE),
(33, 'Oliver', 'Q', 'Douglas', 'oliver.douglas@gmail.com', '7890123456', NOW(), TRUE),
(34, 'Harper', 'B', 'Lloyd', 'harper.lloyd@gmail.com', '8901234567', NOW(), TRUE),
(35, 'Evan', 'D', 'Byrne', 'evan.byrne@gmail.com', '9012345678', NOW(), TRUE),
(36, 'Chloe', 'H', 'Fowler', 'chloe.fowler@gmail.com', '0123456789', NOW(), TRUE),
(37, 'Mason', 'T', 'Henderson', 'mason.henderson@gmail.com', '1234567890', NOW(), TRUE),
(38, 'Ella', 'N', 'Riley', 'ella.riley@gmail.com', '2345678901', NOW(), TRUE),
(39, 'Gabriel', 'W', 'Wells', 'gabriel.wells@gmail.com', '3456789012', NOW(), TRUE),
(40, 'Grace', 'M', 'Morgan', 'grace.morgan@gmail.com', '4567890123', NOW(), TRUE);




-- Insert sample ride data
-- Insert sample ride data for the previous year (2023)
INSERT INTO rides (driver_id, customer_id, pickup_location, drop_location, distance, fare, status, date)
VALUES
(1, 21, '123 Main St', '456 Elm St', 10.5, 10.0, 'Completed', '2023-01-01 10:00:00'),
(2, 22, '789 Oak St', '101 Pine St', 8.0, 5.0, 'Completed', '2023-01-05 12:30:00'),
(3, 23, '202 Birch St', '303 Cedar St', 12.3, 25.0, 'Completed', '2023-01-10 15:45:00'),
(4, 24, '404 Maple St', '505 Willow St', 5.0, 12.5, 'Completed', '2023-01-15 14:00:00'),
(5, 25, '606 Aspen St', '707 Redwood St', 6.8, 18.0, 'Completed', '2023-01-20 08:00:00'),
(6, 26, '808 Palm St', '909 Oakwood St', 9.5, 22.0, 'Completed', '2023-01-25 16:30:00'),
(7, 27, '1010 Beach St', '1111 Forest St', 15.0, 10.0, 'Completed', '2023-01-28 13:20:00'),
(8, 28, '1212 River St', '1313 Valley St', 7.2, 7.0, 'Completed', '2023-01-30 09:00:00'),
(9, 29, '1414 Mountain St', '1515 Hill St', 10.0, 70.0, 'Completed', '2023-01-30 18:00:00'),
(10, 30, '1616 Desert St', '1717 Ocean St', 14.0, 8.0, 'Completed', '2023-01-31 11:50:00'),
(1, 21, '123 Main St', '456 Elm St', 10.5, 20.0, 'Completed', '2023-02-01 10:00:00'),
(2, 22, '789 Oak St', '101 Pine St', 8.0, 15.0, 'Completed', '2023-02-05 12:30:00'),
(3, 23, '202 Birch St', '303 Cedar St', 12.3, 25.0, 'Completed', '2023-02-10 15:45:00'),
(4, 24, '404 Maple St', '505 Willow St', 5.0, 12.5, 'Completed', '2023-02-14 14:00:00'),
(5, 25, '606 Aspen St', '707 Redwood St', 6.8, 18.0, 'Completed', '2023-02-18 08:00:00'),
(6, 26, '808 Palm St', '909 Oakwood St', 9.5, 22.0, 'Completed', '2023-02-21 16:30:00'),
(7, 27, '1010 Beach St', '1111 Forest St', 15.0, 30.0, 'Completed', '2023-02-23 13:20:00'),
(8, 28, '1212 River St', '1313 Valley St', 7.2, 17.0, 'Completed', '2023-02-25 09:00:00'),
(9, 29, '1414 Mountain St', '1515 Hill St', 10.0, 20.0, 'Completed', '2023-02-28 18:00:00'),
(10, 30, '1616 Desert St', '1717 Ocean St', 14.0, 28.0, 'Completed', '2023-02-28 11:50:00'),
(1, 21, '123 Main St', '456 Elm St', 10.5, 20.0, 'Completed', '2023-03-01 10:00:00'),
(2, 22, '789 Oak St', '101 Pine St', 8.0, 15.0, 'Completed', '2023-03-05 12:30:00'),
(3, 23, '202 Birch St', '303 Cedar St', 12.3, 25.0, 'Completed', '2023-03-10 15:45:00'),
(4, 24, '404 Maple St', '505 Willow St', 5.0, 12.5, 'Completed', '2023-03-15 14:00:00'),
(5, 25, '606 Aspen St', '707 Redwood St', 6.8, 18.0, 'Completed', '2023-03-20 08:00:00'),
(6, 26, '808 Palm St', '909 Oakwood St', 9.5, 22.0, 'Completed', '2023-03-25 16:30:00'),
(7, 27, '1010 Beach St', '1111 Forest St', 15.0, 30.0, 'Completed', '2023-03-28 13:20:00'),
(8, 28, '1212 River St', '1313 Valley St', 7.2, 17.0, 'Completed', '2023-03-30 09:00:00'),
(9, 29, '1414 Mountain St', '1515 Hill St', 10.0, 20.0, 'Completed', '2023-03-30 18:00:00'),
(10, 30, '1616 Desert St', '1717 Ocean St', 14.0, 28.0, 'Completed', '2023-03-31 11:50:00'),
(1, 21, '123 Main St', '456 Elm St', 10.5, 20.0, 'Completed', '2024-01-01 10:00:00'),
(2, 22, '789 Oak St', '101 Pine St', 8.0, 15.0, 'Completed', '2024-01-05 12:30:00'),
(3, 23, '202 Birch St', '303 Cedar St', 12.3, 25.0, 'Completed', '2024-01-10 15:45:00'),
(4, 24, '404 Maple St', '505 Willow St', 5.0, 12.5, 'Completed', '2024-01-15 14:00:00'),
(5, 25, '606 Aspen St', '707 Redwood St', 6.8, 118.0, 'Completed', '2024-01-20 08:00:00'),
(6, 26, '808 Palm St', '909 Oakwood St', 9.5, 122.0, 'Completed', '2024-01-25 16:30:00'),
(7, 27, '1010 Beach St', '1111 Forest St', 15.0, 30.0, 'Completed', '2024-01-28 13:20:00'),
(8, 28, '1212 River St', '1313 Valley St', 7.2, 17.0, 'Completed', '2024-01-30 09:00:00'),
(9, 29, '1414 Mountain St', '1515 Hill St', 10.0, 20.0, 'Completed', '2024-01-30 18:00:00'),
(10, 30, '1616 Desert St', '1717 Ocean St', 14.0, 28.0, 'Completed', '2024-01-31 11:50:00'),
(1, 21, '123 Main St', '456 Elm St', 10.5, 20.0, 'Completed', '2024-02-01 10:00:00'),
(2, 22, '789 Oak St', '101 Pine St', 8.0, 15.0, 'Completed', '2024-02-05 12:30:00'),
(3, 23, '202 Birch St', '303 Cedar St', 12.3, 25.0, 'Completed', '2024-02-10 15:45:00'),
(4, 24, '404 Maple St', '505 Willow St', 5.0, 12.5, 'Completed', '2024-02-14 14:00:00'),
(5, 25, '606 Aspen St', '707 Redwood St', 6.8, 18.0, 'Completed', '2024-02-18 08:00:00'),
(6, 26, '808 Palm St', '909 Oakwood St', 9.5, 22.0, 'Completed', '2024-02-21 16:30:00'),
(7, 27, '1010 Beach St', '1111 Forest St', 15.0, 30.0, 'Completed', '2024-02-23 13:20:00'),
(8, 28, '1212 River St', '1313 Valley St', 7.2, 17.0, 'Completed', '2024-02-25 09:00:00'),
(9, 29, '1414 Mountain St', '1515 Hill St', 10.0, 20.0, 'Completed', '2024-02-28 18:00:00'),
(10, 30, '1616 Desert St', '1717 Ocean St', 14.0, 28.0, 'Completed', '2024-02-28 11:50:00'),
(1, 21, '123 Main St', '456 Elm St', 10.5, 20.0, 'Completed', '2024-03-01 10:00:00'),
(2, 22, '789 Oak St', '101 Pine St', 8.0, 15.0, 'Completed', '2024-03-05 12:30:00'),
(3, 23, '202 Birch St', '303 Cedar St', 12.3, 25.0, 'Completed', '2024-03-10 15:45:00'),
(4, 24, '404 Maple St', '505 Willow St', 5.0, 12.5, 'Completed', '2024-03-15 14:00:00'),
(5, 25, '606 Aspen St', '707 Redwood St', 6.8, 18.0, 'Completed', '2024-03-20 08:00:00'),
(6, 26, '808 Palm St', '909 Oakwood St', 9.5, 22.0, 'Completed', '2024-03-25 16:30:00'),
(7, 27, '1010 Beach St', '1111 Forest St', 15.0, 30.0, 'Completed', '2024-03-28 13:20:00'),
(8, 28, '1212 River St', '1313 Valley St', 7.2, 17.0, 'Completed', '2024-03-30 09:00:00'),
(9, 29, '1414 Mountain St', '1515 Hill St', 10.0, 20.0, 'Completed', '2024-03-30 18:00:00'),
(10, 30, '1616 Desert St', '1717 Ocean St', 14.0, 28.0, 'Completed', '2024-03-31 11:50:00');


INSERT INTO ride_geolocations (ride_id, latitude, longitude)
VALUES
(1, 40.7128, -74.0060),  
(1, 40.7306, -73.9352),  
(1, 40.7550, -73.9830),  
(1, 40.7580, -73.9855),  
(1, 40.7790, -73.9800),  
(1, 40.7128, -74.0060),  
(2, 34.0522, -118.2437),  
(2, 34.0632, -118.2500),  
(2, 34.0750, -118.2700),  
(2, 34.0812, -118.2900),  
(2, 34.0980, -118.3000),  
(2, 34.0522, -118.2437), 
(3, 41.8781, -87.6298),  
(3, 41.8800, -87.6200),  
(3, 41.8900, -87.6100),  
(3, 41.9000, -87.6000),  
(3, 41.9050, -87.5900),  
(3, 41.8781, -87.6298), 
(4, 29.7604, -95.3698),  
(4, 29.7700, -95.3600),  
(4, 29.7800, -95.3500),  
(4, 29.7900, -95.3400),  
(4, 29.8000, -95.3300),  
(4, 29.7604, -95.3698),  
(5, 51.5074, -0.1278), 
(5, 51.5150, -0.1400),  
(5, 51.5250, -0.1450),  
(5, 51.5300, -0.1500),  
(5, 51.5400, -0.1550),  
(5, 51.5074, -0.1278), 
(6, 48.8566, 2.3522),  
(6, 48.8600, 2.3500),  
(6, 48.8700, 2.3400),  
(6, 48.8800, 2.3300),  
(6, 48.8900, 2.3200),  
(6, 48.8566, 2.3522),  
(7, 52.5200, 13.4050),  
(7, 52.5300, 13.4000),  
(7, 52.5400, 13.3950),  
(7, 52.5500, 13.3900),  
(7, 52.5600, 13.3850),  
(7, 52.5200, 13.4050),  
(8, 37.7749, -122.4194),  
(8, 37.7800, -122.4300),  
(8, 37.7900, -122.4400),  
(8, 37.8000, -122.4500),  
(8, 37.8100, -122.4600),  
(8, 37.7749, -122.4194),  
(9, 34.0522, -118.2437),  
(9, 34.0600, -118.2500),  
(9, 34.0700, -118.2600),  
(9, 34.0800, -118.2700),  
(9, 34.0900, -118.2800),  
(9, 34.0522, -118.2437), 
(10, 40.7306, -73.9352),
(10, 40.7400, -73.9300),  
(10, 40.7500, -73.9200),  
(10, 40.7600, -73.9100),  
(10, 40.7700, -73.9000),  
(10, 40.7306, -73.9352);  



INSERT INTO payment_details (ride_id, payment_method, amount, transaction_status, transaction_id)
VALUES
(1, 'CreditCard', 20.0, 'Completed', 'TXN00123'),
(2, 'Cash', 15.0, 'Completed', 'TXN00124'),
(3, 'DebitCard', 25.0, 'Completed', 'TXN00125'),
(4, 'CreditCard', 12.5, 'Completed', 'TXN00126'),
(5, 'Wallet', 18.0, 'Failed', 'TXN00127'),
(6, 'CreditCard', 22.0, 'Completed', 'TXN00128'),
(7, 'DebitCard', 30.0, 'Completed', 'TXN00129'),
(8, 'Cash', 17.0, 'Completed', 'TXN00130'),
(9, 'Wallet', 20.0, 'Completed', 'TXN00131'),
(10, 'CreditCard', 28.0, 'Completed', 'TXN00132');


INSERT INTO rewards (user_id, points_earned, category, description)
VALUES
(1, 100, 'Ride', 'Reward for completing 10 rides'),
(2, 150, 'Ride', 'Reward for completing 15 rides'),
(3, 120, 'Referral', 'Reward for referring a new customer'),
(4, 80, 'Promotion', 'Reward for using a promotional code'),
(5, 200, 'Ride', 'Reward for completing 20 rides'),
(6, 250, 'Referral', 'Reward for referring multiple customers'),
(7, 50, 'Ride', 'Reward for completing 5 rides'),
(8, 90, 'Promotion', 'Reward for participating in a promotion'),
(9, 170, 'Referral', 'Reward for referring a customer'),
(10, 60, 'Ride', 'Reward for completing 6 rides');




