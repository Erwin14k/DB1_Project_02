-- Function to verify if exists a restaurant with coverage area
DELIMITER //
  CREATE FUNCTION check_client_address_coverage(
    p_client_address_id INT
  )
  RETURNS BOOLEAN
  READS SQL DATA
  BEGIN
  DECLARE v_municipality VARCHAR(50);
  DECLARE v_zone INT;

	-- Obtaint "municipality" and "zone" of the client_address_id
	SELECT municipality, zone INTO v_municipality, v_zone
	FROM client_address
	WHERE client_address_id = p_client_address_id;

	-- Verify a restaurant "municipality" and "zone" match
	IF EXISTS (
		SELECT 1
		FROM restaurant
		WHERE restaurant_municipality = v_municipality
		AND restaurant_zone = v_zone
	) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END//
DELIMITER ;





-- Function to return the id of the restaurant who has coverage area
DELIMITER //
  CREATE FUNCTION return_coverage_restaurant_id(
    p_client_address_id INT
  )
  -- Varchar return
  RETURNS VARCHAR(100) 
  READS SQL DATA
  BEGIN
  DECLARE v_municipality VARCHAR(50);
  DECLARE v_zone INT;
  DECLARE v_restaurant_id VARCHAR(100); 
    
  -- Obtaint "municipality" and "zone" of the client_address_id
  SELECT municipality, zone INTO v_municipality, v_zone
  FROM client_address
  WHERE client_address_id = p_client_address_id;

  -- Verify a restaurant "municipality" and "zone" match
  SELECT restaurant_id INTO v_restaurant_id
  FROM restaurant
  WHERE restaurant_municipality = v_municipality
  AND restaurant_zone = v_zone;

  -- If a coverage restaurant exists
  IF v_restaurant_id IS NOT NULL THEN
    -- Return the restaurant id
    RETURN v_restaurant_id;
  ELSE
    RETURN '-1'; 
  END IF;
END//
DELIMITER ;





-- Function to verify if exists a product 
DELIMITER //
  CREATE FUNCTION check_product_existence(
    p_product_type CHAR,
    p_product_number INT
  )
  RETURNS BOOLEAN
  READS SQL DATA
  BEGIN
	-- Verify a restaurant "municipality" and "zone" match
	IF EXISTS (
		SELECT 1
		FROM product
		WHERE product_type = p_product_type
		AND product_number = p_product_number
	) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END//
DELIMITER ;


-- Function to return the product price 
DELIMITER //
  CREATE FUNCTION return_product_price(
    p_product_type CHAR,
    p_product_number INT
  )
  RETURNS DECIMAL(10,2)
  READS SQL DATA
  BEGIN
	DECLARE product_price_result DECIMAL(10,2);
  -- obtain the product price
  SELECT product_price INTO product_price_result
    FROM product
    WHERE product_type = p_product_type
    AND product_number = p_product_number;
  -- Return the product_price
  RETURN product_price_result;
  END//
DELIMITER ;


-- Function to return the product name 
DELIMITER //
  CREATE FUNCTION return_product_name(
    p_product_type CHAR,
    p_product_number INT
  )
  RETURNS VARCHAR(50)
  READS SQL DATA
  BEGIN
	DECLARE product_name_result VARCHAR(50);
  -- obtain the product name
  SELECT product_name INTO product_name_result
    FROM product
    WHERE product_type = p_product_type
    AND product_number = p_product_number;
  -- Return the product_name
  RETURN product_name_result;
  END//
DELIMITER ;





-- Function to return the order status
DELIMITER //
  CREATE FUNCTION return_order_status(
    p_order_id INT
  )
  -- Varchar return
  RETURNS VARCHAR(100) 
  READS SQL DATA
  BEGIN
  DECLARE v_order_status VARCHAR(100); 
    

  -- found the order
  SELECT order__status INTO v_order_status
  FROM order_
  WHERE order__id = p_order_id;

  -- Return the order status
  RETURN v_order_status;
END//
DELIMITER ;


-- Function to return the order payment method
DELIMITER //
  CREATE FUNCTION return_order_payment_method(
    p_order_id INT
  )
  -- Varchar return
  RETURNS CHAR 
  READS SQL DATA
  BEGIN
  DECLARE result_payment_method CHAR; 
    

  -- found the order
  SELECT order__payment_method INTO result_payment_method
  FROM order_
  WHERE order__id = p_order_id;

  -- Return the order payment method
  RETURN result_payment_method;
END//
DELIMITER ;


-- Function to return the order client dpi
DELIMITER //
  CREATE FUNCTION return_order_client_dpi(
    p_order_id INT
  )
  -- Varchar return
  RETURNS BIGINT 
  READS SQL DATA
  BEGIN
  DECLARE result_client_dpi BIGINT; 
    
  -- find the order
  SELECT order__client_dpi INTO result_client_dpi
  FROM order_
  WHERE order__id = p_order_id;

  -- Return the order client dpi
  RETURN result_client_dpi;
END//
DELIMITER ;


-- Function to return the order client address
DELIMITER //
  CREATE FUNCTION return_order_client_address(
    p_order_id INT
  )
  -- Varchar return
  RETURNS BIGINT 
  READS SQL DATA
  BEGIN
  DECLARE result_client_address BIGINT; 
    
  -- find the order
  SELECT order__client_address INTO result_client_address
  FROM order_
  WHERE order__id = p_order_id;

  -- Return the order  client address
  RETURN result_client_address;
END//
DELIMITER ;


-- Function to return the order total cost.
DELIMITER //

CREATE FUNCTION calculate_order_total(
  p_order_product_id INT)
  RETURNS DECIMAL(10, 2)
  READS SQL DATA
  BEGIN
    DECLARE total DECIMAL(10, 2);
    DECLARE taxes DECIMAL(10, 2);
    -- Calculate the total accumulated.
    SELECT SUM(order_product_ammount * order_product_price) INTO total
    FROM order_product
    WHERE order_product_orderid = p_order_product_id;
    -- Calculate the taxes
    SET taxes = total * 0.12;
    -- Set the total
    SET total = total + taxes;
    -- Return the total
    RETURN total;
END //

DELIMITER ;



-- Function to return the client nit
DELIMITER //
  CREATE FUNCTION return_client_nit(
    p_client_dpi BIGINT
  )
  RETURNS VARCHAR(20)
  READS SQL DATA
  BEGIN
	DECLARE client_nit_result INT;
  -- obtain the client nit
  SELECT nit INTO client_nit_result
    FROM client
    WHERE client_dpi = p_client_dpi;
  -- If client nit is null
  IF client_nit_result IS NULL THEN
    -- Return the client nit
    RETURN 'C/F';
  ELSE
    RETURN client_nit_result;
  END IF;
  END//
DELIMITER ;


-- Function to return the client_address municipality
DELIMITER //
  CREATE FUNCTION return_client_address_municipality(
    p_client_address_id BIGINT
  )
  RETURNS VARCHAR(20)
  READS SQL DATA
  BEGIN
	DECLARE client_address_municipality VARCHAR(100);
  -- obtain the client address municipality
  SELECT municipality INTO client_address_municipality
    FROM client_address
    WHERE client_address_id = p_client_address_id;
  RETURN client_address_municipality;
  END//
DELIMITER ;


-- Function to return the job name 
DELIMITER //
  CREATE FUNCTION return_job_name(
    p_job_id INT
  )
  RETURNS VARCHAR(50)
  READS SQL DATA
  BEGIN
	DECLARE job_name_result VARCHAR(50);
  -- obtain the job name
  SELECT name INTO job_name_result
    FROM job
    WHERE p_job_id = job_id;
  -- Return the job name
  RETURN job_name_result;
  END//
DELIMITER ;


-- Function to return the job salary 
DELIMITER //
  CREATE FUNCTION return_job_salary(
    p_job_id INT
  )
  RETURNS DECIMAL(10,2)
  READS SQL DATA
  BEGIN
	DECLARE job_salary_result DECIMAL(10,2);
  -- obtain the job salary
  SELECT salary INTO job_salary_result
    FROM job
    WHERE p_job_id = job_id;
  -- Return the job salary
  RETURN job_salary_result;
  END//
DELIMITER ;


-- Function to return the job id 
DELIMITER //
  CREATE FUNCTION return_job_id(
    p_employee_id INT
  )
  RETURNS INT
  READS SQL DATA
  BEGIN
	DECLARE job_id_result DECIMAL(10,2);
  -- obtain the job id
  SELECT employee_job INTO job_id_result
    FROM employee
    WHERE p_employee_id = employee_id;
  -- Return the job id
  RETURN job_id_result;
  END//
DELIMITER ;

-- Function to return the employee name 
DELIMITER //
  CREATE FUNCTION return_employee_name(
    p_employee_id INT
  )
  RETURNS VARCHAR(50)
  READS SQL DATA
  BEGIN
	DECLARE employee_name_result VARCHAR(50);
  -- obtain the employee name
  SELECT CONCAT(employee_name, ' ', employee_surname) INTO employee_name_result
    FROM employee
    WHERE p_employee_id = employee_id;
  -- Return the employee name
  RETURN employee_name_result;
  END//
DELIMITER ;