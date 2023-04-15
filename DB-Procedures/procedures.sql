-- ================================== 1. Insert Restaurant Procedure ==================================
DELIMITER //
	CREATE PROCEDURE RegistrarRestaurante(
			-- Parameters
			p_restaurant_id VARCHAR(100),
			p_restaurant_address VARCHAR(100),
			p_restaurant_municipality VARCHAR(100),
			p_restaurant_zone INT,
			p_restaurant_phone INT,
			p_restaurant_staff INT,
			p_restaurant_parking SMALLINT,
			p_restaurant_manager INT
	)
	BEGIN
		DECLARE restaurant_count INT; -- restaurant id match counter
		-- Verify if "zone" and "staff" parameters are positive integers
		IF p_restaurant_zone <= 0 OR p_restaurant_staff <= 0 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'restaurant_zone and restaurant_staff must be positive integers';
		ELSE
			-- -- Verify if restaurant name exists
			SELECT COUNT(*) INTO restaurant_count FROM restaurant WHERE restaurant_id = p_restaurant_id;
			IF restaurant_count > 0 THEN -- If exists
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'The restaurant id already exists on the restaurant table';
			ELSE
				-- Insert a new restaurant
				INSERT INTO restaurant (restaurant_id, restaurant_address, restaurant_municipality, restaurant_zone, restaurant_phone, restaurant_staff, restaurant_parking, restaurant_manager)
				VALUES (p_restaurant_id, p_restaurant_address, p_restaurant_municipality, p_restaurant_zone, p_restaurant_phone, p_restaurant_staff, p_restaurant_parking, p_restaurant_manager);
			END IF;
		END IF;
	END;
//
DELIMITER ;

-- Delete the RegistrarRestaurante procedure
DROP PROCEDURE IF EXISTS RegistrarRestaurante;





-- ================================== 2. Insert Employee Procedure ==================================
DELIMITER //
	CREATE PROCEDURE CrearEmpleado(
		IN p_employee_name VARCHAR(50),
		IN p_employee_surname VARCHAR(50),
		IN p_employee_birthdate DATE(50),
		IN p_employee_email VARCHAR(50),
		IN p_employee_phone INT,
		IN p_employee_address VARCHAR(100),
		IN p_employee_dpi BIGINT,
		IN p_employee_start_date DATE,
		IN p_employee_job INT,
		IN p_employee_restaurant INT
		
	)
	BEGIN
		-- Verify if employee dpi exists
		IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_dpi = p_employee_dpi) THEN
			-- Validate email format
			IF REGEXP_LIKE(p_employee_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
				-- Verify if employee job exists
				IF NOT EXISTS (SELECT 1 FROM job WHERE job_id = p_employee_job) THEN
					SIGNAL SQLSTATE '45000' 
					SET MESSAGE_TEXT = 'The employee job not exists!!';
				ELSE
					-- Verify if employee restaurant exists
					IF NOT EXISTS (SELECT 1 FROM restaurant WHERE restaurand_id = p_employee_restaurant) THEN
						SIGNAL SQLSTATE '45000' 
						SET MESSAGE_TEXT = 'The employee restaurant not exists!!';
					ELSE
						-- Insert a new employee
						INSERT INTO employee (employee_name, employee_surname, employee_birthdate, employee_email, employee_phone, employee_address, employee_dpi,employee_start_date,employee_job,employee_restaurant)
						VALUES (p_employee_name, p_employee_surname, p_employee_birthdate, p_employee_email, p_employee_phone, p_employee_address, p_employee_dpi,p_employee_start_date,p_employee_job,p_employee_restaurant);
					END IF;
				END IF;
			ELSE
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'Invalid email format!!';
			END IF;
		ELSE
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The employee dpi already exists in the client table!!';
		END IF;
	END;
//
DELIMITER;

-- Delete the CrearEmpleado procedure
DROP PROCEDURE IF EXISTS CrearEmpleado;





-- ================================== 3. Insert Job Procedure ==================================
DELIMITER //
	CREATE PROCEDURE RegistrarPuesto(
		IN parameter_name VARCHAR(50),
		IN parameter_description VARCHAR(150),
		IN parameter_salary DECIMAL(10,2)
	)
	BEGIN
		-- Verify if job name exists
		IF NOT EXISTS (SELECT 1 FROM job WHERE name = parameter_name) THEN
			-- Insert a new job
			INSERT INTO job (name, description, salary)
			VALUES (parameter_name, parameter_description, parameter_salary);
		ELSE
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The job name already exists in the job table';
		END IF;
	END;
//
DELIMITER ;

-- Delete the RegistrarPuesto procedure
DROP PROCEDURE IF EXISTS RegistrarPuesto;





-- ================================== 4. Insert Client Procedure ==================================
DELIMITER //
	CREATE PROCEDURE RegistrarCliente(
		IN p_client_dpi BIGINT,
		IN p_client_name VARCHAR(50),
		IN p_client_surname VARCHAR(50),
		IN p_client_birthdate DATE,
		IN p_client_email VARCHAR(50),
		IN p_client_phone INT ,
		IN p_client_nit INT
	)
	BEGIN
		-- Verify if client dpi exists
		IF NOT EXISTS (SELECT 1 FROM client WHERE client_dpi = p_client_dpi) THEN
			-- Validate email format
			IF REGEXP_LIKE(p_client_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
				-- Insert a new client
				INSERT INTO client (client_dpi, name, surname, birthdate, email, phone, nit)
				VALUES (p_client_dpi, p_client_name, p_client_surname, p_client_birthdate, p_client_email, p_client_phone, p_client_nit);
			ELSE
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'Invalid email format';
			END IF;
		ELSE
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The client dpi already exists in the client table';
		END IF;
	END;
//
DELIMITER;

-- Delete the RegistrarCliente procedure
DROP PROCEDURE IF EXISTS RegistrarCliente;





-- ================================== 5. Insert Client address Procedure ==================================
DELIMITER //
	CREATE PROCEDURE RegistrarDireccion(
		IN p_client_address_dpi BIGINT,
		IN p_client_address_address VARCHAR(100),
		IN p_client_address_municipality VARCHAR(50),
		IN p_client_address_zone INT
	)
	BEGIN
		IF p_client_address_zone <= 0  THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'The client address zone must be a positive integer!!';
		ELSE
			-- If client dpi not exists
			IF NOT EXISTS (SELECT 1 FROM client WHERE client_dpi = p_client_address_dpi) THEN
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'The client dpi not exists in the client table!!';
			ELSE
				-- Insert a new client address
				INSERT INTO client_address (client_dpi, address, municipality, zone)
					VALUES (p_client_address_dpi,p_client_address_address,p_client_address_municipality,p_client_address_zone);
				
			END IF;
		END IF;
	END;
//
DELIMITER;

-- Delete the RegistrarDireccion procedure
DROP PROCEDURE IF EXISTS RegistrarDireccion;





-- ================================== 6. Create A New Order ==================================
DELIMITER //
	CREATE PROCEDURE CrearOrden(
		IN p_order_dpi BIGINT,
		IN p_order_address_id INT,
		IN p_order_channel CHAR
	)
	BEGIN
		DECLARE v_result BOOLEAN;
		DECLARE restaurand_id VARCHAR(100);
		-- If client dpi not exists
		IF NOT EXISTS (SELECT 1 FROM client WHERE client_dpi = p_order_dpi) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The client dpi not exists in the client table!!';
		ELSE
			-- If client address not exists
			IF NOT EXISTS (SELECT 1 FROM client_address WHERE client_address_id = p_order_address_id) THEN
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'The client address not exists in the client_address table!!';
			ELSE
				IF LENGTH(p_order_channel) <> 1 
				OR (UPPER(SUBSTRING(p_order_channel, 1, 1)) <> 'L' AND UPPER(SUBSTRING(p_order_channel, 1, 1)) <> 'A') THEN
					SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'The order channel must be single character strings of specific values (L/A) !!';
				ELSE
					-- function to verify client address coverage
					SET v_result = check_client_address_coverage(p_order_address_id);
					-- If the address does not apply in the registered coverage of restaurants
					IF v_result = FALSE THEN
						-- Insert a new order with "Sin Cobertura" status
						INSERT INTO order_ (order__start_date, order__end_date, order__status, order__client_dpi,
						order__client_address,order__channel,order__restaurant_id,order__employee_id)
						VALUES (NOW(),NULL,'SIN COBERTURA',-1,p_order_dpi,p_order_address_id,p_order_channel,NULL,NULL);
						SIGNAL SQLSTATE '45000'
						SET MESSAGE_TEXT = 'The client address does not have coverage for the order!!';
					ELSE
						-- function to return the coverage restaurant id
						SET restaurand_id = return_coverage_restaurant_id(p_order_address_id);
						-- Insert a new order
						INSERT INTO order_ (order__start_date, order__end_date, order__status, order__client_dpi,
						order__client_address,order__channel,order__restaurant_id,order__employee_id)
						VALUES (NOW(),NULL,'INICIADA',1,p_order_dpi,p_order_address_id,p_order_channel,restaurand_id,NULL);
					END IF;
				END IF;
			END IF;
		END IF;
	END;
//
DELIMITER;

-- Delete the CrearOrden procedure
DROP PROCEDURE IF EXISTS CrearOrden;





-- ================================== 7. Add Item To A Order ==================================
DELIMITER //
	CREATE PROCEDURE AgregarItem(
		IN p_order_id BIGINT,
		IN p_product_type CHAR,
		IN p_product_number INT,
		IN p_ammount INT,
		IN p_observation VARCHAR(100)
	)
	BEGIN
		DECLARE v_result BOOLEAN;
		DECLARE order_status VARCHAR(50);
		-- If order id not exists
		IF NOT EXISTS (SELECT 1 FROM order_ WHERE order__id = p_order_id AND order__status_int != -1) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The order id does not exist, or has a status of non-coverage.!!';
		ELSE
			-- Verify a positive number in amount parameter
			IF p_ammount <= 0  THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'The product ammount must be a positive integer!!';
			ELSE
				-- Verify a correct product type
				IF LENGTH(p_product_type) <> 1 
				OR (UPPER(SUBSTRING(p_product_type, 1, 1)) <> 'C' AND UPPER(SUBSTRING(p_product_type, 1, 1)) <> 'E'
				AND UPPER(SUBSTRING(p_product_type, 1, 1)) <> 'B' AND UPPER(SUBSTRING(p_product_type, 1, 1)) <> 'P') THEN
					SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'The product type must be single character strings of specific values (C/E/B/P) !!';
				ELSE
					-- function to verify a product existence
					SET v_result = check_product_existence(p_product_type,p_product_number);
					-- If the product not exists
					IF v_result = FALSE THEN
						SIGNAL SQLSTATE '45000'
						SET MESSAGE_TEXT = 'The product not exists!!';
					ELSE
						-- function to return the order status
						SET order_status = return_order_status(p_order_id);
						IF order_status = 'INICIADA' THEN
							--Update the order status
							CALL update_order_status(p_order_id,'AGREGANDO',2);
						END IF;
						-- Insert a new order_product detail
						INSERT INTO order_product (order_product_ptype, order_product_pnumber, order_product_ammount, oder_product_observation,
						order_product_orderid)
						VALUES (p_product_type,p_product_number,p_ammount,p_observation,p_order_id);
					END IF;
				END IF;
			END IF;
		END IF;
	END;
//
DELIMITER;

-- Delete the AgregarItem procedure
DROP PROCEDURE IF EXISTS AgregarItem;









