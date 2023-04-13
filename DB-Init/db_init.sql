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
TRUNCATE TABLE order_r ;
TRUNCATE TABLE order_product ;
TRUNCATE TABLE product;
TRUNCATE TABLE job;
TRUNCATE TABLE client;
TRUNCATE TABLE client_direction;

-- Drop Tables
DROP TABLE restaurant ;
DROP TABLE employee ;
DROP TABLE order_r ;
DROP TABLE order_product ;
DROP TABLE product;
DROP TABLE job;
DROP TABLE client;
DROP TABLE client_direction;

-- Select * From Tables
SELECT * FROM  restaurant ;
SELECT * FROM  employee ;
SELECT * FROM  order_r ;
SELECT * FROM  order_product ;
SELECT * FROM  product;
SELECT * FROM  job;
SELECT * FROM client;
SELECT * FROM  client_direction;




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
        restaurant_direction VARCHAR(100) NOT NULL,
        restaurant_municipality VARCHAR(100) NOT NULL,
        restaurant_zone INT NOT NULL,
        restaurant_phone INT NOT NULL,
        restaurant_staff INT NOT NULL,
        restaurant_parking SMALLINT NOT NULL,
        restaurant_manager INT NOT NULL
);


-- Employee Table
CREATE TABLE IF NOT EXISTS employee(
	employee_id BIGINT PRIMARY KEY,
        employee_name VARCHAR(50) NOT NULL,
        employee_surname VARCHAR(50) NOT NULL,
        employee_birthdate DATE NOT NULL,
        employee_email VARCHAR(50) NOT NULL,
        employee_phone INT NOT NULL,
        employee_direction VARCHAR(100) NOT NULL,
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
        NIT INT
);

-- Client_Direction table
CREATE TABLE IF NOT EXISTS client_direction(
	client_direction_id INT PRIMARY KEY AUTO_INCREMENT,
        client_dpi BIGINT NOT NULL,
        direction VARCHAR(100) NOT NULL,
        municipality VARCHAR(50) NOT NULL,
        zone INT NOT NULL,
        FOREIGN KEY (client_dpi) REFERENCES client(client_dpi) ON DELETE CASCADE
);

-- Product table
CREATE TABLE IF NOT EXISTS product(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
        product_type CHAR NOT NULL,
        product_number INT NOT NULL,
        product_name VARCHAR(50) NOT NULL,
        product_price DECIMAL(10,2) NOT NULL
);

-- Order table
CREATE TABLE IF NOT EXISTS order_r(
	order_r_id INT PRIMARY KEY AUTO_INCREMENT,
        order_r_start_date DATE NOT NULL,
        order_r_end_date DATE NOT NULL,
        order_r_status VARCHAR(50) NOT NULL,
        order_r_client_dpi BIGINT NOT NULL,
        order_r_client_direction VARCHAR(100) NOT NULL,
        order_r_channel CHAR NOT NULL,
        order_r_restaurant_id VARCHAR(100)  NOT NULL,
        order_r_employee_id BIGINT  NOT NULL,
        FOREIGN KEY (order_r_client_dpi) REFERENCES client(client_dpi) ON DELETE CASCADE,
        FOREIGN KEY (order_r_restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE CASCADE,
        FOREIGN KEY (order_r_employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE
);



-- Order_Product table
CREATE TABLE IF NOT EXISTS order_product(
	order_product_id INT PRIMARY KEY AUTO_INCREMENT,
        order_product_ptype CHAR NOT NULL,
        order_product_pnumber INT NOT NULL,
        order_product_ammount INT NOT NULL,
        oder_product_observation VARCHAR(100) NOT NULL,
        order_product_pid INT NOT NULL,
        order_product_orderid INT NOT NULL,
        FOREIGN KEY (order_product_pid) REFERENCES product(product_id) ON DELETE CASCADE,
        FOREIGN KEY (order_product_orderid) REFERENCES order_r(order_r_id) ON DELETE CASCADE
);