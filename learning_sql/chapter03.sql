/* create tables */

create table department
 (dept_id smallint unsigned not null auto_increment,
  name varchar(20) not null,
  constraint pk_department primary key (dept_id)
 );

create table branch
 (branch_id smallint unsigned not null auto_increment,
  name varchar(20) not null,
  address varchar(30),
  city varchar(20),
  state varchar(2),
  zip varchar(12),
  constraint pk_branch primary key (branch_id)
 );

create table employee
 (emp_id smallint unsigned not null auto_increment,
  fname varchar(20) not null,
  lname varchar(20) not null,
  start_date date not null,
  end_date date,
  superior_emp_id smallint unsigned,
  dept_id smallint unsigned,
  title varchar(20),
  assigned_branch_id smallint unsigned,
  constraint fk_e_emp_id
    foreign key (superior_emp_id) references employee (emp_id),
  constraint fk_dept_id
    foreign key (dept_id) references department (dept_id),
  constraint fk_e_branch_id
    foreign key (assigned_branch_id) references branch (branch_id),
  constraint pk_employee primary key (emp_id)
 );

create table product_type
 (product_type_cd varchar(10) not null,
  name varchar(50) not null,
  constraint pk_product_type primary key (product_type_cd)
 );

create table product
 (product_cd varchar(10) not null,
  name varchar(50) not null,
  product_type_cd varchar(10) not null,
  date_offered date,
  date_retired date,
  constraint fk_product_type_cd foreign key (product_type_cd)
    references product_type (product_type_cd),
  constraint pk_product primary key (product_cd)
 );

create table customer
 (cust_id integer unsigned not null auto_increment,
  fed_id varchar(12) not null,
  cust_type_cd enum('I','B') not null,
  address varchar(30),
  city varchar(20),
  state varchar(20),
  postal_code varchar(10),
  constraint pk_customer primary key (cust_id)
 );

create table individual
 (cust_id integer unsigned not null,
  fname varchar(30) not null,
  lname varchar(30) not null,
  birth_date date,
  constraint fk_i_cust_id foreign key (cust_id)
    references customer (cust_id),
  constraint pk_individual primary key (cust_id)
 );

create table business
 (cust_id integer unsigned not null,
  name varchar(40) not null,
  state_id varchar(10) not null,
  incorp_date date,
  constraint fk_b_cust_id foreign key (cust_id)
    references customer (cust_id),
  constraint pk_business primary key (cust_id)
 );

create table officer
 (officer_id smallint unsigned not null auto_increment,
  cust_id integer unsigned not null,
  fname varchar(30) not null,
  lname varchar(30) not null,
  title varchar(20),
  start_date date not null,
  end_date date,
  constraint fk_o_cust_id foreign key (cust_id)
    references business (cust_id),
  constraint pk_officer primary key (officer_id)
 );

create table account
 (account_id integer unsigned not null auto_increment,
  product_cd varchar(10) not null,
  cust_id integer unsigned not null,
  open_date date not null,
  close_date date,
  last_activity_date date,
  status enum('ACTIVE','CLOSED','FROZEN'),
  open_branch_id smallint unsigned,
  open_emp_id smallint unsigned,
  avail_balance float(10,2),
  pending_balance float(10,2),
  constraint fk_product_cd foreign key (product_cd)
    references product (product_cd),
  constraint fk_a_cust_id foreign key (cust_id)
    references customer (cust_id),
  constraint fk_a_branch_id foreign key (open_branch_id)
    references branch (branch_id),
  constraint fk_a_emp_id foreign key (open_emp_id)
    references employee (emp_id),
  constraint pk_account primary key (account_id)
 );

create table transaction
 (txn_id integer unsigned not null auto_increment,
  txn_date datetime not null,
  account_id integer unsigned not null,
  txn_type_cd enum('DBT','CDT'),
  amount double(10,2) not null,
  teller_emp_id smallint unsigned,
  execution_branch_id smallint unsigned,
  funds_avail_date datetime,
  constraint fk_t_account_id foreign key (account_id)
    references account (account_id),
  constraint fk_teller_emp_id foreign key (teller_emp_id)
    references employee (emp_id),
  constraint fk_exec_branch_id foreign key (execution_branch_id)
    references branch (branch_id),
  constraint pk_transaction primary key (txn_id)
 );

/* changes charset for database */
ALTER DATABASE bank COLLATE = 'utf8_general_ci';
-- only show in command line, phpMyAdmin doesn't refresh
SHOW CREATE DATABASE bank;

SELECT emp_id, fname, lname
FROM employee
WHERE lname = 'Bkadfl';

SELECT fname, lname
FROM employee;

SELECT * FROM department;
SELECT name FROM department;

SELECT emp_id, 'AMFSADA', emp_id * 3.14159, UPPER(lname) FROM employee;

-- FROM can be omitted if we call funcitons and nothing else
SELECT VERSION(),
USER(),
DATABASE();

-- alias
-- without alias
SELECT emp_id,
'ACTIVE' status,
emp_id * 3.14159 empid_x_pi,
UPPER(lname) last_name_upper
FROM employee;
-- same as above, but explicit alias
SELECT emp_id,
'ACTIVE' AS status,
emp_id * 3.14159 AS empid_x_pi,
UPPER(lname) AS last_name_upper
FROM employee;

-- distinct
SELECT cust_id
FROM account;

SELECT DISTINCT cust_id
FROM account;

-- subquery-generated table
SELECT e.emp_id, e.fname, e.lname
FROM (SELECT emp_id, fname, lname, start_date, title
FROM employee) e;

-- views
CREATE VIEW employee_vw AS
SELECT emp_id, fname, lname,
YEAR(start_date) start_year
FROM employee;

-- query a view
SELECT emp_id, start_year
FROM employee_vw;

-- table links
SELECT employee.emp_id, employee.fname,
employee.lname, department.name dept_name
FROM employee INNER JOIN department
ON employee.dept_id = department.dept_id;

-- table aliases
SELECT e.emp_id, e.fname, e.lname,
d.name dept_name
FROM employee e INNER JOIN department d
ON e.dept_id = d.dept_id;
-- OR
SELECT e.emp_id, e.fname, e.lname,
d.name dept_name
FROM employee AS e INNER JOIN department AS d
ON e.dept_id = d.dept_id;

-- WHERE
SELECT emp_id, fname, lname, start_date, title
FROM employee
WHERE title = 'Head Teller';
-- AND
SELECT emp_id, fname, lname, start_date, title
FROM employee
WHERE title = 'Head Teller'
AND start_date > '2006-01-01';
-- OR
SELECT emp_id, fname, lname, start_date, title
FROM employee
WHERE title = 'Head Teller'
OR start_date > '2006-01-01';

SELECT emp_id, fname, lname, start_date, title
FROM employee
WHERE (title = 'Head Teller' AND start_date > '2006-01-01')
OR (title = 'Teller' AND start_date > '2007-01-01');

-- GROUP BY & HAVING
SELECT d.name, count(e.emp_id) num_employees
FROM department d INNER JOIN employee e
ON d.dept_id = e.dept_id
GROUP BY d.name
HAVING count(e.emp_id) > 2;

-- ORDER BY
SELECT open_emp_id, product_cd
FROM account
ORDER BY open_emp_id;

SELECT open_emp_id, product_cd
FROM account
ORDER BY open_emp_id, product_cd;

SELECT account_id, product_cd, open_date, avail_balance
FROM account
ORDER BY avail_balance DESC;

SELECT cust_id, cust_type_cd, city, state, fed_id
FROM customer
ORDER BY RIGHT(fed_id, 3);

-- order by column id
SELECT emp_id, title, start_date, fname, lname
FROM employee
ORDER BY 2, 5;