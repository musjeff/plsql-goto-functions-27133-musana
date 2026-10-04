-- Tests for B1-B4 (expected values in the labels)
SET SERVEROUTPUT ON
BEGIN
  DBMS_OUTPUT.PUT_LINE('B1 emp 101 annual (expect 10200000): ' || fn_annual_salary(101));
  DBMS_OUTPUT.PUT_LINE('B1 emp 999 (expect NULL): ' || NVL(TO_CHAR(fn_annual_salary(999)),'NULL'));
  DBMS_OUTPUT.PUT_LINE('B2 emp 101 years: ' || fn_years_of_service(101));
  DBMS_OUTPUT.PUT_LINE('B2 emp 107 future hire (expect 0): ' || fn_years_of_service(107));
  DBMS_OUTPUT.PUT_LINE('B3 tax 50000  (expect 0): '     || fn_calculate_tax(50000));
  DBMS_OUTPUT.PUT_LINE('B3 tax 100000 (expect 4000): '  || fn_calculate_tax(100000));
  DBMS_OUTPUT.PUT_LINE('B3 tax 200000 (expect 24000): ' || fn_calculate_tax(200000));
  DBMS_OUTPUT.PUT_LINE('B3 tax 300000 (expect 54000): ' || fn_calculate_tax(300000));
  DBMS_OUTPUT.PUT_LINE('B4 dept 10 (expect Finance): '  || fn_dept_name(10));
  DBMS_OUTPUT.PUT_LINE('B4 dept 99 (expect Unknown): '  || fn_dept_name(99));
  BEGIN
    DBMS_OUTPUT.PUT_LINE(fn_calculate_tax(-5));
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('B3 negative salary raised: ' || SQLERRM);
  END;
END;
/
