# Indexes

## What is an index?

An **index** is a data structure that speeds up data retrieval operations at the cost of additional storage and slower writes (INSERT/UPDATE/DELETE). Think of it like a book's index — it helps you jump to the right page quickly.

Without an index: the database scans every row (**sequential scan**).
With an index: the database jumps directly to matching rows (**index scan**).

## Creating indexes

```sql
-- Single-column index
CREATE INDEX idx_products_category
ON products (category_id);

-- Multi-column (composite) index
CREATE INDEX idx_orders_customer_status
ON orders (customer_id, status);

-- Unique index (also enforces uniqueness)
CREATE UNIQUE INDEX idx_customers_email
ON customers (email);
```

## Dropping an index

```sql
DROP INDEX idx_products_category;
```

## When to use indexes

**Good candidates:**
- Columns used in `WHERE` clauses frequently
- Columns used in `JOIN` conditions
- Columns used in `ORDER BY` on large tables
- Foreign key columns

**When NOT to index:**
- Very small tables (sequential scan is faster)
- Columns with very low cardinality (e.g., a boolean)
- Tables with very frequent writes and rare reads

## EXPLAIN — query plan analysis

```sql
EXPLAIN SELECT * FROM products WHERE category_id = 1;
EXPLAIN ANALYZE SELECT * FROM products WHERE category_id = 1;
```

`EXPLAIN ANALYZE` actually runs the query and shows real timings.

---

## Exercises

### Exercise 1
Create an index on the `orders` table for the `customer_id` column (frequently used in JOINs).

### Exercise 2
Create a composite index on `order_items (order_id, product_id)`.

### Exercise 3
Run `EXPLAIN` on the following query before and after creating an index on `products.category_id`. Describe what changes in the query plan:

```sql
SELECT * FROM products WHERE category_id = 2;
```

### Exercise 4
List all indexes on the `orders` table using the system catalog.

> **Hint:** In PostgreSQL, query `pg_indexes`.

### Exercise 5
Drop the index you created in Exercise 1 and verify it no longer exists.

### Exercise 6 — Challenge
The following query is slow on a large dataset. Identify which columns should be indexed and create them:

```sql
SELECT c.first_name, c.last_name, o.ordered_at, o.status
FROM customers AS c
JOIN orders AS o ON c.id = o.customer_id
WHERE o.status = 'delivered'
  AND o.ordered_at >= '2024-03-01';
```
