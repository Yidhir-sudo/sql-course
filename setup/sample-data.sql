-- =============================================================
-- ShopDB — Sample database for the SQL Course
-- Compatible with PostgreSQL (and mostly SQLite / MySQL)
-- =============================================================

-- -------------------------
-- Clean slate
-- -------------------------
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;

-- -------------------------
-- Tables
-- -------------------------

CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE products (
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(200) NOT NULL,
    category_id  INT REFERENCES categories(id),
    price        NUMERIC(10, 2) NOT NULL,
    stock        INT NOT NULL DEFAULT 0,
    created_at   DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE customers (
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    email      VARCHAR(200) NOT NULL UNIQUE,
    city       VARCHAR(100),
    country    VARCHAR(100),
    joined_at  DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE employees (
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    role       VARCHAR(100),
    manager_id INT REFERENCES employees(id),
    hired_at   DATE NOT NULL
);

CREATE TABLE orders (
    id          SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    employee_id INT REFERENCES employees(id),
    status      VARCHAR(50) NOT NULL DEFAULT 'pending',
    ordered_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipped_at  TIMESTAMP
);

CREATE TABLE order_items (
    id         SERIAL PRIMARY KEY,
    order_id   INT REFERENCES orders(id),
    product_id INT REFERENCES products(id),
    quantity   INT NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL
);

-- -------------------------
-- Seed data — categories
-- -------------------------
INSERT INTO categories (name, description) VALUES
    ('Electronics',  'Gadgets, devices, and accessories'),
    ('Books',        'Printed and digital books'),
    ('Clothing',     'Apparel and fashion items'),
    ('Home & Garden','Furniture, decor, and gardening supplies'),
    ('Sports',       'Sports equipment and outdoor gear');

-- -------------------------
-- Seed data — products
-- -------------------------
INSERT INTO products (name, category_id, price, stock, created_at) VALUES
    ('Wireless Mouse',         1,  29.99, 150, '2024-01-10'),
    ('Mechanical Keyboard',    1,  89.99,  80, '2024-01-15'),
    ('USB-C Hub',              1,  45.00, 200, '2024-02-01'),
    ('Monitor 27"',            1, 349.00,  30, '2024-02-20'),
    ('Webcam HD',              1,  59.99,  60, '2024-03-05'),
    ('Learning SQL',           2,  39.99, 300, '2024-01-05'),
    ('The Pragmatic Programmer',2, 44.99, 250, '2024-01-05'),
    ('Clean Code',             2,  34.99, 280, '2024-01-05'),
    ('Database Design Pro',    2,  49.99, 120, '2024-03-01'),
    ('Running Shoes',          5,  79.99,  90, '2024-02-10'),
    ('Yoga Mat',               5,  24.99, 200, '2024-02-15'),
    ('Dumbbell Set 10kg',      5,  54.99,  40, '2024-03-10'),
    ('Winter Jacket',          3, 129.99,  55, '2024-01-20'),
    ('Casual T-Shirt',         3,  19.99, 400, '2024-01-25'),
    ('Garden Hose 20m',        4,  34.99,  70, '2024-03-20'),
    ('Bookshelf Oak',          4, 199.99,  15, '2024-02-28');

-- -------------------------
-- Seed data — customers
-- -------------------------
INSERT INTO customers (first_name, last_name, email, city, country, joined_at) VALUES
    ('Alice',   'Martin',   'alice.martin@email.com',   'Paris',     'France',      '2024-01-12'),
    ('Bob',     'Smith',    'bob.smith@email.com',      'London',    'UK',          '2024-01-20'),
    ('Clara',   'Dupont',   'clara.dupont@email.com',   'Lyon',      'France',      '2024-02-05'),
    ('David',   'Jones',    'david.jones@email.com',    'Manchester','UK',          '2024-02-14'),
    ('Eva',     'Müller',   'eva.muller@email.com',     'Berlin',    'Germany',     '2024-02-20'),
    ('Frank',   'Rossi',    'frank.rossi@email.com',    'Rome',      'Italy',       '2024-03-01'),
    ('Grace',   'Tanaka',   'grace.tanaka@email.com',   'Tokyo',     'Japan',       '2024-03-10'),
    ('Hugo',    'Leclerc',  'hugo.leclerc@email.com',   'Paris',     'France',      '2024-03-15'),
    ('Ines',    'Garcia',   'ines.garcia@email.com',    'Madrid',    'Spain',       '2024-04-01'),
    ('Jake',    'Brown',    'jake.brown@email.com',     'New York',  'USA',         '2024-04-10'),
    ('Karen',   'White',    'karen.white@email.com',    'Chicago',   'USA',         '2024-04-15'),
    ('Liam',    'Petit',    'liam.petit@email.com',     'Bordeaux',  'France',      '2024-05-01'),
    ('Mia',     'Chen',     'mia.chen@email.com',       'Shanghai',  'China',       '2024-05-10'),
    ('Noah',    'Kumar',    'noah.kumar@email.com',     'Mumbai',    'India',       '2024-05-20'),
    ('Olivia',  'Andersen', 'olivia.andersen@email.com','Copenhagen','Denmark',     '2024-06-01');

-- -------------------------
-- Seed data — employees
-- -------------------------
INSERT INTO employees (id, first_name, last_name, role, manager_id, hired_at) VALUES
    (1, 'Sophie',  'Laurent',  'Sales Manager',    NULL, '2022-03-01'),
    (2, 'Thomas',  'Bernard',  'Sales Rep',        1,    '2023-01-15'),
    (3, 'Marie',   'Dubois',   'Sales Rep',        1,    '2023-06-01'),
    (4, 'Paul',    'Moreau',   'Logistics Manager',NULL, '2022-05-10'),
    (5, 'Julie',   'Simon',    'Logistics',        4,    '2023-09-01');

-- -------------------------
-- Seed data — orders
-- -------------------------
INSERT INTO orders (id, customer_id, employee_id, status, ordered_at, shipped_at) VALUES
    (1,  1, 2, 'delivered', '2024-02-01 10:00', '2024-02-03 14:00'),
    (2,  2, 2, 'delivered', '2024-02-05 09:30', '2024-02-07 11:00'),
    (3,  3, 3, 'delivered', '2024-02-10 15:00', '2024-02-12 10:00'),
    (4,  4, 2, 'shipped',   '2024-03-01 08:00', '2024-03-03 09:00'),
    (5,  5, 3, 'delivered', '2024-03-05 12:00', '2024-03-07 16:00'),
    (6,  1, 2, 'delivered', '2024-03-10 11:00', '2024-03-12 13:00'),
    (7,  6, 3, 'cancelled', '2024-03-15 14:00', NULL),
    (8,  7, 2, 'delivered', '2024-04-01 10:30', '2024-04-03 15:00'),
    (9,  8, 3, 'pending',   '2024-04-10 09:00', NULL),
    (10, 9, 2, 'shipped',   '2024-04-15 13:00', '2024-04-17 11:00'),
    (11,10, 3, 'delivered', '2024-05-01 10:00', '2024-05-03 14:00'),
    (12,11, 2, 'delivered', '2024-05-10 11:30', '2024-05-12 09:00'),
    (13,12, 3, 'pending',   '2024-05-20 15:00', NULL),
    (14,13, 2, 'delivered', '2024-06-01 08:00', '2024-06-03 12:00'),
    (15,14, 3, 'shipped',   '2024-06-10 14:00', '2024-06-12 10:00');

-- -------------------------
-- Seed data — order_items
-- -------------------------
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1,  1, 1,  29.99),
    (1,  2, 1,  89.99),
    (2,  6, 2,  39.99),
    (3,  4, 1, 349.00),
    (3,  3, 1,  45.00),
    (4,  7, 1,  44.99),
    (4,  8, 1,  34.99),
    (5, 10, 1,  79.99),
    (5, 11, 2,  24.99),
    (6, 13, 1, 129.99),
    (6, 14, 3,  19.99),
    (7,  5, 1,  59.99),
    (8,  9, 1,  49.99),
    (8, 12, 1,  54.99),
    (9,  1, 2,  29.99),
    (10,15, 1,  34.99),
    (11, 2, 1,  89.99),
    (11, 3, 2,  45.00),
    (12, 6, 1,  39.99),
    (12,16, 1, 199.99),
    (13, 4, 1, 349.00),
    (14,10, 2,  79.99),
    (14,11, 1,  24.99),
    (15, 7, 3,  44.99);
