USE infoman1_week8;

-- Task 3.1: department summary.
SELECT department,
       COUNT(*) AS headcount,
       AVG(salary) AS average_salary,
       COUNT(DISTINCT job_title) AS distinct_job_titles
FROM employee
GROUP BY department
ORDER BY department;

-- Task 3.2: headcount by department and job title.
SELECT department,
       job_title,
       COUNT(*) AS headcount
FROM employee
GROUP BY department, job_title
ORDER BY department, job_title;
