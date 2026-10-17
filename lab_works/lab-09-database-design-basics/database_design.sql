-- Lab 09: Database Design Basics

-- =========================================================
-- 1. First Normal Form (1NF)
-- =========================================================

-- Unnormalized table: multiple phone numbers in one column.
CREATE TABLE students_bad (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    phone_numbers TEXT
);

INSERT INTO students_bad (student_id, name, phone_numbers)
VALUES (1, 'Anna Ivanova', '111-111, 222-222');

SELECT * FROM students_bad;

-- Normalized design: student details and phone numbers are separated.
CREATE TABLE students_lab9 (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE students_phones (
    student_id INT,
    phone_number VARCHAR(15),
    phone_type VARCHAR(20),
    PRIMARY KEY (student_id, phone_number),
    FOREIGN KEY (student_id) REFERENCES students_lab9(student_id)
);

INSERT INTO students_lab9 (student_id, name)
VALUES (1, 'Anna Ivanova');

INSERT INTO students_phones (student_id, phone_number, phone_type)
VALUES
    (1, '111-111', 'Mobile'),
    (1, '222-222', 'Work');

SELECT * FROM students_lab9;
SELECT * FROM students_phones;

-- =========================================================
-- 2. Second Normal Form (2NF)
-- =========================================================

-- Unnormalized design: course name is repeated in enrollment rows.
CREATE TABLE enrollments_bad (
    student_id INT,
    course_id INT,
    course_name VARCHAR(100),
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO enrollments_bad
    (student_id, course_id, course_name, grade)
VALUES
    (1, 101, 'Database Systems', 'A'),
    (2, 101, 'Database Systems', 'B+');

SELECT * FROM enrollments_bad;

-- Normalized design: course information is stored separately.
CREATE TABLE courses_lab9 (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT
);

CREATE TABLE enrollments_lab9 (
    student_id INT,
    course_id INT,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students_lab9(student_id),
    FOREIGN KEY (course_id) REFERENCES courses_lab9(course_id)
);

INSERT INTO courses_lab9 (course_id, course_name, credits)
VALUES (101, 'Database Systems', 3);

INSERT INTO students_lab9 (student_id, name)
VALUES (2, 'Peter Smith');

INSERT INTO enrollments_lab9 (student_id, course_id, grade)
VALUES
    (1, 101, 'A'),
    (2, 101, 'B+');

SELECT * FROM courses_lab9;
SELECT * FROM enrollments_lab9;

-- =========================================================
-- 3. Third Normal Form (3NF)
-- =========================================================

-- Unnormalized design: department information is repeated.
-- department_name is dependent on department_id, which is not the primary key of the students table.
-- department_name is transitively dependent on student_id through department_id.
CREATE TABLE students_bad_3nf (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(100)
);

INSERT INTO students_bad_3nf
    (student_id, name, department_id, department_name)
VALUES
    (1, 'Anna Ivanova', 10, 'Computer Science'),
    (2, 'Peter Smith', 10, 'Computer Science');

SELECT * FROM students_bad_3nf;

-- Normalized design: department details are stored separately.
CREATE TABLE departments_lab9 (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    department_head VARCHAR(100)
);

CREATE TABLE students_3nf_lab9 (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments_lab9(department_id)
);

INSERT INTO departments_lab9
    (department_id, department_name, department_head)
VALUES
    (10, 'Computer Science', 'Alice Johnson');

INSERT INTO students_3nf_lab9
    (student_id, name, department_id)
VALUES
    (1, 'Anna Ivanova', 10),
    (2, 'Peter Smith', 10);

SELECT * FROM departments_lab9;
SELECT * FROM students_3nf_lab9;

SELECT
    s.student_id,
    s.name,
    d.department_name,
    d.department_head
FROM students_3nf_lab9 AS s
JOIN departments_lab9 AS d
    ON s.department_id = d.department_id;

-- =========================================================
-- 4. Library Database Design
-- =========================================================

CREATE TABLE authors_lab9 (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE
);

CREATE TABLE books_lab9 (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    publication_year INTEGER,
    available_copies INTEGER DEFAULT 1
);

CREATE TABLE book_authors_lab9 (
    book_id INTEGER,
    author_id INTEGER,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books_lab9(book_id),
    FOREIGN KEY (author_id) REFERENCES authors_lab9(author_id)
);

CREATE TABLE members_lab9 (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    membership_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE loans_lab9 (
    loan_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    loan_date DATE DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE,
    late_fee DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (member_id) REFERENCES members_lab9(member_id),
    FOREIGN KEY (book_id) REFERENCES books_lab9(book_id)
);

-- Insert authors.
INSERT INTO authors_lab9 (first_name, last_name, birth_date)
VALUES
    ('George', 'Orwell', '1903-06-25'),
    ('Jane', 'Austen', '1775-12-16');

-- Insert books.
INSERT INTO books_lab9
    (title, isbn, publication_year, available_copies)
VALUES
    ('1984', '9780451524935', 1949, 3),
    ('Animal Farm', '9780451526342', 1945, 2),
    ('Pride and Prejudice', '9780141439518', 1813, 4);

-- Link books to authors.
INSERT INTO book_authors_lab9 (book_id, author_id)
VALUES
    (1, 1),
    (2, 1),
    (3, 2);

-- Insert library members.
INSERT INTO members_lab9 (first_name, last_name, email, phone)
VALUES
    ('Anna', 'Ivanova', 'anna@example.com', '111-111'),
    ('Peter', 'Smith', 'peter@example.com', '222-222');

-- Insert loan records.
INSERT INTO loans_lab9
    (member_id, book_id, loan_date, due_date, return_date, late_fee)
VALUES
    (1, 1, '2026-10-01', '2026-10-15', NULL, 0.00),
    (2, 3, '2026-10-02', '2026-10-16', '2026-10-10', 0.00);

-- Check all library tables.
SELECT * FROM authors_lab9;
SELECT * FROM books_lab9;
SELECT * FROM book_authors_lab9;
SELECT * FROM members_lab9;
SELECT * FROM loans_lab9;

-- Books and their authors.
SELECT
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    b.publication_year,
    b.available_copies
FROM books_lab9 AS b
JOIN book_authors_lab9 AS ba
    ON b.book_id = ba.book_id
JOIN authors_lab9 AS a
    ON ba.author_id = a.author_id
ORDER BY b.title;

-- Loans and member details.
SELECT
    m.first_name || ' ' || m.last_name AS member_name,
    b.title,
    l.loan_date,
    l.due_date,
    l.return_date,
    l.late_fee
FROM loans_lab9 AS l
JOIN members_lab9 AS m
    ON l.member_id = m.member_id
JOIN books_lab9 AS b
    ON l.book_id = b.book_id
ORDER BY l.loan_date;