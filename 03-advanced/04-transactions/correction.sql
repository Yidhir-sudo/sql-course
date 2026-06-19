-- =============================================================
-- Module 04 — Transactions | Corrections
-- =============================================================

-- Exercise 1: Full order transaction
BEGIN;

-- Step 1: Decrease stock
UPDATE products
SET stock = stock - 2
WHERE id = 1;

-- Step 2: Create the order
INSERT INTO orders (customer_id, employee_id, status, ordered_at)
VALUES (1, 2, 'pending', NOW());

-- Step 3: Add order item (referencing the new order id)
-- In PostgreSQL, use RETURNING to get the generated id:
-- Wrapped in a DO block for illustration purposes:
DO $$
DECLARE
    new_order_id INT;
BEGIN
    INSERT INTO orders (customer_id, employee_id, status, ordered_at)
    VALUES (1, 2, 'pending', NOW())
    RETURNING id INTO new_order_id;

    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (new_order_id, 1, 2, 29.99);

    UPDATE products SET stock = stock - 2 WHERE id = 1;
END;
$$;

COMMIT;

-- Exercise 2: Duplicate email — forced rollback
BEGIN;

INSERT INTO customers (first_name, last_name, email, country, joined_at)
VALUES ('Test', 'User', 'alice.martin@email.com', 'France', CURRENT_DATE);
-- This will fail: email already exists (UNIQUE constraint)

-- In a real application the error is caught and we roll back:
ROLLBACK;
-- The INSERT never persists

-- Exercise 3: SAVEPOINT usage
BEGIN;

UPDATE products SET stock = stock - 5 WHERE id = 1;

SAVEPOINT after_product1;

UPDATE products SET stock = stock - 100 WHERE id = 2;
-- stock might go negative — revert this step only

ROLLBACK TO SAVEPOINT after_product1;

-- Safe alternative
UPDATE products SET stock = stock - 2 WHERE id = 2;

COMMIT;

-- Exercise 4 — Conceptual answer (in comments)
-- READ COMMITTED allows non-repeatable reads: if transaction A reads
-- an account balance, then transaction B updates it and commits, and
-- then transaction A reads it again — it sees a different value.
-- This can cause a transfer to use an outdated balance.
-- Use REPEATABLE READ or SERIALIZABLE for financial operations.

-- Exercise 5 — Challenge: Safe category transfer with audit log
CREATE TABLE IF NOT EXISTS audit_log (
    id          SERIAL PRIMARY KEY,
    action      VARCHAR(200),
    performed_at TIMESTAMP DEFAULT NOW()
);

BEGIN;

DO $$
DECLARE
    target_category_id INT := 2;  -- move product 1 to category 2
    target_exists      INT;
BEGIN
    -- Check target category exists
    SELECT COUNT(*) INTO target_exists
    FROM categories WHERE id = target_category_id;

    IF target_exists = 0 THEN
        RAISE EXCEPTION 'Target category % does not exist', target_category_id;
    END IF;

    -- Update product category
    UPDATE products
    SET category_id = target_category_id
    WHERE id = 1;

    -- Log the action
    INSERT INTO audit_log (action)
    VALUES ('Product 1 moved to category ' || target_category_id);
END;
$$;

COMMIT;
