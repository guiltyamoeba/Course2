use modelcarsdb;
-- task 1.1:
SELECT customerNumber, customerName
FROM customers
ORDER BY creditLimit DESC
LIMIT 10;
desc customers;
-- 13 rows returned with customer names and their customernumbers in desc order

-- task 1.2:
SELECT country, AVG(creditLimit) as avg_credit_limit
FROM customers
GROUP BY country
ORDER BY avg_credit_limit DESC;
-- 27 rows returned with country and avg_credit_limit with denmark as highest

-- task 1.3:
SELECT state, COUNT(*) as customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;
-- 19 rows returned with state and customer_count

-- task 1.4:
SELECT customers.customerNumber, customers.customerName
FROM customers
LEFT JOIN orders ON customers.customerNumber = orders.customerNumber
WHERE orders.orderNumber IS NULL;
-- 24 rows returned who havent placed orders

-- task 1.5:
SELECT 
    customers.customerNumber,
    customers.customerName,
    SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS totalSales
FROM 
    customers
LEFT JOIN 
    orders ON customers.customerNumber = orders.customerNumber
LEFT JOIN 
    orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY 
    customers.customerNumber, customers.customerName
ORDER BY 
    totalSales DESC;
-- 122 rows returned with euro+shopping channel as highest customer name and total sales 
    
    
-- task 1.6:
SELECT 
    customers.customerNumber,
    customers.customerName,
    employees.employeeNumber AS salesRepEmployeeNumber,
    CONCAT(employees.firstName, ' ', employees.lastName) AS salesRepName
FROM 
    customers
LEFT JOIN 
    employees ON customers.salesRepEmployeeNumber = employees.employeeNumber
ORDER BY 
    customers.customerName;
-- 122 rows returned with customer name and salesrepemployeenumber and salesrepname
    
    
-- Task 1.7
SELECT c.customerNumber AS customer_id, c.customerName,
       MAX(p.paymentDate) AS most_recent_payment_date
FROM customers AS c
INNER JOIN payments AS p ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber
ORDER BY most_recent_payment_date DESC;
-- 98 rows returned with customer name and their most recent payment date

-- task 1.8
SELECT c.customerName,c.customerNumber,c.creditlimit,SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber
HAVING total_sales > c.creditLimit
order by total_sales desc;
-- 59 rows returned who exceeded their creditlimit.


-- task 1.9
SELECT c.customerName, c.customerNumber,p.productLine
FROM Customers c
JOIN Orders o ON c.customerNumber = o.customerNumber
JOIN OrderDetails od ON o.orderNumber = od.orderNumber
JOIN Products p ON od.productCode = p.productCode
WHERE p.productLine = 'Motorcycles'; 
-- 359 customer names returned under motorcycle productline.


-- task 1.10
SELECT c.customerName
FROM Customers c
INNER JOIN Orders o ON c.customerNumber = o.customerNumber
INNER JOIN OrderDetails od ON o.orderNumber = od.orderNumber
INNER JOIN Products p ON od.productCode = p.productCode
WHERE p.buyPrice IN (
  SELECT MAX(buyPrice)
  FROM Products
);
-- 28 rows returned.

-- Task2: Office data analysis
-- task 2.1
SELECT officecode, COUNT(*) AS num_employees
FROM Employees
GROUP BY officecode;
-- 7 rows returned with officecodes and num_employees


-- task 2.2
SELECT officeCode
FROM Employees
GROUP BY officeCode
HAVING COUNT(*) < 6;
-- 6 rows returned with office codes 1,3,4,5,6,7 

-- task 2.3
select o.officeCode, o.territory
from Offices o;
-- 7 rows returned

-- task2.4
SELECT o.officeCode
FROM Offices o
LEFT JOIN Employees e ON o.officeCode = e.officeCode
GROUP BY o.officeCode
HAVING COUNT(e.employeeNumber) = 0;
-- 	interpretation:there is no offices that have no employees

-- task2.5
select o.officecode,sum(od.quantityOrdered*priceEach) as total_sales from offices o
join employees e join customers c join orders os join orderdetails od on
o.officeCode = e.officeCode and
e.employeeNumber = c.salesRepEmployeeNumber and
c.customerNumber = os.customerNumber and 
os.orderNumber=od.orderNumber
group by o.officeCode
order by total_sales desc;
-- office 4 is most profitable with total sales 3083761.58


-- task 2.6
SELECT officeCode, COUNT(*) AS num_employees
FROM Employees
GROUP BY officeCode
ORDER BY num_employees DESC
LIMIT 1;
-- 1 row  with officecode and num_employees are returned

-- task 2.7
Select o.officeCode AS OfficeName, avg(c.creditLimit) as AverageCreditLimit
From Customers c
left join Offices o on c.city= o.city 
group by o.officeCode;
-- 6 rows retuned with offcie name and average credit limit are shown.

-- task 2.8
SELECT country, COUNT(*) AS num_offices
FROM Offices
GROUP BY country;
-- 5 rows returned with country and their num_offices are present

-- Product analysis 
-- task 3.1:
SELECT productLine, COUNT(*) AS num_products
FROM Products
GROUP BY productLine;
-- 7 rows returnned by productline and num_products

-- task 3.2:
SELECT productLine, AVG(buyprice) AS avg_buy_price, AVG(msrp) AS avg_msrp
FROM Products
GROUP BY productLine;
-- 7 rows returned by productline and avg_buy_price and avg_msrp

-- task 3.3:
SELECT * 
FROM Products
WHERE msrp BETWEEN 50 AND 100;
-- 51 rows returned.

-- task 3.4:
SELECT productLine, SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM Products p
INNER JOIN OrderDetails od ON p.productCode = od.productCode
GROUP BY productLine;
-- 7 rows returned by productline and sales for each prodcut.

-- task 3.5:
SELECT * 
FROM Products
WHERE quantityInStock < 10;
-- Interpretation: so there is no <10 quantityinstock list.

-- task 3.6:
SELECT * 
FROM Products
ORDER BY msrp DESC
LIMIT 1;
-- Interpretation:1952 Alpine Renault 1300 is the most expensive product based on MSRP=214.30

-- task 3.7:
SELECT p.productCode AS ProductCode, p.productName AS ProductName, 
       SUM(od.quantityOrdered * od.priceEach) AS TotalSales
FROM Products p
INNER JOIN OrderDetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName;
-- 109 rows returned by givng product name and their total sales with their product codes

-- Task3.8:
delimiter $$
CREATE PROCEDURE top_sellingproducts (in num_products int)
BEGIN
  select productCode, SUM(quantityOrdered) AS totalquantitysold
from orderdetails
  group by productCode
  order by totalquantitysold desc
  limit num_products;
END; $$
 -- interpretation:here top 10 product codes returned based on quantityorder

-- task 3.9:
select * from products
where quantityInStock < 10
  and productLine in ('Classic Cars', 'Motorcycles');
-- 	interpretation: there is no productline of 'classic cars','motorcycles' under the quantityinstock is less than 10

-- task 3.10:
select p.productName,count(o.customerNumber) as count_of_customers from products p
join orderdetails od join orders o on 
p.productCode=od.productcode and 
od.orderNumber = o.orderNumber 
group by p.productname
having count_of_customers>12
order by count_of_customers desc;
-- Here 109 rows returned in these the highest count of customer is'1992 ferari 360 spider red' with the count of 53 customers


-- task 3.11:
select p.productname,p.productline,od.quantityOrdered from products p
join orderdetails od on p.productCode=od.productCode
group by p.productname,p.productline,od.quantityOrdered
having od.quantityOrdered > (select avg(quantityOrdered) from orderdetails);
 -- 990 rows returned showing products having ordered more than the avg number of orders for their productline.













