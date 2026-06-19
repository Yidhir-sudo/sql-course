-- =============================================================
-- Module 04 — Database Design | Corrections
-- =============================================================

-- Exercise 1 — Normalization: orders_flat violations
-- Violations:
--   1NF: repeating groups (product1/qty1, product2/qty2) — not atomic
--   2NF: customer_name and customer_email depend on customer, not on the order
--   3NF: if customer_name depends on customer_email, that is a transitive dependency

-- Corrected design (already mirrors our ShopDB structure):
-- customers(id, name, email)
-- orders(id, customer_id FK)
-- order_items(id, order_id FK, product_id FK, quantity)
-- products(id, name)

-- Exercise 2: CHECK constraints on products
ALTER TABLE products
    ADD CONSTRAINT chk_products_price_positive CHECK (price > 0),
    ADD CONSTRAINT chk_products_stock_non_negative CHECK (stock >= 0);

-- Verify:
-- INSERT INTO products (name, category_id, price, stock) VALUES ('Bad', 1, -5, 0);
-- → ERROR: violates check constraint "chk_products_price_positive"

-- Exercise 3: CHECK constraint on orders status
ALTER TABLE orders
    ADD CONSTRAINT chk_orders_status
    CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled'));

-- Exercise 4: Coupon system design
CREATE TABLE coupons (
    id              SERIAL PRIMARY KEY,
    code            VARCHAR(50) NOT NULL UNIQUE,
    discount_pct    NUMERIC(5, 2) NOT NULL CHECK (discount_pct > 0 AND discount_pct <= 100),
    expires_at      DATE NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE
);

-- Link coupons to orders; enforce one coupon per customer
CREATE TABLE coupon_usages (
    id          SERIAL PRIMARY KEY,
    coupon_id   INT NOT NULL REFERENCES coupons(id),
    customer_id INT NOT NULL REFERENCES customers(id),
    order_id    INT NOT NULL REFERENCES orders(id) UNIQUE,  -- one coupon per order
    used_at     TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (coupon_id, customer_id)  -- one use per customer per coupon
);

-- The orders table can optionally reference the coupon:
ALTER TABLE orders ADD COLUMN coupon_id INT REFERENCES coupons(id);

-- Exercise 5 — Challenge: Product reviews
CREATE TABLE reviews (
    id          SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    product_id  INT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    rating      SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment     TEXT,
    reviewed_at TIMESTAMP NOT NULL DEFAULT NOW(),
    -- One review per customer per product
    UNIQUE (customer_id, product_id)
);

-- Note: enforcing "customer must have purchased the product" at DB level
-- requires a trigger or a CHECK against order_items.
-- Here we enforce it at the application level, but we can document it:

-- Example trigger (PostgreSQL):
CREATE OR REPLACE FUNCTION check_purchase_before_review()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM orders      AS o
        JOIN order_items AS oi ON o.id = oi.order_id
        WHERE o.customer_id = NEW.customer_id
          AND oi.product_id = NEW.product_id
    ) THEN
        RAISE EXCEPTION 'Customer % has not purchased product %',
            NEW.customer_id, NEW.product_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_review_purchase_check
BEFORE INSERT ON reviews
FOR EACH ROW EXECUTE FUNCTION check_purchase_before_review();

-- Exercise 6 — Conceptual answer (in comments)
-- UUID as primary key:
--   Pros:
--     - Globally unique across systems/databases (safe for distributed systems,
--       microservices, replication, data merging)
--     - Does not expose record counts or insertion order to external consumers
--   Cons:
--     - 16 bytes vs 4 bytes for INT — larger indexes and foreign keys
--     - Random UUIDs (v4) cause index fragmentation (poor cache locality)
--     - Harder to read/debug manually
--   When to use UUID:
--     - Distributed systems where multiple nodes generate IDs independently
--     - Public-facing IDs (avoid enumeration attacks)
--     - Data federation / multi-database merges
--   When to prefer SERIAL:
--     - Single-database applications
--     - Maximum performance on large tables
--     - Natural ordering by insertion time is useful

-- Compromise: UUID v7 (timestamp-ordered) or ULID — random + ordered
