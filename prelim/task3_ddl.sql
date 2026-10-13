CREATE DATABASE IF NOT EXISTS toolshare_prelim
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE toolshare_prelim;

CREATE TABLE Member (
  member_id INT UNSIGNED NOT NULL,
  name VARCHAR(100) NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  membership_start_date DATE NOT NULL,
  PRIMARY KEY (member_id)
) ENGINE=InnoDB;

CREATE TABLE Storage_Location (
  location_code VARCHAR(20) NOT NULL,
  description VARCHAR(255) NOT NULL,
  PRIMARY KEY (location_code)
) ENGINE=InnoDB;

CREATE TABLE Certification (
  certification_id INT UNSIGNED NOT NULL,
  certification_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (certification_id),
  UNIQUE KEY uq_certification_name (certification_name)
) ENGINE=InnoDB;

CREATE TABLE Tool (
  tool_id INT UNSIGNED NOT NULL,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  purchase_date DATE NOT NULL,
  location_code VARCHAR(20) NOT NULL,
  PRIMARY KEY (tool_id),
  CONSTRAINT fk_tool_storage_location
    FOREIGN KEY (location_code)
    REFERENCES Storage_Location (location_code)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Borrowing (
  borrowing_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  member_id INT UNSIGNED NOT NULL,
  tool_id INT UNSIGNED NOT NULL,
  borrow_date DATE NOT NULL,
  return_date DATE NULL,
  PRIMARY KEY (borrowing_id),
  KEY ix_borrowing_member_date (member_id, borrow_date),
  KEY ix_borrowing_tool_return (tool_id, return_date),
  CONSTRAINT chk_return_not_before_borrow
    CHECK (return_date IS NULL OR return_date >= borrow_date),
  CONSTRAINT fk_borrowing_member
    FOREIGN KEY (member_id)
    REFERENCES Member (member_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_borrowing_tool
    FOREIGN KEY (tool_id)
    REFERENCES Tool (tool_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Tool_Certification (
  tool_id INT UNSIGNED NOT NULL,
  certification_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (tool_id, certification_id),
  CONSTRAINT fk_tool_certification_tool
    FOREIGN KEY (tool_id)
    REFERENCES Tool (tool_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_tool_certification_certification
    FOREIGN KEY (certification_id)
    REFERENCES Certification (certification_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Member_Certification (
  member_id INT UNSIGNED NOT NULL,
  certification_id INT UNSIGNED NOT NULL,
  completion_date DATE NOT NULL,
  PRIMARY KEY (member_id, certification_id),
  CONSTRAINT fk_member_certification_member
    FOREIGN KEY (member_id)
    REFERENCES Member (member_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_member_certification_certification
    FOREIGN KEY (certification_id)
    REFERENCES Certification (certification_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

DELIMITER //

CREATE TRIGGER trg_borrowing_certifications_before_insert
BEFORE INSERT ON Borrowing
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM Tool_Certification AS tc
    LEFT JOIN Member_Certification AS mc
      ON mc.member_id = NEW.member_id
      AND mc.certification_id = tc.certification_id
      AND mc.completion_date <= NEW.borrow_date
    WHERE tc.tool_id = NEW.tool_id
      AND mc.member_id IS NULL
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Member lacks a required certification completed by the borrow date';
  END IF;
END//

CREATE TRIGGER trg_borrowing_certifications_before_update
BEFORE UPDATE ON Borrowing
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM Tool_Certification AS tc
    LEFT JOIN Member_Certification AS mc
      ON mc.member_id = NEW.member_id
      AND mc.certification_id = tc.certification_id
      AND mc.completion_date <= NEW.borrow_date
    WHERE tc.tool_id = NEW.tool_id
      AND mc.member_id IS NULL
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Member lacks a required certification completed by the borrow date';
  END IF;
END//

DELIMITER ;

-- Data type choices:
-- phone_number is VARCHAR(20), not a number: it may contain +, spaces, punctuation,
-- and leading zeroes, and is never used for arithmetic.
-- membership_start_date, purchase_date, borrow_date, return_date, and completion_date
-- are DATE because the specification records calendar dates, not times.
-- location_code is VARCHAR(20) because codes such as "Shelf A3" are identifiers,
-- not quantities, and may contain letters and spaces.
