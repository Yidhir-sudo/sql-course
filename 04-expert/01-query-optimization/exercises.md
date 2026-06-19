# Query Optimization

## Why optimization matters

On large datasets, a poorly written query can take minutes instead of milliseconds. Understanding the query planner helps you write efficient SQL.

## The query execution order

SQL is **written** in this order:
`SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT`

But it is **executed** in this order:
`FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT`

Understanding this prevents common mistakes like using a SELECT alias in WHERE.

## EXPLAIN and EXPLAIN ANALYZE

```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 1;
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 1;
```

Key nodes to understand:
- **Seq Scan** — reads entire table (bad for large tables)
- **Index Scan** — uses an index (fast for selective filters)
- **Bitmap Heap Scan** — bulk index access (good for moderate selectivity)
- **Hash Join / Nested Loop / Merge Join** — join strategies
- **cost=X..Y** — estimated cost (start..total)
- **rows=N** — estimated row count
- **actual time=X..Y** — real execution time (ANALYZE only)

## Common anti-patterns

```sql
-- BAD: function on indexed column prevents index use
WHERE UPPER(email) = 'ALICE@EMAIL.COM'
-- GOOD: store data consistently, or use functional index
WHERE email = 'alice@email.com'

-- BAD: SELECT * fetches unnecessary columns
SELECT * FROM orders WHERE ...
-- GOOD: select only what you need
SELECT id, status, ordered_at FROM orders WHERE ...

-- BAD: NOT IN with subquery (slow, NULL-unsafe)
WHERE id NOT IN (SELECT customer_id FROM orders)
-- GOOD: NOT EXISTS
WHERE NOT EXISTS (SELECT 1 FROM orders WHERE orders.customer_id = customers.id)

-- BAD: OFFSET-based pagination on large tables
SELECT * FROM products ORDER BY id LIMIT 10 OFFSET 100000
-- GOOD: keyset pagination
SELECT * FROM products WHERE id > 100000 ORDER BY id LIMIT 10
```

---

## Exercises

### Exercise 1
Run `EXPLAIN ANALYZE` on a query that retrieves all orders for `customer_id = 1`. Identify whether an index scan or a sequential scan is used and why.

### Exercise 2
Rewrite the following query to avoid using a function on the indexed column:

```sql
SELECT * FROM customers WHERE LOWER(country) = 'france';
```

### Exercise 3
Compare the performance of `NOT IN` vs `NOT EXISTS` to find customers who never ordered. Use `EXPLAIN ANALYZE` to show the difference.

### Exercise 4
The following query is slow. Identify at least two issues and rewrite it:

```sql
SELECT *
FROM orders
WHERE DATE(ordered_at) = '2024-03-01'
ORDER BY ordered_at;
```

### Exercise 5
Implement **keyset pagination** (cursor-based) to paginate through products sorted by `id`. Return page 1 (first 5), then page 2 (next 5) without using `OFFSET`.

### Exercise 6 — Challenge
You have a query that runs with a Nested Loop join on a million-row table. Using `EXPLAIN`, identify the join strategy. Then try adding or dropping indexes to encourage a Hash Join instead. Explain your reasoning.
