# ToolShare Relational Schema

`<u>... </u>` marks a primary-key attribute; `FK` marks a foreign key.

- `Member(<u>member_id</u>, name, phone_number, membership_start_date)`
- `Storage_Location(<u>location_code</u>, description)`
- `Tool(<u>tool_id</u>, name, category, purchase_date, location_code [FK])`
- `Certification(<u>certification_id</u>, certification_name)`
- `Borrowing(<u>borrowing_id</u>, member_id [FK], tool_id [FK], borrow_date, return_date)`
- `Tool_Certification(<u>tool_id</u> [PK, FK], <u>certification_id</u> [PK, FK])`
- `Member_Certification(<u>member_id</u> [PK, FK], <u>certification_id</u> [PK, FK], completion_date)`

## Relationship and key notes

- `Borrowing` resolves the Member–Tool M:N relationship. `borrowing_id` distinguishes repeated loans of the same tool by the same member; `return_date` is nullable to represent an open loan.
- `Tool_Certification` resolves the Tool–Certification M:N relationship. Its two foreign keys together form its primary key.
- `Member_Certification` resolves the Member–Certification M:N relationship. Its two foreign keys together form its primary key; `completion_date` belongs to this relationship.
- Every tool has exactly one storage location. `Tool.location_code` is therefore a NOT NULL foreign key to `Storage_Location.location_code`; a location may have zero or many tools.
- No weak entity or composite, multivalued, or derived attribute is specified in the scenario.
- The requirement that a borrower has completed every certification required by a tool is a cross-table business rule; the DDL implements it with borrowing triggers.
