# INFOMAN1 — Week 8 Lab Answers

**Employee Payroll Query Lab**  
**Term:** Midterm

The supplied seed data is included as [week08_seed.sql](./week08_seed.sql). I parsed all 500
employee rows to calculate the expected results below. Run the SQL scripts against MySQL to
capture the required screenshots or query output before submitting.

## Setup

Open PowerShell and start the MySQL client using the configured port:

```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p -P 3307
```

At the `mysql>` prompt, load the seed file. The forward slashes in the `SOURCE` path are
supported by MySQL on Windows:

```sql
CREATE DATABASE IF NOT EXISTS infoman1_week8;
USE infoman1_week8;
SOURCE C:/Users/User/INFOMAN1/week8/week08_seed.sql;
SELECT COUNT(*) AS employee_rows FROM employee;
```

Confirm `employee_rows` is **500**, then run [task1.sql](./task1.sql),
[task2.sql](./task2.sql), [task3.sql](./task3.sql), and [task4.sql](./task4.sql).

## Task 1 — Pattern Matching

Queries are in [task1.sql](./task1.sql). Expected row counts from the supplied 500-row data:

| Query | Row count |
|---|---:|
| Last names ending in `ez` | 161 |
| First names starting with `Ma` | 112 |
| Codes matching `E____` | 500 |
| Codes matching `E_0__` | 48 |

The `E____` pattern matches five characters total: the literal `E` followed by four
single-character `_` wildcards. `E_0__` places a literal `0` in the third character position.

**Evidence:** Add screenshots or text output from running the four Task 1 queries in MySQL.

## Task 2 — Basic Aggregation & NULL Handling

The aggregation queries are in [task2.sql](./task2.sql). Expected values from the supplied seed:

| Measure | Expected result |
|---|---:|
| Total employees (`COUNT(*)`) | 500 |
| Employees with commission (`COUNT(commission)`) | 352 |
| Total monthly payroll (`SUM(salary)`) | 33,282,250.00 |
| Average salary (`AVG(salary)`) | 66,564.50 |
| Earliest hire date | 2015-01-03 |
| Latest hire date | 2026-09-14 |
| Total compensation including commission | 35,387,750.00 |

`COUNT(*)` counts all 500 employees, while `COUNT(commission)` skips `NULL` values, so 148
employees have no recorded commission. `COALESCE(commission, 0)` changes those missing values
to zero; otherwise `salary + commission` would be `NULL` for those employees and would not be
included in the sum.

**Evidence:** Capture the outputs from running the Task 2 queries in MySQL.

## Task 3 — Grouping Data

The two grouping queries are in [task3.sql](./task3.sql). Expected department summary:

| department | headcount | average_salary | distinct_job_titles |
|---|---:|---:|---:|
| Engineering | 125 | 75,160.00 | 3 |
| Finance | 69 | 79,513.04 | 3 |
| HR | 50 | 62,610.00 | 3 |
| Sales | 144 | 71,799.65 | 3 |
| Support | 112 | 44,028.57 | 3 |

Expected headcounts by department and job title:

| department | job_title | headcount |
|---|---|---:|
| Engineering | DevOps Engineer | 42 |
| Engineering | QA Analyst | 39 |
| Engineering | Software Engineer | 44 |
| Finance | Accountant | 21 |
| Finance | Finance Manager | 24 |
| Finance | Financial Analyst | 24 |
| HR | HR Manager | 18 |
| HR | HR Specialist | 20 |
| HR | Recruiter | 12 |
| Sales | Account Manager | 50 |
| Sales | Sales Manager | 49 |
| Sales | Sales Representative | 45 |
| Support | Support Agent | 40 |
| Support | Support Lead | 29 |
| Support | Support Specialist | 43 |

**Evidence:** Capture the outputs from running the Task 3 queries in MySQL.

## Task 4 — Advanced Filtering with HAVING

The queries are in [task4.sql](./task4.sql). The department salary averages are approximately:
Support — 44,028.57; HR — 62,610.00; Sales — 71,799.65; Engineering — 75,160.00; Finance —
79,513.04.

**Chosen threshold:** 70,000. This is above the overall salary average of 66,564.50 and selects
the three departments whose mean salaries exceed that benchmark.

Expected result for Task 4.1:

| department | average_salary |
|---|---:|
| Finance | 79,513.04 |
| Engineering | 75,160.00 |
| Sales | 71,799.65 |

Expected result for Task 4.2:

| department | active_headcount |
|---|---:|
| Engineering | 104 |
| Finance | 52 |
| Sales | 116 |
| Support | 99 |

`HAVING` is required for Task 4.1 because it filters the grouped average salary; `WHERE` filters
individual rows before aggregation. In Task 4.2, `WHERE` first restricts rows to active
employees, then `HAVING` filters each department's grouped count to values greater than 50.

**Evidence:** Capture the Task 4.1 and Task 4.2 result grids in MySQL.

## Submission Checklist

- [x] Save the instructor-provided `week08_seed.sql` in this folder.
- [x] Confirm the provided seed contains exactly 500 employee rows.
- [x] Record expected result values and explain the requested aggregate logic.
- [ ] Run the SQL scripts in MySQL and attach the required screenshots or text output.
- [ ] Commit the final deliverables with task-specific commit messages.
- [ ] Submit only the URL of the persistent `infoman1` repository in Moodle.
