# Window Functions

## What are window functions?

Window functions perform calculations **across a set of rows related to the current row**, without collapsing them into a single result like `GROUP BY` does.

```sql
SELECT
    name,
    price,
    AVG(price) OVER () AS overall_avg   -- computed for every row, no grouping
FROM products;
```

## Syntax

```sql
function_name(column) OVER (
    [PARTITION BY col1, col2]   -- group-like division
    [ORDER BY col3]             -- ordering within the window
    [ROWS/RANGE frame]          -- window frame
)
```

## Common window functions

| Function | Description |
|---|---|
| `ROW_NUMBER()` | Unique sequential rank (no ties) |
| `RANK()` | Rank with gaps on ties |
| `DENSE_RANK()` | Rank without gaps on ties |
| `LAG(col, n)` | Value from n rows before |
| `LEAD(col, n)` | Value from n rows after |
| `SUM(col) OVER (...)` | Running or partitioned sum |
| `AVG(col) OVER (...)` | Running or partitioned average |
| `FIRST_VALUE(col)` | First value in the window |
| `LAST_VALUE(col)` | Last value in the window |

## Examples

```sql
-- Rank products by price within each category
SELECT
    name,
    category_id,
    price,
    RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
FROM products;

-- Running total of revenue
SELECT
    ordered_at::DATE AS day,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY ordered_at::DATE) AS running_total
FROM (
    SELECT ordered_at, SUM(quantity * unit_price) AS daily_revenue
    FROM orders JOIN order_items ON orders.id = order_items.order_id
    GROUP BY ordered_at::DATE
) d;
```

---

## Exercises

### Exercise 1
For each product, show its name, price, and the **average price of all products** alongside each row.

### Exercise 2
Rank all products by price (highest first). Show name, price, and rank. Use `RANK()`.

### Exercise 3
For each category, rank products by price from highest to lowest within that category. Use `DENSE_RANK()`.

### Exercise 4
For each order item, show the product name, unit price, and the **price of the previous row** (using `LAG`).

### Exercise 5
Compute the **running total of revenue** ordered by `order_id`.

### Exercise 6 — Challenge
For each customer, find the order ranked **first** (earliest) and compute the value of that order. Use `ROW_NUMBER()` and a subquery or CTE to filter rank = 1.
