-- =============================================================
-- Module 03 — HAVING | Corrections
-- =============================================================

-- Exercise 1: Categories with more than 3 products
SELECT category_id, COUNT(*) AS nb_products
FROM products
GROUP BY category_id
HAVING COUNT(*) > 3;

-- Exercise 2: Customers with more than 1 order
SELECT customer_id, COUNT(*) AS nb_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY nb_orders DESC;

-- Exercise 3: Products with total quantity sold > 2
SELECT
    product_id,
    SUM(quantity) AS total_sold
FROM order_items
GROUP BY product_id
HAVING SUM(quantity) > 2
ORDER BY total_sold DESC;

-- Exercise 4: Months with revenue > 300
SELECT
    DATE_TRUNC('month', o.ordered_at) AS month,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi ON o.id = oi.order_id
GROUP BY DATE_TRUNC('month', o.ordered_at)
HAVING SUM(oi.quantity * oi.unit_price) > 300
ORDER BY month;

-- Exercise 5: Employees who handled more than 5 orders
SELECT employee_id, COUNT(*) AS nb_orders
FROM orders
GROUP BY employee_id
HAVING COUNT(*) > 5
ORDER BY nb_orders DESC;

-- Exercise 6 — Challenge: Categories where avg price of in-stock products > 50
SELECT
    category_id,
    ROUND(AVG(price), 2) AS avg_price,
    COUNT(*)             AS nb_products
FROM products
WHERE stock > 0
GROUP BY category_id
HAVING AVG(price) > 50
ORDER BY avg_price DESC;
