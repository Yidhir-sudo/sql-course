-- =============================================================
-- Module 02 — SELECT and FROM | Corrections
-- =============================================================

-- Exercise 1: All columns from products
SELECT *
FROM products;

-- Exercise 2: Specific columns
SELECT name, price, stock
FROM products;

-- Exercise 3: Full name as a single column
SELECT first_name || ' ' || last_name AS full_name
FROM customers;

-- Exercise 4: Price excluding 20% tax
SELECT
    name,
    price,
    ROUND(price / 1.2, 2) AS price_ht
FROM products;

-- Exercise 5: Stock value per product
SELECT
    name,
    price,
    stock,
    ROUND(price * stock, 2) AS stock_value
FROM products;

-- Exercise 6 — Challenge: Extract year from ordered_at
-- PostgreSQL:
SELECT
    id,
    status,
    ordered_at,
    EXTRACT(YEAR FROM ordered_at) AS year
FROM orders;

-- SQLite equivalent:
-- SELECT id, status, ordered_at, strftime('%Y', ordered_at) AS year
-- FROM orders;
