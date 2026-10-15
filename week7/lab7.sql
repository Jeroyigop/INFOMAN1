USE university_db;

-- Task 1: students in either major, with a last name starting with S,
-- excluding students in the Online section.
SELECT first_name, last_name, major
FROM students
WHERE major IN ('Computer Science', 'Information Technology')
  AND last_name LIKE 'S%'
  AND NOT (section = 'Online');

-- Task 2: format instructor name and rounded salary.
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

-- Task 3: find assignments taking more than 14 days, longest first.
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

-- Task 4: missing descriptions, or 4-6 credit courses with ADV in the code.
SELECT course_code, course_name, credits
FROM courses
WHERE (course_description IS NULL OR credits BETWEEN 4 AND 6)
  AND course_code LIKE '%ADV%'
ORDER BY course_name ASC;
