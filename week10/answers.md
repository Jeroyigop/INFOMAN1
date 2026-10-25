# INFOMAN1 — Week 10 Lab Answers

Name: Jerie Corales
Student ID: 2510704
GitHub repo: https://github.com/Jeroyigop/INFOMAN1
Date submitted: 10/25/26

The database setup is in [week10_seed.sql](./week10_seed.sql), and the statements for Tasks
1–4 are in [lab10.sql](./lab10.sql). The screenshots in this folder document the MySQL run.
The three invalid constraint-test statements are intentionally expected to return errors.

## Task 1 — Safe INSERT

**Approach / explanation:**
I listed the target columns in both `INSERT` statements so each value maps to the intended
field, even if the table's column order changes. After each insert, I selected by its SKU to
confirm the product details. The duplicate-SKU rejection is tested in Task 4 after the
`UNIQUE` constraint has been added.

**Code / query used (if applicable):**
See Task 1 in [lab10.sql](./lab10.sql).

```sql
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
```

**Evidence (screenshot filename, output, or file reference in this folder):**
[task1.png](./task1.png) shows both successful inserts and their post-insert `SELECT`s. On
the fresh seed, the Calculator is product ID 6 and the Compass is product ID 7. The duplicate
`BP-001` test later in [lab10.sql](./lab10.sql) is rejected by the SKU uniqueness constraint
because that SKU already belongs to Ballpen.

**Reflection question:**
Explicit column names make the insert less dependent on the table's physical column order
and reduce the chance of putting a value in the wrong field. Omitted columns receive their
declared default, an automatically generated value such as `AUTO_INCREMENT`, or `NULL` if
the column permits it and no default applies; otherwise MySQL rejects the insert.

## Task 2 — UPDATE & DELETE Without Collateral Damage

**Approach / explanation:**
I previewed each target row with the same `WHERE` condition used by the change, then verified
the result afterward. The fresh seed assigns product ID 6 to the new Calculator and ID 5 to
the Eraser, so both statements target primary keys rather than names. Without a `WHERE`
clause, the `UPDATE` would change every product's price and the `DELETE` would remove every
product row if allowed. The seed's foreign key from `sales` references products 1 and 2,
so an unfiltered delete would be rejected unless those dependent sales were removed too.

**Code / query used (if applicable):**
See Task 2 in [lab10.sql](./lab10.sql); it includes preview, execute, and verify statements
for both changes.

```sql
SELECT product_id, product_name, price
FROM products
WHERE product_id = 6;

UPDATE products
SET price = 875.00
WHERE product_id = 6;

SELECT product_id, product_name, price
FROM products
WHERE product_id = 6;

SELECT product_id, product_name, sku
FROM products
WHERE product_id = 5;

DELETE FROM products
WHERE product_id = 5;

SELECT product_id, product_name, sku
FROM products
WHERE product_id = 5;
```

**Evidence (screenshot filename, output, or file reference in this folder):**
[task1.png](./task1.png) shows the Calculator preview and updated price. [task2.png](./task2.png)
shows the Eraser preview and the empty result after deletion.

**Reflection question:**
Without `WHERE`, an `UPDATE` affects every row. A `DELETE` attempts to remove every row, but
the foreign key from `sales` would block it while sales still reference products 1 and 2.
A primary key is safer than a name because it uniquely identifies one row and is not shared
by products with the same name.

## Task 3 — Self Join & Cross Join

**Approach / explanation:**
The self join uses `e` for each employee and `m` for that employee's manager. A `LEFT JOIN`
preserves Lea even though her `manager_id` is `NULL`. The color-size `CROSS JOIN` intentionally
produces all 3 × 3 combinations, which is useful when generating every color and size variant
for a catalog; it should be explicit because an accidental missing join condition can
multiply unrelated rows.

**Code / query used (if applicable):**
See Task 3 in [lab10.sql](./lab10.sql).

```sql
SELECT e.employee_name AS employee, m.employee_name AS manager
FROM employees AS e
LEFT JOIN employees AS m
  ON e.manager_id = m.employee_id;

SELECT c.color_name, z.size_name, COUNT(*) OVER () AS total_pairs
FROM colors AS c
CROSS JOIN sizes AS z
ORDER BY c.color_name, z.size_name;
```

**Evidence (screenshot filename, output, or file reference in this folder):**
[task2.png](./task2.png) shows the self-join output, including Lea with a `NULL` manager.
[task3.png](./task3.png) shows all 9 color-size pairs (3 colors × 3 sizes), with `total_pairs`
equal to 9 on every row.

**Reflection question:**
The aliases distinguish the employee row from the manager row even though both come from
`employees`. `LEFT JOIN` keeps employees without a manager. A `CROSS JOIN` is deliberate
when every combination is needed, such as all color-size product variants; omitting an
intended `ON` condition by mistake can create a similar, unintended multiplication.

## Task 4 — Constraints & Table Evolution

**Approach / explanation:**
I added an optional `contact_number` column, then used `ALTER TABLE` to require a product
name, make SKU values unique, and reject non-positive prices. The valid test inserts are
wrapped in transactions and rolled back so they demonstrate accepted writes without leaving
test rows. Each invalid insert is marked as expected to fail. MySQL enforces `CHECK`
constraints starting with version 8.0.16.

**Code / query used (if applicable):**
See Task 4 in [lab10.sql](./lab10.sql) for the `ALTER TABLE` statements and passing/rejected
write tests.

```sql
ALTER TABLE products ADD COLUMN contact_number VARCHAR(20);
ALTER TABLE products MODIFY product_name VARCHAR(100) NOT NULL;
ALTER TABLE products ADD CONSTRAINT uq_products_sku UNIQUE (sku);
ALTER TABLE products
  ADD CONSTRAINT chk_products_price_positive CHECK (price > 0);
```

**Evidence (screenshot filename, output, or file reference in this folder):**
[task3.png](./task3.png) shows the successful `ALTER TABLE` statements, a passing `NOT NULL`
test, and the expected `NOT NULL` and `UNIQUE` errors. [task4.png](./task4.png) shows the
passing positive-price test. The expected rejections are: inserting `NULL` for `product_name`
violates `NOT NULL`; reusing `BP-001`
violates `uq_products_sku`; inserting price `0.00` violates
`chk_products_price_positive`. MySQL should report an error for each invalid statement.
The lab begins with `SELECT VERSION();`; confirm that the server is MySQL 8.0.16 or later
for enforced `CHECK` constraints.

**Reflection question:**
Constraints reject future writes that break a rule, but they do not repair or remove invalid
rows already stored. Before adding `NOT NULL`, inspect existing rows for `NULL` values and
correct them; otherwise, the `ALTER TABLE` may fail.

## Task 5 — Reflection

**Approach / explanation:**
This reflection distinguishes convenient application feedback from database rules that
must hold for every client. Personalize the mistake example to match something you actually
made or observed while running this lab.

**Code / query used (if applicable):**
No additional SQL is required.

**Evidence (screenshot filename, output, or file reference in this folder):**
Reflection draft (replace the bracketed sentence with a true mistake you made or observed;
keep the final reflection between 150 and 200 words):

A campus bookstore application should validate information before submission so staff can
get clear feedback, such as being told that a price must be positive. The database should
also enforce essential rules because records may be added through another screen, an import,
or a direct SQL statement that bypasses the form. Task 4 demonstrates this defense in depth:
the application can explain the price rule, while `CHECK (price > 0)` prevents any client
from storing a zero or negative price. The database's `UNIQUE` constraint similarly protects
SKU integrity even if an application check misses a duplicate. **[Replace this sentence
with a specific mistake you actually made or observed, its symptom, and how you fixed it.]**
For example, an `UPDATE` without its `WHERE` condition could change every product's price;
the symptom would be many rows changing instead of only the Calculator. Previewing the
target with `SELECT`, using the product's primary key in the update, and verifying afterward
are safeguards against that mistake. Application checks improve usability, while database
constraints provide a reliable final boundary for the data.

**Reflection question:**
Use application checks to give users immediate, understandable feedback, and database
constraints to guarantee data integrity across every client. A symptom of relying only on
the wrong layer is invalid data being stored through a path that bypasses the application.

## Self-Check

- [ ] Run [week10_seed.sql](./week10_seed.sql) once, then run [lab10.sql](./lab10.sql).
- [ ] Capture outputs, including the three expected constraint-rejection errors.
- [ ] Replace the marked Task 5 example with a mistake you actually made or observed.
- [ ] Confirm your name, student ID, and repository details are correct.
- [x] Place the SQL scripts and this `answers.md` inside `week10/`.
- [ ] Commit the completed deliverables and submit the repository link in Moodle.
