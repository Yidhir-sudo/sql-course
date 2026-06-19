-- =============================================================
-- Module 04 — ORDER BY | Corrections
-- =============================================================

-- Exercise 1: Products sorted by price ascending
SELECT *
FROM products
ORDER BY price ASC;

-- Exercise 2: Products sorted by price descending
SELECT *
FROM products
ORDER BY price DESC;

-- Exercise 3: Customers by country then last_name
SELECT *
FROM customers
ORDER BY country ASC, last_name ASC;

-- Exercise 4: 5 most expensive products
SELECT name, price
FROM products
ORDER BY price DESC
LIMIT 5;

-- Exercise 5: Orders from most recent to oldest
SELECT id, status, ordered_at
FROM orders
ORDER BY ordered_at DESC;

-- Exercise 6 — Challenge: Custom status ordering
SELECT *
FROM orders
ORDER BY
    CASE status
        WHEN 'delivered' THEN 1
        WHEN 'shipped'   THEN 2
        WHEN 'pending'   THEN 3
        WHEN 'cancelled' THEN 4
        ELSE 5
    END ASC,
    ordered_at DESC;
