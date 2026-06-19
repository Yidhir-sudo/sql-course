-- =============================================================
-- Module 02 — CTEs | Corrections
-- =============================================================

-- Exercise 1: Rewrite subquery with a CTE
WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM orders      AS o
    JOIN order_items AS oi ON o.id = oi.order_id
    GROUP BY o.customer_id
)
SELECT customer_id, ROUND(total_spent, 2) AS total_spent
FROM customer_spending
WHERE total_spent > 200
ORDER BY total_spent DESC;

-- Exercise 2: Top 3 customers and top 3 products in one query
WITH top_customers AS (
    SELECT
        'customer'                        AS type,
        c.first_name || ' ' || c.last_name AS name,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS value
    FROM orders      AS o
    JOIN order_items AS oi ON o.id = oi.order_id
    JOIN customers   AS c  ON c.id = o.customer_id
    GROUP BY c.id, c.first_name, c.last_name
    ORDER BY value DESC
    LIMIT 3
),
top_products AS (
    SELECT
        'product'    AS type,
        p.name       AS name,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS value
    FROM order_items AS oi
    JOIN products    AS p ON p.id = oi.product_id
    GROUP BY p.id, p.name
    ORDER BY value DESC
    LIMIT 3
)
SELECT * FROM top_customers
UNION ALL
SELECT * FROM top_products;

-- Exercise 3: Top product by quantity sold per category
WITH product_sales AS (
    SELECT
        p.id          AS product_id,
        p.name        AS product_name,
        p.category_id,
        SUM(oi.quantity) AS total_sold,
        RANK() OVER (
            PARTITION BY p.category_id
            ORDER BY SUM(oi.quantity) DESC
        ) AS rnk
    FROM order_items AS oi
    JOIN products    AS p ON p.id = oi.product_id
    GROUP BY p.id, p.name, p.category_id
)
SELECT product_name, category_id, total_sold
FROM product_sales
WHERE rnk = 1
ORDER BY category_id;

-- Exercise 4: Month-over-month revenue growth
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.ordered_at) AS month,
        SUM(oi.quantity * oi.unit_price)  AS revenue
    FROM orders      AS o
    JOIN order_items AS oi ON o.id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.ordered_at)
),
mom_growth AS (
    SELECT
        month,
        ROUND(revenue, 2) AS revenue,
        ROUND(LAG(revenue) OVER (ORDER BY month), 2) AS prev_month_revenue,
        ROUND(
            100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
                  / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
            1
        ) AS growth_pct
    FROM monthly_revenue
)
SELECT * FROM mom_growth ORDER BY month;

-- Exercise 5 — Challenge: Recursive employee hierarchy
WITH RECURSIVE emp_hierarchy AS (
    -- Anchor: employees with no manager
    SELECT
        id,
        first_name,
        last_name,
        role,
        manager_id,
        NULL::VARCHAR AS manager_name,
        0             AS depth
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.first_name,
        e.last_name,
        e.role,
        e.manager_id,
        (h.first_name || ' ' || h.last_name)::VARCHAR AS manager_name,
        h.depth + 1
    FROM employees     AS e
    JOIN emp_hierarchy AS h ON e.manager_id = h.id
)
SELECT
    depth,
    REPEAT('  ', depth) || first_name || ' ' || last_name AS name,
    role,
    COALESCE(manager_name, '— top level —') AS manager
FROM emp_hierarchy
ORDER BY depth, id;
