# Database Design

## What is database design?

Database design is the process of structuring data to ensure **integrity**, **performance**, and **maintainability**. Good design avoids redundancy and makes queries natural to write.

## Normalization

Normalization organizes data to reduce redundancy. The main normal forms are:

### 1NF — First Normal Form
- Each column contains **atomic** (indivisible) values
- No repeating groups or arrays in columns

### 2NF — Second Normal Form
- Is in 1NF
- Every non-key attribute is **fully dependent** on the entire primary key (no partial dependencies — relevant for composite PKs)

### 3NF — Third Normal Form
- Is in 2NF
- No **transitive dependencies** (non-key columns should not depend on other non-key columns)

### BCNF — Boyce-Codd Normal Form
- Stricter version of 3NF: every determinant must be a candidate key

## Denormalization

Sometimes we **intentionally** break normalization for performance (e.g., storing pre-computed totals, duplicating frequently joined data). Always document and justify denormalization.

## Constraints

```sql
-- Primary key
id SERIAL PRIMARY KEY

-- Foreign key with cascade
customer_id INT REFERENCES customers(id) ON DELETE CASCADE

-- Not null
email VARCHAR(200) NOT NULL

-- Unique
UNIQUE (email)

-- Check constraint
CHECK (price > 0)
CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled'))

-- Default
joined_at DATE DEFAULT CURRENT_DATE
```

## Entity-Relationship design tips

- Each entity → one table
- Each relationship → foreign key or junction table
- Avoid storing computed values unless for performance
- Use surrogate keys (SERIAL / UUID) as primary keys
- Always define foreign key constraints to enforce referential integrity

---

## Exercises

### Exercise 1 — Normalization analysis
The following table is **not normalized**. Identify which normal form it violates and propose a corrected design:

```
orders_flat:
| order_id | customer_name | customer_email | product1 | qty1 | product2 | qty2 |
```

### Exercise 2
Add a `CHECK` constraint on the `products` table to ensure `price > 0` and `stock >= 0`.

### Exercise 3
Add a `CHECK` constraint on the `orders` table to ensure `status` can only be `pending`, `shipped`, `delivered`, or `cancelled`.

### Exercise 4 — Design a new feature
The shop wants to add a **discount coupon** system. Design the tables needed:
- Coupons have a code, discount percentage, and an expiry date
- A coupon can be used on an order
- A coupon can only be used once per customer

Write the `CREATE TABLE` statements with all appropriate constraints.

### Exercise 5 — Challenge
The shop wants to support **product reviews**: customers can leave a rating (1–5) and a comment on products they have purchased. Design and create the `reviews` table with all necessary constraints (including ensuring the customer actually purchased the product — at least enforce it at the column level).

### Exercise 6 — Conceptual
Explain when you would choose a **UUID** as a primary key instead of a `SERIAL` integer, and what the trade-offs are (performance, storage, distribution).
