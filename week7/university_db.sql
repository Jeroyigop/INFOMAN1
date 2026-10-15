-- ============================================================
-- university_db.sql — INFOMAN1 Week 7 Lab Database
-- Course: INFOMAN1 | Lab 7: Functions, Aliases & Filtering
--
-- Import via MySQL terminal:
--   mysql -u root -p < university_db.sql
-- ============================================================

DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE university_db;

-- Table: students (used in Task 1)
CREATE TABLE students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name  VARCHAR(50) NOT NULL,
  major      VARCHAR(100) NOT NULL,
  section    VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

INSERT INTO students (first_name, last_name, major, section) VALUES
  ('Sofia',    'Santos',    'Computer Science',       'Face-to-Face'),
  ('Samuel',   'Santiago',  'Information Technology', 'Hybrid'),
  ('Sarah',    'Sy',        'Computer Science',       'Face-to-Face'),
  ('Miguel',   'Santos',    'Information Technology', 'Online'),
  ('Anna',     'Smith',     'Computer Science',       'Online'),
  ('Jose',     'Rizal',     'Computer Science',       'Face-to-Face'),
  ('Maria',    'Silva',     'Business Administration','Face-to-Face'),
  ('Daniel',   'Serrano',   'Information Technology', 'Face-to-Face'),
  ('Kevin',    'Garcia',    'Information Technology', 'Hybrid'),
  ('Liza',     'Soberano',  'Computer Science',       'Hybrid');

-- Table: instructors (used in Task 2)
CREATE TABLE instructors (
  instructor_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name    VARCHAR(50) NOT NULL,
  last_name     VARCHAR(50) NOT NULL,
  salary        DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

INSERT INTO instructors (first_name, last_name, salary) VALUES
  ('John',    'Smith',    55000.75),
  ('Maria',   'Santos',   62500.40),
  ('Robert',  'Johnson',  48999.60),
  ('Angela',  'Reyes',    71250.25),
  ('Paolo',   'Cruz',     47000.90),
  ('Karen',   'Villanueva', 59875.15);

-- Table: assignments (used in Task 3)
CREATE TABLE assignments (
  assignment_id   INT AUTO_INCREMENT PRIMARY KEY,
  assignment_name VARCHAR(100) NOT NULL,
  assigned_date   DATE NOT NULL,
  due_date        DATE NOT NULL
) ENGINE=InnoDB;

INSERT INTO assignments (assignment_name, assigned_date, due_date) VALUES
  ('ERD Design Project',   '2026-08-01', '2026-08-10'),
  ('SQL Basics Worksheet', '2026-08-05', '2026-08-25'),
  ('Normalization Case',   '2026-09-01', '2026-09-22'),
  ('Midterm Lab Report',   '2026-09-10', '2026-10-05'),
  ('Quiz Review Task',     '2026-09-15', '2026-09-20'),
  ('Capstone Proposal',    '2026-09-01', '2026-10-15');

-- Table: courses (used in Task 4)
CREATE TABLE courses (
  course_code        VARCHAR(20) PRIMARY KEY,
  course_name        VARCHAR(100) NOT NULL,
  credits            INT NOT NULL,
  course_description TEXT NULL
) ENGINE=InnoDB;

INSERT INTO courses (course_code, course_name, credits, course_description) VALUES
  ('CS-ADV101',  'Advanced Database Systems',  5, NULL),
  ('IT-ADV210',  'Advanced Networking',        3, NULL),
  ('CS-ADV305',  'Advanced Algorithms',        4, 'In-depth study of algorithm design.'),
  ('CS-101',     'Introduction to Computing',  3, NULL),
  ('IT-ADV150',  'Advanced Web Development',   6, 'Full-stack development with frameworks.'),
  ('MATH-101',   'College Algebra',            3, 'Foundations of algebra.'),
  ('CS-ADV400',  'Advanced Capstone Project',  6, NULL),
  ('ENG-ADV110', 'Advanced Technical Writing', 2, NULL);
