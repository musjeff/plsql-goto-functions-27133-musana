-- A3: Illegal GOTO and the fix
SET SERVEROUTPUT ON

-- PART 1: ILLEGAL. You cannot jump INTO an IF block.
-- Expected: PLS-00375: illegal GOTO statement; this GOTO cannot branch to label 'INSIDE_IF'
BEGIN
  GOTO inside_if;
  IF 1 = 1 THEN
    <<inside_if>>
    DBMS_OUTPUT.PUT_LINE('Inside the IF');
  END IF;
END;
/

-- PART 2: FIX. Put the label at the same level (outside the IF),
-- or jump OUT of a block rather than into it.
BEGIN
  GOTO after_if;
  IF 1 = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Inside the IF (skipped)');
  END IF;
  <<after_if>>
  DBMS_OUTPUT.PUT_LINE('Fixed: jumped to a label in the same block');
END;
/
