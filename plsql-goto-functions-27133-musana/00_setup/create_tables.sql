-- Setup: tables and sample data (Oracle)
SET SERVEROUTPUT ON

BEGIN EXECUTE IMMEDIATE 'DROP TABLE employees PURGE';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE departments PURGE';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/

CREATE TABLE departments (
  dept_id   NUMBER PRIMARY KEY,
  dept_name VARCHAR2(50) NOT NULL
);

CREATE TABLE employees (
  emp_id         NUMBER PRIMARY KEY,
  first_name     VARCHAR2(50),
  last_name      VARCHAR2(50),
  dept_id        NUMBER REFERENCES departments(dept_id),
  monthly_salary NUMBER(12,2),
  hire_date      DATE,
  status         VARCHAR2(10) DEFAULT 'ACTIVE'
);

INSERT INTO departments VALUES (10, 'Finance');
INSERT INTO departments VALUES (20, 'IT');
INSERT INTO departments VALUES (30, 'Human Resources');

INSERT INTO employees VALUES (101,'Alice','Uwase',10,850000,DATE '2018-03-15','ACTIVE');
INSERT INTO employees VALUES (102,'Jean','Habimana',20,250000,DATE '2021-07-01','ACTIVE');
INSERT INTO employees VALUES (103,'Grace','Mukamana',30,120000,DATE '2023-01-10','ACTIVE');
INSERT INTO employees VALUES (104,'Eric','Nshimiyimana',10,1500000,DATE '2015-09-20','ACTIVE');
-- Edge cases used by the validator tests
INSERT INTO employees VALUES (105,'Diane','Ingabire',NULL,400000,DATE '2020-05-05','ACTIVE');
INSERT INTO employees VALUES (106,'Patrick','Mugisha',20,0,DATE '2022-02-02','ACTIVE');
INSERT INTO employees VALUES (107,'Clarisse','Uwera',30,300000,DATE '2027-01-01','ACTIVE');
INSERT INTO employees VALUES (108,'Samuel','Kalisa',20,180000,DATE '2019-11-11','INACTIVE');
COMMIT;

SELECT * FROM departments;
SELECT * FROM employees ORDER BY emp_id;
