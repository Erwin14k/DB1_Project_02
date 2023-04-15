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
		WHERE order_product_ptype = p_product_type
		AND order_product_pnumber = p_product_number
	) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
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