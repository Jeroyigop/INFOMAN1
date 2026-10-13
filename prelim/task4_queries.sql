USE toolshare_prelim;

-- 1. Names and categories of Power Tools.
SELECT name, category
FROM Tool
WHERE category = 'Power Tools';

-- 2. Members who joined after January 1, 2025.
SELECT member_id, name, membership_start_date
FROM Member
WHERE membership_start_date > '2025-01-01';

-- 3. Borrowing records still on loan.
SELECT borrowing_id, member_id, tool_id, borrow_date, return_date
FROM Borrowing
WHERE return_date IS NULL;

-- 4. Borrowing records for Maria Santos (member ID 1001 in the supplemental fixture).
-- Use the member ID selected for your own data if the instructor's fixture differs.
SELECT borrowing_id, member_id, tool_id, borrow_date, return_date
FROM Borrowing
WHERE member_id = 1001;

-- 5. Tools purchased before January 1, 2024.
SELECT tool_id, name, category, purchase_date
FROM Tool
WHERE purchase_date < '2024-01-01';

-- Expected result preview for the supplemental fixture only (execute the SELECTs
-- above against the instructor's data and capture its actual output for submission):
-- 1: 2001 Cordless Drill | Power Tools; 2002 Chainsaw | Power Tools;
--    2003 MIG Welder | Power Tools; 2004 Circular Saw | Power Tools
-- 2: 1002 Jordan Lee | 2025-02-03; 1003 Avery Patel | 2025-05-20;
--    1005 Taylor Kim | 2026-01-15
-- 3: 5002 member 1002 tool 2007 | 2025-03-10 | NULL;
--    5004 member 1001 tool 2002 | 2025-02-10 | NULL;
--    5006 member 1005 tool 2004 | 2026-02-10 | NULL
-- 4: 5001 member 1001 tool 2001 | 2025-02-01 | 2025-02-04;
--    5004 member 1001 tool 2002 | 2025-02-10 | NULL
-- 5: 2001 Cordless Drill | 2023-05-10; 2003 MIG Welder | 2022-09-01;
--    2004 Circular Saw | 2023-11-22; 2005 Garden Spade | 2021-04-10;
--    2007 Step Ladder | 2023-08-07
