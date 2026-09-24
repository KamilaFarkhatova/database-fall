-- Lab 05: Databases

-- Create a new database
CREATE DATABASE university;

-- Switch to the new database
\c university

-- Switch back to the postgres database
-- before dropping university
\c postgres

-- Drop the database
DROP DATABASE university;