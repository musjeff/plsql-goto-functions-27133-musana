# Reflection (C2)

**Student:** Musana &nbsp;|&nbsp; **ID:** 27133 &nbsp;|&nbsp; **Course:** INSY 8311, Database Development with PL/SQL

---

## 1. What I learned about GOTO

**How it works.** A `GOTO` transfers control to a label written as `<<label_name>>`. A label must be followed by an executable statement. In A2 I put the label at the end of the loop body and followed it with `NULL;` so the loop could skip the rest of an iteration.

**What is legal and what is not.**

| Jump | Allowed? |
|---|---|
| To a label in the same block | Yes |
| Out of an `IF`, loop or nested block | Yes |
| **Into** an `IF`, `CASE`, loop or nested block | **No** (`PLS-00375`) |

In A3 my first block jumped into an `IF` and failed with `PLS-00375`. The fix was to move the label out of the `IF` so it sits at the same level as the `GOTO`.

**GOTO versus structured code.** A1 and A2 work with `GOTO`, but the A4 rewrites with `IF / ELSIF / ELSE` are shorter and read from top to bottom. With `GOTO` I have to scan the program for labels to understand the flow, which gets harder as the code grows. The one place `GOTO` felt reasonable was C1, where five checks all need to leave through one exit (`<<finish>>`). Even there, early `RETURN` statements would also work.

## 2. What I learned about functions

- **Every path must return.** A function that reaches its end without a `RETURN` fails at runtime. I handled `NO_DATA_FOUND` in B1, B2 and B4 so a missing row gives `NULL` or `'Unknown'` instead of an unhandled error.
- **Fail loudly on bad input.** In B3, a negative or `NULL` salary raises `RAISE_APPLICATION_ERROR(-20002, ...)`. Returning 0 would have hidden bad data.
- **Progressive tax.** Each bracket must tax only its own slice of the salary. For 300,000: 4,000 + 20,000 + 30,000 = 54,000. Applying one flat rate to the whole salary would give the wrong answer.
- **Functions in SQL (B5).** Functions that do not change data can be called in `SELECT`, `WHERE` and `ORDER BY`. This keeps a business rule in one place instead of repeating it in every query.
- **Performance.** A function that queries a table runs once per row, so on a large table it can be slow. A join would often be faster.
- **`SYSDATE`.** `fn_years_of_service` depends on the current date, so the same input gives a different answer over time. That is why it cannot be declared `DETERMINISTIC`.

## 3. Challenges I faced

- **Running files from the wrong folder.** SQL\*Plus kept returning `SP2-0310: unable to open file` because I had started it outside the repository. Relative paths like `@02_functions/...` only work when SQL\*Plus is started from the repository root. Now I check the current folder first.
- **A function that was never created.** When I verified my work, `FN_YEARS_OF_SERVICE` was missing from the list of compiled functions, so B5 and the tests would have failed on it. Checking `user_objects` and `user_errors` caught this. The lesson: don't assume a script ran, verify that the objects exist and are `VALID`.
- **Understanding A3.** At first the idea of "illegal" `GOTO` was abstract. Triggering the real `PLS-00375` error and then fixing it made the scope rules clear.
- **Ordering dependencies.** C1 calls `fn_dept_name`, so B4 has to be compiled before C1.

## 4. How I tested my work

- **Normal and edge cases:** an unknown employee, a future hire date, and tax at the bracket boundaries.
- **Validator cases:** one valid employee and five invalid ones (not found, inactive, zero salary, no department, future hire date).
- **Integration:** B5 confirms the functions work inside SQL queries.
- **Compile check:** `user_objects` showed all functions `VALID` and `user_errors` was empty.

## 5. What I would improve

- Store tax brackets and the raise threshold in tables instead of hard-coding them, so rules can change without editing code.
- Have the validator return a code plus a message, so callers can react without parsing text.
- Replace the per-row function lookups in reports with joins for large data sets.
- Add logging for unexpected errors instead of handling only the known ones.

## 6. Use of AI

I used an AI assistant (Claude) to help draft the code and documentation. I ran everything in my own Oracle database, debugged the problems above, and studied the code so I can explain it and prepare for the quiz.
