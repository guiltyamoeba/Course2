use hr;
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    (SELECT department_name 
     FROM departments d 
     WHERE d.department_id = e.department_id) AS department_name
FROM 
    employees e;
-- task2
SELECT e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
)
ORDER BY e.department_id, e.salary DESC;
-- task3
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.department_id IN (
    SELECT department_id
    FROM departments
    WHERE LOWER(department_name) LIKE '%sales%'
)
AND e.salary < (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id IN (
        SELECT department_id
        FROM departments
        WHERE LOWER(department_name) LIKE '%sales%'
    )
)
ORDER BY e.last_name, e.first_name;
-- task4
SELECT e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.salary > (
    SELECT MAX(salary)
    FROM employees
    WHERE job_id = 'IT_PROG'
)
ORDER BY e.salary ASC;
-- task5
SELECT e.employee_id, e.first_name, e.last_name, e.job_id, e.salary
FROM employees e
WHERE (e.job_id, e.salary) IN (
    SELECT job_id, MIN(salary)
    FROM employees
    GROUP BY job_id
)
ORDER BY e.salary ASC, e.job_id;
-- task6
SELECT e.first_name, e.last_name, e.department_id
FROM employees e
WHERE e.salary > 0.6 * (
    SELECT SUM(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
)
ORDER BY e.department_id, e.salary DESC;
-- task7
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.manager_id IN (
    SELECT e2.employee_id
    FROM employees e2
    WHERE e2.department_id IN (
        SELECT d.department_id
        FROM departments d
        WHERE d.location_id IN (
            SELECT l.location_id
            FROM locations l
            WHERE l.country_id = 'UK'
        )
    )
)
ORDER BY e.last_name, e.first_name;
-- task8
SELECT 
    first_name, 
    last_name, 
    CAST(salary AS DECIMAL(10,2)) AS salary
FROM 
    employees
ORDER BY 
    salary DESC
LIMIT 5;