# Notes
## Start MariaDB and phpMyAdmin
``
docker-compose up -d
``
## Getting on the container
``
docker exec -it learnsql_mariadb_1 /bin/bash
``

+ start mysql
``mysql -u root -p``
+ use the example database created at chapter 2
``USE learnsql;``
## You can run your SQL statements in phpMyAdmin

## Books used
+ Alan Beaulieu Learning SQL 2nd edition
+ Myers - Copeland: Essential SQLAlchemy, 2nd edition