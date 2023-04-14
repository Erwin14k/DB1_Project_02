-- ================================== 1. Insert Restaurant Procedure ==================================
DELIMITER //
	CREATE PROCEDURE insert_restaurant(
			-- Parameters
			p_restaurant_id VARCHAR(100),
			p_restaurant_direction VARCHAR(100),
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
				INSERT INTO restaurant (restaurant_id, restaurant_direction, restaurant_municipality, restaurant_zone, restaurant_phone, restaurant_staff, restaurant_parking, restaurant_manager)
				VALUES (p_restaurant_id, p_restaurant_direction, p_restaurant_municipality, p_restaurant_zone, p_restaurant_phone, p_restaurant_staff, p_restaurant_parking, p_restaurant_manager);
			END IF;
		END IF;
	END;
//
DELIMITER ;

-- Delete the insert_restaurant procedure
DROP PROCEDURE IF EXISTS insert_restaurant;





-- ================================== 3. Insert Job Procedure ==================================
DELIMITER //
	CREATE PROCEDURE insert_job(
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

-- Delete the insert_job procedure
DROP PROCEDURE IF EXISTS insert_job;





-- ================================== 4. Insert Client Procedure ==================================
DELIMITER //
	CREATE PROCEDURE insert_client(
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

-- Delete the insert_client procedure
DROP PROCEDURE IF EXISTS insert_client;





-- ================================== 5. Insert Client Direction Procedure ==================================
DELIMITER //
	CREATE PROCEDURE insert_client_direction(
		IN p_client_direction_dpi BIGINT,
		IN p_client_direction_direction VARCHAR(100),
		IN p_client_direction_municipality VARCHAR(50),
		IN p_client_direction_zone INT
	)
	BEGIN
		IF p_client_direction_zone <= 0  THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'The client address zone must be a positive integer!!';
		ELSE
			-- If client dpi not exists
			IF NOT EXISTS (SELECT 1 FROM client WHERE client_dpi = p_client_direction_dpi) THEN
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'The client dpi not exists in the client table!!';
			ELSE
				-- Insert a new client direction
				INSERT INTO client_direction (client_dpi, direction, municipality, zone)
					VALUES (p_client_direction_dpi,p_client_direction_direction,p_client_direction_municipality,p_client_direction_zone);
				
			END IF;
		END IF;
	END;
//
DELIMITER;

-- Delete the insert_client_direction procedure
DROP PROCEDURE IF EXISTS insert_client_direction;





-- ================================== 6. Create A New Order ==================================
DELIMITER //
	CREATE PROCEDURE create_new_order(
		IN p_order_dpi BIGINT,
		IN p_order_direction_id INT,
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
			-- If client direction not exists
			IF NOT EXISTS (SELECT 1 FROM client_direction WHERE client_direction_id = p_order_direction_id) THEN
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'The client direction not exists in the client_direction table!!';
			ELSE
				IF LENGTH(p_order_channel) <> 1 
				OR (UPPER(SUBSTRING(p_order_channel, 1, 1)) <> 'L' AND UPPER(SUBSTRING(p_order_channel, 1, 1)) <> 'A') THEN
					SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'The order channel must be single character strings of specific values (L/A) !!';
				ELSE
					-- function to verify client direction coverage
					SET v_result = check_client_direction_coverage(p_order_direction_id);
					-- If the address does not apply in the registered coverage of restaurants
					IF v_result = FALSE THEN
						SIGNAL SQLSTATE '45000'
						SET MESSAGE_TEXT = 'The client direction does not have coverage for the order!!';
					ELSE
						-- function to verify client direction coverage
						SET restaurand_id = return_coverage_restaurant_id(p_order_direction_id);
						-- Insert a new order
						INSERT INTO order_r (order_r_start_date, order_r_end_date, order_r_status, order_r_client_dpi,
						order_r_client_direction,order_r_channel,order_r_restaurant_id,order_r_employee_id)
						VALUES (NOW(),NULL,'INICIADA',p_order_dpi,p_order_direction_id,p_order_channel,restaurand_id,NULL);
					END IF;
				END IF;
			END IF;
		END IF;
	END;
//
DELIMITER;

-- Delete the create_new_order procedure
DROP PROCEDURE IF EXISTS create_new_order;



