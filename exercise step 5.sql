#What is the earliest and latest date of transactions for all members?
SELECT
	MIN(txn_date) AS earliest_date,
    MAX(txn_date) AS latest_date
FROM trading.transactions;

#What is the range of market_date values available in the prices data?
SELECT
	MIN(market_date) AS earliest_date,
    MAX(market_date) AS latest_date
FROM trading.prices;

##### JOINING DATASET #####
# SELECT column_list
# FROM table1
# JOIN table2
# ON table1.column_name = table2.column_name

#Which top 3 mentors have the most Bitcoin quantity as of the 29th of August?
SELECT members.first_name,
SUM(CASE 
	WHEN transactions.txn_type = 'BUY' THEN transactions.quantity
	WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity 
    END)
AS total_quantity
FROM trading.members
JOIN trading.transactions
ON members.member_id = transactions.member_id
WHERE ticker = 'BTC'
GROUP BY first_name
ORDER BY total_quantity DESC
LIMIT 3;