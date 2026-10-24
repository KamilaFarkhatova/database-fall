
-- Lab 16: Transactions and ACID Properties

-- ==================================================
-- 1. CREATE TABLES
-- ==================================================

CREATE TABLE accounts_lab16 (
    account_id SERIAL PRIMARY KEY,
    balance NUMERIC(12, 2) NOT NULL CHECK (balance >= 0)
);

CREATE TABLE customers_lab16 (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders_lab16 (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers_lab16(customer_id),
    total NUMERIC(12, 2)
);

CREATE TABLE products_lab16 (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10, 2) CHECK (price > 0)
);

CREATE TABLE inventory_lab16 (
    product_id INTEGER PRIMARY KEY,
    stock INTEGER NOT NULL CHECK (stock >= 0)
);

CREATE TABLE order_items_lab16 (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders_lab16(order_id),
    product_id INTEGER,
    quantity INTEGER
);

CREATE TABLE logs_lab16 (
    log_id SERIAL PRIMARY KEY,
    message TEXT
);

CREATE TABLE audit_log_lab16 (
    audit_id SERIAL PRIMARY KEY,
    action VARCHAR(100),
    "timestamp" TIMESTAMP
);

CREATE TABLE users_lab16 (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE user_preferences_lab16 (
    preference_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users_lab16(id),
    theme VARCHAR(50)
);

-- ==================================================
-- 2. INITIAL DATA
-- ==================================================

INSERT INTO accounts_lab16 (balance)
VALUES (2000.00), (1000.00);

INSERT INTO customers_lab16 (name, email)
VALUES ('Initial Customer', 'initial@example.com');

INSERT INTO inventory_lab16 (product_id, stock)
VALUES (101, 50), (102, 30);

-- ==================================================
-- 3. BEGIN, COMMIT, ROLLBACK
-- ==================================================

BEGIN;
ROLLBACK;

BEGIN TRANSACTION;
ROLLBACK;

START TRANSACTION;
ROLLBACK;

-- Commit a transfer of 100

BEGIN;

UPDATE accounts_lab16
SET balance = balance - 100
WHERE account_id = 1;

UPDATE accounts_lab16
SET balance = balance + 100
WHERE account_id = 2;

COMMIT;

-- Roll back a transfer of 100

BEGIN;

UPDATE accounts_lab16
SET balance = balance - 100
WHERE account_id = 1;

UPDATE accounts_lab16
SET balance = balance + 100
WHERE account_id = 2;

ROLLBACK;

-- Transfer 500

BEGIN;

SELECT balance
FROM accounts_lab16
WHERE account_id = 1;

UPDATE accounts_lab16
SET balance = balance - 500
WHERE account_id = 1;

UPDATE accounts_lab16
SET balance = balance + 500
WHERE account_id = 2;

COMMIT;

-- ==================================================
-- 4. ATOMICITY
-- ==================================================

BEGIN;

INSERT INTO orders_lab16 (customer_id, total)
VALUES (1, 250.00);

INSERT INTO order_items_lab16 (order_id, product_id, quantity)
VALUES (1, 101, 2);

UPDATE inventory_lab16
SET stock = stock - 2
WHERE product_id = 101;

COMMIT;

-- ==================================================
-- 5. CONSISTENCY
-- ==================================================

BEGIN;

INSERT INTO customers_lab16 (name, email)
VALUES ('John Doe', 'john@email.com');

INSERT INTO orders_lab16 (customer_id, total)
VALUES (currval('customers_lab16_customer_id_seq'), 100.00);

COMMIT;

-- ==================================================
-- 6. ISOLATION LEVELS
-- ==================================================

BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT * FROM accounts_lab16;

COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT *
FROM accounts_lab16
WHERE balance > 1000;

SELECT *
FROM accounts_lab16
WHERE balance > 1000;

COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT *
FROM accounts_lab16
WHERE balance > 1000;

SELECT *
FROM accounts_lab16
WHERE balance > 1000;

COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT * FROM accounts_lab16;

UPDATE accounts_lab16
SET balance = balance * 1.05;

COMMIT;

BEGIN;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT * FROM accounts_lab16;

COMMIT;

-- ==================================================
-- 7. SAVEPOINTS
-- ==================================================

BEGIN;

INSERT INTO customers_lab16 (name, email)
VALUES ('Alice', 'alice@email.com');

SAVEPOINT after_customer_insert;

INSERT INTO orders_lab16 (customer_id, total)
VALUES (1, 500.00);

ROLLBACK TO SAVEPOINT after_customer_insert;

INSERT INTO orders_lab16 (customer_id, total)
VALUES (1, 300.00);

COMMIT;

-- Multiple savepoints

BEGIN;

INSERT INTO products_lab16 (name, price)
VALUES ('Laptop', 999.99);

SAVEPOINT sp1;

INSERT INTO products_lab16 (name, price)
VALUES ('Mouse', 25.99);

SAVEPOINT sp2;

-- This insert violates the CHECK constraint.
-- After the error, roll back to sp2 before continuing.
INSERT INTO products_lab16 (name, price)
VALUES ('Invalid Product', -50.00);

ROLLBACK TO SAVEPOINT sp2;

INSERT INTO products_lab16 (name, price)
VALUES ('Keyboard', 79.99);

COMMIT;

-- Releasing savepoints

BEGIN;

INSERT INTO logs_lab16 (message)
VALUES ('Starting process');

SAVEPOINT process_start;

INSERT INTO logs_lab16 (message)
VALUES ('Process completed');

RELEASE SAVEPOINT process_start;

COMMIT;

-- ==================================================
-- 8. SHORT TRANSACTION
-- ==================================================

BEGIN;

UPDATE inventory_lab16
SET stock = stock - 1
WHERE product_id = 101;

INSERT INTO order_items_lab16 (order_id, product_id, quantity)
VALUES (1, 101, 1);

COMMIT;

-- ==================================================
-- 9. ERROR HANDLING
-- ==================================================

DO $$
DECLARE
    current_balance NUMERIC;
BEGIN
    SELECT balance
    INTO current_balance
    FROM accounts_lab16
    WHERE account_id = 1;

    IF current_balance < 100 THEN
        RAISE EXCEPTION 'Insufficient funds';
    END IF;

    UPDATE accounts_lab16
    SET balance = balance - 100
    WHERE account_id = 1;

    UPDATE accounts_lab16
    SET balance = balance + 100
    WHERE account_id = 2;

EXCEPTION
    WHEN raise_exception THEN
        RAISE NOTICE 'Transaction failed: %', SQLERRM;
END $$;

-- ==================================================
-- 10. ISOLATION LEVEL BEST PRACTICES
-- ==================================================

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
COMMIT;

-- ==================================================
-- 11. SAVEPOINT FOR ORDER ITEMS
-- ==================================================

BEGIN;

INSERT INTO orders_lab16 (customer_id, total)
VALUES (1, 1000.00);

SAVEPOINT before_items;

INSERT INTO order_items_lab16 (order_id, product_id, quantity)
VALUES (currval('orders_lab16_order_id_seq'), 101, 2);

INSERT INTO order_items_lab16 (order_id, product_id, quantity)
VALUES (currval('orders_lab16_order_id_seq'), 102, 1);

COMMIT;

-- ==================================================
-- 12. MONITOR BLOCKING TRANSACTIONS
-- ==================================================

SELECT
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
JOIN pg_catalog.pg_stat_activity blocking_activity
    ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;

-- ==================================================
-- 13. EXPLICIT TRANSACTION CONTROL
-- ==================================================

BEGIN;

INSERT INTO audit_log_lab16 (action, "timestamp")
VALUES ('user_creation', NOW());

INSERT INTO users_lab16 (name, email)
VALUES ('John Doe', 'john@example.com');

INSERT INTO user_preferences_lab16 (user_id, theme)
VALUES (currval('users_lab16_id_seq'), 'dark');

COMMIT;

-- Without explicit transaction control

INSERT INTO audit_log_lab16 (action, "timestamp")
VALUES ('user_creation', NOW());

INSERT INTO users_lab16 (name, email)
VALUES ('John Doe', 'john@example.com');
