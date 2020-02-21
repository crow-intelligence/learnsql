SELECT open_emp_id
FROM account;

-- who opened an account
SELECT open_emp_id
FROM account
GROUP BY open_emp_id;

-- how many account belongs to each
SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id;

SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id
HAVING COUNT(*) > 4;

SELECT MAX(avail_balance) max_balance,
MIN(avail_balance) min_balance,
AVG(avail_balance) avg_balance,
SUM(avail_balance) tot_balance,
COUNT(*) num_accounts
FROM account
WHERE product_cd = 'CHK';

SELECT product_cd,
MAX(avail_balance) max_balance,
MIN(avail_balance) min_balance,
AVG(avail_balance) avg_balance,
SUM(avail_balance) tot_balance,
COUNT(*) num_accts
FROM account
GROUP BY product_cd;

SELECT account_id, open_emp_id
FROM account
ORDER BY open_emp_id;

-- count rows
SELECT COUNT(open_emp_id)
FROM account;

-- count distinct elements
SELECT COUNT(DISTINCT open_emp_id)
FROM account;

SELECT MAX(pending_balance - avail_balance) max_uncleared
FROM account;

CREATE TABLE number_tbl
(val SMALLINT);
INSERT INTO number_tbl VALUES (1);
INSERT INTO number_tbl VALUES (3);
INSERT INTO number_tbl VALUES (5);

SELECT COUNT(*) num_rows,
COUNT(val) num_vals,
SUM(val) total,
MAX(val) max_val,
AVG(val) avg_val
FROM number_tbl;

INSERT INTO number_tbl VALUES (NULL);
-- NULL is dangerous
SELECT COUNT(*) num_rows,
COUNT(val) num_vals,
SUM(val) total,
MAX(val) max_val,
AVG(val) avg_val
FROM number_tbl;

-- single-column grouping
SELECT product_cd, SUM(avail_balance) prod_balance
FROM account
GROUP BY product_cd;
-- multicolumn grouping
SELECT product_cd, open_branch_id,
SUM(avail_balance) tot_balance
FROM account
GROUP BY product_cd, open_branch_id;

-- grouping via expressions
SELECT EXTRACT(YEAR FROM start_date) year,
COUNT(*) how_many
FROM employee
GROUP BY EXTRACT(YEAR FROM start_date);

-- use ROLLUP for sum by category
SELECT product_cd, open_branch_id,
SUM(avail_balance) tot_balance
FROM account
GROUP BY product_cd, open_branch_id WITH ROLLUP;

SELECT product_cd, SUM(avail_balance) prod_balance
FROM account
WHERE status = 'ACTIVE'
GROUP BY product_cd
HAVING SUM(avail_balance) >= 10000;

SELECT 'Small Fry' name, 0 low_limit, 4999.99 high_limit
UNION ALL
SELECT 'Average Joes' name, 5000 low_limit, 9999.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 10000 low_limit, 9999999.99 high_limit;


SELECT groups.name, COUNT(*) num_customers
FROM
(SELECT SUM(a.avail_balance) cust_balance
FROM account a INNER JOIN product p
ON a.product_cd = p.product_cd
WHERE p.product_type_cd = 'ACCOUNT'
GROUP BY a.cust_id) cust_rollup
INNER JOIN
(SELECT 'Small Fry' name, 0 low_limit, 4999.99 high_limit
UNION ALL
SELECT 'Average Joes' name, 5000 low_limit,
9999.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 10000 low_limit,
9999999.99 high_limit) groups
ON cust_rollup.cust_balance
BETWEEN groups.low_limit AND groups.high_limit
GROUP BY groups.name;

SELECT p.name product, b.name branch,
CONCAT(e.fname, ' ', e.lname) name,
SUM(a.avail_balance) tot_deposits
FROM account a INNER JOIN employee e
ON a.open_emp_id = e.emp_id
INNER JOIN branch b
ON a.open_branch_id = b.branch_id
INNER JOIN product p
ON a.product_cd = p.product_cd
WHERE p.product_type_cd = 'ACCOUNT'
GROUP BY p.name, b.name, e.fname, e.lname
ORDER BY 1,2;


