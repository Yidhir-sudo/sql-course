-- =============================================================
-- Module 01 — What is SQL? | Corrections
-- =============================================================
-- These exercises are conceptual and do not require SQL queries.
-- The answers below use SQL to EXPLORE the database structure.
-- =============================================================

-- Exercise 1: List all tables in the database
-- In PostgreSQL:
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- In SQLite:
-- SELECT name FROM sqlite_master WHERE type = 'table';

-- Exercise 2: Inspect primary keys — view table structure
-- In PostgreSQL, use \d tablename in psql, or:
SELECT
    kcu.table_name,
    kcu.column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY'
  AND tc.table_schema = 'public'
ORDER BY kcu.table_name;

-- Result:
--   customers    → id  (uniquely identifies a customer)
--   products     → id  (uniquely identifies a product)
--   orders       → id  (uniquely identifies an order)
--   order_items  → id  (uniquely identifies a line in an order)

-- Exercise 3: Inspect foreign keys in the orders table
SELECT
    kcu.column_name,
    ccu.table_name  AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON tc.constraint_name = ccu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'orders';

-- Result:
--   customer_id → customers(id)  : which customer placed the order
--   employee_id → employees(id)  : which employee handled the order

-- Exercise 4: Sample business questions (answered in later modules)
-- • Which customers placed the most orders?
-- • What is the total revenue per month?
-- • Which products are low in stock?
-- • Which employees handle the most orders?
-- • What is the average order value per country?
