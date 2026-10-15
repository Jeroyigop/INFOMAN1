USE infoman1_week8;

-- Task 4.1a: inspect actual department averages before choosing a threshold.
SELECT department,
       AVG(salary) AS average_salary
FROM employee
GROUP BY department
ORDER BY average_salary;

-- Task 4.1b: set this after inspecting Task 4.1a, then run the query.
SET @salary_threshold = NULL;

SELECT department,
       AVG(salary) AS average_salary
FROM employee
GROUP BY department
HAVING AVG(salary) > @salary_threshold
ORDER BY average_salary DESC;

-- Task 4.2: filter active employees before grouping, then filter group counts.
SELECT department,
       COUNT(*) AS active_headcount
FROM employee
WHERE status = 'Active'
GROUP BY department
HAVING COUNT(*) > 50
ORDER BY department;
