-- =============================================================
-- Module 03 — Indexes | Corrections
-- =============================================================

-- Exercise 1: Index on orders.customer_id
CREATE INDEX idx_orders_customer_id
ON orders (customer_id);

-- Exercise 2: Composite index on order_items
CREATE INDEX idx_order_items_order_product
ON order_items (order_id, product_id);

-- Exercise 3: EXPLAIN before index
EXPLAIN SELECT * FROM products WHERE category_id = 2;
-- Expected: Seq Scan on products (no index yet)

CREATE INDEX idx_products_category_id ON products (category_id);

EXPLAIN SELECT * FROM products WHERE category_id = 2;
-- Expected: Index Scan using idx_products_category_id on products
-- The difference: the planner now uses the index instead of scanning all rows.

-- Exercise 4: List indexes on the orders table
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'orders';

-- Exercise 5: Drop index and verify
DROP INDEX idx_orders_customer_id;

SELECT indexname
FROM pg_indexes
WHERE tablename = 'orders'
  AND indexname = 'idx_orders_customer_id';
-- Should return 0 rows

-- Exercise 6 — Challenge: Index strategy for the slow query
-- The query filters on: orders.status, orders.ordered_at, and joins on orders.customer_id

-- Option 1: Composite index covering the WHERE and JOIN
CREATE INDEX idx_orders_status_date_customer
ON orders (status, ordered_at, customer_id);

-- Option 2: Separate indexes (simpler, planner picks)
CREATE INDEX idx_orders_status     ON orders (status);
CREATE INDEX idx_orders_ordered_at ON orders (ordered_at);

-- Verify with EXPLAIN ANALYZE:
EXPLAIN ANALYZE
SELECT c.first_name, c.last_name, o.ordered_at, o.status
FROM customers AS c
JOIN orders AS o ON c.id = o.customer_id
WHERE o.status = 'delivered'
  AND o.ordered_at >= '2024-03-01';
