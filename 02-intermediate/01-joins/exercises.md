# JOINs

## Why JOIN?

Data is split across multiple tables to avoid redundancy. JOINs let you combine rows from two or more tables based on a related column.

## Types of JOIN

### INNER JOIN
Returns only rows that have a match in **both** tables.

```sql
SELECT customers.first_name, orders.id, orders.status
FROM customers
INNER JOIN orders ON customers.id = orders.customer_id;
```

### LEFT JOIN
Returns **all rows from the left table** and matching rows from the right. Non-matching right rows are NULL.

```sql
SELECT customers.first_name, orders.id
FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id;
-- Customers with no orders will appear with NULL order id
```

### RIGHT JOIN
All rows from the right table, matching from the left. (Less common — usually rewritten as a LEFT JOIN.)

### FULL OUTER JOIN
All rows from both tables; NULLs where there is no match.

### CROSS JOIN
Cartesian product — every row from A combined with every row from B. Rarely used intentionally.

## Table aliases

Use short aliases to keep queries readable:

```sql
SELECT c.first_name, o.status
FROM customers AS c
JOIN orders AS o ON c.id = o.customer_id;
```

---

## Exercises

### Exercise 1
Retrieve all orders along with the **first name** and **last name** of the customer who placed each order.

### Exercise 2
Retrieve all order items (`order_items`) along with the **product name** and **unit price** stored in `order_items`.

### Exercise 3
List all customers and the number of orders they placed. Include customers who have placed **zero** orders.

> **Hint:** Use a `LEFT JOIN` and `COUNT`.

### Exercise 4
Retrieve all orders with the customer's full name and the name of the employee who handled the order.

### Exercise 5
List every product along with its **category name**. Include products that have no category.

### Exercise 6
For each order, show the order `id`, customer full name, and the **total number of items** in that order (sum of quantities).

### Exercise 7 — Challenge
List each customer along with their **total spending** (sum of `quantity × unit_price` across all their orders). Include customers who never ordered (show 0, not NULL).

> **Hint:** You will need to join `customers → orders → order_items`.
