
-- Select the target database
USE dataco_supply_chain;

-- Calculate overall executive KPIs, including sales, profit, margin, orders, customers, products, and quantity
SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(
        SUM(`Order Profit Per Order`) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    COUNT(DISTINCT `Customer Id`) AS Total_Customers,
    COUNT(DISTINCT `Product Card Id`) AS Total_Products,
    SUM(`Order Item Quantity`) AS Total_Quantity
FROM fact_order_items;


-- Analyze monthly performance by calculating orders, sales, profit, and profit margin
SELECT
    `Order Year` AS Order_Year,
    `Order Month` AS Order_Month,
    `Order Year Month` AS YearMonth,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(
        SUM(`Order Profit Per Order`) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM fact_order_items
GROUP BY
    `Order Year`,
    `Order Month`,
    `Order Year Month`
ORDER BY
    `Order Year`,
    `Order Month`;


-- Market Performance Analysis
-- Compare orders, customers, sales, profit, and profit margin across markets
SELECT
    Market,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    COUNT(DISTINCT `Customer Id`) AS Total_Customers,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(
        SUM(`Order Profit Per Order`) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM fact_order_items
GROUP BY Market
ORDER BY Total_Sales DESC;


-- Order Status Analysis
-- Evaluate order volume, sales, profit, and profit margin for each order status
SELECT
    `Order Status`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(
        SUM(`Order Profit Per Order`) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM fact_order_items
GROUP BY `Order Status`
ORDER BY Total_Orders DESC;
```
