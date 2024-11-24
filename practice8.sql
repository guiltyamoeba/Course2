use ecommerceinvdb;
-- Task1:
DELIMITER //

CREATE TRIGGER before_order_item_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    -- Check for negative or zero quantity
    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Quantity must be greater than zero.';
    END IF;

    -- Get the current stock level for the product
    SELECT stock_level INTO current_stock
    FROM products
    WHERE product_id = NEW.product_id;

    -- Check if there's sufficient stock
    IF NEW.quantity > current_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Insufficient stock for this product.';
    END IF;
END//

DELIMITER ;

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 3, 0);
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 3, -1);
#Interpretation:Error: Quantity must be greater than zero.
-- task2:
ALTER TABLE orders
ADD COLUMN total_amount DECIMAL(10,2);
SET SQL_SAFE_UPDATES = 0;
UPDATE orders SET total_amount = 0;
SET SQL_SAFE_UPDATES = 1;
CREATE TABLE daily_sales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sale_date DATE,
    total_sales DECIMAL(10,2)
);
-- task2:
DELIMITER //

CREATE TRIGGER after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE item_total DECIMAL(10,2);
    DECLARE order_date DATE;

    -- Calculate the total for the newly inserted item
    SELECT price * NEW.quantity INTO item_total
    FROM products
    WHERE product_id = NEW.product_id;

    -- Update the total_amount in the orders table
    UPDATE orders
    SET total_amount = COALESCE(total_amount, 0) + item_total
    WHERE order_id = NEW.order_id;

    -- Get the order date
    SELECT order_date INTO order_date
    FROM orders
    WHERE order_id = NEW.order_id;

    -- Insert or update the daily sales summary
    INSERT INTO daily_sales (sale_date, total_sales)
    VALUES (order_date, item_total)
    ON DUPLICATE KEY UPDATE total_sales = total_sales + item_total;
END//

DELIMITER ;
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (10, 1, 2);
select * from order_items