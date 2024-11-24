-- Task1 created the database
create database techmac_db;
use techmac_db;

-- Task2 creating the tables
create table techhyve_employees(
employeeid varchar(10) primary key,
firstname varchar(50) not null,
lastname varchar(50) not null,
gender char(10) not null,
age int not null
);
desc techhyve_employees;

create table techcloud_employees(
employeeid varchar(10) primary key,
firstname varchar(50) not null,
lastname varchar(50) not null,
gender char(10) not null,
age int not null
);
desc techcloud_employees;

create table techsoft_employees(
employeeid varchar(10) primary key,
firstname varchar(50) not null,
lastname varchar(50) not null,
gender char(10) not null,
age int not null
);
desc techsoft_employees;

-- Task3 inserting the data here
insert into techmac_db.techhyve_employees values
('TH0001', 'Eli', 'Evans', 'Male', 26),
('TH0002', 'Carlos', 'Simmons', 'Male', 32),
('TH0003', 'Kathie', 'Bryant', 'Female', 25),
('TH0004', 'Joey', 'Hughes', 'Male', 41),
('TH0005', 'Alice', 'Matthews', 'Female', 52);

insert into techmac_db.techcloud_employees values
('TC0001', 'Teresa', 'Bryant', 'Female', 39),
('TC0002', 'Alexis', 'Patterson', 'Male', 48),
('TC0003', 'Rose', 'Bell', 'Female', 42),
('TC0004', 'Gemma', 'Watkins', 'Female', 44),
('TC0005', 'Kingston', 'Martinez', 'Male', 29);

insert into techmac_db.techsoft_employees values 
('TS0001', 'Peter', 'Burtler', 'Male', 44),
('TS0002', 'Harold', 'Simmons', 'Male', 54),
('TS0003', 'Juliana', 'Sanders', 'Female', 36),
('TS0004', 'Paul', 'Ward', 'Male', 29),
('TS0005', 'Nicole', 'Bryant', 'Female', 30);

-- Task4 creating backup database
create database backup_techmac_db;
use backup_techmac_db;
-- inserting the database into backup database
create table techhyve_employees_bkp as select * FROM techmac_db.techhyve_employees;
create table techcloud_employees_bkp as select * FROM techmac_db.techcloud_employees;
create table techsoft_employees_bkp as select * FROM techmac_db.techsoft_employees;
-- Task5 Deleting the values
use techmac_db;
delete from techmac_db.techhyve_employees WHERE employeeid IN ('TH0003', 'TH0005');
delete from techmac_db.techcloud_employees WHERE employeeid IN ('TC0001', 'TC0004');

