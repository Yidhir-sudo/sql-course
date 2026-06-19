-- =============================================================
-- Module 03 — Partitioning | Corrections
-- =============================================================

-- Exercise 1: Range-partitioned orders table by quarter
CREATE TABLE orders_part (
    id          SERIAL,
    customer_id INT,
    employee_id INT,
    status      VARCHAR(50) NOT NULL DEFAULT 'pending',
    ordered_at  TIMESTAMP NOT NULL,
    shipped_at  TIMESTAMP
) PARTITION BY RANGE (ordered_at);

CREATE TABLE orders_part_2024_q1 PARTITION OF orders_part
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE orders_part_2024_q2 PARTITION OF orders_part
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

CREATE TABLE orders_part_2024_q3 PARTITION OF orders_part
    FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

CREATE TABLE orders_part_2024_q4 PARTITION OF orders_part
    FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- Exercise 2: Insert data and verify partition pruning
INSERT INTO orders_part (customer_id, employee_id, status, ordered_at)
SELECT customer_id, employee_id, status, ordered_at
FROM orders;

-- Verify which partition rows land in:
SELECT tableoid::regclass AS partition, COUNT(*)
FROM orders_part
GROUP BY tableoid;

-- Partition pruning — only Q2 is scanned:
EXPLAIN SELECT *
FROM orders_part
WHERE ordered_at >= '2024-04-01' AND ordered_at < '2024-07-01';

-- Exercise 3: List-partitioned orders by status
CREATE TABLE orders_by_status_part (
    id          SERIAL,
    customer_id INT,
    status      VARCHAR(50) NOT NULL,
    ordered_at  TIMESTAMP NOT NULL
) PARTITION BY LIST (status);

CREATE TABLE orders_status_delivered PARTITION OF orders_by_status_part
    FOR VALUES IN ('delivered');

CREATE TABLE orders_status_shipped   PARTITION OF orders_by_status_part
    FOR VALUES IN ('shipped');

CREATE TABLE orders_status_pending   PARTITION OF orders_by_status_part
    FOR VALUES IN ('pending');

CREATE TABLE orders_status_cancelled PARTITION OF orders_by_status_part
    FOR VALUES IN ('cancelled');

-- Exercise 4: Add Q1 2025 partition, drop Q1 2024
CREATE TABLE orders_part_2025_q1 PARTITION OF orders_part
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');

-- Drop Q1 2024 (data is archived or no longer needed)
DROP TABLE orders_part_2024_q1;

-- Verify remaining partitions:
SELECT inhrelid::regclass AS partition
FROM pg_inherits
WHERE inhparent = 'orders_part'::regclass;

-- Exercise 5 — Challenge: Hash partitioning on products
CREATE TABLE products_part (
    id          SERIAL,
    name        VARCHAR(200) NOT NULL,
    category_id INT,
    price       NUMERIC(10, 2),
    stock       INT
) PARTITION BY HASH (id);

CREATE TABLE products_part_h0 PARTITION OF products_part
    FOR VALUES WITH (MODULUS 3, REMAINDER 0);

CREATE TABLE products_part_h1 PARTITION OF products_part
    FOR VALUES WITH (MODULUS 3, REMAINDER 1);

CREATE TABLE products_part_h2 PARTITION OF products_part
    FOR VALUES WITH (MODULUS 3, REMAINDER 2);

-- Populate from existing table
INSERT INTO products_part (id, name, category_id, price, stock)
SELECT id, name, category_id, price, stock
FROM products;

-- Verify row distribution across partitions
SELECT tableoid::regclass AS partition, COUNT(*) AS row_count
FROM products_part
GROUP BY tableoid
ORDER BY partition;
