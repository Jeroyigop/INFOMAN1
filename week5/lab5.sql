USE infoman1_vetclinic;

-- Task 1
SELECT * FROM pet;
SELECT pet_name, species FROM pet;

-- Task 2
SELECT * FROM pet
WHERE species = 'Dog';

-- Task 3
SELECT * FROM pet
WHERE age > 2;

SELECT * FROM appointment
WHERE appointment_date > '2026-01-01';

-- Task 4
SELECT pet_name, species, age
FROM pet
WHERE species = 'Dog' AND age > 3;

SELECT * FROM pet
WHERE species = 'dog';

SELECT * FROM pet
WHERE species = Dog;

SELECT * FROM pet
WHERE age = 'three';