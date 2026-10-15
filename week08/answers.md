# INFOMAN1 — Week 8 Lab Answers

**Employee Payroll Query Lab**  
**Term:** Midterm

## Setup

Download the instructor-provided `week08_seed.sql` from Moodle and place it in this folder.
The Moodle attachment link requires authentication and was not accessible from this workspace,
so the seed file and data-dependent results are not fabricated here.

From the MySQL prompt, load the seed file and confirm its row count:

```sql
CREATE DATABASE IF NOT EXISTS infoman1_week8;
USE infoman1_week8;
SOURCE C:/Users/User/INFOMAN1/week08/week08_seed.sql;
SELECT COUNT(*) AS employee_rows FROM employee;
```

Confirm the count is **500** before running the task scripts below.

## Task 1 — Pattern Matching

The three requested result queries and row-count checks are in [task1.sql](./task1.sql).
After loading the seed data, record the returned row counts and add screenshots or text output
for each result here. The `E____` check should return 500 rows.

| Query | Row count |
|---|---:|
| Last names ending in `ez` | Record after running |
| First names starting with `Ma` | Record after running |
| Codes matching `E____` | Expected: 500 |
| Codes matching `E_0__` | Record after running |

## Task 2 — Basic Aggregation & NULL Handling

The aggregation queries are in [task2.sql](./task2.sql). Run them and record the
returned values here:

| Measure | Result |
|---|---|
| Total employees | Record after running |
| Employees with commission | Record after running |
| Total monthly payroll | Record after running |
| Average salary | Record after running |
| Earliest hire date | Record after running |
| Latest hire date | Record after running |
| Total compensation including commission | Record after running |

`COUNT(*)` counts every employee, while `COUNT(commission)` excludes rows where commission is
`NULL`; their difference is the number of employees without a recorded commission.
`COALESCE(commission, 0)` substitutes zero for a missing commission so each employee's salary
still contributes to the total compensation instead of causing the row expression to become
`NULL`.

## Task 3 — Grouping Data

The department summary and department/job-title headcount queries are in [task3.sql](./task3.sql).
Run them and include the result grids or text output here.

## Task 4 — Advanced Filtering with HAVING

First run the department salary averages in [task4.sql](./task4.sql) to inspect the seed data.
Choose and explain a reasonable threshold based on those results, then set `@salary_threshold`
in the script before running the department filter.

**Chosen threshold and reason:** Complete after inspecting the department averages.

The department average salary condition belongs in `HAVING` because it filters grouped
aggregate results; `WHERE` filters individual rows before grouping.

The active-employee query also uses `HAVING` because the condition `COUNT(*) > 50` applies to
each department's grouped count, while `WHERE status = 'Active'` first limits the input rows
to active employees.

Add both Task 4 result grids or text outputs here after running the queries.

## Submission Checklist

- [ ] Download `week08_seed.sql` from Moodle and save it in this folder.
- [ ] Import the seed file and confirm `employee` contains exactly 500 rows.
- [ ] Run each query, record the actual outputs and Task 1 row counts, and add evidence.
- [ ] Inspect department averages, choose and explain the Task 4.1 threshold, and run it.
- [ ] Commit the work with meaningful task-specific commit messages.
- [ ] Submit only the URL of the persistent `infoman1` repository in Moodle.
