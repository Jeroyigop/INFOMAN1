# Lab 4: Performance Task Using SQL 1 (DDL & Table Creation)
**Course:** Information Management 1 (INFOMAN1)  
**Database Name:** `infoman1_vetclinic`

## Task 1 — Create Database

Database: infoman1_vetclinic

## Task 2 — Create Core Tables

Created:
- owner
- pet
- veterinarian

## Task 3 — Create Relationship Tables

Created:
- appointment
- vaccination_record

## Task 4 — Verify Schema

All five tables were checked using SHOW TABLES and DESCRIBE.

## Task 5 — Fix a Mistake

The phone_number column was initially INT.

DESCRIBE owner showed the incorrect INT data type.

I used ALTER TABLE to change it to VARCHAR(20).

The corrected data type is VARCHAR(20), which is suitable for phone numbers.

## Self-Check

- [ ] Database created
- [ ] Five tables created
- [ ] Tables verified
- [ ] Mistake corrected
- [ ] Changes committed and pushed