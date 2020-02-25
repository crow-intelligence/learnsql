SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'learnsql'
ORDER BY 1;

SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'learnsql' AND table_type = 'BASE TABLE'
ORDER BY 1;

SELECT table_name, is_updatable
FROM information_schema.views
WHERE table_schema = 'learnsql'
ORDER BY 1;

SELECT column_name, data_type, character_maximum_length char_max_len,
numeric_precision num_prcsn, numeric_scale num_scale
FROM information_schema.columns
WHERE table_schema = 'learnsql' AND table_name = 'account'
ORDER BY ordinal_position;

SELECT index_name, non_unique, seq_in_index, column_name
FROM information_schema.statistics
WHERE table_schema = 'learnsql' AND table_name = 'account'
ORDER BY 1, 3;

SELECT constraint_name, table_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'learnsql'
ORDER BY 3,1;

-- deployment verification
SELECT tbl.table_name,
(SELECT count(*) FROM information_schema.columns clm
WHERE clm.table_schema = tbl.table_schema
AND clm.table_name = tbl.table_name) num_columns,
(SELECT count(*) FROM information_schema.statistics sta
WHERE sta.table_schema = tbl.table_schema
AND sta.table_name = tbl.table_name) num_indexes,
(SELECT count(*) FROM information_schema.table_constraints tc
WHERE tc.table_schema = tbl.table_schema
AND tc.table_name = tbl.table_name
AND tc.constraint_type = 'PRIMARY KEY') num_primary_keys
FROM information_schema.tables tbl
WHERE tbl.table_schema = 'learnsql' AND tbl.table_type = 'BASE TABLE'
ORDER BY 1;

-- dynamic sql execution
-- should be executed after each other, use the console, not phpmyadmin!!!
SET @qry = 'SELECT cust_id, cust_type_cd, fed_id FROM customer';
PREPARE dynsql1 FROM @qry;
EXECUTE dynsql1;