# INFOMAN1 — Week 11 Lab Answers

Name: Jerie Corales
Student ID: 2510704
GitHub repo: https://github.com/Jeroyigop/INFOMAN1
Date submitted: 11/25/26

The flawed source table is created by [week11_seed.sql](./week11_seed.sql). The
read-only anomaly demonstrations and 1NF, 2NF, and 3NF table builds are in
[lab11.sql](./lab11.sql). Expected results are listed below; run the scripts in MySQL
and save screenshots of the actual query output before submitting. The seed should be run
once; if it is accidentally run twice, the source has six rows instead of three. The 1NF
load uses `SELECT DISTINCT` to avoid carrying identical duplicate source rows into the
normalized relation.

## Task 1 — Diagnose the Anomalies

**Approach / explanation:**
I inspected the repeated department facts, the course facts attached to enrollment rows,
and Ana's IT102 record without changing the source table. The D01 query shows three rows
requiring the same department-name correction. An independent IT103 course fact has no
student-course row to attach to in this design, while deleting Ana's IT102 enrollment would
also remove the only stored Web Development course facts.

**Code / query used (if applicable):**
See Task 1 queries in [lab11.sql](./lab11.sql).

```sql
SELECT dept_id, department_name, COUNT(*) AS rows_to_update
FROM student_enrollment
WHERE dept_id = 'D01'
GROUP BY dept_id, department_name;

SELECT
  NULL AS student_id, NULL AS student_name, NULL AS enrolled_courses,
  'IT103' AS course_id, 'Intro to Networks' AS course_title,
  'D01' AS dept_id, 'Computing Studies' AS department_name, NULL AS grade;

SELECT student_id, student_name, course_id, course_title, dept_id, department_name
FROM student_enrollment
WHERE student_id = 101 AND course_id = 'IT102';
```

**Evidence (screenshot filename, output, or file reference in this folder):**
Expected after one seed run: the D01 grouping reports **3** rows; the IT103 illustration shows that an
unassigned course would require `NULL` student/enrollment data (or a fabricated student);
the Ana/IT102 query returns the only row containing the `IT102` / `Web Development` facts.
The supplied schema permits `NULL`, so SQL would accept a malformed course-only row if
inserted; this script demonstrates the issue with `SELECT` and leaves the source unchanged.
If the seed was run twice, the D01 grouping reports six physical rows because the schema
has no key to prevent duplicates.

**Anomaly causes:**
- **Update:** The department name is duplicated across enrollment rows, so renaming D01
  requires updating all three copies consistently.
- **Insert:** Course facts are stored only alongside enrollment facts, so the design has no
  proper course-only row.
- **Delete:** The IT102 course facts occur only in Ana's enrollment row, so deleting that
  enrollment also deletes the only stored facts for the course.

**Reflection question:**
The delete anomaly is most visible because removing Ana's IT102 enrollment would also
erase the only occurrence of the Web Development course facts. The common structural cause
is storing facts about students, courses, departments, and enrollments together in one
repeating table rather than keeping each entity and relationship in its own relation.

## Task 2 — Reach First Normal Form

**Approach / explanation:**
I created one row per student-course enrollment and removed the comma-separated
`enrolled_courses` field. The `(student_id, course_id)` composite primary key gives every
student-course pair a dependable identity, and each remaining column contains one value.
1NF still repeats student names and course/department descriptions across enrollment rows;
later normalization stages remove that redundancy.

**Code / query used (if applicable):**
See the 1NF table creation, population, and `SELECT` in [lab11.sql](./lab11.sql).

```sql
CREATE TABLE enrollment_1nf (
  student_id INT NOT NULL,
  student_name VARCHAR(100) NOT NULL,
  course_id VARCHAR(10) NOT NULL,
  course_title VARCHAR(100) NOT NULL,
  dept_id VARCHAR(10) NOT NULL,
  department_name VARCHAR(100) NOT NULL,
  grade DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (student_id, course_id)
);
```

**Evidence (screenshot filename, output, or file reference in this folder):**
Expected atomic rows:

| student_id | student_name | course_id | course_title | dept_id | department_name | grade |
|---:|---|---|---|---|---|---:|
| 101 | Ana Cruz | IT101 | Database Systems | D01 | Computing Studies | 1.50 |
| 101 | Ana Cruz | IT102 | Web Development | D01 | Computing Studies | 1.25 |
| 102 | Ben Lim | IT101 | Database Systems | D01 | Computing Studies | 1.75 |

Capture the `SELECT` from `enrollment_1nf` to show each row has one student-course pair
and atomic values.

**Reflection question:**
Student names still repeat because they are carried on each student-course row after
removing the multi-valued cell. 2NF separates student facts that depend only on
`student_id` from enrollment facts that depend on the full student-course key.

## Task 3 — Reach Second Normal Form

**Approach / explanation:**
The natural composite key in the 1NF table is `(student_id, course_id)`. The observed
dependencies are `student_id -> student_name`, `course_id -> course_title, dept_id,
department_name`, `dept_id -> department_name`, and `(student_id, course_id) -> grade`.
I moved student and course facts into their own tables while keeping the grade with the
complete enrollment key. The course-to-department-name dependency remains for the 3NF step.

**Code / query used (if applicable):**
The `students_2nf`, `courses_2nf`, and `enrollments_2nf` definitions and their reconstructing
join are in [lab11.sql](./lab11.sql).

```sql
CREATE TABLE students_2nf (
  student_id INT PRIMARY KEY,
  student_name VARCHAR(100) NOT NULL
);

CREATE TABLE courses_2nf (
  course_id VARCHAR(10) PRIMARY KEY,
  course_title VARCHAR(100) NOT NULL,
  dept_id VARCHAR(10) NOT NULL,
  department_name VARCHAR(100) NOT NULL
);

CREATE TABLE enrollments_2nf (
  student_id INT NOT NULL,
  course_id VARCHAR(10) NOT NULL,
  grade DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students_2nf(student_id),
  FOREIGN KEY (course_id) REFERENCES courses_2nf(course_id)
);
```

**Evidence (screenshot filename, output, or file reference in this folder):**
The 2NF join in [lab11.sql](./lab11.sql) should reconstruct the same three enrollment
records, including the correct student, course, department, and grade values. Capture its
result. A student's name depends on the student portion of the composite key; a grade
describes that student's result in a specific course and therefore depends on both key
columns.

**Reflection question:**
If `student_id` alone determines `student_name`, the name does not require the full
composite key. A grade can differ for each student-course pair, so neither key component
alone identifies it; it depends on the whole key.

## Task 4 — Reach Third Normal Form

**Approach / explanation:**
The transitive dependency is `course_id -> dept_id -> department_name`: the course key
determines its department, and the department identifier determines the department name.
I moved department names to `departments_3nf` and kept `dept_id` as a foreign key in
`courses_3nf`. The final query joins students, enrollments, courses, and departments to
rebuild the complete report without storing department names redundantly on courses.

**Code / query used (if applicable):**
See the `departments_3nf` and `courses_3nf` definitions and final four-table join in
[lab11.sql](./lab11.sql).

**Evidence (screenshot filename, output, or file reference in this folder):**
Expected normalization decision path:

| Table | Multi-valued attribute? | Partial dependency? | Transitive dependency? | Verdict |
|---|---|---|---|---|
| `students_2nf` | No | No | No | 3NF |
| `courses_3nf` | No | No | No | 3NF |
| `departments_3nf` | No | No | No | 3NF |
| `enrollments_3nf` | No | No; `grade` depends on the full composite key | No | 3NF |

The final four-table join should return the same three student-course-grade rows as the
earlier reports, with department names included. Capture the output to show the split
preserved the relationships and facts.

**Reflection question:**
The department name is indirectly dependent on a course because `course_id` determines
`dept_id`, and `dept_id` determines `department_name`. The final join proves the information
was not lost by rebuilding each enrollment with its student, course, and department facts.

## Task 5 — Reflection

**Approach / explanation:**
This reflection contrasts a normalized operational enrollment design with carefully chosen
denormalization for reporting. Personalize the marked mistake sentence so it truthfully
describes a mistake you made or observed.

**Code / query used (if applicable):**
No additional SQL is required.

**Evidence (screenshot filename, output, or file reference in this folder):**
Reflection draft (replace the bracketed sentence with a true mistake, symptom, and fix;
keep the final reflection between 150 and 200 words):

A campus enrollment system should normally use 3NF for its operational records so a course
title or department name has one authoritative place to update. Tasks 1 and 4 show why:
changing the Computing Studies name in the original table would require editing several
enrollment rows, while separating departments means one department row can be corrected.
Normalization also lets the system record a new course before any student enrolls. For
large dashboards, however, a reporting table or materialized summary may deliberately
repeat names or precompute counts to make frequent reports faster. That repetition is safer
when it is generated from normalized source tables and refreshed consistently, rather than
being independently edited as operational data. **[Replace this with a mistake you actually
made or observed, its symptom, and how you fixed it.]** For example, if a split omitted
`course_id` from the enrollment key, a student taking multiple courses could no longer be
represented correctly. Keeping both `student_id` and `course_id` in the primary key, and
checking the reconstructed join against the original three enrollment records, protects
that relationship. I would normalize the source of truth and denormalize only for a clear,
measured reporting need.

**Reflection question:**
I would keep denormalized repetition in a report when performance or a fixed snapshot is
needed, while preserving normalized source tables. A symptom that a split dropped a key is
missing or incorrectly merged student-course rows when the report is joined back together.

## Self-Check

- [ ] Run [week11_seed.sql](./week11_seed.sql) once, then run [lab11.sql](./lab11.sql).
- [ ] Capture screenshots or exported output for Tasks 1–4.
- [ ] Replace the marked Task 5 example with a mistake you actually made or observed.
- [ ] Confirm your name, student ID, repository link, and submission date.
- [x] Place the SQL scripts and this `answers.md` inside `week11/`.
- [ ] Commit the completed deliverables and submit the repository link in Moodle.
