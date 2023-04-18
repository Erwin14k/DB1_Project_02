-- Creation of the database
CREATE DATABASE IF NOT EXISTS restaurant_chain;

-- Show all the databases, to verify if exists.
SHOW DATABASES;

-- Use the database
USE restaurant_chain;

-- Show the database tables
SHOW TABLES;

-- Instrctions to avoid truncate or drop conflicts
SET FOREIGN_KEY_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 1;

-- Truncate tables
TRUNCATE TABLE restaurant ;
TRUNCATE TABLE employee ;
TRUNCATE TABLE order_ ;
TRUNCATE TABLE order_product ;
TRUNCATE TABLE product;
TRUNCATE TABLE job;
TRUNCATE TABLE client;
TRUNCATE TABLE client_address;
TRUNCATE TABLE bill;

-- Drop Tables
DROP TABLE restaurant ;
DROP TABLE employee ;
DROP TABLE order_ ;
DROP TABLE order_product ;
DROP TABLE product;
DROP TABLE job;
DROP TABLE client;
DROP TABLE client_address;
DROP TABLE bill;

-- Select * From Tables
SELECT * FROM  restaurant ;
SELECT * FROM  employee ;
SELECT * FROM  order_ ;
SELECT * FROM  order_product ;
SELECT * FROM  product;
SELECT * FROM  job;
SELECT * FROM client;
SELECT * FROM  client_address;
SELECT * FROM  bill;




-- Job Table
CREATE TABLE IF NOT EXISTS job (
  job_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	description VARCHAR(150) NOT NULL,
	salary DECIMAL(10,2) NOT NULL
);


-- Restaurant Table
CREATE TABLE IF NOT EXISTS restaurant(
  restaurant_id VARCHAR(100)  PRIMARY KEY,
  restaurant_address VARCHAR(100) NOT NULL,
  restaurant_municipality VARCHAR(100) NOT NULL,
  restaurant_zone INT NOT NULL,
  restaurant_phone INT NOT NULL,
  restaurant_staff INT NOT NULL,
  restaurant_parking SMALLINT NOT NULL
);


-- Employee Table
CREATE TABLE IF NOT EXISTS employee(
  employee_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_name VARCHAR(50) NOT NULL,
  employee_surname VARCHAR(50) NOT NULL,
  employee_birthdate DATE NOT NULL,
  employee_email VARCHAR(50) NOT NULL,
  employee_phone INT NOT NULL,
  employee_address VARCHAR(100) NOT NULL,
  employee_dpi BIGINT NOT NULL,
  employee_start_date DATE NOT NULL,
  employee_job INT NOT NULL,
  employee_restaurant VARCHAR(100) NOT NULL,
  FOREIGN KEY (employee_job) REFERENCES job(job_id) ON DELETE CASCADE,
  FOREIGN KEY (employee_restaurant) REFERENCES restaurant(restaurant_id) ON DELETE CASCADE
);

-- Client table
CREATE TABLE IF NOT EXISTS client(
  client_dpi BIGINT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  birthdate DATE NOT NULL,
  email VARCHAR(50) NOT NULL,
  phone INT NOT NULL,
  nit INT
);

-- Client_address table
CREATE TABLE IF NOT EXISTS client_address(
  client_address_id INT PRIMARY KEY AUTO_INCREMENT,
  client_dpi BIGINT NOT NULL,
  address VARCHAR(100) NOT NULL,
  municipality VARCHAR(50) NOT NULL,
  zone INT NOT NULL,
  FOREIGN KEY (client_dpi) REFERENCES client(client_dpi) ON DELETE CASCADE
);

-- Product table
CREATE TABLE IF NOT EXISTS product(
  product_id VARCHAR(10) PRIMARY KEY,
  product_type CHAR NOT NULL,
  product_number INT NOT NULL,
  product_name VARCHAR(50) NOT NULL,
  product_price DECIMAL(10,2) NOT NULL
);

-- Order table
CREATE TABLE IF NOT EXISTS order_(
  order__id INT PRIMARY KEY AUTO_INCREMENT,
  order__start_date DATETIME NOT NULL,
  order__end_date DATETIME ,
  order__status VARCHAR(50) NOT NULL,
  order__status_int INT NOT NULL,
  order__client_dpi BIGINT NOT NULL,
  order__client_address VARCHAR(100) NOT NULL,
  order__channel CHAR NOT NULL,
  order__restaurant_id VARCHAR(100),
  order__employee_id BIGINT ,
  order__payment_method CHAR,
  FOREIGN KEY (order__client_dpi) REFERENCES client(client_dpi) ON DELETE CASCADE,
  FOREIGN KEY (order__restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE CASCADE,
  FOREIGN KEY (order__employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE
);



-- Order_Product table
CREATE TABLE IF NOT EXISTS order_product(
  order_product_id INT PRIMARY KEY AUTO_INCREMENT,
  order_product_ptype CHAR NOT NULL,
  order_product_pnumber INT NOT NULL,
  order_product_ammount INT NOT NULL,
  order_product_observation VARCHAR(100) NOT NULL,
  order_product_orderid INT NOT NULL,
  order_product_price DECIMAL (10,2)NOT NULL,
  FOREIGN KEY (order_product_orderid) REFERENCES order_(order__id) ON DELETE CASCADE
);


-- Bill table
CREATE TABLE IF NOT EXISTS bill(
  bill_serial_number VARCHAR(50) PRIMARY KEY,
  bill_total DECIMAL(10,2) NOT NULL,
  bill_place VARCHAR(100) NOT NULL,
  bill_date_time DATETIME NOT NULL,
  bill_order_id INT NOT NULL,
  bill_client_nit VARCHAR(50) NOT NULL,
  bill_payment_method CHAR,
  FOREIGN KEY (bill_order_id) REFERENCES order_(order__id) ON DELETE CASCADE
);


INSERT INTO product (product_id,product_type, product_number, product_name, product_price) VALUES
('C1', 'C', 1, 'Cheeseburger',41.00),
('C2', 'C', 2, 'Chicken Sandwinch',32.00),
('C3', 'C', 3, 'BBQ Ribs',54.00),
('C4', 'C', 4, 'Pasta Alfredo',47.00),
('C5', 'C', 5, 'Pizza Espinator',85.00),
('C6', 'C', 6, 'Buffalo Wings',36.00),
('E1', 'E', 1, 'Papas fritas',15.00),
('E2', 'E', 2, 'Aros de cebolla',17.00),
('E3', 'E', 3, 'Coleslaw',12.00),
('B1', 'B', 1, 'Coca-Cola',12.00),
('B2', 'B', 2, 'Fanta',12.00),
('B3', 'B', 3, 'Sprite',12.00),
('B4', 'B', 4, 'Té frío',12.00),
('B5', 'B', 5, 'Cerveza de barril',18.00),
('P1', 'P', 1, 'Copa de helado',13.00),
('P2', 'P', 2, 'Cheesecake',15.00),
('P3', 'P', 3, 'Cupcake de chocolate',8.00),
('P4', 'P', 4, 'Flan',10.00);
