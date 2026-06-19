-- =============================================================
-- Module 05 — LIMIT and DISTINCT | Corrections
-- =============================================================

-- Exercise 1: 3 cheapest products
SELECT name, price
FROM products
ORDER BY price ASC
LIMIT 3;

-- Exercise 2: Distinct countries
SELECT DISTINCT country
FROM customers
ORDER BY country;

-- Exercise 3: Distinct order statuses
SELECT DISTINCT status
FROM orders;

-- Exercise 4: Count distinct countries
SELECT COUNT(DISTINCT country) AS nb_countries
FROM customers;

-- Exercise 5: Page 2 with 5 products per page (rows 6–10)
SELECT name, price
FROM products
ORDER BY name ASC
LIMIT 5 OFFSET 5;

-- Exercise 6: Distinct city + country combinations
SELECT DISTINCT city, country
FROM customers
ORDER BY country ASC, city ASC;

-- Exercise 7 — Challenge: 3rd to 5th most expensive products
SELECT name, price
FROM products
ORDER BY price DESC
LIMIT 3 OFFSET 2;
