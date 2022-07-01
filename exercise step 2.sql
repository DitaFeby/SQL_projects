CREATE SCHEMA trading;

CREATE TABLE trading.members (
  `member_id` VARCHAR(6),
  `first_name` VARCHAR(7),
  `region` VARCHAR(13)
);

CREATE TABLE trading.prices (
  `ticker` VARCHAR(3),
  `market_date` DATE,
  `price` FLOAT,
  `open` FLOAT,
  `high` FLOAT,
  `low` FLOAT,
  `volume` VARCHAR(7),
  `change` VARCHAR(7)
);

CREATE TABLE trading.transactions (
  `txn_id` INTEGER,
  `member_id` VARCHAR(6),
  `ticker` VARCHAR(3),
  `txn_date` DATE,
  `txn_type` VARCHAR(4),
  `quantity` FLOAT,
  `percentage_fee` FLOAT,
  `txn_time` TIMESTAMP
);

/*
-- Creating these indexes after loading data
-- will make things run much faster!!!

CREATE INDEX ON trading.prices (ticker, market_date);
CREATE INDEX ON trading.transactions (txn_date, ticker);
CREATE INDEX ON trading.transactions (txn_date, member_id);
CREATE INDEX ON trading.transactions (member_id);
CREATE INDEX ON trading.transactions (ticker);

*/

#Show only the top 5 rows from the trading.members table#
SELECT * FROM trading.members LIMIT 5;

#Sort all the rows in the table by first_name in alphabetical order and show the top 3 rows#
SELECT * FROM trading.members
ORDER BY first_name ASC
LIMIT 3;

#Which records from trading.members are from the United States region?#
SELECT * FROM trading.members
WHERE region = 'United States';

#Select only the member_id and first_name columns for members who are not from Australia#
SELECT member_id, first_name FROM trading.members
WHERE region != 'Australia';

#Return the unique region values from the trading.members table and sort the output by reverse alphabetical order#
SELECT DISTINCT region FROM trading.members 
ORDER BY region DESC;

#How many mentors are there from Australia or the United States?#
SELECT COUNT(DISTINCT first_name) 
AS mentor_count
FROM trading.members 
WHERE region = 'Australia' OR region = 'United States';
#Other option#
SELECT
  COUNT(*) AS mentor_count
FROM trading.members
WHERE region IN ('Australia', 'United States');

#How many mentors are not from Australia or the United States?#
SELECT COUNT(*) AS mentor_count
FROM trading.members
WHERE region NOT IN ('Australia', 'United States');

#How many mentors are there per region? Sort the output by regions with the most mentors to the least#
SELECT region, 
COUNT(*) AS mentor_count
FROM trading.members
GROUP BY region
ORDER BY mentor_count DESC;

#How many US mentors and non US mentors are there?#
SELECT
	CASE
		WHEN region = 'United States' THEN 'United States'
		ELSE 'Non US'
	END AS mentor_region, 
COUNT(*) AS mentor_count
FROM trading.members
GROUP BY mentor_region;

#How many mentors have a first name starting with a letter before 'E'?#
SELECT first_name
FROM trading.members
WHERE LEFT(first_name, 1) < 'E';




