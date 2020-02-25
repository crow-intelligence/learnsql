-- create a view
CREATE VIEW customer_vw
(cust_id,
fed_id,
cust_type_cd,
address,
city,
state,
zipcode
)
AS
SELECT cust_id,
concat('ends in ', substr(fed_id, 8, 4)) fed_id,
cust_type_cd,
address,
city,
state,
postal_code
FROM customer;

-- query a view
SELECT cust_id, fed_id, cust_type_cd
FROM customer_vw;

-- views are just like tables
DESC customer_vw;


CREATE VIEW customer_totals_vw
(cust_id,
cust_type_cd,
cust_name,
num_accounts,
tot_deposits
)
AS
SELECT cst.cust_id, cst.cust_type_cd,
CASE
WHEN cst.cust_type_cd = 'B' THEN
(SELECT bus.name FROM business bus WHERE bus.cust_id = cst.cust_id)
ELSE
(SELECT concat(ind.fname, ' ', ind.lname)
FROM individual ind
WHERE ind.cust_id = cst.cust_id)
END cust_name,
sum(CASE WHEN act.status = 'ACTIVE' THEN 1 ELSE 0 END) tot_active_accounts,
sum(CASE WHEN act.status = 'ACTIVE' THEN act.avail_balance ELSE 0 END) tot_balance
FROM customer cst INNER JOIN account act
ON act.cust_id = cst.cust_id
GROUP BY cst.cust_id, cst.cust_type_cd;
-- create a table, when performance issues arise
CREATE TABLE customer_totals
AS
SELECT * FROM customer_totals_vw;
-- place the view on the new table
CREATE OR REPLACE VIEW customer_totals_vw
(cust_id,
cust_type_cd,
cust_name,
num_accounts,
tot_deposits
)
AS
SELECT cust_id, cust_type_cd, cust_name, num_accounts, tot_deposits
FROM customer_totals;