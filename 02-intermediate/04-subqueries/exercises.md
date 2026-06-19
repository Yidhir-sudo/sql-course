# Subqueries

## What is a subquery?

A **subquery** (or nested query) is a SELECT statement placed inside another SQL statement. It is evaluated first, and its result is used by the outer query.

## Subquery in WHERE

```sql
-- Find products more expensive than the average price
SELECT name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

## Subquery with IN

```sql
-- Find customers who have placed at least one order
SELECT first_name, last_name
FROM customers
WHERE id IN (SELECT DISTINCT customer_id FROM orders);
```

## Subquery with NOT IN

```sql
-- Find customers who have never ordered
SELECT first_name, last_name
FROM customers
WHERE id NOT IN (SELECT customer_id FROM orders WHERE customer_id IS NOT NULL);
```

## Correlated subquery

A correlated subquery references the outer query. It runs once per row of the outer query.

```sql
-- For each customer, show if they've placed more than 1 order
SELECT
    first_name,
    last_name,
    (SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.id) AS order_count
FROM customers;
```

## Subquery in FROM (derived table)

```sql
SELECT cat_stats.category_id, cat_stats.avg_price
FROM (
    SELECT category_id, AVG(price) AS avg_price
    FROM products
    GROUP BY category_id
) AS cat_stats
WHERE cat_stats.avg_price > 50;
```

---

## Exercises

### Exercise 1
Find all products that are **more expensive than the average product price**.

### Exercise 2
Find all customers who have **never placed an order** (use `NOT IN` or `NOT EXISTS`).

### Exercise 3
Find the **most expensive product in each category** using a subquery.

### Exercise 4
Find all orders whose **total value** (sum of `quantity × unit_price` in `order_items`) is greater than `200`.

### Exercise 5
Using a subquery in `FROM`, calculate the average number of items per order.

### Exercise 6 — Challenge
Find all customers who have spent **more than the average customer spending**. Use a subquery to compute the average spending.
