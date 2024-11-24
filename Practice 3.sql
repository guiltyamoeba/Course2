use sakila;
desc customer;
SELECT *
FROM Customer
WHERE active = 0;
-- Task2
SELECT first_name, last_name, email
FROM Customer
WHERE active = 0;
-- Task3
SELECT store_id, COUNT(*) as inactive_customer_count
FROM Customer
WHERE active = 0
GROUP BY store_id
ORDER BY inactive_customer_count DESC
LIMIT 1;
-- Task4 
SELECT title
FROM Film
WHERE rating = 'PG-13';
-- Task5
SELECT title, length
FROM Film
WHERE rating = 'PG-13'
ORDER BY length DESC
LIMIT 3;
-- Task6
SELECT title, rental_duration
FROM Film
WHERE rating = 'PG-13'
ORDER BY rental_duration ASC
LIMIT 5;
-- task7
SELECT AVG(rental_rate) AS average_rental_cost
FROM Film;
-- Task8
SELECT SUM(replacement_cost) AS total_replacement_cost
FROM Film;
SELECT category_id, name
FROM category
WHERE name IN ('Animation', 'Children');
SELECT c.name AS category_name, COUNT(fc.film_id) AS film_count
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
WHERE c.category_id IN (2, 3)
GROUP BY c.category_id, c.name;