# Lab 10 — Viewing Database and Table Structure

## Objective

Learn how to inspect database and table structures in PostgreSQL and understand relationships between tables.

## 1. PostgreSQL commands

- `\dt` — lists tables in the current database.
- `\d table_name` — displays the structure of a specific table.
- `\conninfo` — displays information about the current database connection.

## 2. Database structure

The PostgreSQL commands were executed in the `postgres` database. The tables, columns, data types, primary keys, indexes, and foreign keys were inspected using `psql`.

## 3. ER Diagram

The file `erd_dvd_rental_hw.png` contains an ER diagram exported from DBeaver for the separate `dvd_rental_hw` project.

The diagram illustrates tables and their relationships, including films, actors, categories, inventory, rentals, payments, customers, and staff.