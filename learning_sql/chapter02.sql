CREATE DATABASE learnsql;

USE learnsql;

CREATE TABLE person
(person_id SMALLINT UNSIGNED AUTO_INCREMENT,
fname VARCHAR(20),
lname VARCHAR(20),
gender ENUM('M','F'),
birth_date DATE,
street VARCHAR(30),
city VARCHAR(20),
state VARCHAR(20),
country VARCHAR(20),
postal_code VARCHAR(20),
CONSTRAINT pk_person PRIMARY KEY (person_id)
);

DESC person;

CREATE TABLE favorite_food
(person_id SMALLINT UNSIGNED,
food VARCHAR(20),
CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id)
REFERENCES person (person_id)
);

DROP TABLE person;
DROP TABLE favorite_food;
# doesn't work on my mariadb!!!
ALTER TABLE person MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;

INSERT INTO person
(person_id, fname, lname, gender, birth_date)
VALUES (null, 'William','Turner', 'M', '1972-05-27');

SELECT person_id, fname, lname, birth_date
FROM person;

SELECT person_id, fname, lname, birth_date
FROM person
WHERE person_id = 1;

SELECT person_id, fname, lname, birth_date
FROM person
WHERE lname = 'Turner';

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'pizza');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'cookies');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'nachos');

SELECT food
FROM favorite_food
WHERE person_id = 1
ORDER BY food;

INSERT INTO person
(person_id, fname, lname, gender, birth_date, street, city, state, country, postal_code)
VALUES (null, 'Susan','Smith', 'F', '1975-11-02', '23 Maple St.', 'Arlington', 'VA', 'USA', '20220');

SELECT person_id, fname, lname, birth_date
FROM person;

UPDATE person
SET street = '1225 Tremont St.',
city = 'Boston',
state = 'MA',
country = 'USA',
postal_code = '02138'
WHERE person_id = 1;

DELETE FROM person
WHERE person_id = 2;

# nonunique primary key
INSERT INTO person
(person_id, fname, lname, gender, birth_date)
VALUES (1, 'Charles','Fulton', 'M', '1968-01-15');

# Nonexistent Foreign Key
INSERT INTO favorite_food (person_id, food)
VALUES (999, 'lasagna');

# Column Value Violations
UPDATE person
SET gender = 'Z'
WHERE person_id = 1;

#Invalid Date Conversions
UPDATE person
SET birth_date = 'DEC-21-1980'
WHERE person_id = 1;

# dateformatting
UPDATE person
SET birth_date = str_to_date('DEC-21-1980' , '%b-%d-%Y')
WHERE person_id = 1;