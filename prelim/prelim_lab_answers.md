# INFOMAN1 Prelim Lab Exam — ToolShare

## Task 1 — Conceptual ERD

See [task1_conceptual_erd.drawio](./task1_conceptual_erd.drawio) and its PNG export.

The core entities are Member, Tool, Certification, and Storage Location. Their identifying attributes are `member_id`, `tool_id`, `certification_id`, and `location_code`. A member may borrow zero or many tools, and a tool may be borrowed by zero or many members over its lifetime. `borrow_date` and `return_date` describe each borrowing event. A member may complete zero or many certifications, and a certification may be completed by zero or many members; `completion_date` belongs to that relationship. A tool may require zero or many certifications, and a certification may apply to zero or many tools. Each tool is stored at exactly one location; each location may hold zero or many tools. No composite, multivalued, or derived attributes are identified by the specification.

## Task 2 — Logical ERD and relational schema

See [task2_logical_erd.drawio](./task2_logical_erd.drawio), its PNG export, and [task2_relational_schema.md](./task2_relational_schema.md).

The three M:N relationships are resolved by `Borrowing`, `Tool_Certification`, and `Member_Certification`. The former stores loan event dates; the latter stores the completion date. There are no weak entities in the specification. The tool's required storage assignment is a non-null FK to `Storage_Location`.

## Task 3 — MySQL DDL

The database and tables are defined in [task3_ddl.sql](./task3_ddl.sql). Primary/foreign keys and total participation in storage assignment are enforced. Borrowing triggers reject a loan if the member has not completed every certification required for the tool by the borrowing date.

Data type choices: phone numbers use `VARCHAR(20)` because they are identifiers that can contain `+`, punctuation, spaces, and leading zeroes, not quantities. Calendar-only events use `DATE` rather than a timestamp because the scenario specifies dates without times. Location codes use `VARCHAR(20)` because labels such as `Shelf A3` are alphanumeric.

Live MySQL verification could not be completed in this environment: the Windows service listens on port 3307, but unauthenticated access as `root` was denied. The current [task3_describe_output.txt](./task3_describe_output.txt) records that limitation and the commands to capture actual output. Do not submit it as successful verification until those commands have been run successfully.

## Task 4 — DQL queries

The five `SELECT`/`WHERE` queries are in [task4_queries.sql](./task4_queries.sql). The instructor-provided sample script was not present in this repository. For demonstrability, [toolshare_sample_data.sql](./toolshare_sample_data.sql) is a clearly marked supplemental fixture meeting the stated minimum row counts; it can be run after the DDL. Query result previews in the query file correspond only to that fixture and are not represented as captured MySQL output. Replace the fixture/result previews with the instructor data and actual query output before submission if that script is supplied.

## Task 5 — Cross-week mismatch

The original query fails because `Borrowing` has `member_id`, not `member_name`. Relational design stores a member's name once in `Member`, and the loan table refers to that member by a foreign key. The DDL consequently creates no `member_name` column in `Borrowing`, so MySQL reports an unknown-column error; adding the name to every loan would duplicate member data and risk inconsistencies.

Run these as two separate, single-table queries:

```sql
SELECT member_id
FROM Member
WHERE name = 'Maria Santos';
```

The supplemental fixture returns `1001`. Use the ID returned by the first query in the second query:

```sql
SELECT borrow_date, return_date
FROM Borrowing
WHERE member_id = 1001;
```

If using the instructor's fixture, substitute the actual `member_id` returned by the first query. This demonstrates the Week 3 separation of entities and use of keys/foreign keys, Week 4 implementation of those choices as table columns and constraints, and Week 5's need for `WHERE` to filter on a column that actually exists in the queried table. Finding a person's loans across both tables would ordinarily use a join, but the requested two-step answer uses only single-table queries.

## Task 6 — Walkthrough

Record and upload the walkthrough as an unlisted YouTube video. Include the conceptual and logical diagrams, schema, live `SHOW TABLES`/`DESCRIBE`, all five queries with actual non-empty results, and the Task 5 failure explanation and corrected queries. No video was recorded or uploaded as part of preparing these repository files.

**Unlisted video URL:** _Add after recording and uploading._
