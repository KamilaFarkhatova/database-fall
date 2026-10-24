-- Data Import/Export and Backup

-- =========================================================
-- 1. COPY COMMAND
-- =========================================================

-- Export data to file
COPY employees TO '/tmp/employees.csv' WITH CSV HEADER;

-- Import data from file
COPY employees FROM '/tmp/employees.csv' WITH CSV HEADER;

-- Export with custom delimiter and NULL representation
COPY employees TO '/tmp/employees.txt'
WITH DELIMITER '|' NULL 'N/A' CSV HEADER;

-- Import specific columns only
COPY employees(first_name, last_name, email)
FROM '/tmp/new_employees.csv' WITH CSV HEADER;

-- Export query results
COPY (
    SELECT * FROM employees WHERE department = 'IT'
) TO '/tmp/it_employees.csv' WITH CSV HEADER;


-- =========================================================
-- 2. CSV IMPORT/EXPORT
-- =========================================================

-- Basic CSV export
COPY products TO '/tmp/products.csv' WITH CSV HEADER;

-- Custom quote character and delimiter
COPY customers TO '/tmp/customers.csv'
WITH CSV HEADER DELIMITER ';' QUOTE '"';

-- Export with FORCE_QUOTE
COPY orders TO '/tmp/orders.csv'
WITH CSV HEADER FORCE_QUOTE (order_date);

-- Basic CSV import
COPY products FROM '/tmp/products.csv' WITH CSV HEADER;

-- Import while ignoring invalid rows
COPY products FROM '/tmp/products_with_errors.csv'
WITH CSV HEADER ON_ERROR IGNORE;

-- Import with specific encoding
COPY products FROM '/tmp/products_utf8.csv'
WITH CSV HEADER ENCODING 'UTF8';

-- Handle embedded commas and quotes
COPY customer_feedback TO '/tmp/feedback.csv'
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';

-- Custom NULL representation
COPY sales_data FROM '/tmp/sales.csv'
WITH CSV HEADER NULL 'NULL';


-- =========================================================
-- 3. PG_DUMP AND PG_RESTORE
-- Ran these commands in the operating-system terminal.
-- =========================================================

-- pg_dump -h localhost -U postgres -d postgres > backup.sql
-- pg_dump -h localhost -U postgres -d postgres -Fc > backup.dump
-- pg_dump -h localhost -U postgres -d postgres -t employees -t departments > tables_backup.sql
-- pg_dump -h localhost -U postgres -d postgres -Fc -v > backup_verbose.dump
-- pg_restore -h localhost -U postgres -d postgres backup.dump
-- createdb new_database
-- pg_restore -h localhost -U postgres -d new_database backup.dump
-- pg_restore -h localhost -U postgres -d postgres -t employees backup.dump
-- pg_restore -h localhost -U postgres -d postgres -j 4 backup.dump
-- pg_dump -h localhost -U postgres -d postgres -s > schema_only.sql
-- pg_dump -h localhost -U postgres -d postgres -a > data_only.sql
-- pg_dump -h localhost -U postgres -d postgres -T log_table -T temp_data > backup_without_logs.sql


-- =========================================================
-- 4. FULL DATABASE BACKUPS
-- =========================================================

-- pg_dumpall -h localhost -U postgres > full_cluster_backup.sql
-- pg_dump -h localhost -U postgres -d production_db -Fc --verbose > full_production_backup.dump
-- pg_dump -h localhost -U postgres -d postgres -Fc -O > backup_with_ownership.dump

-- Automated backup script example (Bash)
-- #!/bin/bash
-- DATE=$(date +%Y%m%d_%H%M%S)
-- BACKUP_DIR="/backups/postgresql"
-- DB_NAME="postgres"
-- pg_dump -h localhost -U postgres -d "$DB_NAME" -Fc > "$BACKUP_DIR/${DB_NAME}_${DATE}.dump"
-- find "$BACKUP_DIR" -name "${DB_NAME}_*.dump" -mtime +7 -delete

-- Backup validation
-- pg_restore --list backup.dump
-- createdb test_restore
-- pg_restore -d test_restore backup.dump


-- =========================================================
-- 5. INCREMENTAL BACKUPS
-- Configuration settings belong in postgresql.conf.
-- =========================================================

-- archive_mode = on
-- archive_command = 'cp %p /backup/wal/%f'
-- wal_level = replica

-- Base backup commands
-- pg_basebackup -h localhost -U postgres -D /backup/base -Ft -z -P
-- pg_basebackup -h localhost -U postgres -D /backup/base -x -P

-- Force WAL segment switch
SELECT pg_switch_wal();

-- WAL archive cleanup
-- pg_archivecleanup /backup/wal 000000010000000000000010


-- =========================================================
-- 6. POINT-IN-TIME RECOVERY (PITR)
-- =========================================================

-- Configuration settings in postgresql.conf:
-- wal_level = replica
-- archive_mode = on
-- archive_command = 'cp %p /backup/wal/%f'
-- restore_command = 'cp /backup/wal/%f %p'

-- Recovery commands for a configured Linux server:
-- sudo systemctl stop postgresql
-- rm -rf /var/lib/postgresql/data/*
-- tar -xf /backup/base/base.tar -C /var/lib/postgresql/data/
-- cat > /var/lib/postgresql/data/recovery.signal << EOF
-- restore_command = 'cp /backup/wal/%f %p'
-- recovery_target_time = '2024-01-15 14:30:00'
-- EOF
-- sudo systemctl start postgresql

-- Recovery targeting options:
-- recovery_target_time = '2024-01-15 14:30:00'
-- recovery_target_xid = '12345'
-- recovery_target_name = 'before_data_migration'

-- Create named restore point
SELECT pg_create_restore_point('before_data_migration');


-- =========================================================
-- 7. DATA MIGRATION STRATEGIES
-- =========================================================

-- Strategy 1: Dump and restore
-- pg_dump -h source_host -U postgres -d source_db -Fc > migration.dump
-- pg_restore -h target_host -U postgres -d target_db migration.dump

-- Strategy 2: Logical replication
-- On source database:
-- CREATE PUBLICATION migration_pub FOR ALL TABLES;

-- On target database:
-- CREATE SUBSCRIPTION migration_sub
-- CONNECTION 'host=source_host dbname=source_db user=replication_user'
-- PUBLICATION migration_pub;

-- Strategy 3: Physical replication
-- postgresql.conf on primary:
-- wal_level = replica
-- max_wal_senders = 3
-- pg_basebackup -h primary_host -D /var/lib/postgresql/standby -U replication_user -R -P

-- Strategy 4: ETL pipeline migration

-- Create staging table
CREATE TABLE staging_customers AS
SELECT * FROM customers WHERE 1=0;

-- Extract data in batches
COPY (
    SELECT * FROM customers LIMIT 10000 OFFSET 0
) TO '/tmp/customers_batch_1.csv' WITH CSV HEADER;

-- Transform and load
COPY staging_customers
FROM '/tmp/customers_batch_1.csv' WITH CSV HEADER;

-- Validate and merge
INSERT INTO target_customers
SELECT * FROM staging_customers
ON CONFLICT (customer_id) DO UPDATE SET
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    email = EXCLUDED.email;


-- =========================================================
-- 8. MIGRATION BEST PRACTICES
-- =========================================================

-- Verify source data integrity
SELECT COUNT(*) FROM source_table;

-- Test migration on smaller dataset:
-- pg_dump -h source -U postgres -d postgres -t small_table | psql -h target -U postgres -d postgres

-- Monitor migration progress
SELECT pid, usename, application_name, client_addr, state
FROM pg_stat_activity
WHERE application_name = 'pg_dump';

-- Post-migration validation
SELECT COUNT(*) FROM target_table;


-- =========================================================
-- 9. HANDLING LARGE TABLE MIGRATIONS
-- =========================================================

-- Create partitioned parent table if it does not exist
CREATE TABLE IF NOT EXISTS large_table (
    record_date DATE NOT NULL,
    value TEXT
) PARTITION BY RANGE (record_date);

-- Create 2023 partition
CREATE TABLE large_table_2023 PARTITION OF large_table
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Migrate partitions individually:
-- pg_dump -h source -U postgres -d postgres -t large_table_2023 | psql -h target -U postgres -d postgres