-- C1: Payroll validator combining GOTO and a function.
-- Returns 'VALID' or a message describing the first problem found.
-- Run AFTER B4 (it calls fn_dept_name).
CREATE OR REPLACE FUNCTION fn_validate_payroll(p_emp_id IN NUMBER)
RETURN VARCHAR2
IS
  v_emp employees%ROWTYPE;
  v_msg VARCHAR2(200);
BEGIN
  BEGIN
    SELECT * INTO v_emp FROM employees WHERE emp_id = p_emp_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_msg := 'INVALID: employee not found';
      GOTO finish;   -- jumping OUT of a nested block is legal
  END;

  IF v_emp.status <> 'ACTIVE' THEN
    v_msg := 'INVALID: employee is not ACTIVE';
    GOTO finish;
  END IF;

  IF v_emp.monthly_salary IS NULL OR v_emp.monthly_salary <= 0 THEN
    v_msg := 'INVALID: salary must be greater than zero';
    GOTO finish;
  END IF;

  IF v_emp.dept_id IS NULL OR fn_dept_name(v_emp.dept_id) = 'Unknown' THEN
    v_msg := 'INVALID: missing or unknown department';
    GOTO finish;
  END IF;

  IF v_emp.hire_date > SYSDATE THEN
    v_msg := 'INVALID: hire date is in the future';
    GOTO finish;
  END IF;

  v_msg := 'VALID';

  <<finish>>
  RETURN v_msg;
END fn_validate_payroll;
/
SHOW ERRORS
