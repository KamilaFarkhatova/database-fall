-- Lab 06: Tables, Data Types and Constraints
-- Student: Kamila Farkhatova

-- 1. Create a students table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100)
);

-- 2. Test DROP TABLE
CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

DROP TABLE test_table;

-- 3. Test DROP TABLE IF EXISTS
DROP TABLE IF EXISTS test_table;

-- 4. Add a column
ALTER TABLE students
ADD COLUMN date_of_birth DATE;

-- 5. Drop a column
ALTER TABLE students
DROP COLUMN faculty;

-- 6. Change a column's data type
ALTER TABLE students
ALTER COLUMN first_name TYPE TEXT;

-- 7. Add a constraint
ALTER TABLE students
ADD CONSTRAINT unique_student_email UNIQUE (email);

-- 8. Rename a column
ALTER TABLE students
RENAME COLUMN email TO email_address;

-- 9. Rename the table
ALTER TABLE students
RENAME TO university_students;

-- 10. Create a temporary table
CREATE TEMP TABLE temp_students (
    id SERIAL,
    name VARCHAR(50)
);

-- 11. Drop the main table
DROP TABLE university_students;

-- temp_students is automatically removed when the PostgreSQL session ends.