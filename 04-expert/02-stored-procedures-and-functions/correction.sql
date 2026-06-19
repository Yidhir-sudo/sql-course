-- =============================================================
-- Module 02 — Stored Procedures and Functions | Corrections
-- =============================================================

-- Exercise 1: Total revenue per product
CREATE OR REPLACE FUNCTION product_revenue(p_product_id INT)
RETURNS NUMERIC AS $$
    SELECT COALESCE(SUM(quantity * unit_price), 0)
    FROM order_items
    WHERE product_id = p_product_id;
$$ LANGUAGE sql STABLE;

-- Test:
SELECT p.name, ROUND(product_revenue(p.id), 2) AS revenue
FROM products AS p
ORDER BY revenue DESC;

-- Exercise 2: Order total
CREATE OR REPLACE FUNCTION order_total(p_order_id INT)
RETURNS NUMERIC AS $$
    SELECT COALESCE(SUM(quantity * unit_price), 0)
    FROM order_items
    WHERE order_id = p_order_id;
$$ LANGUAGE sql STABLE;

-- Test:
SELECT id, ROUND(order_total(id), 2) AS total
FROM orders;

-- Exercise 3: Classify order by size
CREATE OR REPLACE FUNCTION classify_order(p_order_id INT)
RETURNS TEXT AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT order_total(p_order_id) INTO total;

    IF total < 50 THEN
        RETURN 'small';
    ELSIF total <= 200 THEN
        RETURN 'medium';
    ELSE
        RETURN 'large';
    END IF;
END;
$$ LANGUAGE plpgsql STABLE;

-- Test:
SELECT id, ROUND(order_total(id), 2) AS total, classify_order(id) AS size
FROM orders;

-- Exercise 4: Stored procedure to place an order
CREATE TABLE IF NOT EXISTS audit_log (
    id           SERIAL PRIMARY KEY,
    action       TEXT,
    performed_at TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE PROCEDURE place_order(
    p_customer_id INT,
    p_employee_id INT,
    p_product_id  INT,
    p_quantity    INT
)
LANGUAGE plpgsql AS $$
DECLARE
    current_stock  INT;
    current_price  NUMERIC;
    new_order_id   INT;
BEGIN
    -- Check stock
    SELECT stock, price
    INTO current_stock, current_price
    FROM products
    WHERE id = p_product_id;

    IF current_stock < p_quantity THEN
        RAISE EXCEPTION 'Insufficient stock for product %. Available: %, Requested: %',
            p_product_id, current_stock, p_quantity;
    END IF;

    -- Create order
    INSERT INTO orders (customer_id, employee_id, status, ordered_at)
    VALUES (p_customer_id, p_employee_id, 'pending', NOW())
    RETURNING id INTO new_order_id;

    -- Create order item
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (new_order_id, p_product_id, p_quantity, current_price);

    -- Decrease stock
    UPDATE products
    SET stock = stock - p_quantity
    WHERE id = p_product_id;

    -- Audit
    INSERT INTO audit_log (action)
    VALUES (
        'Order ' || new_order_id || ' placed: product ' || p_product_id ||
        ' x' || p_quantity || ' for customer ' || p_customer_id
    );

    COMMIT;
END;
$$;

-- Test:
CALL place_order(1, 2, 1, 2);

-- Exercise 5 — Challenge: Monthly revenue report as a table function
CREATE OR REPLACE FUNCTION monthly_revenue_report()
RETURNS TABLE (month DATE, revenue NUMERIC)
LANGUAGE sql STABLE AS $$
    SELECT
        DATE_TRUNC('month', o.ordered_at)::DATE AS month,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM orders      AS o
    JOIN order_items AS oi ON o.id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.ordered_at)
    ORDER BY month;
$$;

-- Test:
SELECT * FROM monthly_revenue_report();
