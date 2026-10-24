
-- Lab 15: Advanced Querying

-- ==================================================
-- 1. CREATE TABLES
-- ==================================================

CREATE TABLE employees_lab15 (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10, 2),
    manager_id INTEGER REFERENCES employees_lab15(employee_id),
    tenure INTEGER
);

CREATE TABLE orders_lab15 (
    order_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    region_id INTEGER,
    amount NUMERIC(12, 2),
    status VARCHAR(30),
    order_date DATE
);

CREATE TABLE warehouse_1_lab15 (
    product_id INTEGER,
    product_name VARCHAR(100),
    quantity INTEGER
);

CREATE TABLE warehouse_2_lab15 (
    product_id INTEGER,
    product_name VARCHAR(100),
    quantity INTEGER
);

CREATE TABLE sales_lab15 (
    sale_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    year INTEGER,
    sales_amount NUMERIC(12, 2)
);

CREATE TABLE pivoted_sales_lab15 (
    product_name VARCHAR(100) PRIMARY KEY,
    year_2022 NUMERIC(12, 2),
    year_2023 NUMERIC(12, 2),
    year_2024 NUMERIC(12, 2)
);

-- ==================================================
-- 2. INSERT DATA
-- ==================================================

INSERT INTO employees_lab15
    (first_name, last_name, department, salary, manager_id, tenure)
VALUES
    ('Maria', 'Garcia', 'Management', 130000, NULL, 15),
    ('James', 'Wilson', 'Engineering', 100000, 1, 10),
    ('Sophia', 'Martin', 'Sales', 85000, 1, 7),
    ('Daniel', 'Young', 'Engineering', 90000, 2, 6),
    ('Olivia', 'King', 'Sales', 70000, 3, 4),
    ('Aiden', 'Scott', 'Engineering', 75000, 2, 3),
    ('Emma', 'Davis', 'HR', 60000, 1, 8),
    ('Noah', 'Taylor', 'Sales', 65000, 3, 2);

INSERT INTO orders_lab15
    (product_name, region_id, amount, status, order_date)
VALUES
    ('Laptop', 1, 250000, 'High Priority', '2024-01-15'),
    ('Keyboard', 1, 45000, 'Medium Priority', '2024-03-20'),
    ('Monitor', 2, 180000, 'Low Priority', '2024-04-12'),
    ('Laptop', 2, 300000, 'High Priority', '2023-06-10'),
    ('Mouse', 3, 25000, 'Low Priority', '2023-09-18'),
    ('Monitor', 1, 210000, 'Medium Priority', '2024-07-22'),
    ('Keyboard', 3, 50000, 'High Priority', '2022-11-05'),
    ('Mouse', 2, 30000, 'Medium Priority', '2022-12-11');

INSERT INTO warehouse_1_lab15
    (product_id, product_name, quantity)
VALUES
    (1, 'Laptop', 10),
    (2, 'Keyboard', 0),
    (3, 'Mouse', 25),
    (4, 'Monitor', 0),
    (5, 'Webcam', 12);

INSERT INTO warehouse_2_lab15
    (product_id, product_name, quantity)
VALUES
    (2, 'Keyboard', 0),
    (3, 'Mouse', 0),
    (4, 'Monitor', 0),
    (5, 'Webcam', 8),
    (6, 'Headphones', 15);

INSERT INTO sales_lab15 (product_name, year, sales_amount)
VALUES
    ('Laptop', 2022, 100000),
    ('Laptop', 2023, 125000),
    ('Laptop', 2024, 150000),
    ('Keyboard', 2022, 20000),
    ('Keyboard', 2023, 25000),
    ('Keyboard', 2024, 30000),
    ('Monitor', 2022, 50000),
    ('Monitor', 2023, 60000),
    ('Monitor', 2024, 75000);

INSERT INTO pivoted_sales_lab15
    (product_name, year_2022, year_2023, year_2024)
VALUES
    ('Laptop', 100000, 125000, 150000),
    ('Keyboard', 20000, 25000, 30000),
    ('Monitor', 50000, 60000, 75000);

-- ==================================================
-- 3. VERIFY TABLES
-- ==================================================

\dt

SELECT * FROM employees_lab15 ORDER BY employee_id;
SELECT * FROM orders_lab15 ORDER BY order_id;
SELECT * FROM warehouse_1_lab15 ORDER BY product_id;
SELECT * FROM warehouse_2_lab15 ORDER BY product_id;
SELECT * FROM sales_lab15 ORDER BY sale_id;
SELECT * FROM pivoted_sales_lab15 ORDER BY product_name;

-- ==================================================
-- 4. SUBQUERIES
-- ==================================================

SELECT first_name, last_name, salary
FROM employees_lab15
WHERE salary > (
    SELECT AVG(salary)
    FROM employees_lab15
)
ORDER BY salary DESC;

SELECT first_name, last_name, department, salary
FROM employees_lab15
WHERE department IN (
    SELECT department
    FROM employees_lab15
    GROUP BY department
    HAVING AVG(salary) > 80000
)
ORDER BY department, salary DESC;

-- ==================================================
-- 5. COMMON TABLE EXPRESSIONS
-- ==================================================

WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders_lab15
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 100000
ORDER BY region_id;

WITH department_averages AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees_lab15
    GROUP BY department
)
SELECT
    e.first_name,
    e.last_name,
    e.department,
    e.salary,
    da.avg_salary
FROM employees_lab15 e
JOIN department_averages da
    ON e.department = da.department
WHERE e.salary > da.avg_salary
ORDER BY e.department, e.salary DESC;

-- ==================================================
-- 6. RECURSIVE QUERY
-- ==================================================

WITH RECURSIVE org_chart AS (
    SELECT
        employee_id,
        first_name,
        last_name,
        manager_id,
        1 AS hierarchy_level
    FROM employees_lab15
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        oc.hierarchy_level + 1
    FROM employees_lab15 e
    INNER JOIN org_chart oc
        ON e.manager_id = oc.employee_id
)
SELECT *
FROM org_chart
ORDER BY hierarchy_level, employee_id;

-- ==================================================
-- 7. SET OPERATIONS
-- ==================================================

SELECT product_name
FROM warehouse_1_lab15
UNION
SELECT product_name
FROM warehouse_2_lab15
ORDER BY product_name;

SELECT product_name
FROM warehouse_1_lab15
UNION ALL
SELECT product_name
FROM warehouse_2_lab15
ORDER BY product_name;

SELECT product_id
FROM warehouse_1_lab15
WHERE quantity = 0
INTERSECT
SELECT product_id
FROM warehouse_2_lab15
WHERE quantity = 0
ORDER BY product_id;

SELECT product_id
FROM warehouse_1_lab15
EXCEPT
SELECT product_id
FROM warehouse_2_lab15
ORDER BY product_id;

-- ==================================================
-- 8. WINDOW FUNCTIONS
-- ==================================================

SELECT
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS dept_salary_rank
FROM employees_lab15
ORDER BY department, dept_salary_rank;

SELECT
    first_name,
    last_name,
    department,
    salary,
    ROW_NUMBER() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS row_num,
    RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS salary_rank,
    DENSE_RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS dense_salary_rank
FROM employees_lab15
ORDER BY department, salary DESC;

SELECT
    first_name,
    last_name,
    department,
    salary,
    SUM(salary) OVER (
        PARTITION BY department
    ) AS department_total_salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS department_avg_salary
FROM employees_lab15
ORDER BY department, salary DESC;

SELECT
    first_name,
    last_name,
    salary,
    LAG(salary) OVER (ORDER BY salary) AS previous_salary,
    LEAD(salary) OVER (ORDER BY salary) AS next_salary
FROM employees_lab15
ORDER BY salary;

-- ==================================================
-- 9. PIVOT
-- ==================================================

SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END)
        AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END)
        AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END)
        AS year_2024
FROM sales_lab15
GROUP BY product_name
ORDER BY product_name;

-- ==================================================
-- 10. UNPIVOT
-- ==================================================

SELECT product_name, '2022' AS year, year_2022 AS sales_amount
FROM pivoted_sales_lab15
UNION ALL
SELECT product_name, '2023' AS year, year_2023 AS sales_amount
FROM pivoted_sales_lab15
UNION ALL
SELECT product_name, '2024' AS year, year_2024 AS sales_amount
FROM pivoted_sales_lab15
ORDER BY product_name, year;

-- ==================================================
-- 11. FILTER CLAUSE
-- ==================================================

SELECT
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    SUM(salary) OVER (
        PARTITION BY department
    ) AS total_dept_salary,
    AVG(salary) FILTER (
        WHERE tenure > 5
    ) OVER () AS avg_salary_senior
FROM employees_lab15
ORDER BY department, employee_id;

-- ==================================================
-- 12. CUSTOM SORTING WITH CASE
-- ==================================================

SELECT product_name, status
FROM orders_lab15
ORDER BY
    CASE status
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        WHEN 'Low Priority' THEN 3
        ELSE 4
    END,
    product_name;

-- ==================================================
-- 13. EXPLAIN
-- ==================================================

EXPLAIN
SELECT first_name, last_name, salary
FROM employees_lab15
WHERE department = 'Engineering'
ORDER BY salary DESC;

-- ==================================================
-- 14. EXPLAIN ANALYZE BEFORE INDEX
-- ==================================================

EXPLAIN ANALYZE
SELECT first_name, last_name, salary
FROM employees_lab15
WHERE department = 'Engineering'
ORDER BY salary DESC;

-- ==================================================
-- 15. CREATE INDEX
-- ==================================================

CREATE INDEX idx_employees_lab15_department
ON employees_lab15(department);

-- ==================================================
-- 16. EXPLAIN ANALYZE AFTER INDEX
-- ==================================================

EXPLAIN ANALYZE
SELECT first_name, last_name, salary
FROM employees_lab15
WHERE department = 'Engineering'
ORDER BY salary DESC;

-- ==================================================
-- 17. SELECT ONLY REQUIRED COLUMNS
-- ==================================================

SELECT first_name, last_name, salary
FROM employees_lab15
WHERE salary > 80000
ORDER BY salary DESC;

-- ==================================================
-- 18. LIMIT
-- ==================================================

SELECT
    order_id,
    product_name,
    region_id,
    amount,
    status
FROM orders_lab15
ORDER BY amount DESC
LIMIT 10;
