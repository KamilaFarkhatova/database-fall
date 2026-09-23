-- Lab 03: Basic psql Commands

-- Connection command used:
-- psql -h localhost -p 5432 -U postgres -d postgres

-- List all databases
\l

-- Connect to database
\c postgres

-- List all tables
\dt

-- List all relations
\d

-- Create students table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

-- List tables after creating students
\dt

-- List all relations after creating students
\d

-- Describe students table
\d students

-- Insert data
INSERT INTO students (name, age)
VALUES ('Alice', 21), ('Bob', 23);

-- Select data
SELECT * FROM students;

-- Show SQL command help
\h

-- Show psql meta-command help
\?

-- Drop table
DROP TABLE students;

-- Check tables after dropping students
\dt
