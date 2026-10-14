
-- Select the target database
USE dataco_supply_chain;

-- 1. Customer Performance
-- Identify the top 10 customers by sales and evaluate their orders, quantity, profit, and profit margin
SELECT
    `Customer Id`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    SUM(`Order Item Quantity`) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(
        SUM(`Order Profit Per Order`) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM fact_order_items
GROUP BY `Customer Id`
ORDER BY Total_Sales DESC
LIMIT 10;


-- 2. Customer Segmentation by Sales
-- Calculate customer-level sales, profit, and order count, then divide customers into three sales tiers
WITH Customer_Sales AS (
    SELECT
        `Customer Id`,
        SUM(Sales) AS Total_Sales,
        SUM(`Order Profit Per Order`) AS Total_Profit,
        COUNT(DISTINCT `Order Id`) AS Total_Orders
    FROM fact_order_items
    GROUP BY `Customer Id`
),
-- Rank customers into three groups of approximately equal size based on total sales
Ranked_Customers AS (
    SELECT
        *,
        NTILE(3) OVER (ORDER BY Total_Sales) AS Sales_Tier
    FROM Customer_Sales
)
-- Summarize customer count, average sales, total sales, profit, margin, and order frequency by tier
SELECT
    CASE
        WHEN Sales_Tier = 1 THEN 'Low Value'
        WHEN Sales_Tier = 2 THEN 'Medium Value'
        ELSE 'High Value'
    END AS Customer_Segment,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Total_Sales), 2) AS Avg_Sales_Per_Customer,
    ROUND(SUM(Total_Sales), 2) AS Segment_Total_Sales,
    ROUND(SUM(Total_Profit), 2) AS Segment_Total_Profit,
    ROUND(
        SUM(Total_Profit) / NULLIF(SUM(Total_Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent,
    ROUND(AVG(Total_Orders), 2) AS Avg_Orders_Per_Customer
FROM Ranked_Customers
GROUP BY Sales_Tier
ORDER BY Sales_Tier;


-- 3. Customer Repeat Purchase Analysis
-- Calculate the total orders and sales for each customer
WITH Customer_Orders AS (
    SELECT
        `Customer Id`,
        COUNT(DISTINCT `Order Id`) AS Total_Orders,
        SUM(Sales) AS Total_Sales
    FROM fact_order_items
    GROUP BY `Customer Id`
)
-- Compare one-time and repeat customers by count, percentage, order frequency, and sales
SELECT
    CASE
        WHEN Total_Orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS Customer_Type,
    COUNT(*) AS Total_Customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS Customer_Percentage,
    ROUND(AVG(Total_Orders), 2) AS Avg_Orders_Per_Customer,
    ROUND(SUM(Total_Sales), 2) AS Total_Sales,
    ROUND(AVG(Total_Sales), 2) AS Avg_Sales_Per_Customer
FROM Customer_Orders
GROUP BY Customer_Type
ORDER BY Total_Customers DESC;
```
