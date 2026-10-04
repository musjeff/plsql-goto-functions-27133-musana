-- B1: Annual salary = monthly salary * 12 (NULL if employee not found)
CREATE OR REPLACE FUNCTION fn_annual_salary(p_emp_id IN NUMBER)
RETURN NUMBER
IS
  v_monthly employees.monthly_salary%TYPE;
BEGIN
  SELECT monthly_salary INTO v_monthly
    FROM employees WHERE emp_id = p_emp_id;
  RETURN v_monthly * 12;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END fn_annual_salary;
/
SHOW ERRORS
