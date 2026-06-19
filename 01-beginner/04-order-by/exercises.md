# ORDER BY

## Sorting results

`ORDER BY` sorts the result set by one or more columns.

```sql
SELECT name, price
FROM products
ORDER BY price;          -- ascending by default (ASC)
```

```sql
ORDER BY price DESC;     -- descending
```

## Sorting by multiple columns

When the first column has ties, the second column breaks them:

```sql
SELECT first_name, last_name, country
FROM customers
ORDER BY country ASC, last_name ASC;
```

## Sorting by column position

You can reference columns by their position in the SELECT list:

```sql
SELECT name, price, stock
FROM products
ORDER BY 2 DESC;   -- sorts by price (2nd column)
```

## NULL ordering

NULLs sort last in ascending order by default.
You can control this with `NULLS FIRST` / `NULLS LAST` (PostgreSQL):

```sql
ORDER BY shipped_at ASC NULLS LAST;
```

---

## Exercises

### Exercise 1
Retrieve all products sorted by price from cheapest to most expensive.

### Exercise 2
Retrieve all products sorted by price from most expensive to cheapest.

### Exercise 3
Retrieve all customers sorted alphabetically by country, then by last name within each country.

### Exercise 4
Retrieve the 5 most expensive products (name and price only).

> **Hint:** Combine `ORDER BY` with `LIMIT`.

### Exercise 5
Retrieve all orders sorted by `ordered_at` from most recent to oldest. Show `id`, `status`, and `ordered_at`.

### Exercise 6 — Challenge
Retrieve all orders sorted so that `delivered` orders appear first, then `shipped`, then `pending`, then `cancelled`. Within each status, sort by `ordered_at` descending.

> **Hint:** Use `CASE` inside `ORDER BY` to assign a sort rank.
