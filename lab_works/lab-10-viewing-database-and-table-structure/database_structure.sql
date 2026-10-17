-- Lab 10: Viewing Database and Table Structure

-- 1. Show all tables in the current database.
\dt

-- 2. Show all tables, views, sequences, and other relations.
\d

-- 3. Display the structure of the customers table.
\d customers

-- 4. Display the structure of the employee table.
\d employee

-- 5. Display the structure of the orders table and its relationships.
\d orders

-- 6. Display the structure of the order_items table.
\d order_items

-- 7. Display the structure of the products table.
\d products

-- 8. Display the structure of the users table.
\d users

-- 9. Display the structure of the users1 table.
\d users1

-- 10. Show information about the current connection.
\conninfo

-- 11. List foreign keys defined in the public schema.
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column,
    tc.constraint_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.constraint_schema = kcu.constraint_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON tc.constraint_name = ccu.constraint_name
   AND tc.constraint_schema = ccu.constraint_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;