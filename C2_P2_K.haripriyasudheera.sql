use modelcarsdb;
-- task1.1:
SELECT COUNT(*) AS total_employees
FROM employees;
-- total 23 employees

-- task1.2:
SELECT 
employeeNumber,lastName,firstName,email,jobtitle,email from employees;
-- table with employeeNumber,lastName,firstName,email,jobtitle,email are displayed

-- task1.3:
SELECT 
    jobTitle,
    COUNT(*) AS employee_count
FROM 
    employees
GROUP BY 
    jobTitle
ORDER BY 
    employee_count DESC;
-- 7  job titles with employee counts are represented.

-- task1.4:
SELECT 
    employeeNumber,lastName,firstName,email,jobtitle
FROM 
    employees
WHERE 
    reportsTo IS NULL;
--  1 row is returened with name Diane murphy

-- task1.5:
select c.salesRepEmployeeNumber, sum(od.quantityOrdered * od.priceEach) as totalSales
from customers c
inner join orders o on c.customerNumber = o.customerNumber
inner join orderdetails od on o.orderNumber = od.orderNumber
group by c.salesRepEmployeeNumber
order by totalSales desc;
-- Interpretation:here  15 rows returned and highest total sales in salesrep employeeNumber is 1370. and  the lowest is 1166

-- task 1.6
select c.salesRepEmployeeNumber, sum(od.quantityOrdered * od.priceEach) as totalSales
from customers c
inner join orders o on c.customerNumber = o.customerNumber
inner join orderdetails od on o.orderNumber = od.orderNumber
group by c.salesRepEmployeeNumber
order by totalSales desc;
-- Interpretation: here the most profitable sales is 1370(sales repemployeenumber) based on total sales

-- Task1.7
SELECT DISTINCT e.firstName, e.lastName
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE (
    SELECT SUM(od2.quantityOrdered * od2.priceEach)
    FROM customers c2
    JOIN orders o2 ON c2.customerNumber = o2.customerNumber
    JOIN orderdetails od2 ON o2.orderNumber = od2.orderNumber
    WHERE c2.salesRepEmployeeNumber = e.employeeNumber
) > (
    SELECT AVG(employee_total)
    FROM (
        SELECT c3.salesRepEmployeeNumber, SUM(od3.quantityOrdered * od3.priceEach) as employee_total
        FROM customers c3
        JOIN orders o3 ON c3.customerNumber = o3.customerNumber
        JOIN orderdetails od3 ON o3.orderNumber = od3.orderNumber
        JOIN employees e2 ON c3.salesRepEmployeeNumber = e2.employeeNumber
        WHERE e2.officeCode = e.officeCode
        GROUP BY c3.salesRepEmployeeNumber
    ) as office_sales
)
ORDER BY e.lastName, e.firstName;
-- Interpretation: 7 rows returned with first names and last names


-- task 2.1
select c.customerNumber, avg(od.priceEach * od.quantityOrdered) AS avg_Order_Amount
from customers c
inner join orders o on c.customerNumber = o.customerNumber
inner join orderdetails od on o.orderNumber = od.orderNumber
group by c.customerNumber
order by c.customerNumber desc;
-- Interpretation:here 98 rows returend.and highest avg_order_amount is 2863.766458 under the customerNumber is 496.alter

-- task2.2
select month(o.orderDate) as order_Month, count(*) as number_of_Orders
from orders o
group by month(o.orderDate)
order by order_Month ;
-- Interpretation: heighest number of orders in month of 11 and the number of orders is 63.and lowest is 17 under the 8 month

-- Task2.3:
select * from orders where status = 'pending';
-- Interpretation: there is no pending status in shipment

-- Task 2.4:
select c.customerNumber, c.customerName, c.phone,o.orderNumber, o.orderDate, o.requiredDate,o.shippedDate
from orders o
inner join customers c on o.customerNumber = c.customerNumber;
-- Interpretation:here returned 326 rows with customernumber,customername,customer phone,ordernumber,orderDate,required date,shipped date

-- Task2.5:
select * from orders
order by orderDate desc;
-- Interpretation:10424,10425 have most recent date that is 2005-05-31

-- Task2.6:
select o.orderNumber, o.orderDate, SUM(od.quantityOrdered * od.priceEach) as total_sales
from orders o
inner join orderdetails od on o.orderNumber= od.orderNumber
group by o.ordernumber;
-- Interpretation:here 326 rows returned with ordernumber ,orderdate and total_sales

-- Task 2.7:
select o.orderNumber, o.orderDate, SUM(od.quantityOrdered * od.priceEach) as total_sales
from orders o
inner join orderdetails od on o.orderNumber= od.orderNumber
group by o.ordernumber
order by total_sales desc
limit 1;
-- Interpretation:10165 oredernumber have highest_value that is 67392.85

-- Task 2.8:
select o.orderNumber, o.orderDate, c.customerNumber, c.customerName, od.productCode, p.productName, od.quantityOrdered, od.priceEach
from orders o
inner join orderdetails od on o.orderNumber = od.orderNumber
inner join customers c on o.customerNumber = c.customerNumber
inner join products p on od.productCode = p.productCode;
-- Interpretation:here 1000 rows returned with orders with corresponding order details and also customerName,customerNumber,productcode

-- task 2.9:
select p.productCode, p.productName, sum(od.quantityOrdered * od.priceEach) as total_orders
from orderdetails od
inner join products p on od.productCode = p.productCode
group by p.productCode, p.productName
order by total_orders desc;
-- Interpretation:most frequently order product is S18_3232(productCode),	1992 Ferrari 360 Spider red(productName)


-- Task2.10:
select o.orderNumber, o.orderDate, sum(od.quantityOrdered * od.priceEach) as total_revenue
from orders o
inner join orderdetails od on o.orderNumber = od.orderNumber
group by o.orderNumber, o.orderDate;
-- Interpretation:here 326 rows returned orderNumber wise  with total revenue

-- Task2.11:
select o.orderNumber, o.orderDate, sum(od.quantityOrdered * od.priceEach) as total_revenue
from orders o
inner join orderdetails od on o.orderNumber = od.orderNumber
group by o.orderNumber, o.orderDate
order by total_revenue desc;
-- Interpretation:the most profitable orderNumber is 10165 and the highest total_revenue is 67392.85

-- Task2.12:
select o.orderNumber, o.orderDate, c.customerNumber, c.customerName,
       od.productCode, p.productName, p.productDescription, od.quantityOrdered, od.priceEach
from orders o
inner join orderdetails od on o.orderNumber = od.orderNumber
inner join customers c on o.customerNumber = c.customerNumber
inner join products p on od.productCode = p.productCode;
-- Interpretation:here 1000 rows returned all orders with product information and customer numbers,customerNames also

-- Task2.13:
select o.orderNumber, o.orderDate,o.shippedDate,o.requiredDate from orders o  
where shippedDate > requiredDate;
-- Interpretation:here we got only one ordernumber that is 10615

-- Task2.14:
SELECT 
    od1.productCode AS product1,
    od2.productCode AS product2,
    COUNT(*) AS combination_count
FROM 
    orderdetails od1
JOIN 
    orderdetails od2 ON od1.orderNumber = od2.orderNumber
WHERE 
    od1.productCode < od2.productCode
GROUP BY 
    od1.productCode, od2.productCode
ORDER BY 
    combination_count DESC
LIMIT 10;
-- 10 rows returned with product 1 and product 2 and combination count


-- Task 2.15:
select o.orderNumber, o.orderDate, sum(od.quantityOrdered * od.priceEach) as total_revenue
from orders o
inner join orderdetails od on o.orderNumber = od.orderNumber
group by o.orderNumber, o.orderDate
order by total_revenue desc
limit 10;
-- Interpretation:the top 10 most profitable ordernumber based on total revenue are shown


-- Task 2.16:
DELIMITER //

CREATE TRIGGER update_credit_limit_after_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE order_total DECIMAL(10,2);
    
    -- Calculate the total amount of the new order
    SELECT SUM(quantityOrdered * priceEach)
    INTO order_total
    FROM orderdetails
    WHERE orderNumber = NEW.orderNumber;
    
    -- Update the customer's credit limit
    UPDATE customers
    SET creditLimit = GREATEST(creditLimit - order_total, 0)
    WHERE customerNumber = NEW.customerNumber;
END;
//

DELIMITER ;
-- trigger created automatically updates a customer's credit limit after a new order is placed


-- Task 2.17:
DELIMITER //
-- Trigger for INSERT operations
CREATE TRIGGER log_quantity_change_insert
AFTER INSERT ON orderdetails
FOR EACH ROW
BEGIN
    INSERT INTO product_quantity_log 
    (product_code, order_number, quantity_change, operation)
    VALUES 
    (NEW.productCode, NEW.orderNumber, NEW.quantityOrdered, 'INSERT');
END;
//
-- Trigger for UPDATE operations
CREATE TRIGGER log_quantity_change_update
AFTER UPDATE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE quantity_diff INT;
    SET quantity_diff = NEW.quantityOrdered - OLD.quantityOrdered;
    
    IF quantity_diff != 0 THEN
        INSERT INTO product_quantity_log 
        (product_code, order_number, quantity_change, operation)
        VALUES 
        (NEW.productCode, NEW.orderNumber, quantity_diff, 'UPDATE');
    END IF;
END;
//
DELIMITER ;
-- trigger created a trigger that logs product quantity changes whenever an order detail is inserted or updated.
