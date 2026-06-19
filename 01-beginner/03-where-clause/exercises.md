# WHERE Clause

## Filtering rows

`WHERE` filters which rows are returned. Only rows where the condition is `TRUE` are included.

```sql
SELECT *
FROM products
WHERE price < 50;
```

## Comparison operators

| Operator | Meaning |
|---|---|
| `=` | Equal |
| `<>` or `!=` | Not equal |
| `<`, `>` | Less / greater than |
| `<=`, `>=` | Less / greater than or equal |
| `BETWEEN a AND b` | Inclusive range |
| `IN (val1, val2)` | Matches any value in the list |
| `LIKE 'pattern'` | Pattern match (`%` = any chars, `_` = one char) |
| `IS NULL` | Value is null |
| `IS NOT NULL` | Value is not null |

## Logical operators

Combine conditions with `AND`, `OR`, and `NOT`:

```sql
SELECT *
FROM products
WHERE price > 30 AND stock > 100;
```

```sql
SELECT *
FROM orders
WHERE status = 'cancelled' OR status = 'pending';
-- Equivalent:
WHERE status IN ('cancelled', 'pending');
```

---

## Exercises

### Exercise 1
Retrieve all products with a price greater than `50`.

### Exercise 2
Retrieve all customers from `France`.

### Exercise 3
Retrieve all orders that are either `pending` or `shipped`.

### Exercise 4
Retrieve all products with a price between `20` and `60` (inclusive).

### Exercise 5
Retrieve all customers whose email address contains `gmail` (using `LIKE`).

> In our dataset there are none — try with `email` instead.

### Exercise 6
Retrieve all orders that have **not yet been shipped** (i.e., `shipped_at` is NULL).

### Exercise 7
Retrieve all products in category `1` (Electronics) with fewer than `100` items in stock.

### Exercise 8 — Challenge
Retrieve all customers who are **not** from France, Germany, or the UK, and who joined after `2024-04-01`.
