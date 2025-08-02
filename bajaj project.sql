USE new_data;

select *
from `bajaj-2003-2020`
;

-- Create a cleaned version of the table

CREATE TABLE bajaj_adjust AS
SELECT
  STR_TO_DATE(Date, '%d-%b-%Y') AS trade_date,
  `Prev Close`,
  `Open Price`,
  `High Price`,
  `Low Price`,
  `Close Price`,
  `Total Traded Quantity`,
  Turnover
FROM `bajaj-2003-2020`
;

-- Q9. Days when stock opened lower than previous close but closed higher than open
SELECT
  trade_date,
  `Prev Close`,
  `Open Price`,
  `Close Price`
FROM bajaj_adjust
WHERE `Open Price` < `Prev Close`
  AND `Close Price` > `Open Price`
  ;
-- Q10. Dates when stock reached or exceeded ₹1000 during the day

SELECT
  trade_date,
  `High Price`
FROM bajaj_adjust
WHERE `High Price` >= 1000
ORDER BY trade_date
;

-- Traded < 1,000 units but Turnover > ₹50,000
SELECT
  trade_date,
  `Total Traded Quantity`,
  Turnover
FROM bajaj_adjust
WHERE `Total Traded Quantity` < 1000
  AND Turnover > 50000;
  
  -- Days where daily price range (High - Low) > ₹100
  SELECT
  trade_date,
  `High Price`,
  `Low Price`,
  (`High Price` - `Low Price`) AS price_range
FROM bajaj_adjust
WHERE (`High Price` - `Low Price`) > 100
ORDER BY price_range DESC;

-- Average closing price per year
SELECT
  YEAR(trade_date) AS year,
  ROUND(AVG(`Close Price`), 2) AS avg_close_price
FROM bajaj_adjust
GROUP BY year
ORDER BY year;

-- q14 Total number of shares traded this year

SELECT
  YEAR(trade_date) AS year,
  SUM(`Total Traded Quantity`) AS total_traded_shares
FROM bajaj_adjust
GROUP BY year
ORDER BY year;


-- Year with highest average turnover per trading day
SELECT
  YEAR(trade_date) AS year,
  ROUND(AVG(Turnover), 2) AS avg_turnover
FROM bajaj_adjust
GROUP BY year
ORDER BY avg_turnover DESC
LIMIT 1;


--  Years where average traded quantity was below 5,000
SELECT
  YEAR(trade_date) AS year,
  ROUND(AVG(`Total Traded Quantity`), 2) AS avg_quantity
FROM bajaj_adjust
GROUP BY year
HAVING avg_quantity < 5000
ORDER BY year;

-- q17 Months with average close price above ₹500
 SELECT
  YEAR(trade_date) AS year,
  MONTH(trade_date) AS month,
  ROUND(AVG(`Close Price`), 2) AS avg_close
FROM bajaj_adjust
GROUP BY year, month
HAVING avg_close > 500
ORDER BY year, month;









  
  



