-- =============================================================
-- Module 01 — Query Optimization | Corrections
-- =============================================================

-- Exercise 1: EXPLAIN ANALYZE on orders for a specific customer
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 1;
-- Without index: Seq Scan (reads all rows)
-- After: CREATE INDEX idx_orders_customer_id ON orders(customer_id);
-- → Index Scan using idx_orders_customer_id

-- Exercise 2: Avoid function on indexed column
-- BAD (prevents index use):
-- SELECT * FROM customers WHERE LOWER(country) = 'france';

-- GOOD: store values consistently and filter directly
SELECT *
FROM customers
WHERE country = 'France';

-- If case-insensitive search is required, create a functional index:
-- CREATE INDEX idx_customers_country_lower ON customers (LOWER(country));
-- Then: WHERE LOWER(country) = 'france'  -- index will be used

-- Exercise 3: NOT IN vs NOT EXISTS
-- NOT IN (slower, NULL-unsafe)
EXPLAIN ANALYZE
SELECT first_name, last_name
FROM customers
WHERE id NOT IN (
    SELECT customer_id FROM orders WHERE customer_id IS NOT NULL
);

-- NOT EXISTS (faster, NULL-safe)
EXPLAIN ANALYZE
SELECT first_name, last_name
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1 FROM orders AS o WHERE o.customer_id = c.id
);

-- Exercise 4: Fix the slow query
-- BAD: DATE(ordered_at) prevents index use on ordered_at
-- SELECT * FROM orders WHERE DATE(ordered_at) = '2024-03-01';

-- GOOD: use a range to allow index scan
SELECT id, customer_id, status, ordered_at
FROM orders
WHERE ordered_at >= '2024-03-01'
  AND ordered_at <  '2024-03-02'
ORDER BY ordered_at;

-- Two improvements:
-- 1. Replace DATE(col) = x with a range to enable index use
-- 2. Replace SELECT * with specific columns

-- Exercise 5: Keyset pagination (cursor-based)
-- Page 1 (first 5 products)
SELECT id, name, price
FROM products
ORDER BY id
LIMIT 5;
-- Returns ids 1–5, last id = 5

-- Page 2 (next 5, cursor = last id from previous page)
SELECT id, name, price
FROM products
WHERE id > 5          -- cursor: last seen id
ORDER BY id
LIMIT 5;
-- Returns ids 6–10

-- Exercise 6 — Challenge: Join strategy tuning
-- A Nested Loop join works well when:
--   • one side is small
--   • the inner side has an index on the join column
-- A Hash Join works well when:
--   • both sides are large
--   • no useful index exists

-- To encourage Hash Join (PostgreSQL):
SET enable_nestloop = OFF;

EXPLAIN ANALYZE
SELECT c.first_name, o.id
FROM customers AS c
JOIN orders    AS o ON c.id = o.customer_id;

-- Reset:
SET enable_nestloop = ON;

-- In practice: ensure large join columns are indexed and let the planner decide.
-- Only override with SET when you are certain the planner is choosing poorly.
