-- =============================================================
-- Module 01 — Window Functions | Corrections
-- =============================================================

-- Exercise 1: Price alongside overall average
SELECT
    name,
    price,
    ROUND(AVG(price) OVER (), 2) AS overall_avg_price
FROM products
ORDER BY price DESC;

-- Exercise 2: Rank all products by price
SELECT
    name,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank
FROM products;

-- Exercise 3: Dense rank within each category
SELECT
    name,
    category_id,
    price,
    DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank_in_category
FROM products
ORDER BY category_id, rank_in_category;

-- Exercise 4: LAG — previous unit price
SELECT
    p.name          AS product_name,
    oi.unit_price,
    LAG(oi.unit_price) OVER (ORDER BY oi.id) AS previous_price
FROM order_items AS oi
JOIN products    AS p ON oi.product_id = p.id;

-- Exercise 5: Running total of revenue by order_id
SELECT
    oi.order_id,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS order_revenue,
    ROUND(
        SUM(SUM(oi.quantity * oi.unit_price)) OVER (ORDER BY oi.order_id),
        2
    ) AS running_total
FROM order_items AS oi
GROUP BY oi.order_id
ORDER BY oi.order_id;

-- Exercise 6 — Challenge: First order per customer and its value
WITH ranked_orders AS (
    SELECT
        o.id            AS order_id,
        o.customer_id,
        o.ordered_at,
        SUM(oi.quantity * oi.unit_price) AS order_value,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.ordered_at
        ) AS rn
    FROM orders      AS o
    JOIN order_items AS oi ON o.id = oi.order_id
    GROUP BY o.id, o.customer_id, o.ordered_at
)
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    ro.order_id,
    ro.ordered_at,
    ROUND(ro.order_value, 2) AS first_order_value
FROM ranked_orders AS ro
JOIN customers     AS c ON c.id = ro.customer_id
WHERE ro.rn = 1
ORDER BY ro.ordered_at;
