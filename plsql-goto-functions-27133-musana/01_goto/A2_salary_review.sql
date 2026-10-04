-- A2: Salary review using GOTO to skip employees
-- Rule: monthly salary < 300000 -> proposed 10% raise; otherwise GOTO next_emp.
SET SERVEROUTPUT ON
DECLARE
  v_new_salary NUMBER;
BEGIN
  FOR r IN (SELECT emp_id, first_name, monthly_salary
              FROM employees WHERE status = 'ACTIVE' ORDER BY emp_id) LOOP

    IF r.monthly_salary IS NULL OR r.monthly_salary >= 300000 THEN
      DBMS_OUTPUT.PUT_LINE(r.first_name || ': no review needed');
      GOTO next_emp;
    END IF;

    v_new_salary := r.monthly_salary * 1.10;
    DBMS_OUTPUT.PUT_LINE(r.first_name || ': ' || r.monthly_salary ||
                         ' -> ' || v_new_salary || ' (10% raise proposed)');

    <<next_emp>>
    NULL;   -- a label must be followed by an executable statement
  END LOOP;
END;
/
