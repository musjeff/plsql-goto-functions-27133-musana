<h1 align="center">PL/SQL GOTO Statements and Functions</h1>

<p align="center">
  <b>Database Development with PL/SQL (INSY 8311)</b><br>
  Individual Assignment III &middot; Instructor: Eric Maniraguha
</p>

<p align="center">
  <img alt="Oracle" src="https://img.shields.io/badge/Database-Oracle-F80000">
  <img alt="PL/SQL" src="https://img.shields.io/badge/Language-PL%2FSQL-blue">
  <img alt="Tasks" src="https://img.shields.io/badge/Tasks-A1--A4%20%7C%20B1--B5%20%7C%20C1--C2-success">
</p>

| | |
|---|---|
| **Student** | Musana |
| **Student ID** | 27133 |
| **Group** | `C` |
| **Submitted** | October 2026 |

---

## Table of Contents
1. [Overview](#overview)
2. [Repository Structure](#repository-structure)
3. [Tasks at a Glance](#tasks-at-a-glance)
4. [How to Run](#how-to-run)
5. [Sample Data](#sample-data)
6. [Verified Results](#verified-results)
7. [Screenshots](#screenshots)
8. [Assumptions](#assumptions)
9. [Notes (AI Use)](#notes-ai-use)
10. [Reflection](#reflection)

---

## Overview
This project covers four areas of PL/SQL:

- **`GOTO` statements:** labels, legal and illegal jumps, and rewriting `GOTO` logic with structured control flow.
- **Stored functions:** parameters, `RETURN`, and exception handling (`NO_DATA_FOUND`, `RAISE_APPLICATION_ERROR`).
- **Functions in SQL:** calling the functions from `SELECT`, `WHERE` and `ORDER BY`.
- **Combined task:** a payroll validator that uses a function and `GOTO` together.

## Repository Structure
```
plsql-goto-functions-27133-musana/
├── README.md
├── .gitignore
├── 00_setup/
│   └── create_tables.sql
├── 01_goto/
│   ├── A1_number_classifier.sql
│   ├── A2_salary_review.sql
│   ├── A3_illegal_goto.sql
│   └── A4_rewrite_no_goto.sql
├── 02_functions/
│   ├── B1_fn_annual_salary.sql
│   ├── B2_fn_years_of_service.sql
│   ├── B3_fn_calculate_tax.sql
│   ├── B4_fn_dept_name.sql
│   └── C1_fn_validate_payroll.sql
├── 03_tests/
│   ├── B5_functions_in_select.sql
│   ├── test_functions.sql
│   └── test_validate_payroll.sql
├── screenshots/
└── docs/
    └── REFLECTION.md
```

## Tasks at a Glance

### Part A: GOTO
| Task | File | What it does |
|---|---|---|
| A1 | `A1_number_classifier.sql` | Classifies a number as negative, zero, positive even or positive odd using labels and `GOTO`. |
| A2 | `A2_salary_review.sql` | Loops over active employees; `GOTO next_emp` skips anyone who needs no review. Salaries below 300,000 get a proposed 10% raise. |
| A3 | `A3_illegal_goto.sql` | Demonstrates an illegal jump into an `IF` block (`PLS-00375`), then the fix. |
| A4 | `A4_rewrite_no_goto.sql` | Rewrites A1 and A2 with `IF / ELSIF / ELSE` only. |

### Part B: Functions
| Task | Function | Returns |
|---|---|---|
| B1 | `fn_annual_salary(emp_id)` | Monthly salary × 12, or `NULL` if the employee does not exist. |
| B2 | `fn_years_of_service(emp_id)` | Completed years since the hire date (0 for a future hire date). |
| B3 | `fn_calculate_tax(monthly_salary)` | Progressive monthly tax; raises error `-20002` for `NULL` or negative input. |
| B4 | `fn_dept_name(dept_id)` | Department name, or `'Unknown'`. |
| B5 | *(queries)* | The four functions used inside `SELECT`, `WHERE` and `ORDER BY`. |

### Part C: Combined
| Task | Deliverable | What it does |
|---|---|---|
| C1 | `fn_validate_payroll(emp_id)` | Returns `'VALID'` or the first problem found. Every check jumps with `GOTO` to a single `<<finish>>` exit. |
| C2 | `docs/REFLECTION.md` | Written reflection. |

## How to Run
Start SQL\*Plus **from the repository root** so the relative paths work:

```bash
cd plsql-goto-functions-27133-musana
sqlplus <user>/<password>@localhost:1521/XEPDB1
```

Then run the files at the `SQL>` prompt in this order:

```sql
-- 1. Setup
@00_setup/create_tables.sql

-- 2. Functions (B4 before C1, because C1 calls fn_dept_name)
@02_functions/B1_fn_annual_salary.sql
@02_functions/B2_fn_years_of_service.sql
@02_functions/B3_fn_calculate_tax.sql
@02_functions/B4_fn_dept_name.sql
@02_functions/C1_fn_validate_payroll.sql

-- 3. GOTO programs
@01_goto/A1_number_classifier.sql
@01_goto/A2_salary_review.sql
@01_goto/A3_illegal_goto.sql
@01_goto/A4_rewrite_no_goto.sql

-- 4. Tests
@03_tests/test_functions.sql
@03_tests/B5_functions_in_select.sql
@03_tests/test_validate_payroll.sql
```

> **Note:** A3 is *supposed* to raise `PLS-00375` in its first block. That is the demonstration. The second block shows the fix.

## Sample Data
`create_tables.sql` creates `departments` (3 rows) and `employees` (8 rows). Four employees are deliberate edge cases for testing the validator:

| Emp ID | Edge case |
|---|---|
| 105 | No department |
| 106 | Zero salary |
| 107 | Hire date in the future |
| 108 | `INACTIVE` status |

## Verified Results
Checked in Oracle after compiling all five functions (`user_errors` returned no rows):

| Call | Expected | Result |
|---|---|---|
| `fn_annual_salary(101)` | 10,200,000 | ✅ 10200000 |
| `fn_years_of_service(107)` (future hire) | 0 | ✅ 0 |
| `fn_calculate_tax(100000)` | 4,000 | ✅ 4000 |
| `fn_calculate_tax(300000)` | 54,000 | ✅ 54000 |
| `fn_dept_name(10)` / `fn_dept_name(99)` | Finance / Unknown | ✅ Finance / Unknown |
| `fn_validate_payroll(101)` | VALID | ✅ VALID |
| `fn_validate_payroll(999)` | not found | ✅ `INVALID: employee not found` |
| `fn_validate_payroll(108)` | inactive | ✅ `INVALID: employee is not ACTIVE` |
| `fn_validate_payroll(106)` | zero salary | ✅ `INVALID: salary must be greater than zero` |
| `fn_validate_payroll(105)` | no department | ✅ `INVALID: missing or unknown department` |
| `fn_validate_payroll(107)` | future hire | ✅ `INVALID: hire date is in the future` |

**Tax bracket check (monthly, RWF):** 100,000 → (100,000 − 60,000) × 10% = 4,000. 300,000 → 4,000 + (200,000 − 100,000) × 20% + (300,000 − 200,000) × 30% = 4,000 + 20,000 + 30,000 = 54,000.

## Screenshots
| Task | Output |
|---|---|
| **A1** Number classifier | ![A1](screenshots/A1_output.png) |
| **A2** Salary review | ![A2](screenshots/A2_output.png) |
| **A3** Illegal GOTO and fix | ![A3](screenshots/A3_error_and_fix.png) |
| **A4** Rewrite without GOTO | ![A4](screenshots/A4_output.png) |
| **B5** Functions in SELECT | ![B5](screenshots/B5_select_output.png) |
| **C1** Payroll validator | ![C1](screenshots/C1_output.png) |

## Assumptions
The assignment brief did not specify these details, so I chose them:

- **Database:** Oracle (XE). Salaries are monthly, in RWF.
- **A2 rule:** monthly salary below 300,000 is eligible for a proposed 10% raise (display only, no table update).
- **B3 brackets (monthly):** 0% up to 60,000 · 10% up to 100,000 · 20% up to 200,000 · 30% above 200,000.
- **C1 checks, in order:** employee exists → status is `ACTIVE` → salary > 0 → valid department → hire date not in the future.

## Notes (AI Use)
I used an AI assistant (Claude) to help draft the SQL code, the README and the reflection structure. I then ran the code in my own Oracle database, fixed the problems I found (for example a missing function and running SQL\*Plus from the wrong folder), compared outputs with the expected values above, and took the screenshots myself. I have reviewed the code and can explain how each program and function works.

## Reflection
My full reflection is in [`docs/REFLECTION.md`](docs/REFLECTION.md).
