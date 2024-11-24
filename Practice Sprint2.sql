use techmac_db;
desc techhyve_employees;
-- Task1.1 Not null values are already set 
-- Task1.2 Set deafult value of age as 21 
-- For techhyve_employees
ALTER TABLE techhyve_employees
ALTER COLUMN age SET DEFAULT 21;

-- For techcloud_employees
ALTER TABLE techcloud_employees
ALTER COLUMN age SET DEFAULT 21;

-- For techsoft_employees
ALTER TABLE techsoft_employees
ALTER COLUMN age SET DEFAULT 21;

-- Task1.3 For techhyve_employees
ALTER TABLE techhyve_employees
ADD CONSTRAINT chk_age_techhyve CHECK (age BETWEEN 21 AND 55);

-- For techcloud_employees
ALTER TABLE techcloud_employees
ADD CONSTRAINT chk_age_techcloud CHECK (age BETWEEN 21 AND 55);

-- For techsoft_employees
ALTER TABLE techsoft_employees
ADD CONSTRAINT chk_age_techsoft CHECK (age BETWEEN 21 AND 55);

-- For techhyve_employees
-- Task1.4 Add two columns named Username and password.
ALTER TABLE techhyve_employees
ADD COLUMN Username VARCHAR(50) NOT NULL,
ADD COLUMN Password VARCHAR(50) NOT NULL;

-- For techcloud_employees
ALTER TABLE techcloud_employees
ADD COLUMN Username VARCHAR(50) NOT NULL,
ADD COLUMN Password VARCHAR(50) NOT NULL;

-- For techsoft_employees
ALTER TABLE techsoft_employees
ADD COLUMN Username VARCHAR(50) NOT NULL,
ADD COLUMN Password VARCHAR(50) NOT NULL;

-- Task1.5
-- For techhyve_employees
ALTER TABLE techhyve_employees
ADD CONSTRAINT chk_gender_techhyve CHECK (gender IN ('Male', 'Female'));

-- For techcloud_employees
ALTER TABLE techcloud_employees
ADD CONSTRAINT chk_gender_techcloud CHECK (gender IN ('Male', 'Female'));

-- For techsoft_employees
ALTER TABLE techsoft_employees
ADD CONSTRAINT chk_gender_techsoft CHECK (gender IN ('Male', 'Female'));

-- Task2
-- For techhyve_employees
ALTER TABLE techhyve_employees
ADD COLUMN Communication_Proficiency INT DEFAULT 1,
ADD CONSTRAINT chk_comm_prof_techhyve CHECK (Communication_Proficiency BETWEEN 1 AND 5);

-- For techcloud_employees
ALTER TABLE techcloud_employees
ADD COLUMN Communication_Proficiency INT DEFAULT 1,
ADD CONSTRAINT chk_comm_prof_techcloud CHECK (Communication_Proficiency BETWEEN 1 AND 5);

-- For techsoft_employees
ALTER TABLE techsoft_employees
ADD COLUMN Communication_Proficiency INT DEFAULT 1,
ADD CONSTRAINT chk_comm_prof_techsoft CHECK (Communication_Proficiency BETWEEN 1 AND 5);

-- Task5
CREATE TABLE techhyvecloud_employees AS
SELECT * FROM techhyve_employees
UNION ALL
SELECT * FROM techcloud_employees;


-- Alter techhyve_employees_bkp table in backup database
ALTER TABLE backup_techmac_db.techhyve_employees_bkp
ADD COLUMN username VARCHAR(50),
ADD COLUMN password VARCHAR(50);

-- Alter techcloud_employees_bkp table in backup database
ALTER TABLE backup_techmac_db.techcloud_employees_bkp
ADD COLUMN username VARCHAR(50),
ADD COLUMN password VARCHAR(50);

ALTER TABLE backup_techmac_db.techhyve_employees_bkp
ADD COLUMN Communication_Proficiency VARCHAR(50);
ALTER TABLE backup_techmac_db.techcloud_employees_bkp
ADD COLUMN Communication_Proficiency VARCHAR(50);


INSERT INTO backup_techmac_db.techhyve_employees_bkp 
SELECT * FROM techmac_db.techhyve_employees AS new_values
ON DUPLICATE KEY UPDATE 
employeeid = new_values.employeeid, 
firstname = new_values.firstname, 
lastname = new_values.lastname, 
gender = new_values.gender, 
age = new_values.age, 
username = new_values.username, 
password = new_values.password, 
Communication_Proficiency = new_values.Communication_Proficiency;

INSERT INTO backup_techmac_db.techcloud_employees_bkp 
SELECT * FROM techmac_db.techcloud_employees AS new_values
ON DUPLICATE KEY UPDATE 
employeeid = new_values.employeeid, 
firstname = new_values.firstname, 
lastname = new_values.lastname, 
gender = new_values.gender, 
age = new_values.age, 
username = new_values.username, 
password = new_values.password, 
Communication_Proficiency = new_values.Communication_Proficiency;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM techmac_db.techhyve_employees;
DELETE FROM techmac_db.techcloud_employees;
SET SQL_SAFE_UPDATES = 1;


CREATE TABLE techhyvecloud_employeees AS
SELECT * FROM backup_techmac_db.techhyve_employees_bkp
UNION ALL
SELECT * FROM backup_techmac_db.techcloud_employees_bkp;

desc techhyvecloud_employeees


