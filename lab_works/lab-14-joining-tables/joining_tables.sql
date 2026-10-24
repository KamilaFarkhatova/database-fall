
-- Lab 14: Joining Tables

-- ==================================================
-- 1. CREATE TABLES
-- ==================================================

CREATE TABLE customers_lab14 (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders_lab14 (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    total_amount NUMERIC(10, 2)
);

CREATE TABLE products_lab14 (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10, 2)
);

CREATE TABLE order_items_lab14 (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders_lab14(order_id),
    product_id INTEGER REFERENCES products_lab14(product_id),
    quantity INTEGER
);

CREATE TABLE employees_lab14 (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    manager_id INTEGER REFERENCES employees_lab14(employee_id)
);

CREATE TABLE users_lab14 (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE user_profiles_lab14 (
    profile_id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES users_lab14(user_id),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(30)
);

CREATE TABLE authors_lab14 (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100)
);

CREATE TABLE books_lab14 (
    book_id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES authors_lab14(author_id),
    title VARCHAR(150),
    publication_year INTEGER
);

CREATE TABLE students_lab14 (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE courses_lab14 (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE enrollments_lab14 (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students_lab14(student_id),
    course_id INTEGER REFERENCES courses_lab14(course_id),
    enrollment_date DATE,
    grade NUMERIC(5, 2)
);

-- ==================================================
-- 2. INSERT DATA
-- ==================================================

INSERT INTO customers_lab14 (name, email)
VALUES
    ('Alice Brown', 'alice@example.com'),
    ('Bob Smith', 'bob@example.com'),
    ('Carol White', 'carol@example.com'),
    ('David Green', 'david@example.com');

INSERT INTO orders_lab14 (customer_id, order_date, total_amount)
VALUES
    (1, '2025-01-15', 250.00),
    (1, '2025-02-20', 120.00),
    (2, '2025-03-05', 75.50),
    (4, '2025-04-10', 310.00),
    (99, '2025-05-01', 50.00);

INSERT INTO products_lab14 (product_name, price)
VALUES
    ('Laptop', 1200.00),
    ('Keyboard', 80.00),
    ('Monitor', 350.00),
    ('Notebook', 5.00);

INSERT INTO order_items_lab14 (order_id, product_id, quantity)
VALUES
    (1, 1, 1),
    (1, 2, 2),
    (2, 4, 5),
    (3, 2, 1),
    (4, 3, 2),
    (5, 4, 3);

INSERT INTO employees_lab14 (name, manager_id)
VALUES
    ('Maria Garcia', NULL),
    ('James Wilson', 1),
    ('Sophia Martin', 1),
    ('Daniel Young', 2),
    ('Olivia King', 2);

INSERT INTO users_lab14 (username)
VALUES
    ('alice_b'),
    ('bob_s'),
    ('carol_w');

INSERT INTO user_profiles_lab14
    (user_id, first_name, last_name, phone)
VALUES
    (1, 'Alice', 'Brown', '555-0101'),
    (2, 'Bob', 'Smith', '555-0102');

INSERT INTO authors_lab14 (author_name)
VALUES
    ('George Orwell'),
    ('Jane Austen'),
    ('Mark Twain');

INSERT INTO books_lab14 (author_id, title, publication_year)
VALUES
    (1, '1984', 1949),
    (1, 'Animal Farm', 1945),
    (2, 'Pride and Prejudice', 1813);

INSERT INTO students_lab14 (student_name)
VALUES
    ('Aibek Erkinov'),
    ('Kamila Farkhatova'),
    ('Meerim Bekova'),
    ('Nursultan Isakov');

INSERT INTO courses_lab14 (course_name)
VALUES
    ('Database Systems'),
    ('Python Programming'),
    ('Computer Networks');

INSERT INTO enrollments_lab14
    (student_id, course_id, enrollment_date, grade)
VALUES
    (1, 1, '2025-01-10', 90),
    (1, 2, '2025-01-12', 85),
    (2, 1, '2025-01-15', 95),
    (2, 3, '2025-01-18', NULL),
    (3, 2, '2025-02-01', 88);

-- ==================================================
-- 3. VERIFY TABLES
-- ==================================================

\dt

SELECT * FROM customers_lab14 ORDER BY customer_id;
SELECT * FROM orders_lab14 ORDER BY order_id;
SELECT * FROM products_lab14 ORDER BY product_id;
SELECT * FROM order_items_lab14 ORDER BY item_id;
SELECT * FROM employees_lab14 ORDER BY employee_id;
SELECT * FROM users_lab14 ORDER BY user_id;
SELECT * FROM user_profiles_lab14 ORDER BY profile_id;
SELECT * FROM authors_lab14 ORDER BY author_id;
SELECT * FROM books_lab14 ORDER BY book_id;
SELECT * FROM students_lab14 ORDER BY student_id;
SELECT * FROM courses_lab14 ORDER BY course_id;
SELECT * FROM enrollments_lab14 ORDER BY enrollment_id;

-- ==================================================
-- 4. INNER JOIN
-- ==================================================

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers_lab14 c
INNER JOIN orders_lab14 o
    ON c.customer_id = o.customer_id;

-- ==================================================
-- 5. LEFT JOIN
-- ==================================================

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers_lab14 c
LEFT JOIN orders_lab14 o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;

-- ==================================================
-- 6. RIGHT JOIN
-- ==================================================

SELECT c.name, c.email, o.order_id, o.order_date, o.total_amount
FROM customers_lab14 c
RIGHT JOIN orders_lab14 o
    ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- ==================================================
-- 7. FULL OUTER JOIN
-- ==================================================

SELECT c.name, c.email, o.order_id, o.order_date, o.total_amount
FROM customers_lab14 c
FULL OUTER JOIN orders_lab14 o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id NULLS LAST, o.order_id;

-- ==================================================
-- 8. CROSS JOIN
-- ==================================================

SELECT c.name, p.product_name
FROM customers_lab14 c
CROSS JOIN products_lab14 p
ORDER BY c.name, p.product_name;

-- ==================================================
-- 9. MULTIPLE TABLE JOINS
-- ==================================================

SELECT
    c.name,
    o.order_date,
    oi.quantity,
    p.product_name,
    p.price
FROM customers_lab14 c
INNER JOIN orders_lab14 o
    ON c.customer_id = o.customer_id
INNER JOIN order_items_lab14 oi
    ON o.order_id = oi.order_id
INNER JOIN products_lab14 p
    ON oi.product_id = p.product_id
ORDER BY c.name, o.order_date, p.product_name;

-- ==================================================
-- 10. SELF JOIN
-- ==================================================

SELECT
    e1.name AS employee,
    e2.name AS manager
FROM employees_lab14 e1
LEFT JOIN employees_lab14 e2
    ON e1.manager_id = e2.employee_id
ORDER BY e1.employee_id;

-- ==================================================
-- 11. JOIN WITH CONDITIONS
-- ==================================================

SELECT c.name, o.order_date, o.total_amount
FROM customers_lab14 c
INNER JOIN orders_lab14 o
    ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-01-01'
  AND o.total_amount > 100
ORDER BY o.order_date;

-- ==================================================
-- 12. ONE-TO-ONE RELATIONSHIP
-- ==================================================

SELECT
    u.username,
    up.first_name,
    up.last_name,
    up.phone
FROM users_lab14 u
LEFT JOIN user_profiles_lab14 up
    ON u.user_id = up.user_id
ORDER BY u.user_id;

-- ==================================================
-- 13. ONE-TO-MANY RELATIONSHIP
-- ==================================================

SELECT
    a.author_name,
    b.title,
    b.publication_year
FROM authors_lab14 a
INNER JOIN books_lab14 b
    ON a.author_id = b.author_id
ORDER BY a.author_name, b.publication_year;

-- ==================================================
-- 14. MANY-TO-MANY RELATIONSHIP
-- ==================================================

SELECT
    s.student_name,
    c.course_name,
    e.enrollment_date,
    e.grade
FROM students_lab14 s
INNER JOIN enrollments_lab14 e
    ON s.student_id = e.student_id
INNER JOIN courses_lab14 c
    ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
ORDER BY s.student_name, c.course_name;

-- ==================================================
-- 15. INDEXES
-- ==================================================

CREATE INDEX idx_orders_lab14_customer_id
    ON orders_lab14(customer_id);

CREATE INDEX idx_order_items_lab14_order_id
    ON order_items_lab14(order_id);

CREATE INDEX idx_order_items_lab14_product_id
    ON order_items_lab14(product_id);

-- ==================================================
-- 16. TABLE ALIASES
-- ==================================================

SELECT c.name, o.order_date
FROM customers_lab14 c
INNER JOIN orders_lab14 o
    ON c.customer_id = o.customer_id
ORDER BY c.name, o.order_date;

-- ==================================================
-- 17. CARTESIAN PRODUCT EXAMPLE
-- ==================================================

SELECT c.name, o.order_date
FROM customers_lab14 c, orders_lab14 o;

-- ==================================================
-- 18. CORRECT JOIN CONDITION
-- ==================================================

SELECT c.name, o.order_date
FROM customers_lab14 c
INNER JOIN orders_lab14 o
    ON c.customer_id = o.customer_id
ORDER BY c.name, o.order_date;

-- ==================================================
-- 19. CUSTOMERS WITHOUT ORDERS
-- ==================================================

SELECT c.name
FROM customers_lab14 c
LEFT JOIN orders_lab14 o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;

-- ==================================================
-- 20. ORDERS WITHOUT MATCHING CUSTOMERS
-- ==================================================

SELECT o.order_id, o.customer_id, o.order_date, o.total_amount
FROM orders_lab14 o
LEFT JOIN customers_lab14 c
    ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL
ORDER BY o.order_id;
