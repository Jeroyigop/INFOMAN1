USE infoman1_week8;

-- Task 1.1: last names ending in "ez".
SELECT emp_id, first_name, last_name
FROM employee
WHERE last_name LIKE '%ez';

-- Task 1.2: first names starting with "Ma".
SELECT emp_id, first_name, department
FROM employee
WHERE first_name LIKE 'Ma%';

-- Task 1.3a: "_" matches exactly one character; this should count all 500 codes.
SELECT COUNT(*) AS matching_five_character_codes
FROM employee
WHERE emp_code LIKE 'E____';

-- Task 1.3b: zero in the third character.
SELECT emp_code, first_name, last_name
FROM employee
WHERE emp_code LIKE 'E_0__';

SELECT COUNT(*) AS matching_codes_with_zero_third_character
FROM employee
WHERE emp_code LIKE 'E_0__';
