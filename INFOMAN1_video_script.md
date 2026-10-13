# INFOMAN1 Video Script: Week 1 to Week 5 and Prelim

*Approximate duration: 5 minutes at a clear, steady speaking pace.*

[Opening slide: “INFOMAN1 — Weeks 1–5 and Prelim”]

**Narrator:**

“Hello everyone! In this video, I’ll share what I learned in Information Management 1, from Week 1 to Week 5, and explain how these lessons came together in our prelim project. We moved from understanding databases to designing them, creating tables, and retrieving information with SQL.”

[Week 1 — Database Basics]

“In Week 1, we learned why databases are useful compared with keeping information in separate files. A database organizes related information so it can be searched, updated, and managed more consistently. We also discussed the role of a database administrator, or DBA. A DBA helps protect the database, manages user access, and safeguards sensitive information. This showed me that database management is about both organizing information and keeping it secure.”

[ Week 2 — Conceptual ERD]

“In Week 2, we practiced conceptual database design using an Entity Relationship Diagram, or ERD. We identified the main entities in a car repair shop example: Customer, Car, Mechanic, and Service Appointment. We listed the information, or attributes, each entity needs and described how the entities relate.

For example, one customer can own many cars, and a car can have multiple service appointments over time. A mechanic can also handle multiple appointments. We used cardinality to describe these connections. Creating an ERD before building the database helps us understand the real-world situation and plan what information the system needs.”

[Week 3 — Logical Design and Schema]

“In Week 3, we developed our understanding of logical ERDs and relational schemas. We learned to represent entities as tables, attributes as columns, and records as rows. We also studied primary keys, which uniquely identify records, and foreign keys, which connect related tables.

We discussed attribute types, participation constraints, and weak entities. For example, a vaccination record depends on the pet it describes. We also learned how to translate relationships into a relational schema. This step turns the ERD into a more specific plan for how data will be arranged in tables.”

[Week 4 — Creating Tables with SQL]

“In Week 4, we used SQL to create and modify database structures. These commands are part of Data Definition Language, or DDL. In our veterinary clinic activity, we created tables for owners, pets, veterinarians, appointments, and vaccination records. We used primary and foreign keys to connect the data and checked the results with commands such as SHOW TABLES and DESCRIBE.

We also corrected a data-type mistake: a phone number should be stored as VARCHAR, not as an integer. Phone numbers are identifiers, may include symbols or leading zeroes, and are not used for arithmetic. This taught me that choosing suitable data types is an important part of designing a reliable database.”

[Week 5 — Retrieving Data]

“In Week 5, we focused on retrieving data with SELECT statements and filtering results with WHERE conditions. SELECT lets us view information without changing the stored records. We practiced checking values and learned that text values need quotation marks. Without quotes, MySQL may interpret a word like Dog as a column name. We also saw why a condition should match the data type of the column. These exercises helped us understand SQL syntax and how small mistakes can affect query results.”

[ Prelim — ToolShare Database]

“For the prelim, we applied these ideas to a ToolShare system. It manages members, tools, certifications, storage locations, and borrowing records. We first designed the entities and their relationships, then represented the design in a relational schema.

The main tables include Member, Tool, Certification, Storage_Location, and Borrowing. Each tool is assigned to one storage location through a foreign key. Borrowing connects a member with a tool and records the borrow date and return date. A blank return date can represent a loan that is still open.

We used two bridge tables for many-to-many relationships. Tool_Certification connects tools with the certifications they require. Member_Certification records certifications completed by members, including the completion date. The paired keys in these bridge tables identify each relationship and help avoid unnecessary duplication.”

[Prelim — Rules and Queries]

“The ToolShare database also includes a business rule: before borrowing a tool, a member must have completed every certification required for that tool. The DDL uses triggers to check this rule when a borrowing is recorded. This demonstrates how database constraints and logic can help maintain valid information.

We also practiced querying the database. One important lesson was that the Borrowing table stores member_id, not member_name. The member’s name is stored in the Member table, and the foreign key connects the records. So a query that asks for a member name directly from Borrowing fails because that column is not there. This reinforces why tables are connected through keys rather than by repeatedly copying the same details.”

[ “From Database Concepts to SQL”]

“To summarize, Week 1 introduced database organization and security. Week 2 taught us to model entities and relationships. Week 3 helped us translate that model into a relational schema. Week 4 showed us how to create tables with SQL, and Week 5 taught us to retrieve and filter data. The ToolShare prelim brought these skills together through ERDs, tables, keys, business rules, and queries.

Overall, I learned that a good database starts with understanding the problem, then designing clear relationships, choosing suitable data types, and checking that the rules and queries work correctly. Thank you for watching!”
