# Week 3 Lab Answers

## Task 1 — Classify Attributes and Identify Weak Entities

- Full name: Composite
- Vaccination history: Multivalued
- Age: Stored attribute
- Vaccination Record: Weak entity because it depends on Pet.

## Task 2 — Specify Participation Constraints

1. Owner–Pet: 0:N
2. Pet–Appointment: 0:N
3. Veterinarian–Appointment: 0:N
4. Pet–Vaccination: 0:N

## Task 3 — Build the Logical ERD

Entities:
- Owner
- Pet
- Veterinarian
- Appointment
- Vaccination Record

## Task 4 — Translate to Relational Schema Notation

Owner(<u>owner_id</u>, first_name, last_name, phone_number)

Pet(<u>pet_id</u>, pet_name, species, age, owner_id*)

Veterinarian(<u>vet_id</u>, first_name, last_name, specialization)

Appointment(<u>appointment_id</u>, appointment_date, reason_for_visit, pet_id*, vet_id*)

Vaccination_Record(<u>pet_id</u>, <u>vaccine_name</u>, <u>vaccination_date</u>)

* = Foreign key

## Task 5 — Key Justification & Schema Validation

I used IDs because they are unique and simple.

The schema includes all owners, pets, veterinarians, appointments, and vaccination records.

## Self-Check

- [ ] All tasks committed with individual, meaningful commit messages
- [ ] All files placed inside `week3/`
- [ ] This file completed `answers.md`
- [ ] Repository link pasted into Moodle (no files uploaded)