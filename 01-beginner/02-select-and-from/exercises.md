# SELECT and FROM

## Syntax

The most fundamental SQL statement retrieves data from a table:

```sql
SELECT column1, column2, ...
FROM table_name;
```

To select **all columns** use `*`:
```sql
SELECT *
FROM customers;
```

### Column aliases
Rename a column in the output using `AS`:
```sql
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM customers;
```

### String concatenation
Combine columns into one value:
```sql
-- PostgreSQL / SQLite
SELECT first_name || ' ' || last_name AS full_name
FROM customers;

-- MySQL
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;
```

### Arithmetic in SELECT
You can do math directly in the column list:
```sql
SELECT name, price, price * 1.2 AS price_with_tax
FROM products;
```

---

## Exercises

### Exercise 1
Retrieve **all columns** from the `products` table.

### Exercise 2
Retrieve only the `name`, `price`, and `stock` columns from the `products` table.

### Exercise 3
Retrieve the `first_name` and `last_name` of all customers, and combine them into a single column called `full_name`.

### Exercise 4
Retrieve all products and add a column called `price_ht` that shows the price excluding 20% tax (i.e., divide the price by 1.2). Round the result to 2 decimal places.

### Exercise 5
Retrieve the `name` and `price` from `products`, and add a column `stock_value` that calculates `price × stock` (total inventory value per product). Alias it clearly.

### Exercise 6 — Challenge
From the `orders` table, select `id`, `status`, and `ordered_at`. Add a column `year` that extracts only the year from `ordered_at`.

> **Hint:** Use `EXTRACT(YEAR FROM ordered_at)` in PostgreSQL or `strftime('%Y', ordered_at)` in SQLite.
