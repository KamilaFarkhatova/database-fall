
-- Lab 12: Querying Data

-- =========================================
-- PART 1: CREATE TABLES
-- =========================================

CREATE TABLE employees_lab12 (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    department_id INTEGER,
    salary NUMERIC(10, 2),
    email VARCHAR(100)
);

CREATE TABLE products_lab12 (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10, 2)
);

CREATE TABLE customers_lab12 (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);

CREATE TABLE users_lab12 (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE sales_lab12 (
    sale_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees_lab12(id),
    amount NUMERIC(10, 2)
);

-- =========================================
-- PART 2: INSERT SAMPLE DATA
-- =========================================

INSERT INTO employees_lab12
    (name, department, department_id, salary, email)
VALUES
    ('Alice Brown', 'Engineering', 3, 120000, 'alice.brown@gmail.com'),
    ('Bob Smith', 'Sales', 5, 85000, 'bob.smith@company.com'),
    ('Anna White', 'Engineering', 3, 95000, 'anna.white@gmail.com'),
    ('Brandon Lee', 'Sales', 5, 65000, 'brandon.lee@gmail.com'),
    ('David Green', 'HR', 7, 55000, 'david.green@company.com'),
    ('Amy Taylor', 'Marketing', 2, 72000, 'amy.taylor@gmail.com'),
    ('Brian Clark', 'Engineering', 3, 78000, 'brian.clark@company.com');

INSERT INTO products_lab12 (product_name, category, price)
VALUES
    ('Strawberry', 'Fruit', 25.00),
    ('Blueberry', 'Fruit', 30.00),
    ('Blackberry', 'Fruit', 45.00),
    ('Laptop', 'Electronics', 850.00),
    ('Keyboard', 'Electronics', 40.00),
    ('Notebook', 'Stationery', 5.00),
    ('Monitor', 'Electronics', 180.00);

INSERT INTO customers_lab12 (customer_name, city)
VALUES
    ('Brad Miller', 'Bishkek'),
    ('Brandon Scott', 'Osh'),
    ('Sarah Johnson', 'Bishkek'),
    ('Brian Wilson', 'Karakol');

INSERT INTO users_lab12 (first_name, last_name, email)
VALUES
    ('Alice', 'Brown', 'alice.brown@gmail.com'),
    ('Bob', 'Smith', 'bob.smith@company.com'),
    ('Anna', 'White', 'anna.white@gmail.com'),
    ('David', 'Green', 'david.green@gmail.com'),
    ('Test', 'Invalid', 'not-an-email'),
    ('Amy', 'Taylor', 'AMY.TAYLOR@EXAMPLE.COM');

INSERT INTO sales_lab12 (employee_id, amount)
VALUES
    (1, 1500.00),
    (1, 800.00),
    (2, 2000.00),
    (3, 1200.00),
    (4, 500.00),
    (6, 2500.00);

-- =========================================
-- PART 3: VERIFY TABLES AND INSERTED DATA
-- =========================================

SELECT * FROM employees_lab12 ORDER BY id;

SELECT * FROM products_lab12 ORDER BY product_id;

SELECT * FROM customers_lab12 ORDER BY customer_id;

SELECT * FROM users_lab12 ORDER BY id;

SELECT * FROM sales_lab12 ORDER BY sale_id;

-- =========================================
-- PART 4: SELECT STATEMENTS
-- =========================================

-- 1. Select all columns
SELECT *
FROM employees_lab12;

-- 2. Select specific columns
SELECT name, department
FROM employees_lab12;

-- 3. Calculate a 10% potential bonus
SELECT name, salary, salary * 0.10 AS potential_bonus
FROM employees_lab12;

-- =========================================
-- PART 5: WHERE CONDITIONS
-- =========================================

-- 4. Employees in the Sales department
SELECT name, salary
FROM employees_lab12
WHERE department = 'Sales';

-- 5. Engineering employees earning more than 75000
SELECT name
FROM employees_lab12
WHERE salary > 75000
  AND department = 'Engineering';

-- 6. Products priced between 20 and 50, inclusive
SELECT product_name, price
FROM products_lab12
WHERE price BETWEEN 20 AND 50;

-- =========================================
-- PART 6: LIKE AND ILIKE
-- =========================================

-- 9. Customer names starting with 'Bra'
SELECT customer_name
FROM customers_lab12
WHERE customer_name LIKE 'Bra%';

-- 10. Product names ending with 'berry'
SELECT product_name
FROM products_lab12
WHERE product_name LIKE '%berry';

-- 11. Email addresses ending with gmail.com
-- Case-insensitive search
SELECT email
FROM users_lab12
WHERE email ILIKE '%gmail.com';

-- =========================================
-- PART 7: REGULAR EXPRESSIONS
-- =========================================

-- 12. Names starting with A or B
SELECT name
FROM employees_lab12
WHERE name ~ '^[AB]';

-- 13. Emails matching a simple email pattern
SELECT email
FROM users_lab12
WHERE email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$';

-- =========================================
-- PART 8: IN AND EXISTS
-- =========================================

-- 16. Employees in department IDs 3, 5, or 7
SELECT name, department
FROM employees_lab12
WHERE department_id IN (3, 5, 7);

-- 17. IN with a subquery
-- Employees with a sale greater than 1000
SELECT name
FROM employees_lab12
WHERE id IN (
    SELECT employee_id
    FROM sales_lab12
    WHERE amount > 1000
);

-- 18. EXISTS with a correlated subquery
SELECT name
FROM employees_lab12 e
WHERE EXISTS (
    SELECT 1
    FROM sales_lab12 s
    WHERE s.employee_id = e.id
      AND s.amount > 1000
);

-- =========================================
-- PART 9: CASE STATEMENT
-- =========================================

-- 19. Categorize employees by salary
SELECT name, salary,
    CASE
        WHEN salary > 100000 THEN 'Senior'
        WHEN salary BETWEEN 60000 AND 100000 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS employee_level
FROM employees_lab12;

-- =========================================
-- PART 10: COMMON TABLE EXPRESSIONS (CTE)
-- =========================================

-- 20. Employees earning more than their department average
WITH department_averages AS (
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM employees_lab12
    GROUP BY department
)
SELECT
    e.name,
    e.salary,
    e.department,
    da.avg_salary
FROM employees_lab12 e
JOIN department_averages da
    ON e.department = da.department
WHERE e.salary > da.avg_salary;
