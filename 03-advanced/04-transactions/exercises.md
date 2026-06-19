# Transactions

## What is a transaction?

A **transaction** is a group of SQL statements executed as a single unit. Either **all** succeed or **none** take effect.

## ACID properties

| Property | Meaning |
|---|---|
| **Atomicity** | All operations succeed or all are rolled back |
| **Consistency** | The database remains in a valid state |
| **Isolation** | Concurrent transactions don't interfere with each other |
| **Durability** | Committed data survives crashes |

## Basic syntax

```sql
BEGIN;                    -- start transaction

UPDATE products
SET stock = stock - 1
WHERE id = 1;

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (16, 1, 1, 29.99);

COMMIT;                   -- confirm all changes
```

If something goes wrong:

```sql
ROLLBACK;                 -- undo everything since BEGIN
```

## SAVEPOINT

Set intermediate checkpoints within a transaction:

```sql
BEGIN;

SAVEPOINT step1;

UPDATE products SET stock = stock - 5 WHERE id = 2;

-- Oops, revert only this step:
ROLLBACK TO SAVEPOINT step1;

-- Continue with other operations:
UPDATE products SET stock = stock - 1 WHERE id = 3;

COMMIT;
```

## Isolation levels

| Level | Dirty Read | Non-Repeatable Read | Phantom Read |
|---|---|---|---|
| `READ UNCOMMITTED` | Possible | Possible | Possible |
| `READ COMMITTED` (default) | Prevented | Possible | Possible |
| `REPEATABLE READ` | Prevented | Prevented | Possible |
| `SERIALIZABLE` | Prevented | Prevented | Prevented |

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

---

## Exercises

### Exercise 1
Write a transaction that:
1. Decreases the stock of product `id = 1` by 2
2. Inserts a new order for customer `id = 1`, handled by employee `id = 2`
3. Inserts the corresponding `order_items` row

### Exercise 2
Write a transaction that attempts to insert a customer with a duplicate email (which violates the `UNIQUE` constraint), then catches the error with a `ROLLBACK`. Observe what happens.

### Exercise 3
Write a transaction with a `SAVEPOINT` that:
1. Updates the stock of product `id = 1` by -5
2. Creates a savepoint
3. Updates the stock of product `id = 2` by -100 (which would bring it negative)
4. Rolls back to the savepoint
5. Instead updates product `id = 2` by -2
6. Commits

### Exercise 4 — Conceptual
Explain why using `READ COMMITTED` (the default) could cause issues in a banking transfer scenario. What isolation level would you use instead?

### Exercise 5 — Challenge
Write a transaction that safely transfers a product from one category to another. If the target category does not exist, roll back. If it does, update the product and log the change (insert into an `audit_log` table that you create first).
