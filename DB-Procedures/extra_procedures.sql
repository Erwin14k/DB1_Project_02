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