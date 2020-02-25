-- table scan
SELECT dept_id, name
FROM department
WHERE name LIKE 'A%';

-- create index
ALTER TABLE department
ADD INDEX dept_name_idx (name);

SHOW INDEX FROM department;

ALTER TABLE department
DROP INDEX dept_name_idx;

-- unique indexes
ALTER TABLE department
ADD UNIQUE dept_name_idx (name);

-- multicolumn indexes, order matters a lot!!!!
ALTER TABLE employee
ADD INDEX emp_names_idx (lname, fname);

-- bitmap is not available on Mariadb
CREATE BITMAP INDEX acc_prod_idx ON account (product_cd);

-- explain
EXPLAIN SELECT cust_id, SUM(avail_balance) tot_bal
FROM account
WHERE cust_id IN (1, 5, 9, 11)
GROUP BY cust_id

ALTER TABLE account
ADD INDEX acc_bal_idx (cust_id, avail_balance);

-- constraints
CREATE TABLE product
(product_cd VARCHAR(10) NOT NULL,
name VARCHAR(50) NOT NULL,
product_type_cd VARCHAR (10) NOT NULL,
date_offered DATE,
date_retired DATE,
CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd)
REFERENCES product_type (product_type_cd),
CONSTRAINT pk_product PRIMARY KEY (product_cd)
);

