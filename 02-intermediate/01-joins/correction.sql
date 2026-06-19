-- =============================================================
-- Module 01 — JOINs | Corrections
-- =============================================================

-- Exercise 1: Orders with customer name
SELECT
    c.first_name,
    c.last_name,
    o.id          AS order_id,
    o.status,
    o.ordered_at
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.id;

-- Exercise 2: Order items with product name
SELECT
    oi.order_id,
    p.name        AS product_name,
    oi.quantity,
    oi.unit_price
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.id;

-- Exercise 3: All customers and their order count (including 0)
SELECT
    c.first_name,
    c.last_name,
    COUNT(o.id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY order_count DESC;

-- Exercise 4: Orders with customer name and employee name
SELECT
    o.id          AS order_id,
    o.status,
    c.first_name  || ' ' || c.last_name  AS customer_name,
    e.first_name  || ' ' || e.last_name  AS employee_name
FROM orders AS o
JOIN customers AS c  ON o.customer_id = c.id
JOIN employees AS e  ON o.employee_id = e.id;

-- Exercise 5: Products with their category name (including uncategorised)
SELECT
    p.name         AS product_name,
    p.price,
    cat.name       AS category_name
FROM products AS p
LEFT JOIN categories AS cat ON p.category_id = cat.id
ORDER BY cat.name, p.name;

-- Exercise 6: Total number of items per order
SELECT
    o.id          AS order_id,
    c.first_name  || ' ' || c.last_name AS customer_name,
    SUM(oi.quantity) AS total_items
FROM orders AS o
JOIN customers    AS c  ON o.customer_id = c.id
JOIN order_items  AS oi ON oi.order_id   = o.id
GROUP BY o.id, customer_name
ORDER BY o.id;

-- Exercise 7 — Challenge: Total spending per customer
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spent
FROM customers AS c
LEFT JOIN orders     AS o  ON c.id       = o.customer_id
LEFT JOIN order_items AS oi ON o.id      = oi.order_id
GROUP BY c.id, customer_name
ORDER BY total_spent DESC;
