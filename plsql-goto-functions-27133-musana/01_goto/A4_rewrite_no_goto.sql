-- A4: A1 and A2 rewritten WITHOUT GOTO
SET SERVEROUTPUT ON

-- A1 without GOTO
DECLARE
  v_num NUMBER := 15;
BEGIN
  IF v_num < 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_num || ' is NEGATIVE');
  ELSIF v_num = 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_num || ' is ZERO');
  ELSIF MOD(v_num, 2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_num || ' is a POSITIVE EVEN number');
  ELSE
    DBMS_OUTPUT.PUT_LINE(v_num || ' is a POSITIVE ODD number');
  END IF;
  DBMS_OUTPUT.PUT_LINE('Classification finished.');
END;
/

-- A2 without GOTO (IF / ELSE replaces the skip)
BEGIN
  FOR r IN (SELECT emp_id, first_name, monthly_salary
              FROM employees WHERE status = 'ACTIVE' ORDER BY emp_id) LOOP
    IF r.monthly_salary IS NULL OR r.monthly_salary >= 300000 THEN
      DBMS_OUTPUT.PUT_LINE(r.first_name || ': no review needed');
    ELSE
      DBMS_OUTPUT.PUT_LINE(r.first_name || ': ' || r.monthly_salary ||
                           ' -> ' || r.monthly_salary * 1.10 || ' (10% raise proposed)');
    END IF;
  END LOOP;
END;
/
