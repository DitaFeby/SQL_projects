SELECT * FROM trading.prices
WHERE ticker = 'BTC' LIMIT 3;

SELECT * FROM trading.prices
WHERE ticker = 'ETH' LIMIT 3;

#How many total records do we have in the trading.prices table?#
SELECT COUNT(*) AS total_records FROM trading.prices;

#How many records are there per ticker value?#
SELECT ticker, COUNT(*) AS record_count FROM trading.prices
GROUP BY ticker
ORDER BY ticker ASC;

#What is the minimum and maximum market_date values?#
SELECT 
	MIN(market_date) AS 'min_date',
	MAX(market_date) AS 'max_date'
FROM trading.prices;

#Are there differences in the minimum and maximum market_date values for each ticker?#
SELECT ticker,
	MIN(market_date) AS 'min_date',
	MAX(market_date) AS 'max_date'
FROM trading.prices
GROUP BY ticker;

#What is the average of the price column for Bitcoin records during the year 2020?#
SELECT AVG(price) AS 'avg' FROM trading.prices
WHERE ticker = 'BTC'
	AND market_date BETWEEN '2020-01-01' AND '2020-12-31';

#What is the monthly average of the price column for Ethereum in 2020?# 
#Sort the output in chronological order and also round the average price value to 2 decimal places#
SELECT MONTH(market_date) AS 'month_start',
	ROUND(AVG(price), 2) AS 'average_eth_price' 
FROM trading.prices
WHERE ticker = 'ETH'
	AND EXTRACT(YEAR FROM market_date) = 2020
GROUP BY month_start
ORDER BY month_start;

#Are there any duplicate market_date values for any ticker value in our table?#
SELECT ticker,
COUNT(market_date) AS 'total_count',
COUNT(DISTINCT market_date) AS 'unique_count'
FROM trading.prices
GROUP BY ticker;

#How many days from the trading.prices table exist where the high price of Bitcoin is over $30,000?#
SELECT COUNT(market_date) AS 'row_count' FROM trading.prices
WHERE ticker = 'BTC'
	AND high > 30000;

#How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker?#
SELECT ticker,
SUM(
	CASE WHEN price > open
	THEN 1 ELSE 0 END
) AS breakout_days
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
GROUP BY ticker;
 
#How many "non_breakout" days were there in 2020 where the price column is less than the open column for each ticker?#
SELECT ticker,
SUM(CASE WHEN price < open THEN 1 ELSE 0 END) AS 'non_breakout_days'
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
GROUP BY ticker;

#What percentage of days in 2020 were breakout days vs non-breakout days? Round the percentages to 2 decimal places#
SELECT ticker,
	ROUND(SUM(CASE WHEN price > open
	THEN 1 ELSE 0 END)
    / COUNT(*),2) AS breakout_percentage,
		ROUND(SUM(CASE WHEN price < open
		THEN 1 ELSE 0 END)
		/ COUNT(*),2) AS nonbreakout_percentage
FROM trading.prices
WHERE EXTRACT(YEAR FROM market_date) = 2020
GROUP BY ticker; 




















