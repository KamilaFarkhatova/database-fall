-- Lab 04: First SQL Query

-- ==========================================
-- Setup: create sample students table
-- ==========================================

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150),
    faculty VARCHAR(100)
);

-- Insert sample data

INSERT INTO students (name, email, faculty)
VALUES
    ('Alymbek', 'alymbek@example.com', 'COMSEH'),
    ('Timur', 'timur@example.com', 'MED'),
    ('Beka', 'beka@example.com', 'MAT');


-- ==========================================
-- 1. SELECT all columns
-- ==========================================

SELECT * FROM students;


-- ==========================================
-- 2. SELECT specific columns
-- ==========================================

SELECT name, email
FROM students;


-- ==========================================
-- 3. SELECT student_id and faculty
-- ==========================================

SELECT student_id, faculty
FROM students;


-- ==========================================
-- 4. WHERE
-- ==========================================

SELECT name, email
FROM students
WHERE name = 'Timur';


-- ==========================================
-- 5. ORDER BY ASC
-- ==========================================

SELECT name, email
FROM students
ORDER BY name;


-- ==========================================
-- 6. ORDER BY DESC
-- ==========================================

SELECT name, email
FROM students
ORDER BY name DESC;


-- ==========================================
-- 7. LIMIT
-- ==========================================

SELECT name, email
FROM students
LIMIT 2;


-- ==========================================
-- 8. Single-line comment
-- ==========================================

-- This query retrieves all students.

SELECT name, faculty
FROM students;


-- ==========================================
-- 9. Multi-line comment
-- ==========================================

/*
This is a multi-line comment.
It can span multiple lines.
*/

SELECT name, email
FROM students;


-- ==========================================
-- Cleanup
-- ==========================================

DROP TABLE students;
