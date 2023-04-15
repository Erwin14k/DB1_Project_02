-- Procedure tu update the order status
DELIMITER //
CREATE PROCEDURE update_order_status(
	IN p_order_id INT,
	IN p_order_status VARCHAR(50),
	IN p_order_status_int INT
	)
BEGIN
  UPDATE order_ SET order__status = p_order_status, order__status_int = p_order_status_int WHERE order__id = p_order_id;
        SELECT 'Order status updated successfully' AS message;
END //
DELIMITER ;

-- Delete the update_order_status procedure
DROP PROCEDURE IF EXISTS update_order_status;





-- Procedure tu update the order employee
DELIMITER //
CREATE PROCEDURE update_order_employee(
	IN p_order_id INT,
	IN p_employee_id INT,
	IN p_payment_method CHAR
	)
BEGIN
  UPDATE order_ SET order__employee_id = p_employee_id, order__payment_method = p_payment_method WHERE order__id = p_order_id;
        SELECT 'Order status updated successfully' AS message;
END //
DELIMITER ;

-- Delete the update_order_employee procedure
DROP PROCEDURE IF EXISTS update_order_employee;


-- Procedure tu update the order end date
DELIMITER //
CREATE PROCEDURE update_order_end_date(
	IN p_order_id INT
	)
BEGIN
  UPDATE order_ SET order__end_date = NOW() WHERE order__id = p_order_id;
        SELECT 'Order end date updated successfully' AS message;
END //
DELIMITER ;

-- Delete the update_order_end_date procedure
DROP PROCEDURE IF EXISTS update_order_end_date;