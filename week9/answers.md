# INFOMAN1 — Week 9 Lab Answers

Name:Jerie Corales
Student ID:2510704
GitHub repo: https://github.com/Jeroyigop/INFOMAN1
Date submitted: 10/25/26

The supplied database setup is in [week9_seed.sql](./week9_seed.sql), and the queries for
Tasks 1–4 are in [lab9.sql](./lab9.sql). The scripts were run in MySQL; the screenshots
[week9.png](./week9.png) and [week9-1.png](./week9-1.png) show the query outputs.

## Task 1 — INNER JOIN Basics

**Approach / explanation:**
I joined `students` to `orders` using their shared student identifier. An `INNER JOIN` returns
only records with a matching order, and sorting by `order_id` places the buyers' orders in
order.

**Code / query used (if applicable):**
See the Task 1 query in [lab9.sql](./lab9.sql).

```sql
SELECT s.student_name, s.program, o.order_id, o.order_date
FROM students AS s
INNER JOIN orders AS o
  ON s.student_id = o.student_id
ORDER BY o.order_id;
```

**Evidence (screenshot filename, output, or file reference in this folder):**
[week9.png](./week9.png) shows the Task 1 output.

| student_name | program | order_id | order_date |
|---|---|---:|---|
| Ana Cruz | BSIT | 101 | 2026-08-10 |
| Ana Cruz | BSIT | 102 | 2026-08-15 |
| Dan Reyes | BSIT | 103 | 2026-08-16 |

**Reflection question:**
An `INNER JOIN` hides students who never ordered because they have no matching row in
`orders`. That is useful for a completed-sales report, where every listed buyer must have a
sale; it would be unsuitable for an all-student roster.

## Task 2 — Finding Missing Relationships

**Approach / explanation:**
The first query uses a `LEFT JOIN` so that every student stays in the result, even when the
right-side order columns have no match. The second query checks the unmatched key with
`IS NULL`, which isolates students who have never ordered.

**Code / query used (if applicable):**
See the two Task 2 queries in [lab9.sql](./lab9.sql).

```sql
SELECT s.student_name, s.program, o.order_id, o.order_date
FROM students AS s
LEFT JOIN orders AS o
  ON s.student_id = o.student_id
ORDER BY s.student_id, o.order_id;

SELECT s.student_name, s.program, o.order_id, o.order_date
FROM students AS s
LEFT JOIN orders AS o
  ON s.student_id = o.student_id
WHERE o.order_id IS NULL
ORDER BY s.student_id;
```

**Evidence (screenshot filename, output, or file reference in this folder):**
[week9.png](./week9.png) shows both Task 2 queries. Expected output for (a): Ana Cruz appears
with orders 101 and 102; Ben Lim and Cara Yu appear
with `NULL` order fields; Dan Reyes appears with order 103. Expected output for (b):

| student_name | program | order_id | order_date |
|---|---|---|---|
| Ben Lim | BSCS | NULL | NULL |
| Cara Yu | BSIS | NULL | NULL |

Ben and Cara appear because neither has a matching row in `orders`. SQL `NULL` represents a
missing/unknown value, so it must be tested with `IS NULL`, not `= NULL`.

**Reflection question:**
The `NULL` values identify missing matches on the order side of the join. SQL's `NULL` means
that there is no ordinary value to compare, so `= NULL` does not evaluate as true; `IS NULL`
is the correct test.

## Task 3 — Four-Table Canteen Report

**Approach / explanation:**
I followed the foreign-key path from students to orders, order items, and menu items. Each
join has its own `ON` condition using the related key, and each selected field is qualified
with its table alias so similarly named columns are unambiguous. Multiplying quantity by
price calculates each item's line total.

**Code / query used (if applicable):**
See the Task 3 query in [lab9.sql](./lab9.sql).

```sql
SELECT
  s.student_name, s.program, o.order_id, m.item_name,
  oi.quantity, m.price, oi.quantity * m.price AS line_total
FROM students AS s
INNER JOIN orders AS o
  ON s.student_id = o.student_id
INNER JOIN order_items AS oi
  ON o.order_id = oi.order_id
INNER JOIN menu_items AS m
  ON oi.menu_id = m.menu_id
ORDER BY o.order_id, m.item_name;
```

**Evidence (screenshot filename, output, or file reference in this folder):**
[week9-1.png](./week9-1.png) shows the Task 3 output.

| student_name | program | order_id | item_name | quantity | price | line_total |
|---|---|---:|---|---:|---:|---:|
| Ana Cruz | BSIT | 101 | Iced Tea | 1 | 30.00 | 30.00 |
| Ana Cruz | BSIT | 101 | Siomai Rice | 2 | 65.00 | 130.00 |
| Ana Cruz | BSIT | 102 | Burger Steak | 1 | 89.00 | 89.00 |
| Dan Reyes | BSIT | 103 | Siomai Rice | 1 | 65.00 | 65.00 |

**Reflection question:**
Each join needs an `ON` condition to state which keys relate the two tables. If a join is
missing its relationship or uses the wrong one, it can produce unrelated combinations,
duplicate rows, or incorrect results; specifying each key relationship avoids that.

## Task 4 — Aliases, Filters, and the Silent Inner Join

**Approach / explanation:**
The first query joins the four tables and filters orders to August 2026, sorting the report
from newest to oldest. The second query uses `LEFT JOIN` throughout but puts the date test
in `WHERE`; this rejects rows where `order_date` is `NULL`. The fixed version puts the date
condition in the `orders` join's `ON` clause, preserving students without an August order.

**Code / query used (if applicable):**
See the three Task 4 queries (4a, 4b, and 4c) in [lab9.sql](./lab9.sql).

**Evidence (screenshot filename, output, or file reference in this folder):**
[week9-1.png](./week9-1.png) shows the Task 4 outputs. Observed row counts:

| Version | Rows | Explanation |
|---|---:|---|
| 4a — INNER JOIN August report | 4 | Four ordered menu items across orders 101–103. |
| 4b — LEFT JOIN with date in `WHERE` | 4 | The `WHERE` condition removes unmatched students whose order date is `NULL`. |
| 4c — LEFT JOIN with date in `ON` | 6 | Four ordered-item rows plus one unmatched row each for Ben and Cara. |

Versions 4a and 4b both return the four August line items. In 4b, although the joins begin
as outer joins, `o.order_date >= '2026-08-01'` is not true for the `NULL` dates, so Ben and
Cara are removed. Moving the date condition into the `ON` clause (4c) preserves all students;
their unmatched order and item columns remain `NULL`. In general, a `WHERE` condition that
requires a right-side value can undo the row-preserving effect of a `LEFT JOIN`.

**Reflection question:**
The `WHERE` clause is applied after the join and rejects rows with `NULL` in `o.order_date`.
For a report that must retain students without matching orders, put the date restriction in
the `ON` clause or explicitly include unmatched rows with an `OR o.order_date IS NULL`
condition.

## Task 5 — Reflection

**Approach / explanation:**
I compared the row-preserving behavior in Task 2 with the order-only report in Task 1, then
used Task 4 to illustrate how filter placement can affect an outer join.

**Code / query used (if applicable):**
No additional SQL is required for this reflection.

**Evidence (screenshot filename, output, or file reference in this folder):**
Reflection (180 words):

For a campus report, I would choose the join based on who must appear in the result. An
`INNER JOIN` is appropriate for a completed sales report because it should list only students
who actually placed orders. Task 1 demonstrates this: Ana Cruz and Dan Reyes appear because
they have matching orders, while Ben Lim and Cara Yu do not. For an all-student canteen
participation report, I would use a `LEFT JOIN` from students to orders so that students with
no purchases remain visible with `NULL` order fields. Task 4 shows a mistake to watch for:
putting a condition such as `o.order_date >= '2026-08-01'` in `WHERE` after a `LEFT JOIN`.
The symptom is that students with no matching order disappear, making the result behave like
an inner join for that condition. The fix is to move the date rule into the `ON` condition
when unmatched students must be retained, or explicitly allow `NULL` dates in `WHERE`.
The correct choice depends on the question: completed transactions call for matched rows,
while coverage or participation reports should preserve the full student roster.

**Reflection question:**
For an all-students roster I would choose `LEFT JOIN`; for completed sales only I would
choose `INNER JOIN`. A warning symptom is that a student with no orders is missing from a
report that is supposed to include everyone.

## Self-Check

- [ ] Run `week9_seed.sql` once in MySQL and verify the tables and sample rows.
- [ ] Run `lab9.sql` and save screenshots or exported output for Tasks 1–4.
- [x] Place the SQL scripts and this `answers.md` inside `week9/`.
- [ ] Replace the student/repository placeholders and enter the submission date.
- [ ] Commit the completed deliverables and submit the repository link in Moodle.
