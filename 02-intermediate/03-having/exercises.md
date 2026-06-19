# HAVING

## Filtering groups

`WHERE` filters individual rows **before** grouping.
`HAVING` filters groups **after** aggregation.

```sql
-- WHERE: filter rows before grouping
SELECT category_id, COUNT(*) AS nb_products
FROM products
WHERE price > 20          -- applied to each row
GROUP BY category_id;

-- HAVING: filter groups after aggregation
SELECT category_id, COUNT(*) AS nb_products
FROM products
GROUP BY category_id
HAVING COUNT(*) >= 3;     -- applied to each group
```

## WHERE vs HAVING — summary

| | WHERE | HAVING |
|---|---|---|
| Runs | Before GROUP BY | After GROUP BY |
| Can filter | Individual rows | Aggregated groups |
| Can use aggregates | No | Yes |

## Using both together

```sql
SELECT category_id, ROUND(AVG(price), 2) AS avg_price
FROM products
WHERE stock > 0             -- filter: only in-stock products
GROUP BY category_id
HAVING AVG(price) > 40;    -- filter: only high-price categories
```

---

## Exercises

### Exercise 1
Find all categories that have **more than 3 products**.

### Exercise 2
Find all customers who have placed **more than 1 order**.

### Exercise 3
Find all products whose total **quantity sold** (across all `order_items`) is greater than `2`.

### Exercise 4
Find months where total revenue exceeded `300`.

### Exercise 5
List employees who have handled **more than 5 orders**.

### Exercise 6 — Challenge
List categories where the **average price of in-stock products** (stock > 0) is greater than `50`. Show the category id, average price, and product count.
