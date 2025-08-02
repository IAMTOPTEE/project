use datagurus;

select *
from `samplestore assignment`
;


CREATE TABLE superstore_adjust AS
SELECT
    `Row ID`,
    `Order ID`,
    STR_TO_DATE(`Order Date`, '%m/%d/%Y') AS order_date,
    STR_TO_DATE(`Ship Date`, '%m/%d/%Y') AS ship_date,
    `Ship Mode`,
    `Customer ID`,
    `Customer Name`,
    `Segment`,
    `Postal Code`,
    `City`,
    `State`,
    `Country`,
    `Region`,
    `Market`,
    `Product ID`,
    `Category`,
    `Sub-Category`,
    `Product Name`,
    REPLACE(REPLACE(Sales, '$', ''), ',', '') + 0 AS sales,
    Quantity,
    Discount,
    CASE
        WHEN Profit LIKE '(%' THEN -REPLACE(REPLACE(REPLACE(Profit, '(', ''), ')', ''), '$', '') + 0
        ELSE REPLACE(REPLACE(Profit, '$', ''), ',', '') + 0
    END AS profit
FROM `samplestore assignment`
;

-- Step 1: Calculate average quantity sold

SELECT AVG(Quantity) AS avg_quantity FROM superstore_adjust;

-- Step 2: Identify high-quantity and low/negative profit sub-categories
SELECT
    `Sub-Category`,
    SUM(Quantity) AS total_quantity_sold,
    SUM(profit) AS total_profit
FROM superstore_adjust
GROUP BY `Sub-Category`
HAVING total_quantity_sold > 5.9428 AND total_profit <= 0
ORDER BY total_quantity_sold DESC;


-- Analyze average discount vs average profit per market
SELECT
    Market,
    ROUND(AVG(Discount), 2) AS avg_discount,
    ROUND(AVG(profit), 2) AS avg_profit
FROM superstore_adjust
GROUP BY Market
ORDER BY avg_discount DESC;

-- Group by segment to see discount-profit relationship
SELECT
    category,
    ROUND(AVG(Discount), 2) AS avg_discount,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_adjust
GROUP BY category
HAVING avg_discount > 0.2 AND total_profit > 0
ORDER BY avg_discount DESC;

-- Q4 hich cities purchase the most items, and how do their profit patterns compare?
SELECT
    City,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore_adjust
GROUP BY City
ORDER BY total_quantity DESC
LIMIT 10;

-- Q5 5: Which markets show the largest disparity between sales and profit?

SELECT
    Market,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(Sales) - SUM(profit), 2) AS sales_profit_gap
FROM superstore_adjust
GROUP BY Market
ORDER BY sales_profit_gap DESC;

-- Step 1: Create a view or temporary column for delay
-- q6Are delays between order and ship date more common in certain regions or segments?

SELECT
    Region,
    Segment,
    AVG(DATEDIFF(ship_date, order_date)) AS avg_shipping_delay
FROM superstore_adjust
GROUP BY Region, Segment
ORDER BY avg_shipping_delay DESC;


--  Q7 Which year or quarter had the best overall profit performance globally?
-- Best yearly performance
SELECT
    YEAR(order_date) AS year,
    SUM(profit) AS total_profit
FROM superstore_cleaned
GROUP BY year
ORDER BY total_profit DESC;

-- Best quarterly performance Which year or quarter had the best overall profit performance globally?
SELECT
    CONCAT(YEAR(order_date), '-Q', QUARTER(order_date)) AS quarter,
    SUM(profit) AS total_profit
FROM superstore_adjust
GROUP BY quarter
ORDER BY total_profit DESC;

-- Q8 8. Identify seasonal patterns — are there specific months where losses spike or profits soar?
SELECT
    MONTH(order_date) AS month,
    SUM(profit) AS total_profit
FROM superstore_adjust
GROUP BY month
ORDER BY total_profit DESC;




