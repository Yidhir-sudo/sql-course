-- =============================================================
-- Module 02 — Aggregations and GROUP BY | Corrections
-- =============================================================

-- Exercise 1: Total number of products
SELECT COUNT(*) AS total_products
FROM products;

-- Exercise 2: Price stats
SELECT
    ROUND(AVG(price), 2) AS avg_price,
    MIN(price)           AS min_price,
    MAX(price)           AS max_price
FROM products;

-- Exercise 3: Product count per category
SELECT
    category_id,
    COUNT(*) AS nb_products
FROM products
GROUP BY category_id
ORDER BY nb_products DESC;

-- Exercise 4: Total revenue
SELECT
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM order_items;

-- Exercise 5: Orders per status
SELECT
    status,
    COUNT(*) AS nb_orders
FROM orders
GROUP BY status
ORDER BY nb_orders DESC;

-- Exercise 6: Total spent per customer
SELECT
    o.customer_id,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM orders AS o
JOIN order_items AS oi ON o.id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC;

-- Exercise 7: Min and max price per category
SELECT
    category_id,
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive
FROM products
GROUP BY category_id
ORDER BY category_id;

-- Exercise 8 — Challenge: Revenue per month
SELECT
    DATE_TRUNC('month', o.ordered_at) AS month,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi ON o.id = oi.order_id
GROUP BY DATE_TRUNC('month', o.ordered_at)
ORDER BY month;

-- SQLite equivalent:
-- SELECT
--     strftime('%Y-%m', o.ordered_at) AS month,
--     ROUND(SUM(oi.quantity * oi.unit_price), 2) AS monthly_revenue
-- FROM orders AS o
-- JOIN order_items AS oi ON o.id = oi.order_id
-- GROUP BY strftime('%Y-%m', o.ordered_at)
-- ORDER BY month;
