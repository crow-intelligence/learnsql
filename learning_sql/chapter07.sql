CREATE TABLE string_tbl
(char_fld CHAR(30),
vchar_fld VARCHAR(30),
text_fld TEXT
);

INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
VALUES ('This is char data',
'This is varchar data',
'This is text data');

-- error
UPDATE string_tbl
SET vchar_fld = 'This is a piece of extremely long varchar data';

UPDATE string_tbl
SET text_fld = 'This string doesn't work';

UPDATE string_tbl
SET text_fld = 'This string didn''t work, but it does now';

SELECT text_fld
FROM string_tbl;

SELECT quote(text_fld)
FROM string_tbl;

DELETE FROM string_tbl;

INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
VALUES ('This string is 28 characters',
'This string is 28 characters',
'This string is 28 characters');

SELECT LENGTH(char_fld) char_length,
LENGTH(vchar_fld) varchar_length,
LENGTH(text_fld) text_length
FROM string_tbl;

SELECT POSITION('characters' IN vchar_fld)
FROM string_tbl;

SELECT name, name LIKE '%ns' ends_in_ns
FROM department;

SELECT cust_id, cust_type_cd, fed_id,
fed_id REGEXP '.{3}-.{2}-.{4}' is_ss_no_format
FROM customer;

DELETE FROM string_tbl;

INSERT INTO string_tbl (text_fld)
VALUES ('This string was 29 characters');

UPDATE string_tbl
SET text_fld = CONCAT(text_fld, ', but now it is longer');

SELECT text_fld
FROM string_tbl;

SELECT CONCAT(fname, ' ', lname, ' has been a ',
title, ' since ', start_date) emp_narrative
FROM employee
WHERE title = 'Teller' OR title = 'Head Teller';

SELECT INSERT('goodbye world', 9, 0, 'cruel ') string;
SELECT INSERT('goodbye world', 1, 7, 'hello') string;

SELECT REPLACE('goodbye world', 'goodbye', 'hello') replacer;

SELECT SUBSTRING('goodbye cruel world', 9, 5);

SELECT (37 * 59) / (78 - (8 * 6));
SELECT MOD(10,4);
SELECT MOD(22.75, 5);
SELECT POW(2,8);

SELECT POW(2,10) kilobyte, POW(2,20) megabyte,
POW(2,30) gigabyte, POW(2,40) terabyte;

SELECT CEIL(72.000000001) celil, FLOOR(72.999999999) floor;
SELECT ROUND(72.49999), ROUND(72.5), ROUND(72.50001);
SELECT ROUND(72.0909, 1), ROUND(72.0909, 2), ROUND(72.0909, 3);
SELECT TRUNCATE(72.0909, 1), TRUNCATE(72.0909, 2),
TRUNCATE(72.0909, 3);

SELECT account_id, SIGN(avail_balance), ABS(avail_balance)
FROM account;

UPDATE transaction
SET txn_date = '2008-09-17 15:30:00'
WHERE txn_id = 99999;

SELECT CAST('2008-09-17 15:30:00' AS DATETIME);

SELECT CAST('2008-09-17' AS DATE) date_field,
CAST('108:17:57' AS TIME) time_field;

UPDATE individual
SET birth_date = STR_TO_DATE('September 17, 2008', '%M %d, %Y')
WHERE cust_id = 9999;
SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP();

UPDATE transaction
SET txn_date = DATE_ADD(txn_date, INTERVAL '3:27:11' HOUR_SECOND)
WHERE txn_id = 9999;

SELECT LAST_DAY('2008-09-17');
SELECT CURRENT_TIMESTAMP() current_est,
CONVERT_TZ(CURRENT_TIMESTAMP(), 'CET', 'UTC') current_utc;

SELECT DAYNAME('2008-09-18');
SELECT EXTRACT(YEAR FROM '2008-09-18 22:19:05');
SELECT DATEDIFF('2020-02-21', '1981-11-18')

SELECT CAST('1456328' AS SIGNED INTEGER);
SELECT CAST('999ABC111' AS UNSIGNED INTEGER);

