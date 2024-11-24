use hr;
-- Task1
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'IT';
-- Task2
SELECT 
    d.department_id,
    d.department_name,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary
FROM 
    departments d
LEFT JOIN 
    employees e ON d.department_id = e.department_id
GROUP BY 
    d.department_id, d.department_name
ORDER BY 
    d.department_id;
-- Task3
SELECT 
    l.city,
    COUNT(e.employee_id) AS employee_count
FROM 
    locations l
JOIN 
    departments d ON l.location_id = d.location_id
JOIN 
    employees e ON d.department_id = e.department_id
GROUP BY 
    l.city
ORDER BY 
    employee_count DESC
LIMIT 10;
-- Task4
SELECT DISTINCT e.employee_id, e.first_name, e.last_name
FROM employees e
JOIN job_history jh ON e.employee_id = jh.employee_id
WHERE jh.end_date = '1999-12-31';
-- Task5
SELECT 
    e.employee_id, 
    e.first_name, 
    d.department_name,
    DATEDIFF(CURDATE(), e.hire_date) / 365 AS total_experience_years
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
WHERE 
    DATEDIFF(CURDATE(), e.hire_date) / 365 >= 25
ORDER BY 
    total_experience_years DESC;