-- Lab 11: Basic Data Operations

-- 1. Create a table for student records.
CREATE TABLE Students_lab11 (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);

-- 2. Insert one student.
INSERT INTO Students_lab11 (first_name, last_name, birth_date)
VALUES ('Kamila', 'Farkhatova', '2006-12-04');

-- 3. Insert multiple students.
INSERT INTO Students_lab11 (first_name, last_name, birth_date)
VALUES
    ('Erbol', 'Mederbek', '2005-12-25'),
    ('Asylbek', 'Turdaliev', '2006-07-21'),
    ('Jibek', 'Karimova', '2006-05-05');

-- 4. Display all students.
SELECT * FROM Students_lab11;

-- 5. Update a student's birth date.
UPDATE Students_lab11
SET birth_date = '2006-12-25'
WHERE first_name = 'Erbol'
  AND last_name = 'Mederbek';

SELECT * FROM Students_lab11;

-- 6. Delete a student by name.
DELETE FROM Students_lab11
WHERE first_name = 'Jibek'
  AND last_name = 'Karimova';

-- 7. Delete students born before 2006.
DELETE FROM Students_lab11
WHERE birth_date < '2006-01-01';

-- 8. Bulk update using IN.
UPDATE Students_lab11
SET last_name = 'Durachkov'
WHERE last_name IN ('Mederbek', 'Turdaliev');

SELECT * FROM Students_lab11;

-- 9. Bulk delete using IN.
DELETE FROM Students_lab11
WHERE student_id IN (2, 3, 4);

SELECT * FROM Students_lab11;

-- 10. Create a separate table for CSV import.
CREATE TABLE students_copy_lab11 (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);

-- 11. Import CSV data.
-- Ran this command in psql from the project directory.
-- \copy students_copy_lab11 (first_name, last_name, birth_date) FROM 'lab_works/lab-11-basic-data-operations/students.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- 12. Verify imported data.
SELECT * FROM students_copy_lab11 ORDER BY student_id;

-- 13. Clean up the temporary CSV-import table after verification.
DROP TABLE students_copy_lab11;