-- =============================================================
-- Module 03 — WHERE Clause | Corrections
-- =============================================================

-- Exercise 1: Products with price > 50
SELECT *
FROM products
WHERE price > 50;

-- Exercise 2: Customers from France
SELECT *
FROM customers
WHERE country = 'France';

-- Exercise 3: Orders pending or shipped
SELECT *
FROM orders
WHERE status IN ('pending', 'shipped');

-- Exercise 4: Products priced between 20 and 60
SELECT *
FROM products
WHERE price BETWEEN 20 AND 60;

-- Exercise 5: Customers whose email contains a pattern
-- No 'gmail' in our dataset — using 'email.com' as example:
SELECT *
FROM customers
WHERE email LIKE '%email.com';

-- Exercise 6: Orders not yet shipped (shipped_at is NULL)
SELECT *
FROM orders
WHERE shipped_at IS NULL;

-- Exercise 7: Electronics (category_id = 1) with stock < 100
SELECT *
FROM products
WHERE category_id = 1
  AND stock < 100;

-- Exercise 8 — Challenge: Customers not from FR/DE/UK, joined after 2024-04-01
SELECT *
FROM customers
WHERE country NOT IN ('France', 'Germany', 'UK')
  AND joined_at > '2024-04-01';
