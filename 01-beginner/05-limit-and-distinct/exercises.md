# LIMIT and DISTINCT

## LIMIT — restrict the number of rows

`LIMIT` caps how many rows are returned. Very useful for previewing data or building "top N" queries.

```sql
SELECT *
FROM products
ORDER BY price DESC
LIMIT 10;
```

### OFFSET — skip rows (pagination)

```sql
SELECT *
FROM products
ORDER BY id
LIMIT 10 OFFSET 20;   -- rows 21 to 30
```

> **Note:** In SQL Server, use `FETCH NEXT 10 ROWS ONLY` / `OFFSET 20 ROWS` instead.

---

## DISTINCT — remove duplicates

`DISTINCT` eliminates duplicate rows from the result:

```sql
SELECT DISTINCT country
FROM customers;
```

You can use `DISTINCT` on multiple columns — the combination must be unique:

```sql
SELECT DISTINCT country, city
FROM customers;
```

### COUNT(DISTINCT ...)

Count how many unique values exist:

```sql
SELECT COUNT(DISTINCT country) AS nb_countries
FROM customers;
```

---

## Exercises

### Exercise 1
Retrieve the 3 cheapest products (name and price).

### Exercise 2
List all distinct countries from which the shop has customers.

### Exercise 3
List all distinct order statuses present in the `orders` table.

### Exercise 4
How many distinct countries are represented in the `customers` table?

### Exercise 5
Retrieve products on page 2 of a paginated list, with 5 products per page, sorted by name alphabetically.

> **Hint:** Use `LIMIT` and `OFFSET`.

### Exercise 6
List all distinct `city` + `country` combinations from the `customers` table, sorted alphabetically by country then city.

### Exercise 7 — Challenge
Retrieve the 3rd to 5th most expensive products (name and price). Do not use `WHERE`.

> **Hint:** Combine `ORDER BY`, `LIMIT`, and `OFFSET`.
