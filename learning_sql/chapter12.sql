-- show storage engine
SHOW TABLE STATUS;

-- change storage engine
ALTER TABLE officer ENGINE = INNODB;

-- create a savepoint
SAVEPOINT my_savepoint;

ROLLBACK TO SAVEPOINT my_savepoint;

START TRANSACTION;
UPDATE product
SET date_retired = CURRENT_TIMESTAMP()
WHERE product_cd = 'XYZ';
SAVEPOINT before_close_accounts;
UPDATE account
SET status = 'CLOSED', close_date = CURRENT_TIMESTAMP(),
last_activity_date = CURRENT_TIMESTAMP()
WHERE product_cd = 'XYZ';
ROLLBACK TO SAVEPOINT before_close_accounts;
COMMIT;