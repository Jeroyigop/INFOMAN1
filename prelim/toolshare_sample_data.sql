-- Supplemental demonstration fixture, authored for these deliverables because the
-- instructor-provided toolshare_sample_data.sql was not present in the repository.
-- Replace this fixture with the instructor's script before final submission if supplied.
USE toolshare_prelim;

INSERT INTO Storage_Location (location_code, description) VALUES
  ('Shelf A3', 'Main room, upper shelf A3'),
  ('Pegboard B1', 'Main room, pegboard B1'),
  ('Cabinet C2', 'Locked cabinet C2');

INSERT INTO Member (member_id, name, phone_number, membership_start_date) VALUES
  (1001, 'Maria Santos', '+1 555-0101', '2024-04-12'),
  (1002, 'Jordan Lee', '555-0102', '2025-02-03'),
  (1003, 'Avery Patel', '555-0103', '2025-05-20'),
  (1004, 'Sam Rivera', '555-0104', '2024-11-08'),
  (1005, 'Taylor Kim', '555-0105', '2026-01-15');

INSERT INTO Certification (certification_id, certification_name) VALUES
  (3001, 'Chainsaw Safety'),
  (3002, 'Welding Basics'),
  (3003, 'Power Tool Safety'),
  (3004, 'Ladder Safety');

INSERT INTO Tool (tool_id, name, category, purchase_date, location_code) VALUES
  (2001, 'Cordless Drill', 'Power Tools', '2023-05-10', 'Pegboard B1'),
  (2002, 'Chainsaw', 'Power Tools', '2024-03-15', 'Cabinet C2'),
  (2003, 'MIG Welder', 'Power Tools', '2022-09-01', 'Cabinet C2'),
  (2004, 'Circular Saw', 'Power Tools', '2023-11-22', 'Pegboard B1'),
  (2005, 'Garden Spade', 'Garden', '2021-04-10', 'Shelf A3'),
  (2006, 'Hedge Trimmer', 'Garden', '2025-02-17', 'Cabinet C2'),
  (2007, 'Step Ladder', 'Ladders', '2023-08-07', 'Shelf A3'),
  (2008, 'Socket Set', 'Hand Tools', '2024-06-12', 'Shelf A3');

INSERT INTO Tool_Certification (tool_id, certification_id) VALUES
  (2001, 3003),
  (2002, 3001),
  (2003, 3002),
  (2004, 3003),
  (2007, 3004);

INSERT INTO Member_Certification (member_id, certification_id, completion_date) VALUES
  (1001, 3001, '2025-01-10'),
  (1001, 3003, '2025-01-12'),
  (1002, 3003, '2025-03-01'),
  (1002, 3004, '2025-03-05'),
  (1003, 3002, '2025-06-10'),
  (1004, 3001, '2024-12-15'),
  (1005, 3003, '2026-02-01');

INSERT INTO Borrowing (borrowing_id, member_id, tool_id, borrow_date, return_date) VALUES
  (5001, 1001, 2001, '2025-02-01', '2025-02-04'),
  (5002, 1002, 2007, '2025-03-10', NULL),
  (5003, 1003, 2003, '2025-06-15', '2025-06-17'),
  (5004, 1001, 2002, '2025-02-10', NULL),
  (5005, 1004, 2005, '2025-01-05', '2025-01-08'),
  (5006, 1005, 2004, '2026-02-10', NULL);
