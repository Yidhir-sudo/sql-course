-- =============================================================
-- Module 04 — Subqueries | Corrections
-- =============================================================

-- Exercise 1: Products more expensive than the average
SELECT name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- Exercise 2: Customers who never ordered (NOT IN)
SELECT first_name, last_name, email
FROM customers
WHERE id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE customer_id IS NOT NULL
);

-- Alternative using NOT EXISTS (more robust with NULLs):
SELECT first_name, last_name, email
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders AS o
    WHERE o.customer_id = c.id
);

-- Exercise 3: Most expensive product per category (correlated subquery)
SELECT name, category_id, price
FROM products AS p
WHERE price = (
    SELECT MAX(price)
    FROM products
    WHERE category_id = p.category_id
)
ORDER BY category_id;

-- Exercise 4: Orders with total value > 200
SELECT order_id, ROUND(total_value, 2) AS total_value
FROM (
    SELECT order_id, SUM(quantity * unit_price) AS total_value
    FROM order_items
    GROUP BY order_id
) AS order_totals
WHERE total_value > 200
ORDER BY total_value DESC;

-- Exercise 5: Average number of items per order
SELECT ROUND(AVG(items_per_order), 2) AS avg_items_per_order
FROM (
    SELECT order_id, SUM(quantity) AS items_per_order
    FROM order_items
    GROUP BY order_id
) AS per_order;

-- Exercise 6 — Challenge: Customers who spent more than the average
WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM orders AS o
    JOIN order_items AS oi ON o.id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    c.first_name,
    c.last_name,
    ROUND(cs.total_spent, 2) AS total_spent
FROM customer_spending AS cs
JOIN customers AS c ON c.id = cs.customer_id
WHERE cs.total_spent > (SELECT AVG(total_spent) FROM customer_spending)
ORDER BY total_spent DESC;
