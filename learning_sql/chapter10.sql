SELECT account_id, cust_id
FROM account;

SELECT cust_id
FROM customer;

SELECT a.account_id, c.cust_id
FROM account a INNER JOIN customer c
ON a.cust_id = c.cust_id;

SELECT a.account_id, b.cust_id, b.name
FROM account a INNER JOIN business b
ON a.cust_id = b.cust_id;

SELECT cust_id, name
FROM business;

SELECT a.account_id, a.cust_id, b.name
FROM account a LEFT OUTER JOIN business b
ON a.cust_id = b.cust_id;

SELECT a.account_id, a.cust_id, i.fname, i.lname
FROM account a LEFT OUTER JOIN individual i
ON a.cust_id = i.cust_id;

SELECT c.cust_id, b.name
FROM customer c LEFT OUTER JOIN business b
ON c.cust_id = b.cust_id;

SELECT c.cust_id, b.name
FROM customer c RIGHT OUTER JOIN business b
ON c.cust_id = b.cust_id;

SELECT a.account_id, a.product_cd,
CONCAT(i.fname, ' ', i.lname) person_name,
b.name business_name
FROM account a LEFT OUTER JOIN individual i
ON a.cust_id = i.cust_id
LEFT OUTER JOIN business b
ON a.cust_id = b.cust_id;

-- self outer joins
SELECT e.fname, e.lname,
e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
FROM employee e INNER JOIN employee e_mgr
ON e.superior_emp_id = e_mgr.emp_id;

SELECT e.fname, e.lname,
e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
FROM employee e LEFT OUTER JOIN employee e_mgr
ON e.superior_emp_id = e_mgr.emp_id;

SELECT e.fname, e.lname,
e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
FROM employee e RIGHT OUTER JOIN employee e_mgr
ON e.superior_emp_id = e_mgr.emp_id;

-- cross joins
SELECT pt.name, p.product_cd, p.name
FROM product p CROSS JOIN product_type pt;

-- natural joins
SELECT a.account_id, a.cust_id, c.cust_type_cd, c.fed_id
FROM account a NATURAL JOIN customer c;