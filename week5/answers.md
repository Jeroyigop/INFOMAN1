# INFOMAN1 — Week 5 Lab Answers

## Task 1 — Basic SELECT

### Query 1
```sql
SELECT * FROM pet;

## Task 2 — Equality

## Task 3 — Relational Operators

### Debugging Results

**Missing Quotes:**
- Query: `WHERE species = Dog;`
- Result: ERROR 1054 — Unknown column 'Dog'.

**Type Mismatch:**
- Query: `WHERE age = 'three';`
- Result: Empty set with 1 warning.
- Explanation: The age column contains numbers, not the word 'three'.

## Task 5 — Reflection

SELECT statements are useful for viewing and retrieving data from a database without changing the stored information. They allow users to display records, filter results, and find specific information using conditions. SELECT is generally safer than DDL and DML because it does not directly modify the database structure or data.

DDL commands, such as CREATE, ALTER, and DROP, change the database structure. DML commands, such as INSERT, UPDATE, and DELETE, change the data stored in tables. Because of this, users must be careful when using DDL and DML commands.

During the activity, I encountered an error when I used Dog without quotation marks. MySQL treated Dog as a column name instead of a text value, which caused an unknown column error. I also tested a type mismatch by comparing the age column with the word 'three'. The query returned an empty result with a warning because the age column contains numerical values. These results taught me to use quotation marks for text values and to check the data type of a column before creating conditions. Proper syntax and understanding data types help prevent errors and unintended results.