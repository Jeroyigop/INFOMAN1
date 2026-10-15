# INFOMAN1 — Week 7 Lab Answers

**Lab 7: Performance Task Using SQL 3 (Functions, Aliases & Filtering)**  
**Course:** INFOMAN1  
**Week:** 7 (Midterm)

The accompanying [university_db.sql](./university_db.sql) contains the lab database and sample
data. The original Moodle `answers.md` template was not accessible, so this file organizes the
answers by the lab's task headings.

## Setup

**Warning:** The provided SQL script starts with `DROP DATABASE IF EXISTS university_db`.
Importing it will delete and recreate any existing database with that name.

From PowerShell or Command Prompt, change to this folder and import the database:

```powershell
cd C:\Users\User\INFOMAN1\week7
mysql -u root -p < university_db.sql
```

Alternatively, open the MySQL client and run:

```sql
SOURCE C:/Users/User/INFOMAN1/week7/university_db.sql;
```

Verify the import:

```sql
USE university_db;
SHOW TABLES;
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM instructors;
SELECT COUNT(*) FROM assignments;
SELECT COUNT(*) FROM courses;
```

## Task 1 — Complex Student Roster

```sql
SELECT first_name, last_name, major
FROM students
WHERE major IN ('Computer Science', 'Information Technology')
  AND last_name LIKE 'S%'
  AND NOT (section = 'Online');
```

The `IN` condition selects either requested major, `LIKE 'S%'` matches last names
beginning with S, and `NOT` excludes students in the Online section. Based on the supplied
sample data, the matching students are:

| first_name | last_name | major |
|---|---|---|
| Sofia | Santos | Computer Science |
| Samuel | Santiago | Information Technology |
| Sarah | Sy | Computer Science |
| Daniel | Serrano | Information Technology |
| Liza | Soberano | Computer Science |

**Evidence:** Add a screenshot of the results grid after running the query in MySQL Workbench.

## Task 2 — Formatting Employee Data

```sql
SELECT CONCAT(
         LEFT(first_name, 1),
         '. ',
         last_name,
         ' ($',
         ROUND(salary),
         ')'
       ) AS `Instructor Details`
FROM instructors
LIMIT 5;
```

**First five rows** from the supplied sample data:

| Instructor Details |
|---|
| J. Smith ($55001) |
| M. Santos ($62500) |
| R. Johnson ($49000) |
| A. Reyes ($71250) |
| P. Cruz ($47001) |

## Task 3 — Project Deadline Analysis

```sql
SELECT assignment_name, assigned_date, due_date, Days_To_Complete
FROM (
    SELECT assignment_name,
           assigned_date,
           due_date,
           DATEDIFF(due_date, assigned_date) AS Days_To_Complete
    FROM assignments
) AS assignment_durations
WHERE Days_To_Complete > 14
ORDER BY Days_To_Complete DESC;
```

The inner query computes the duration in days. The outer query filters on the alias and sorts
the qualifying assignments from longest to shortest. Based on the supplied sample data, the
result is:

| assignment_name | assigned_date | due_date | Days_To_Complete |
|---|---|---|---:|
| Capstone Proposal | 2026-09-01 | 2026-10-15 | 44 |
| Midterm Lab Report | 2026-09-10 | 2026-10-05 | 25 |
| Normalization Case | 2026-09-01 | 2026-09-22 | 21 |
| SQL Basics Worksheet | 2026-08-05 | 2026-08-25 | 20 |

**Evidence:** Add a screenshot of the sorted output after running the query in MySQL Workbench.

## Task 4 — Comprehensive Data Audit

```sql
SELECT course_code, course_name, credits
FROM courses
WHERE (course_description IS NULL OR credits BETWEEN 4 AND 6)
  AND course_code LIKE '%ADV%'
ORDER BY course_name ASC;
```

`AND` has higher precedence than `OR` in SQL, so the parentheses make the intended grouping
explicit: a row must have `ADV` in its course code and must also have either a missing
description or between 4 and 6 credits. Based on the supplied sample data, the alphabetically
ordered results are:

| course_code | course_name | credits |
|---|---|---:|
| CS-ADV305 | Advanced Algorithms | 4 |
| CS-ADV400 | Advanced Capstone Project | 6 |
| CS-ADV101 | Advanced Database Systems | 5 |
| IT-ADV210 | Advanced Networking | 3 |
| ENG-ADV110 | Advanced Technical Writing | 2 |
| IT-ADV150 | Advanced Web Development | 6 |

## Submission Checklist

- [x] Save the provided `university_db.sql` in this folder.
- [ ] Run the queries against the imported database and confirm the schema supports the
  referenced columns (Task 1 expects a `section` column).
- [ ] Add the requested result screenshots. Task 2's first-five-row output is listed above.
- [ ] Submit only the URL to the `infoman1` repository in Moodle.
