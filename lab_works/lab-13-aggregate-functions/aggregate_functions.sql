
-- Lab 13: Aggregate Functions

-- 1. CREATE TABLES

CREATE TABLE employees_lab13 (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10, 2),
    age INTEGER,
    hire_date DATE,
    email VARCHAR(100),
    bonus NUMERIC(10, 2),
    experience_years NUMERIC(4, 1)
);

CREATE TABLE products_lab13 (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2)
);

CREATE TABLE sales_lab13 (
    sale_id SERIAL PRIMARY KEY,
    department VARCHAR(50),
    amount NUMERIC(10, 2),
    sale_date DATE
);

CREATE TABLE employee_skills_lab13 (
    skill_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees_lab13(employee_id),
    skill_name VARCHAR(50)
);

CREATE TABLE product_reviews_lab13 (
    review_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products_lab13(product_id),
    rating NUMERIC(2, 1)
);

-- 2. INSERT SAMPLE DATA

INSERT INTO employees_lab13
    (first_name, last_name, department, salary, age,
     hire_date, email, bonus, experience_years)
VALUES
    ('Alice', 'Brown', 'Engineering', 120000, 28,
     '2021-03-15', 'alice@gmail.com', 12000, 6),
    ('Bob', 'Smith', 'Sales', 85000, 35,
     '2022-06-10', 'bob@company.com', 5000, 10),
    ('Anna', 'White', 'Engineering', 95000, 32,
     '2023-02-20', 'anna@gmail.com', 8000, 8),
    ('Brandon', 'Lee', 'Sales', 65000, 25,
     '2024-01-15', 'brandon@gmail.com', NULL, 3),
    ('David', 'Green', 'HR', 55000, 45,
     '2020-09-01', 'david@company.com', 2000, 15),
    ('Amy', 'Taylor', 'Sales', 72000, 29,
     '2025-04-12', 'amy@gmail.com', 3500, 5),
    ('Brian', 'Clark', 'Engineering', 78000, 38,
     '2022-11-08', NULL, 4000, 12),
    ('Maria', 'Garcia', 'Sales', 68000, 27,
     '2023-07-17', 'maria@gmail.com', 2500, 4),
    ('James', 'Wilson', 'Sales', 74000, 41,
     '2021-12-05', 'james@company.com', NULL, 14),
    ('Sophia', 'Martin', 'Sales', 61000, 23,
     '2025-08-01', 'sophia@gmail.com', 1500, 2),
    ('Daniel', 'Young', 'HR', 59000, 31,
     '2024-05-20', 'daniel@company.com', 1800, 7),
    ('Olivia', 'King', 'Engineering', 105000, 50,
     '2019-04-10', 'olivia@gmail.com', 10000, 20);

INSERT INTO products_lab13 (product_name, category, price)
VALUES
    ('Laptop', 'Electronics', 1200),
    ('Keyboard', 'Electronics', 80),
    ('Monitor', 'Electronics', 350),
    ('Desk', 'Furniture', 450),
    ('Chair', 'Furniture', 220),
    ('Notebook', 'Stationery', 5);

INSERT INTO sales_lab13 (department, amount, sale_date)
VALUES
    ('Sales', 1500, '2025-01-15'),
    ('Sales', 2200, '2025-02-20'),
    ('Engineering', 1800, '2025-03-12'),
    ('HR', 900, '2025-04-05'),
    ('Sales', 3100, '2025-04-18'),
    ('Engineering', 2500, '2025-07-22'),
    ('Sales', 1700, '2025-08-10'),
    ('HR', 1100, '2025-10-03'),
    ('Engineering', 2900, '2026-01-17'),
    ('Sales', 3600, '2026-04-11');

INSERT INTO employee_skills_lab13 (employee_id, skill_name)
VALUES
    (1, 'Python'),
    (1, 'SQL'),
    (1, 'Docker'),
    (2, 'Communication'),
    (2, 'Negotiation'),
    (3, 'Python'),
    (3, 'PostgreSQL'),
    (4, 'Salesforce'),
    (4, 'Communication'),
    (5, 'Recruiting'),
    (6, 'Negotiation'),
    (6, 'Communication'),
    (7, 'Docker'),
    (7, 'PostgreSQL'),
    (8, 'Salesforce'),
    (9, 'Negotiation'),
    (10, 'Communication'),
    (12, 'Python'),
    (12, 'Leadership');

INSERT INTO product_reviews_lab13 (product_id, rating)
VALUES
    (1, 5.0), (1, 4.5), (1, 4.8), (1, 4.7), (1, 5.0),
    (1, 4.6), (1, 4.9), (1, 4.8), (1, 4.7), (1, 5.0),
    (2, 4.0), (2, 3.5), (2, 4.2), (2, 3.8),
    (3, 4.5), (3, 4.7), (3, 4.6);

-- 3. VERIFY TABLES AND DATA

\dt

SELECT * FROM employees_lab13 ORDER BY employee_id;
SELECT * FROM products_lab13 ORDER BY product_id;
SELECT * FROM sales_lab13 ORDER BY sale_id;
SELECT * FROM employee_skills_lab13 ORDER BY skill_id;
SELECT * FROM product_reviews_lab13 ORDER BY review_id;

-- 4. COUNT

SELECT COUNT(*) AS total_employees
FROM employees_lab13;

SELECT COUNT(email) AS employees_with_email
FROM employees_lab13;

SELECT COUNT(DISTINCT department) AS unique_departments
FROM employees_lab13;

-- 5. SUM

SELECT SUM(salary) AS total_salaries
FROM employees_lab13;

SELECT department, SUM(amount) AS total_sales
FROM sales_lab13
GROUP BY department
ORDER BY department;

-- 6. AVG

SELECT AVG(salary) AS average_salary
FROM employees_lab13;

SELECT department, AVG(age) AS avg_age
FROM employees_lab13
GROUP BY department
ORDER BY department;

-- 7. MAX AND MIN

SELECT
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees_lab13;

SELECT department, MAX(hire_date) AS latest_hire
FROM employees_lab13
GROUP BY department
ORDER BY department;

-- 8. STRING_AGG

SELECT
    department,
    STRING_AGG(first_name, ', ') AS employee_names
FROM employees_lab13
GROUP BY department
ORDER BY department;

SELECT
    employee_id,
    STRING_AGG(skill_name, ', ' ORDER BY skill_name) AS skills
FROM employee_skills_lab13
GROUP BY employee_id
ORDER BY employee_id;

-- 9. ARRAY_AGG

SELECT
    department,
    ARRAY_AGG(salary) AS salary_array
FROM employees_lab13
GROUP BY department
ORDER BY department;

SELECT
    department,
    ARRAY_AGG(first_name ORDER BY last_name) AS employees
FROM employees_lab13
GROUP BY department
ORDER BY department;

-- 10. STATISTICAL AGGREGATES

SELECT
    department,
    STDDEV(salary) AS salary_std_dev,
    VARIANCE(salary) AS salary_variance
FROM employees_lab13
GROUP BY department
ORDER BY department;

SELECT
    CORR(experience_years, salary) AS experience_salary_correlation
FROM employees_lab13;

-- 11. GROUP BY: PRODUCTS

SELECT
    category,
    COUNT(*) AS number_of_products,
    SUM(price) AS total_value,
    AVG(price) AS average_price
FROM products_lab13
GROUP BY category
ORDER BY category;

-- 12. GROUP BY YEAR AND QUARTER

SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(QUARTER FROM sale_date) AS quarter,
    COUNT(*) AS total_sales,
    SUM(amount) AS total_revenue
FROM sales_lab13
GROUP BY
    EXTRACT(YEAR FROM sale_date),
    EXTRACT(QUARTER FROM sale_date)
ORDER BY year, quarter;

-- 13. GROUP BY AGE EXPRESSION

SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees_lab13
GROUP BY
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END
ORDER BY age_group;

-- 14. HAVING

SELECT
    department,
    COUNT(*) AS employee_count
FROM employees_lab13
GROUP BY department
HAVING COUNT(*) > 5;

SELECT
    product_id,
    AVG(rating) AS avg_rating,
    COUNT(*) AS review_count
FROM product_reviews_lab13
GROUP BY product_id
HAVING AVG(rating) > 4.0
   AND COUNT(*) >= 10
ORDER BY product_id;

-- 15. AGGREGATE FUNCTION VS WINDOW FUNCTION

SELECT
    department,
    AVG(salary) AS dept_avg_salary
FROM employees_lab13
GROUP BY department
ORDER BY department;

SELECT
    employee_id,
    first_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees_lab13
ORDER BY department, employee_id;

-- 16. HANDLING NULL VALUES

SELECT
    COUNT(*) AS total_rows,
    COUNT(email) AS non_null_emails,
    COUNT(*) - COUNT(email) AS null_emails
FROM employees_lab13;

SELECT
    SUM(bonus) AS total_bonus,
    AVG(bonus) AS avg_bonus,
    COUNT(bonus) AS employees_with_bonus
FROM employees_lab13;

-- 17. MULTIPLE AGGREGATIONS

SELECT
    department,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    AVG(salary) AS avg_salary,
    STDDEV(salary) AS salary_std_dev
FROM employees_lab13
GROUP BY department
ORDER BY avg_salary DESC;

-- 18. CONDITIONAL AGGREGATION

SELECT
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 50000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN hire_date > '2023-01-01' THEN 1 END) AS recent_hires
FROM employees_lab13
GROUP BY department
ORDER BY department;

-- 19. PERCENTAGE CALCULATIONS

SELECT
    department,
    COUNT(*) AS dept_count,
    COUNT(*)::FLOAT /
        (SELECT COUNT(*) FROM employees_lab13) * 100 AS percentage
FROM employees_lab13
GROUP BY department
ORDER BY percentage DESC;
