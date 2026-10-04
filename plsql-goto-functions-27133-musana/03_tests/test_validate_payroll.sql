-- Tests for C1
SET SERVEROUTPUT ON
BEGIN
  DBMS_OUTPUT.PUT_LINE('101 (expect VALID)     : ' || fn_validate_payroll(101));
  DBMS_OUTPUT.PUT_LINE('999 (not found)        : ' || fn_validate_payroll(999));
  DBMS_OUTPUT.PUT_LINE('108 (inactive)         : ' || fn_validate_payroll(108));
  DBMS_OUTPUT.PUT_LINE('106 (zero salary)      : ' || fn_validate_payroll(106));
  DBMS_OUTPUT.PUT_LINE('105 (no department)    : ' || fn_validate_payroll(105));
  DBMS_OUTPUT.PUT_LINE('107 (future hire date) : ' || fn_validate_payroll(107));
END;
/
SELECT emp_id, first_name, fn_validate_payroll(emp_id) AS result
  FROM employees ORDER BY emp_id;
