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
			p_restaurant_parking SMALLINT
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
				INSERT INTO restaurant (restaurant_id, restaurant_address, restaurant_municipality, restaurant_zone, restaurant_phone, restaurant_staff, restaurant_parking)
				VALUES (p_restaurant_id, p_restaurant_address, p_restaurant_municipality, p_restaurant_zone, p_restaurant_phone, p_restaurant_staff, p_restaurant_parking);
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
		IN p_employee_birthdate DATE,
		IN p_employee_email VARCHAR(50),
		IN p_employee_phone INT,
		IN p_employee_address VARCHAR(100),
		IN p_employee_dpi BIGINT,
		IN p_employee_job INT,
		IN p_employee_start_date DATE,
		IN p_employee_restaurant VARCHAR(100)
		
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
					IF NOT EXISTS (SELECT 1 FROM restaurant WHERE restaurant_id = p_employee_restaurant) THEN
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
			SET MESSAGE_TEXT = 'The employee dpi already exists in the employee table!!';
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
		IF parameter_salary <= 0  THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Job Salary must be a positive integer';
		ELSE
			-- Verify if job name exists
			IF NOT EXISTS (SELECT 1 FROM job WHERE name = parameter_name) THEN
				-- Insert a new job
				INSERT INTO job (name, description, salary)
				VALUES (parameter_name, parameter_description, parameter_salary);
			ELSE
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'The job name already exists in the job table';
			END IF;
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





-- ================================== 6. Create A New Order Procedure ==================================
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
			IF NOT EXISTS (SELECT 1 FROM client_address WHERE client_address_id = p_order_address_id
			AND client_dpi=p_order_dpi) THEN
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
						INSERT INTO order_ (order__start_date, order__end_date, order__status, order__status_int,order__client_dpi,
						order__client_address,order__channel,order__restaurant_id,order__employee_id,order__payment_method)
						VALUES (NOW(),NULL,'SIN COBERTURA',-1,p_order_dpi,p_order_address_id,p_order_channel,NULL,NULL,NULL);
						SIGNAL SQLSTATE '45000'
						SET MESSAGE_TEXT = 'The client address does not have coverage for the order!!';
					ELSE
						-- function to return the coverage restaurant id
						SET restaurand_id = return_coverage_restaurant_id(p_order_address_id);
						-- Insert a new order
						INSERT INTO order_ (order__start_date, order__end_date, order__status, order__status_int,order__client_dpi,
						order__client_address,order__channel,order__restaurant_id,order__employee_id,order__payment_method)
						VALUES (NOW(),NULL,'INICIADA',1,p_order_dpi,p_order_address_id,p_order_channel,restaurand_id,NULL,NULL);
					END IF;
				END IF;
			END IF;
		END IF;
	END;
//
DELIMITER;

-- Delete the CrearOrden procedure
DROP PROCEDURE IF EXISTS CrearOrden;





-- ================================== 7. Add Item To An Order  Procedure==================================
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
		DECLARE product_price DECIMAL(10,2);
		-- If order id not exists
		IF NOT EXISTS (SELECT 1 FROM order_ WHERE order__id = p_order_id AND (order__status_int = 1 OR order__status_int=2)) THEN
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
							-- Update the order status
							CALL update_order_status(p_order_id,'AGREGANDO',2);
						END IF;
						-- Insert a new order_product detail
						SET product_price =return_product_price(p_product_type,p_product_number);
						INSERT INTO order_product (order_product_ptype, order_product_pnumber, order_product_ammount, order_product_observation,
						order_product_orderid,order_product_price)
						VALUES (p_product_type,p_product_number,p_ammount,p_observation,p_order_id,product_price);
					END IF;
				END IF;
			END IF;
		END IF;
	END;
//
DELIMITER;

-- Delete the AgregarItem procedure
DROP PROCEDURE IF EXISTS AgregarItem;





-- ================================== 8. Confirm  Order Procedure ==================================
DELIMITER //
	CREATE PROCEDURE ConfirmarOrden(
		IN p_order_id BIGINT,
		IN p_payment_method CHAR,
		IN p_employee_id INT
	)
	BEGIN
		DECLARE total_bill DECIMAL(10,2);
		DECLARE payment_method CHAR;
		DECLARE client_dpi BIGINT;
		DECLARE client_nit VARCHAR(20);
		DECLARE client_direction VARCHAR(100);
		-- If order id not exists
		IF NOT EXISTS (SELECT 1 FROM order_ WHERE order__id = p_order_id AND order__status_int = 2) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The order id does not exist, or has a invalid status!!';
		ELSE
			-- Verify employee id existence
			IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = p_employee_id ) THEN
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'The employee id does not exist!!';
			ELSE
				-- Verify a correct payment method
				IF LENGTH(p_payment_method) <> 1 
				OR (UPPER(SUBSTRING(p_payment_method, 1, 1)) <> 'E' AND UPPER(SUBSTRING(p_payment_method, 1, 1)) <> 'T') THEN
					SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'The payment method must be single character strings of specific values (E/T) !!';
				ELSE
					-- Update the order status
					CALL update_order_status(p_order_id,'EN CAMINO',3);
					-- Update order employee and payment method
					CALL update_order_employee(p_order_id,p_employee_id,p_payment_method);
					-- Insert a new Bill
					SET total_bill=calculate_order_total(p_order_id);
					SET payment_method=return_order_payment_method(p_order_id);
					SET client_dpi=return_order_client_dpi(p_order_id);
					SET client_direction=return_order_client_address(p_order_id);
					SET client_nit=return_client_nit(client_dpi);
					INSERT INTO bill (bill_serial_number, bill_total, bill_place, bill_date_time,
						bill_order_id,bill_client_nit,bill_payment_method)
						VALUES (CONCAT(YEAR(NOW()),p_order_id),total_bill,client_direction,NOW(),p_order_id,client_nit,payment_method);
				END IF;
			END IF;
		END IF;
	END;
//
DELIMITER;

-- Delete the ConfirmarOrden procedure
DROP PROCEDURE IF EXISTS ConfirmarOrden;





-- ================================== 9. Finish  Order Procedure ==================================
DELIMITER //
	CREATE PROCEDURE FinalizarOrden(
		IN p_order_id BIGINT
	)
	BEGIN
		-- If order id not exists
		IF NOT EXISTS (SELECT 1 FROM order_ WHERE order__id = p_order_id AND order__status_int = 3) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The order id does not exist, or has a invalid status!!';
		ELSE
			-- Update the end date Order
			CALL update_order_end_date (p_order_id);
			-- Update the order status
			CALL update_order_status(p_order_id,'ENTREGADA',4);
		END IF;
	END;
//
DELIMITER;

-- Delete the FinalizarOrden procedure
DROP PROCEDURE IF EXISTS FinalizarOrden;








-- ================================== REPORT# 01 List Restaurants ==================================
DELIMITER //
CREATE PROCEDURE ListarRestaurantes()
BEGIN
  SELECT
    restaurant_id,
    restaurant_address,
    restaurant_municipality,
    restaurant_zone,
    restaurant_phone,
    restaurant_staff,
    CASE restaurant_parking
      WHEN 1 THEN 'si'
      ELSE 'no'
    END AS restaurant_parking
  FROM restaurant;
END//
DELIMITER ;

-- Delete the ListarRestaurantes procedure
DROP PROCEDURE IF EXISTS ListarRestaurantes;


-- ================================== REPORT# 02 Consult Employee ==================================
DELIMITER //
	CREATE PROCEDURE ConsultarEmpleado(
		IN p_employee_id INT
	)
	BEGIN
		DECLARE job_name VARCHAR(50);
		DECLARE job_salary DECIMAL(10,2);
		DECLARE job_id INT;
		-- Verify if employee id exists
		IF NOT EXISTS (SELECT 1 FROM employee WHERE employee_id = p_employee_id) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The employee id not exists in the employee table!!';
		ELSE
			SET job_id=return_job_id(p_employee_id);
			SET job_name=return_job_name(job_id);
			SET job_salary=return_job_salary(job_id);

			SELECT LPAD(employee_id, 8, '0') AS id,
				CONCAT(employee_name, ' ', employee_surname) AS name,
        employee_birthdate,
        employee_email,
        employee_phone,
        employee_address,
        employee_dpi,
        job_name,
        employee_start_date,
        job_salary
			FROM employee
			WHERE employee_id  = p_employee_id;
		END IF;
	END;
//
DELIMITER;


-- Delete the ConsultarEmpleado procedure
DROP PROCEDURE IF EXISTS ConsultarEmpleado;



-- ================================== REPORT# 03 Consult Client Order ==================================
DELIMITER //
	CREATE PROCEDURE ConsultarPedidosCliente(
		IN p_order_id INT
	)
	BEGIN
		-- Verify if order id exists
		IF NOT EXISTS (SELECT 1 FROM order_ WHERE order__id = p_order_id AND order__status_int != -1) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The order not exists or has a not coverage status!!';
		ELSE

			SELECT
				return_product_name(order_product_ptype,order_product_pnumber) AS name,
				CASE order_product_ptype
					WHEN 'C' THEN 'Combo'
					WHEN 'B' THEN 'Bebida'
					WHEN 'P' THEN 'Postre'
					ELSE 'Extra'
				END AS order_product_ptype,
				order_product_price,
				order_product_ammount,
				order_product_observation
			FROM order_product
			WHERE order_product_orderid=p_order_id;
		END IF;
	END;
//
DELIMITER;


-- Delete the ConsultarPedidosCliente procedure
DROP PROCEDURE IF EXISTS ConsultarPedidosCliente;

-- ================================== REPORT# 04 Client Orders ==================================
DELIMITER //
	CREATE PROCEDURE ConsultarHistorialOrdenes(
		IN p_client_dpi BIGINT
	)
	BEGIN
		-- Verify if client dpi exists
		IF NOT EXISTS (SELECT 1 FROM client WHERE client_dpi = p_client_dpi) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The client dpi not exists in the client table!!';
		ELSE
			SELECT order__id,
				order__start_date,
				COALESCE(calculate_order_total(order__id), 'N/A') AS total,
				COALESCE(order__restaurant_id, 'N/A') AS restaurant_id,
				COALESCE(return_employee_name(order__employee_id), 'N/A') AS employee,
				COALESCE(return_client_address_address(order__client_address),'N/A') AS address,
				CASE order__channel
					WHEN 'L' THEN 'Llamada'
					ELSE 'Aplicacion'
				END AS order__channel,
				order__status
			FROM order_
			WHERE order__client_dpi  = p_client_dpi;
		END IF;
	END;
//
DELIMITER;


-- Delete the ConsultarHistorialOrdenes procedure
DROP PROCEDURE IF EXISTS ConsultarHistorialOrdenes;


-- ================================== REPORT# 05 Client Addresses ==================================
DELIMITER //
	CREATE PROCEDURE ConsultarDirecciones(
		IN p_client_dpi BIGINT
	)
	BEGIN
		-- Verify if client dpi exists
		IF NOT EXISTS (SELECT 1 FROM client WHERE client_dpi = p_client_dpi) THEN
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'The client dpi not exists in the client table!!';
		ELSE
			SELECT address,
			municipality,
			zone
			FROM client_address
			WHERE client_dpi  = p_client_dpi;
		END IF;
	END;
//
DELIMITER;


-- Delete the ConsultarDirecciones procedure
DROP PROCEDURE IF EXISTS ConsultarDirecciones;


-- ================================== REPORT# 06 Show Orders By Status ==================================
DELIMITER //
	CREATE PROCEDURE MostrarOrdenes(
		IN p_order_status INT
	)
	BEGIN
		SELECT
			order__id,
			order__status,
			order__start_date,
			order__client_dpi,
			COALESCE(return_client_address_address(order__client_address),'N/A') AS address,
			COALESCE(order__restaurant_id, 'N/A') AS restaurant_id,
			CASE order__channel
				WHEN 'L' THEN 'Llamada'
				WHEN 'A' THEN 'Aplicacion'
				ELSE 'N/A'
			END AS order__channel
		FROM order_
		WHERE order__status_int=p_order_status;
	END;
//
DELIMITER;

-- Delete the MostrarOrdenes procedure
DROP PROCEDURE IF EXISTS MostrarOrdenes;


-- ================================== REPORT# 07 Consult Bills ==================================
DELIMITER //
	CREATE PROCEDURE ConsultarFacturas(
		IN p_day INT,
		IN p_month INT,
		IN p_year INT
	)
	BEGIN
		SELECT  
			bill_serial_number,
			bill_total,
			return_client_address_address(bill_place) AS bill_place ,
			bill_date_time,
			bill_order_id,
			bill_client_nit,
			CASE bill_payment_method
				WHEN 'T' THEN 'Tarjeta'
				WHEN 'E' THEN 'Efectivo'
				ELSE 'N/A'
			END AS bill_payment_method
		FROM bill
		WHERE DAY(bill_date_time) = p_day
    AND MONTH(bill_date_time) = p_month
    AND YEAR(bill_date_time) = p_year;
	END;
//
DELIMITER;

-- Delete the ConsultarFacturas procedure
DROP PROCEDURE IF EXISTS ConsultarFacturas;


-- ================================== REPORT# 08 Timeouts ==================================
DELIMITER //
	CREATE PROCEDURE ConsultarTiempos(
		IN p_minutes INT
	)
	BEGIN
		DECLARE minutes INT;
		SELECT
			order__id,
			COALESCE(return_client_address_address(order__client_address),'N/A') AS address,
			order__start_date,
			calculate_order_timeout(order__id) AS minutes,
			COALESCE(return_employee_name(order__employee_id), 'N/A') AS employee
		FROM order_
		WHERE order__end_date IS NOT NULL AND
		TIMESTAMPDIFF(MINUTE, order__start_date,order__end_date ) >=p_minutes;
	END;
//
DELIMITER;

-- Delete the ConsultarTiempos procedure
DROP PROCEDURE IF EXISTS ConsultarTiempos;