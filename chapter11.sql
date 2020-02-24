SELECT c.cust_id, c.fed_id, c.cust_type_cd,
CONCAT(i.fname, ' ', i.lname) indiv_name,
b.name business_name
FROM customer c LEFT OUTER JOIN individual i
ON c.cust_id = i.cust_id
LEFT OUTER JOIN business b
ON c.cust_id = b.cust_id;

-- searched case expression
SELECT c.cust_id, c.fed_id,
CASE
WHEN c.cust_type_cd = 'I'
THEN CONCAT(i.fname, ' ', i.lname)
WHEN c.cust_type_cd = 'B'
THEN b.name
ELSE 'Unknown'
END name
FROM customer c LEFT OUTER JOIN individual i
ON c.cust_id = i.cust_id
LEFT OUTER JOIN business b
ON c.cust_id = b.cust_id;

-- subqueries & case
SELECT c.cust_id, c.fed_id,
CASE
WHEN c.cust_type_cd = 'I' THEN
(SELECT CONCAT(i.fname, ' ', i.lname)
FROM individual i
WHERE i.cust_id = c.cust_id)
WHEN c.cust_type_cd = 'B' THEN
(SELECT b.name
FROM business b
WHERE b.cust_id = c.cust_id)
ELSE 'Unknown'
END name
FROM customer c;

-- simple case expression
-- doesn't run on mariadb!!!
CASE customer.cust_type_cd
WHEN 'I' THEN
(SELECT CONCAT(i.fname, ' ', i.lname)
FROM individual I
WHERE i.cust_id = customer.cust_id)
WHEN 'B' THEN
(SELECT b.name
FROM business b
WHERE b.cust_id = customer.cust_id)
ELSE 'Unknown Customer Type'
END

-- doesn't run on mariadb
SELECT
SUM(CASE
WHEN EXTRACT(YEAR
ELSE 0
END) year_2000,
SUM(CASE
WHEN EXTRACT(YEAR
ELSE 0
END) year_2001,
SUM(CASE
WHEN EXTRACT(YEAR
ELSE 0
END) year_2002,
SUM(CASE
WHEN EXTRACT(YEAR
ELSE 0
END) year_2003,
SUM(CASE
WHEN EXTRACT(YEAR
ELSE 0
END) year_2004,
SUM(CASE
WHEN EXTRACT(YEAR
ELSE 0
END) year_2005
FROM account
WHERE open_date > '1999-12-31' AND open_date < '2006-01-01';

-- that's OK
SELECT c.cust_id, c.fed_id, c.cust_type_cd,
CASE
WHEN EXISTS (SELECT 1 FROM account a
WHERE a.cust_id = c.cust_id
AND a.product_cd = 'CHK') THEN 'Y'
ELSE 'N'
END has_checking,
CASE
WHEN EXISTS (SELECT 1 FROM account a
WHERE a.cust_id = c.cust_id
AND a.product_cd = 'SAV') THEN 'Y'
ELSE 'N'
END has_savings
FROM customer c;

SELECT c.cust_id, c.fed_id, c.cust_type_cd,
CASE (SELECT COUNT(*) FROM account a
WHERE a.cust_id = c.cust_id)
WHEN 0 THEN 'None'
WHEN 1 THEN '1'
WHEN 2 THEN '2'
ELSE '3+'
END num_accounts
FROM customer c;

-- protect against division by zero error
SELECT a.cust_id, a.product_cd, a.avail_balance /
CASE
WHEN prod_tots.tot_balance = 0 THEN 1
ELSE prod_tots.tot_balance
END percent_of_total
FROM account a INNER JOIN
(SELECT a.product_cd, SUM(a.avail_balance) tot_balance
FROM account a
GROUP BY a.product_cd) prod_tots
ON a.product_cd = prod_tots.product_cd;

-- conditional update DOESN'T WORK on mariadb
UPDATE account
SET last_activity_date = CURRENT_TIMESTAMP(),
pending_balance = pending_balance +
(SELECT t.amount *
CASE t.txn_type_cd WHEN 'DBT' THEN −1 ELSE 1 END
FROM transaction t
WHERE t.txn_id = 999),
avail_balance = avail_balance +
(SELECT
CASE
WHEN t.funds_avail_date > CURRENT_TIMESTAMP() THEN 0
ELSE t.amount *
CASE t.txn_type_cd WHEN 'DBT' THEN −1 ELSE 1 END
END
FROM transaction t
WHERE t.txn_id = 999)
WHERE account.account_id =
(SELECT t.account_id
FROM transaction t
WHERE t.txn_id = 999);

-- handling null values
