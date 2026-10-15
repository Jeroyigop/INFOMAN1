USE infoman1_week8;

-- Task 2.1: COUNT(column) ignores NULL commission values.
SELECT COUNT(*) AS total_employees,
       COUNT(commission) AS employees_with_commission
FROM employee;

-- Task 2.2 and 2.3: whole-table aggregates; intentionally no GROUP BY.
SELECT SUM(salary) AS total_monthly_payroll,
       AVG(salary) AS average_salary,
       MIN(hire_date) AS earliest_hire_date,
       MAX(hire_date) AS latest_hire_date
FROM employee;

-- Task 2.4: COALESCE treats a missing commission as zero.
SELECT SUM(salary + COALESCE(commission, 0)) AS total_compensation
FROM employee;
