-- Lab 08: Foreign Keys and Relationships

-- =========================================================
-- 1. Creating foreign keys: inline constraint
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id)
);

-- Structure checks:
-- \d departments
-- \d employees

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 2. Creating foreign keys: table-level constraint
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Structure checks:
-- \d departments
-- \d employees

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 3. Adding a foreign key to an existing table
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER
);

ALTER TABLE employees
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Structure checks:
-- \d departments
-- \d employees

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 4. Named constraint during table creation
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Structure check:
-- \d employees

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 5. Referential integrity: invalid FK and restricted delete
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id)
);

INSERT INTO departments (dept_name, location) VALUES
    ('Engineering', 'Building A'),
    ('Marketing', 'Building B'),
    ('HR', 'Building C');

INSERT INTO employees (first_name, last_name, dept_id)
VALUES ('John', 'Smith', 1);

-- Intentional error: department 99 does not exist.
-- foreign-key constraint violation.
INSERT INTO employees (first_name, last_name, dept_id)
VALUES ('Jane', 'Doe', 99);

-- Intentional error: department 1 is still referenced by John.
-- deletion blocked by the foreign key.
DELETE FROM departments WHERE dept_id = 1;

SELECT * FROM departments;
SELECT * FROM employees;

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 6. ON DELETE CASCADE
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id) ON DELETE CASCADE
);

INSERT INTO departments (dept_name) VALUES
    ('Engineering'),
    ('Marketing');

INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 1),
    ('Jane', 'Doe', 1),
    ('Mike', 'Brown', 2);

SELECT * FROM departments;
SELECT * FROM employees;

DELETE FROM departments WHERE dept_id = 1;

SELECT * FROM departments;
SELECT * FROM employees;

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 7. ON DELETE SET NULL
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id) ON DELETE SET NULL
);

INSERT INTO departments (dept_name) VALUES
    ('Engineering'),
    ('Marketing');

INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 1),
    ('Jane', 'Doe', 1),
    ('Mike', 'Brown', 2);

DELETE FROM departments WHERE dept_id = 1;

SELECT * FROM departments;
SELECT * FROM employees;

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 8. ON DELETE SET DEFAULT
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER DEFAULT 1
        REFERENCES departments(dept_id) ON DELETE SET DEFAULT
);

INSERT INTO departments (dept_name) VALUES
    ('Unassigned'),
    ('Engineering'),
    ('Marketing');

INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 2),
    ('Jane', 'Doe', 2),
    ('Mike', 'Brown', 3);

DELETE FROM departments WHERE dept_id = 2;

SELECT * FROM departments;
SELECT * FROM employees;

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 9. ON DELETE RESTRICT
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id)ON DELETE RESTRICT
);

INSERT INTO departments (dept_name) VALUES ('Engineering');

INSERT INTO employees (first_name, last_name, dept_id)
VALUES ('John', 'Smith', 1);

-- Intentional error: referenced department cannot be deleted.
DELETE FROM departments WHERE dept_id = 1;

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 10. ON UPDATE CASCADE
-- =========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id) ON UPDATE CASCADE
);

INSERT INTO departments (dept_name) VALUES ('Engineering');

INSERT INTO employees (first_name, last_name, dept_id)
VALUES ('John', 'Smith', 1);

SELECT * FROM departments;
SELECT * FROM employees;

UPDATE departments
SET dept_id = 10
WHERE dept_id = 1;

SELECT * FROM departments;
SELECT * FROM employees;

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 11. Combined ON UPDATE CASCADE and ON DELETE CASCADE
-- =========================================================
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO departments (dept_id, dept_name) VALUES
    (1, 'Engineering'),
    (2, 'Marketing');

INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 1),
    ('Jane', 'Doe', 1),
    ('Mike', 'Brown', 2);

SELECT * FROM departments;
SELECT * FROM employees;

UPDATE departments
SET dept_id = 10
WHERE dept_id = 1;

SELECT * FROM departments;
SELECT * FROM employees;

DELETE FROM departments
WHERE dept_id = 10;

SELECT * FROM departments;
SELECT * FROM employees;

DROP TABLE employees;
DROP TABLE departments;

-- =========================================================
-- 12. One-to-one relationship: users and user profiles
-- =========================================================
CREATE TABLE users_lab8 (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profiles_lab8 (
    profile_id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    bio TEXT,
    proflie_picture_url VARCHAR(255),
    FOREIGN KEY (user_id)
        REFERENCES users_lab8(user_id)
        ON DELETE CASCADE
);

-- Structure checks:
-- \d users_lab8
-- \d user_profiles_lab8

INSERT INTO users_lab8 (username, email)
VALUES ('johndoe', 'john@example.com');

INSERT INTO user_profiles_lab8
    (user_id, first_name, last_name, bio)
VALUES
    (1, 'John', 'Doe',
     'Software developer passionate about databases');

SELECT * FROM users_lab8;
SELECT * FROM user_profiles_lab8;

-- Intentional error: UNIQUE user_id allows only one profile per user.
INSERT INTO user_profiles_lab8 (user_id, first_name, last_name)
VALUES (1, 'Jane', 'Smith');

DROP TABLE user_profiles_lab8;
DROP TABLE users_lab8;

-- =========================================================
-- 13. One-to-many relationship: departments and employees
-- =========================================================
CREATE TABLE departments_lab8 (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    manager_name VARCHAR(100),
    budget DECIMAL(10,2)
);

CREATE TABLE employees_lab8 (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(100),
    salary DECIMAL(10,2),
    hire_date DATE DEFAULT CURRENT_DATE,
    dept_id INTEGER NOT NULL,
    FOREIGN KEY (dept_id)
        REFERENCES departments_lab8(dept_id)
        ON DELETE RESTRICT
);

INSERT INTO departments_lab8 (dept_name, manager_name, budget) VALUES
    ('Engineering', 'Alice Johnson', 500000.00),
    ('Marketing', 'Bob Wilson', 200000.00);

INSERT INTO employees_lab8
    (first_name, last_name, position, salary, dept_id)
VALUES
    ('John', 'Smith', 'Software Engineer', 75000.00, 1),
    ('Jane', 'Doe', 'Senior Developer', 85000.00, 1),
    ('Mike', 'Brown', 'DevOps Engineer', 80000.00, 1),
    ('Sarah', 'Davis', 'Marketing Specialist', 55000.00, 2);

SELECT d.dept_name, e.first_name, e.last_name, e.position
FROM departments_lab8 AS d
JOIN employees_lab8 AS e ON d.dept_id = e.dept_id
ORDER BY d.dept_name, e.last_name;

DROP TABLE employees_lab8;
DROP TABLE departments_lab8;

-- =========================================================
-- 14. Many-to-many relationship: students, courses, enrollments
-- =========================================================
CREATE TABLE students_lab8 (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    enrollment_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INTEGER NOT NULL,
    instructor VARCHAR(100)
);

CREATE TABLE student_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    grade CHAR(2),
    FOREIGN KEY (student_id)
        REFERENCES students_lab8(student_id)
        ON DELETE CASCADE,
    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE,
    UNIQUE (student_id, course_id)
);

INSERT INTO students_lab8 (first_name, last_name, email) VALUES
    ('Anna', 'Ivanova', 'anna@example.com'),
    ('Peter', 'Smith', 'peter@example.com'),
    ('Maria', 'Brown', 'maria@example.com');

INSERT INTO courses (course_code, course_name, credits, instructor) VALUES
    ('DB101', 'Database Systems', 3, 'Alice Johnson'),
    ('PY101', 'Python Programming', 4, 'Bob Wilson'),
    ('NW101', 'Computer Networks', 4, 'Carol Davis');

INSERT INTO student_enrollments (student_id, course_id, grade) VALUES
    (1, 1, 'A'),
    (1, 2, 'B+'),
    (2, 1, 'A-'),
    (2, 3, 'B'),
    (3, 2, 'A'),
    (3, 3, 'A-');

-- All students and their courses:
SELECT
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_name,
    se.grade,
    se.enrollment_date
FROM students_lab8 AS s
JOIN student_enrollments AS se ON s.student_id = se.student_id
JOIN courses AS c ON se.course_id = c.course_id
ORDER BY s.last_name, c.course_code;

-- Students enrolled in DB101:
SELECT s.first_name, s.last_name, se.grade
FROM students_lab8 AS s
JOIN student_enrollments AS se ON s.student_id = se.student_id
JOIN courses AS c ON se.course_id = c.course_id
WHERE c.course_code = 'DB101';

-- Courses taken by Maria:
SELECT c.course_code, c.course_name, c.credits, se.grade
FROM courses AS c
JOIN student_enrollments AS se ON c.course_id = se.course_id
JOIN students_lab8 AS s ON se.student_id = s.student_id
WHERE s.email = 'maria@example.com';

-- Intentional error: Anna is already enrolled in course DB101.
INSERT INTO student_enrollments (student_id, course_id, grade)
VALUES (1, 1, 'A');

-- Final data checks:
SELECT * FROM students_lab8;
SELECT * FROM courses;
SELECT * FROM student_enrollments;
