# inspect the most recent 10 transactions by member_id = 'c4ca42'#
SELECT * FROM trading.transactions
WHERE member_id = 'c4ca42'
ORDER BY txn_time DESC
LIMIT 10;

#How many records are there in the trading.transactions table?#
SELECT COUNT(*) FROM trading.transactions;

#How many unique transactions are there?#
SELECT DISTINCT COUNT(*) FROM trading.transactions;

#How many buy and sell transactions are there for Bitcoin?#
SELECT txn_type,
COUNT(*) AS transaction_count 
FROM trading.transactions
WHERE ticker = 'BTC'
GROUP BY txn_type;

#For each year, calculate the following buy and sell metrics for Bitcoin: total transaction count, total quantity, average quantity per transaction
#Also round the quantity columns to 2 decimal places.
SELECT EXTRACT(YEAR FROM txn_date) AS txn_year,
	txn_type,
	COUNT(*) AS transaction_count,
    ROUND(SUM(quantity), 2) AS total_quantity,
    ROUND(AVG(quantity), 2) AS average_quantity
FROM trading.transactions
WHERE ticker = 'BTC'
GROUP BY txn_type, txn_year;

#What was the monthly total quantity purchased and sold for Ethereum in 2020?#
SELECT 
	EXTRACT(MONTH FROM txn_date) AS calender_month,
	SUM(CASE WHEN txn_type = 'BUY' THEN quantity ELSE 0 END) AS buy_quantity,
	SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END) AS sell_quantity
FROM trading.transactions
WHERE ticker = 'ETH' 
AND txn_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY calender_month;

#Summarise all buy and sell transactions for each member_id 
#by generating 1 row for each member with the following additional columns: 
#Bitcoin buy quantity, Bitcoin sell quantity, Ethereum buy quantity, Ethereum sell quantity
SELECT member_id,
	SUM(CASE WHEN txn_type = 'BUY' AND ticker = 'BTC' THEN quantity ELSE 0 END) AS btc_buy_quantity,
    SUM(CASE WHEN txn_type = 'SELL' AND ticker = 'BTC' THEN quantity ELSE 0 END) AS btc_sell_quantity,
    SUM(CASE WHEN txn_type = 'BUY' AND ticker = 'ETH' THEN quantity ELSE 0 END) AS eth_buy_quantity,
    SUM(CASE WHEN txn_type = 'SELL' AND ticker = 'ETH' THEN quantity ELSE 0 END) AS eth_sell_quantity
FROM trading.transactions
GROUP BY member_id;

#What was the final quantity holding of Bitcoin for each member? Sort the output from the highest BTC holding to lowest
SELECT member_id,
	SUM(CASE WHEN txn_type = 'BUY' THEN quantity
		WHEN txn_type = 'SELL' THEN -quantity
        ELSE 0 END)
	AS final_btc_holding
FROM trading.transactions
WHERE ticker = 'BTC'
GROUP BY member_id;

#Which members have sold less than 500 Bitcoin? Sort the output from the most BTC sold to least
SELECT member_id,
	SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END) AS btc_sold_quantity
FROM trading.transactions
WHERE ticker = 'BTC'
GROUP BY member_id 
HAVING btc_sold_quantity < 500
ORDER BY btc_sold_quantity DESC;

#Which member_id has the highest buy to sell ratio by quantity?
SELECT member_id,
	SUM(CASE WHEN txn_type = 'BUY' THEN quantity ELSE 0 END) /
    SUM(CASE WHEN txn_type = 'SELL' THEN quantity ELSE 0 END)
AS buy_to_sell_ratio
FROM trading.transactions
GROUP BY member_id;
