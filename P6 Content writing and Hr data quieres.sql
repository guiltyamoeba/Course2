-- Task1:Content writing
/*-- Proposed LinkedIn Profile Outline
Profile Picture: A professional-looking image representing AI or language models.Headline: AI Language Model | Natural Language Processing Expert | Text Generation | Machine Learning

About Section:

Clearly define what a language model is.
Highlight key capabilities: natural language understanding, text generation, translation, summarization, etc.
Emphasize potential applications in various industries (e.g., customer service, content creation, research, education).
Briefly mention the benefits of using a language model.
Experience:

Language Model Developer (or similar):
Company: OpenAI (or hypothetical company)
Dates: (Start date - Present)
Job description: Focus on development, training, and improvement of language models. Highlight technical skills and accomplishments.
Freelance Language Model Consultant (or similar):
Company: Freelance
Dates: (Start date - Present)
Job description: Showcase potential consulting services, such as model selection, implementation, and optimization.
Skills:

Natural Language Processing (NLP)
Machine Learning
Deep Learning
Python
TensorFlow/PyTorch (or other relevant frameworks)
Data Analysis
Algorithm Development
Endorsements and Recommendations:

Request endorsements for your listed skills from experts in the field.
Recommendations:

Seek recommendations from researchers, developers, or companies that have used your capabilities.
Interests:

Artificial Intelligence
Natural Language Processing
Machine Learning
Data Science
Emerging Technologies */

-- Task2:
/*Improved Text:

It's fascinating how you can understand this, even with the mistakes. The fact that you can still make sense of it despite the errors adds a unique quality to the reading experience.*/

-- BARD-QUERYING HR DATA
use hr;
-- Task1: Description of tables usine describe command
DESCRIBE regions;
DESCRIBE countries;
DESCRIBE locations;
DESCRIBE departments;
DESCRIBE jobs;
DESCRIBE employees;
DESCRIBE job_history;
-- task2(a):Finding total number of comapanies
SELECT r.region_name, COUNT(c.country_id) AS total_countries
FROM regions r
JOIN countries c ON r.region_id = c.region_id
GROUP BY r.region_name;
-- task2(b):Top 10 largest cities by population
SELECT c.city_name, ci.population
FROM countries c
JOIN locations l ON c.country_id = l.country_id
JOIN cities ci ON l.location_id = ci.city_id
ORDER BY ci.population DESC
LIMIT 10; -- Here even though we have given the data set the BARD didnt give the 
-- output according to the dataset.
-- task2(c):Finding the average salary of employees in each department.
SELECT d.department_name, AVG(e.salary) AS average_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
-- task2(d): Finding the total sales for each country in the last quarter
SELECT c.country_name, SUM(o.total_amount) AS total_sales
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
JOIN addresses a ON cu.address_id = a.address_id
JOIN cities ci ON a.city_id = ci.city_id
JOIN countries c ON ci.country_id = c.country_id
WHERE o.order_date >= CURDATE() - INTERVAL 3 MONTH
GROUP BY c.country_name;-- Here even though we have given the data set the BARD didnt give the 
-- output according to the dataset.
-- task2(e): Top 10 most popular products based on the number of orders.
SELECT p.product_name, COUNT(oi.order_id) AS order_count
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY order_count DESC
LIMIT 10;-- Here even though we have given the data set the BARD didnt give the 
-- output according to the dataset.
-- task2(f):Find the customers who have placed the most orders in last year.
SELECT cu.customer_name, COUNT(o.order_id) AS order_count
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY cu.customer_name
ORDER BY order_count DESC;-- Here even though we have given the data set the BARD didnt give the 
-- output according to the dataset.

-- task2(g):Employees who have generated most sales in the last quarter.
SELECT e.employee_name, SUM(o.total_amount) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
WHERE o.order_date >= CURDATE() - INTERVAL 3 MONTH
GROUP BY e.employee_name
ORDER BY total_sales DESC;

-- task3:Additinal business queires by bard.
-- Employee-Related Queries
-- Average salary per job title:
SELECT j.job_title, AVG(e.salary) AS average_salary
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
GROUP BY j.job_title;
-- Employee turnover:
SELECT COUNT(*) AS number_of_turnovers
FROM job_history;
-- Employees with more than two job titles:
SELECT e.employee_id, e.first_name, e.last_name, COUNT(jh.job_id) AS job_count
FROM employees e
JOIN job_history jh ON e.employee_id = jh.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(jh.job_id) > 2;
-- Job-Related Queries
-- Most common job titles:
SELECT j.job_title, COUNT(*) AS job_count
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
GROUP BY j.job_title
ORDER BY job_count DESC;
-- Salary range for each job title:

SELECT j.job_title, MIN(e.salary) AS min_salary, MAX(e.salary) AS max_salary
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
GROUP BY j.job_title;
-- Job mobility (employees who have changed jobs):
SELECT e.employee_id, e.first_name, e.last_name, COUNT(jh.job_id) AS job_changes
FROM employees e
JOIN job_history jh ON e.employee_id = jh.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(jh.job_id) > 1;
-- Task4:
/* Understanding the Task
We will focus on the departments, jobs, and employees tables to derive insights.

Potential Business Queries
Department-Related Queries
Department size: Determine the number of employees in each department.
Department locations: Find departments located in specific countries or regions.
Departmental salary budgets: Calculate the total salary expenditure for each department.
Job-Related Queries within Departments
Job distribution: Analyze the distribution of job titles across departments.
Departmental salary ranges: Find the minimum and maximum salaries for each department.
Employee-Related Queries within Departments
Departmental turnover: Calculate employee turnover rates for each department.
Departmental seniority: Find the average tenure of employees in each department.
SQL Queries
Assumptions:

The employees table has a hire_date column.
The departments table has a location_id column referencing the locations table.
Department-Related Queries
Number of employees in each department:*/
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
-- Departments in a specific country:
SELECT d.department_name, c.country_name
FROM departments d
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
WHERE c.country_name = 'United States';  -- Replace 'United States' with desired country
-- Departmental salary budget:
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
/*Job-Related Queries within Departments
Job distribution by department:*/
SELECT d.department_name, j.job_title, COUNT(e.employee_id) AS employee_count
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN jobs j ON e.job_id = j.job_id
GROUP BY d.department_name, j.job_title;-- wrong
-- Departmental salary ranges:
SELECT d.department_name, MIN(e.salary) AS min_salary, MAX(e.salary) AS max_salary
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
-- Employee-Related Queries within Departments
-- Departmental turnover (assuming job_history table exists):
SELECT d.department_name, COUNT(jh.employee_id) AS turnover_count
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN job_history jh ON e.employee_id = jh.employee_id
GROUP BY d.department_name;
-- Departmental seniority:
SELECT d.department_name, AVG(DATEDIFF(CURDATE(), e.hire_date)) / 365 AS average_tenure
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Task5:
/*Task 5: Identifying Unique Queries and Summarizing Analysis
Extracting Unique Queries
By carefully examining the SQL queries generated in Tasks 2, 3, and 4, we can identify distinct query patterns and their corresponding analysis objectives.

Key Query Patterns:

Aggregations:

Calculating sums, averages, counts, or other aggregate functions on numerical columns.
Examples: Total sales, average salary, employee count.
Joins:

Combining data from multiple tables based on related columns.
Examples: Joining orders with customers, employees with departments.
Filtering:

Selecting specific subsets of data based on conditions.
Examples: Filtering by date range, country, or department.
Ranking and Ordering:

Sorting data based on specific columns or calculated values.
Examples: Top 10 products by sales, employees with highest salaries.
Summary of Analysis
Based on the executed queries and their results, we can draw the following insights:

Employee Analysis:
Salary distributions across job titles and departments.
Employee turnover rates and patterns.
Departmental employee counts and diversity.
Departmental Analysis:
Department sizes and locations.
Salary budgets and expenditure by department.
Job distributions within departments.
Job Analysis:
Average salaries and salary ranges for different job titles.
Job popularity and distribution across departments.
Sales Analysis:
Total sales by country and product.
Customer purchasing behavior (frequency, total spend).
Employee sales performance.
Limitations:

The depth of analysis is constrained by the available data and the complexity of the queries.
Without additional data (e.g., product categories, customer demographics), certain analyses might be limited.
Potential Next Steps:

Explore correlations between employee performance and factors like tenure, department, or job title.
Analyze sales trends over time to identify patterns or seasonality.
Use data visualization tools to represent findings effectively.
By building upon these initial queries and incorporating more sophisticated analysis techniques, deeper insights can be extracted from the HR database.*/
