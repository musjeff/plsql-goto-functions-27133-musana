-- B2: Completed years of service (NULL if employee not found)
CREATE OR REPLACE FUNCTION fn_years_of_service(p_emp_id IN NUMBER)
RETURN NUMBER
IS
  v_hire employees.hire_date%TYPE;
BEGIN
  SELECT hire_date INTO v_hire
    FROM employees WHERE emp_id = p_emp_id;
  IF v_hire > SYSDATE THEN
    RETURN 0;   -- not started yet
  END IF;
  RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_hire) / 12);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END fn_years_of_service;
/
SHOW ERRORS
