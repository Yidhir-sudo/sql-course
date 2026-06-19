# CTEs (Common Table Expressions)

## What is a CTE?

A CTE defines a **named temporary result set** that you can reference within the same query. It improves readability compared to deeply nested subqueries.

```sql
WITH cte_name AS (
    SELECT ...
)
SELECT *
FROM cte_name;
```

## Multiple CTEs

Chain multiple CTEs separated by commas:

```sql
WITH
    top_customers AS (
        SELECT customer_id, SUM(quantity * unit_price) AS total
        FROM orders JOIN order_items ON orders.id = order_items.order_id
        GROUP BY customer_id
    ),
    ranked AS (
        SELECT *, RANK() OVER (ORDER BY total DESC) AS rnk
        FROM top_customers
    )
SELECT *
FROM ranked
WHERE rnk <= 5;
```

## Recursive CTEs

Recursive CTEs process hierarchical data (e.g., org charts, category trees):

```sql
WITH RECURSIVE emp_hierarchy AS (
    -- Anchor: start with top-level employees (no manager)
    SELECT id, first_name, last_name, manager_id, 0 AS depth
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: join subordinates
    SELECT e.id, e.first_name, e.last_name, e.manager_id, h.depth + 1
    FROM employees AS e
    JOIN emp_hierarchy AS h ON e.manager_id = h.id
)
SELECT *
FROM emp_hierarchy
ORDER BY depth, id;
```

---

## Exercises

### Exercise 1
Rewrite the following subquery using a CTE:
```sql
SELECT * FROM (
    SELECT customer_id, SUM(quantity * unit_price) AS total_spent
    FROM orders JOIN order_items ON orders.id = order_items.order_id
    GROUP BY customer_id
) AS t
WHERE total_spent > 200;
```

### Exercise 2
Using two CTEs, find the top 3 customers by total spending and the top 3 products by total revenue. Display both results in a single query using `UNION ALL`.

### Exercise 3
Using a CTE and a window function, find the top-ranked product (by total quantity sold) in each category.

### Exercise 4
Calculate the **month-over-month revenue growth** using two CTEs: one for monthly revenue, one for the comparison.

> **Hint:** Use `LAG()` on the monthly revenue CTE.

### Exercise 5 — Challenge: Recursive CTE
Traverse the employee hierarchy. For each employee, show their name, role, their manager's name, and their depth level in the hierarchy (0 = no manager).
