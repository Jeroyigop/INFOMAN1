USE infoman1_canteen;

-- Task 1: Buyers with orders.
SELECT s.student_name, s.program, o.order_id, o.order_date
FROM students AS s
INNER JOIN orders AS o
  ON s.student_id = o.student_id
ORDER BY o.order_id;

-- Task 2a: Every student, including students with no orders.
SELECT s.student_name, s.program, o.order_id, o.order_date
FROM students AS s
LEFT JOIN orders AS o
  ON s.student_id = o.student_id
ORDER BY s.student_id, o.order_id;

-- Task 2b: Students who have never ordered.
SELECT s.student_name, s.program, o.order_id, o.order_date
FROM students AS s
LEFT JOIN orders AS o
  ON s.student_id = o.student_id
WHERE o.order_id IS NULL
ORDER BY s.student_id;

-- Task 3: Four-table report, one explicit key relationship per JOIN.
SELECT
  s.student_name,
  s.program,
  o.order_id,
  m.item_name,
  oi.quantity,
  m.price,
  oi.quantity * m.price AS line_total
FROM students AS s
INNER JOIN orders AS o
  ON s.student_id = o.student_id
INNER JOIN order_items AS oi
  ON o.order_id = oi.order_id
INNER JOIN menu_items AS m
  ON oi.menu_id = m.menu_id
ORDER BY o.order_id, m.item_name;

-- Task 4a: August 2026 item report, newest orders first.
SELECT
  s.student_name AS buyer,
  o.order_date,
  m.item_name AS item,
  oi.quantity * m.price AS line_total
FROM students AS s
INNER JOIN orders AS o
  ON s.student_id = o.student_id
INNER JOIN order_items AS oi
  ON o.order_id = oi.order_id
INNER JOIN menu_items AS m
  ON oi.menu_id = m.menu_id
WHERE o.order_date >= '2026-08-01'
  AND o.order_date < '2026-09-01'
ORDER BY o.order_date DESC, o.order_id DESC, m.item_name;

-- Task 4b: LEFT JOIN version with the date condition in WHERE.
-- The WHERE condition removes rows where o.order_date is NULL.
SELECT
  s.student_name AS buyer,
  o.order_date,
  m.item_name AS item,
  oi.quantity * m.price AS line_total
FROM students AS s
LEFT JOIN orders AS o
  ON s.student_id = o.student_id
LEFT JOIN order_items AS oi
  ON o.order_id = oi.order_id
LEFT JOIN menu_items AS m
  ON oi.menu_id = m.menu_id
WHERE o.order_date >= '2026-08-01'
  AND o.order_date < '2026-09-01'
ORDER BY o.order_date DESC, o.order_id DESC, m.item_name;

-- Task 4c: Preserve every student by moving the date rule into the orders ON clause.
SELECT
  s.student_name AS buyer,
  o.order_date,
  m.item_name AS item,
  oi.quantity * m.price AS line_total
FROM students AS s
LEFT JOIN orders AS o
  ON s.student_id = o.student_id
  AND o.order_date >= '2026-08-01'
  AND o.order_date < '2026-09-01'
LEFT JOIN order_items AS oi
  ON o.order_id = oi.order_id
LEFT JOIN menu_items AS m
  ON oi.menu_id = m.menu_id
ORDER BY o.order_date DESC, o.order_id DESC, m.item_name;
