USE infoman1_bookstore;

-- Check the server version before testing CHECK constraint enforcement.
SELECT VERSION();

-- Task 1: Insert products with explicit column lists and verify each insert.
-- On a fresh seed, product IDs 1-5 are occupied and these inserts receive IDs 6 and 7.
INSERT INTO products (product_name, sku, price, stock_quantity, status)
VALUES ('Scientific Calculator', 'CALC-SCI-001', 850.00, 20, 'Active');

SELECT product_id, product_name, sku, price, stock_quantity, status
FROM products
WHERE sku = 'CALC-SCI-001';

INSERT INTO products (product_name, sku, price, stock_quantity, status)
VALUES ('Compass', 'CMP-001', 120.00, 50, 'Active');

SELECT product_id, product_name, sku, price, stock_quantity, status
FROM products
WHERE sku = 'CMP-001';

-- Task 2: Preview, update, and verify using the Calculator's seeded-run ID.
SELECT product_id, product_name, price
FROM products
WHERE product_id = 6;

UPDATE products
SET price = 875.00
WHERE product_id = 6;

SELECT product_id, product_name, price
FROM products
WHERE product_id = 6;

-- Preview, delete, and verify the seeded Eraser row by its stable primary key.
SELECT product_id, product_name, sku
FROM products
WHERE product_id = 5;

DELETE FROM products
WHERE product_id = 5;

SELECT product_id, product_name, sku
FROM products
WHERE product_id = 5;

-- Task 3a: The LEFT JOIN keeps Lea even though she has no manager.
SELECT
  e.employee_name AS employee,
  m.employee_name AS manager
FROM employees AS e
LEFT JOIN employees AS m
  ON e.manager_id = m.employee_id
ORDER BY e.employee_id;

-- Task 3b: Deliberately generate each available color-size variant.
SELECT
  c.color_name,
  z.size_name,
  COUNT(*) OVER () AS total_pairs
FROM colors AS c
CROSS JOIN sizes AS z
ORDER BY c.color_name, z.size_name;

-- Task 4a: Add optional contact information to products.
ALTER TABLE products
ADD COLUMN contact_number VARCHAR(20);

-- Task 4b: Add the three required integrity rules.
ALTER TABLE products
MODIFY product_name VARCHAR(100) NOT NULL;

ALTER TABLE products
ADD CONSTRAINT uq_products_sku UNIQUE (sku);

ALTER TABLE products
ADD CONSTRAINT chk_products_price_positive CHECK (price > 0);

-- MySQL 8.0.16+ enforces CHECK constraints.
-- Run each valid test separately; ROLLBACK leaves no test product behind.

-- NOT NULL: valid write passes.
START TRANSACTION;
INSERT INTO products (product_name, sku, price, stock_quantity, status)
VALUES ('Not Null Test', 'TEST-NN-001', 1.00, 1, 'Active');
SELECT product_name, sku FROM products WHERE sku = 'TEST-NN-001';
ROLLBACK;

-- NOT NULL: expected error; an explicit NULL is rejected regardless of SQL mode.
INSERT INTO products (product_name, sku, price, stock_quantity, status)
VALUES (NULL, 'TEST-NN-INVALID', 1.00, 1, 'Active');

-- UNIQUE: valid write with an unused SKU passes.
START TRANSACTION;
INSERT INTO products (product_name, sku, price, stock_quantity, status)
VALUES ('Unique Test', 'TEST-UNIQUE-001', 1.00, 1, 'Active');
SELECT product_name, sku FROM products WHERE sku = 'TEST-UNIQUE-001';
ROLLBACK;

-- UNIQUE: expected duplicate-key error because BP-001 already exists.
INSERT INTO products (product_name, sku, price, stock_quantity, status)
VALUES ('Duplicate SKU Test', 'BP-001', 1.00, 1, 'Active');

-- CHECK: valid positive price passes.
START TRANSACTION;
INSERT INTO products (product_name, sku, price, stock_quantity, status)
VALUES ('Price Test', 'TEST-PRICE-001', 0.01, 1, 'Active');
SELECT product_name, sku, price FROM products WHERE sku = 'TEST-PRICE-001';
ROLLBACK;

-- CHECK: expected check-constraint error because price is not greater than zero.
INSERT INTO products (product_name, sku, price, stock_quantity, status)
VALUES ('Invalid Price Test', 'TEST-PRICE-INVALID', 0.00, 1, 'Active');
