# ToolShare Relational Schema Video Script

[Opening shot: title screen with “ToolShare Relational Schema”]

Narrator:
"Hello everyone! Today, I’ll explain the relational schema for the ToolShare system, a simple but effective database design for managing members, tools, certifications, and borrowing records."

"The first entity is Member. Each member has a unique member ID, their name, phone number, and the date their membership started. This table stores the basic identity and membership information for every user in the system."

"Next is Storage_Location. This table keeps track of where tools are stored, using a unique location code and a description of that storage area. This helps organize where each tool physically belongs in the system."

"The Tool table records every item in the inventory. Each tool has a unique tool ID, a name, a category, its purchase date, and a location code that references where it is stored. This location code is a foreign key, which means each tool belongs to exactly one storage location."

"We also have a Certification table. A certification is identified by a unique certification ID and a certification name. This allows the system to track skills, qualifications, or required training that members and tools may have."

"The Borrowing table is especially important because it handles the relationship between members and tools. Each borrowing record has its own borrowing ID, a member ID, a tool ID, the borrow date, and a return date. The return date can be empty, which means the item is still outstanding and has not yet been returned."

"This helps solve the many-to-many relationship between Member and Tool. One member can borrow many tools, and one tool can be borrowed by many members over time. The borrowing ID distinguishes separate loans, even when the same member borrows the same tool more than once."

"Now let’s look at the bridge tables. The Tool_Certification table resolves the many-to-many relationship between tools and certifications. It uses both tool ID and certification ID as a composite primary key. This means a tool can be linked to multiple certifications, and each certification can apply to multiple tools."

"Similarly, the Member_Certification table resolves the many-to-many relationship between members and certifications. It includes member ID, certification ID, and completion date. The combination of member ID and certification ID forms the primary key, while the completion date records when the member completed that certification."

"The design also follows a clear business rule: every tool must be assigned to exactly one storage location, while a location can hold many tools. This is represented by the foreign key from Tool to Storage_Location."

"Another important idea is that the system supports a cross-table business rule: a borrower must have completed every certification required by a tool before borrowing it. This rule is enforced through database triggers in the DDL, which means the system checks the required certifications automatically when a borrowing action is made."

"In summary, this database design is clean and normalized. It stores core data in individual tables, uses foreign keys to maintain relationships, and uses association tables to handle many-to-many connections. This makes the ToolShare system easy to manage, extend, and enforce with business rules."

[Closing shot: end screen with “ToolShare Database Design”]
