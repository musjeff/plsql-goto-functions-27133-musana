-- A1: Number classifier using GOTO
SET SERVEROUTPUT ON
DECLARE
  v_num NUMBER := 15;   -- change to test: -4, 0, 8, 15
BEGIN
  IF v_num < 0 THEN
    GOTO negative_num;
  ELSIF v_num = 0 THEN
    GOTO zero_num;
  ELSIF MOD(v_num, 2) = 0 THEN
    GOTO even_num;
  ELSE
    GOTO odd_num;
  END IF;

  <<negative_num>>
  DBMS_OUTPUT.PUT_LINE(v_num || ' is NEGATIVE');
  GOTO done;

  <<zero_num>>
  DBMS_OUTPUT.PUT_LINE(v_num || ' is ZERO');
  GOTO done;

  <<even_num>>
  DBMS_OUTPUT.PUT_LINE(v_num || ' is a POSITIVE EVEN number');
  GOTO done;

  <<odd_num>>
  DBMS_OUTPUT.PUT_LINE(v_num || ' is a POSITIVE ODD number');

  <<done>>
  DBMS_OUTPUT.PUT_LINE('Classification finished.');
END;
/
