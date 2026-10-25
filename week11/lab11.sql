USE infoman1_normalization;

-- Task 1a: D01 and its department name are repeated across three enrollment rows.
SELECT dept_id, department_name, COUNT(*) AS rows_to_update
FROM student_enrollment
WHERE dept_id = 'D01'
GROUP BY dept_id, department_name;

SELECT student_id, course_id, department_name
FROM student_enrollment
WHERE dept_id = 'D01'
ORDER BY student_id, course_id;

-- Task 1b: Read-only illustration of a course-only fact the wide table cannot
-- represent without inventing an enrollment or storing NULL student fields.
SELECT
  NULL AS student_id,
  NULL AS student_name,
  NULL AS enrolled_courses,
  'IT103' AS course_id,
  'Intro to Networks' AS course_title,
  'D01' AS dept_id,
  'Computing Studies' AS department_name,
  NULL AS grade;

-- In the supplied schema, these columns are nullable, so a real INSERT with
-- NULL student/enrollment data would be accepted, but it would be a malformed
-- enrollment row. This lab intentionally leaves student_enrollment unchanged.

-- Task 1c: Ana's IT102 row is the only row carrying these course facts.
SELECT student_id, student_name, course_id, course_title, dept_id, department_name
FROM student_enrollment
WHERE student_id = 101
  AND course_id = 'IT102';

-- Task 2: Build a 1NF relation with one atomic student-course row and a
-- dependable composite primary key. The source remains unchanged.
DROP TABLE IF EXISTS enrollments_3nf;
DROP TABLE IF EXISTS courses_3nf;
DROP TABLE IF EXISTS departments_3nf;
DROP TABLE IF EXISTS enrollments_2nf;
DROP TABLE IF EXISTS courses_2nf;
DROP TABLE IF EXISTS students_2nf;
DROP TABLE IF EXISTS enrollment_1nf;

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

INSERT INTO enrollment_1nf
  (student_id, student_name, course_id, course_title, dept_id, department_name, grade)
SELECT DISTINCT
  student_id, student_name, course_id, course_title, dept_id, department_name, grade
FROM student_enrollment;

SELECT
  student_id, student_name, course_id, course_title, dept_id, department_name, grade
FROM enrollment_1nf
ORDER BY student_id, course_id;

-- Task 3: Observed dependencies in enrollment_1nf:
-- student_id -> student_name
-- course_id -> course_title, dept_id, department_name
-- dept_id -> department_name
-- (student_id, course_id) -> grade
-- Decompose partial dependencies. The transitive department dependency remains
-- in courses_2nf until Task 4.
CREATE TABLE students_2nf (
  student_id INT PRIMARY KEY,
  student_name VARCHAR(100) NOT NULL
);

INSERT INTO students_2nf (student_id, student_name)
SELECT DISTINCT student_id, student_name
FROM enrollment_1nf;

CREATE TABLE courses_2nf (
  course_id VARCHAR(10) PRIMARY KEY,
  course_title VARCHAR(100) NOT NULL,
  dept_id VARCHAR(10) NOT NULL,
  department_name VARCHAR(100) NOT NULL
);

INSERT INTO courses_2nf (course_id, course_title, dept_id, department_name)
SELECT DISTINCT course_id, course_title, dept_id, department_name
FROM enrollment_1nf;

CREATE TABLE enrollments_2nf (
  student_id INT NOT NULL,
  course_id VARCHAR(10) NOT NULL,
  grade DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students_2nf(student_id),
  FOREIGN KEY (course_id) REFERENCES courses_2nf(course_id)
);

INSERT INTO enrollments_2nf (student_id, course_id, grade)
SELECT student_id, course_id, grade
FROM enrollment_1nf;

SELECT
  s.student_id, s.student_name, c.course_id, c.course_title,
  c.dept_id, c.department_name, e.grade
FROM enrollments_2nf AS e
INNER JOIN students_2nf AS s
  ON e.student_id = s.student_id
INNER JOIN courses_2nf AS c
  ON e.course_id = c.course_id
ORDER BY s.student_id, c.course_id;

-- Task 4: Remove the transitive dependency course_id -> dept_id -> department_name.
CREATE TABLE departments_3nf (
  dept_id VARCHAR(10) PRIMARY KEY,
  department_name VARCHAR(100) NOT NULL
);

INSERT INTO departments_3nf (dept_id, department_name)
SELECT DISTINCT dept_id, department_name
FROM courses_2nf;

CREATE TABLE courses_3nf (
  course_id VARCHAR(10) PRIMARY KEY,
  course_title VARCHAR(100) NOT NULL,
  dept_id VARCHAR(10) NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES departments_3nf(dept_id)
);

INSERT INTO courses_3nf (course_id, course_title, dept_id)
SELECT course_id, course_title, dept_id
FROM courses_2nf;

CREATE TABLE enrollments_3nf (
  student_id INT NOT NULL,
  course_id VARCHAR(10) NOT NULL,
  grade DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students_2nf(student_id),
  FOREIGN KEY (course_id) REFERENCES courses_3nf(course_id)
);

INSERT INTO enrollments_3nf (student_id, course_id, grade)
SELECT student_id, course_id, grade
FROM enrollments_2nf;

-- Final 3NF report reconstructed from the four normalized tables.
SELECT
  s.student_id,
  s.student_name,
  c.course_id,
  c.course_title,
  d.dept_id,
  d.department_name,
  e.grade
FROM enrollments_3nf AS e
INNER JOIN students_2nf AS s
  ON e.student_id = s.student_id
INNER JOIN courses_3nf AS c
  ON e.course_id = c.course_id
INNER JOIN departments_3nf AS d
  ON c.dept_id = d.dept_id
ORDER BY s.student_id, c.course_id;
