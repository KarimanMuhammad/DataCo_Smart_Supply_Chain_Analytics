
-- 1. Delivery Delay by Order Status
-- Compare late delivery rates across different order statuses.
-- Aggregate item-level records to obtain one record per order.
WITH Order_Delivery AS (
    SELECT
        `Order Id`,
        MAX(`Order Status`) AS Order_Status,
        MAX(`Late Delivery Flag`) AS Late_Flag
    FROM fact_order_items
    GROUP BY `Order Id`
)
SELECT
    Order_Status,
    COUNT(*) AS Total_Orders,
    SUM(Late_Flag = 1) AS Late_Orders,
    ROUND(AVG(Late_Flag) * 100, 2) AS Late_Delivery_Rate_Percent
FROM Order_Delivery
GROUP BY Order_Status
ORDER BY Late_Delivery_Rate_Percent DESC;


-- 2. Business Impact of Delivery Delays
-- Compare sales, profit, profit margin, and average order sales
-- between late and on-time deliveries.
WITH Order_Delivery AS (
    SELECT
        `Order Id`,
        MAX(`Late Delivery Flag`) AS Late_Flag,
        SUM(Sales) AS Order_Sales,
        SUM(`Order Profit Per Order`) AS Order_Profit
    FROM fact_order_items
    GROUP BY `Order Id`
)
SELECT
    CASE
        WHEN Late_Flag = 1 THEN 'Late Delivery'
        ELSE 'On-Time Delivery'
    END AS Delivery_Performance,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Order_Sales), 2) AS Total_Sales,
    ROUND(SUM(Order_Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Order_Profit) / NULLIF(SUM(Order_Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent,
    ROUND(AVG(Order_Sales), 2) AS Avg_Sales_Per_Order
FROM Order_Delivery
GROUP BY Late_Flag
ORDER BY Late_Flag DESC;


-- 3. Repeat Customers vs. Delivery Performance
-- Classify customers based on their total number of orders.
-- Compare late delivery rates between repeat and one-time customers.
WITH Order_Delivery AS (
    SELECT
        `Order Id`,
        MAX(`Customer Id`) AS Customer_ID,
        MAX(`Late Delivery Flag`) AS Late_Flag
    FROM fact_order_items
    GROUP BY `Order Id`
),
Customer_Types AS (
    SELECT
        Customer_ID,
        COUNT(*) AS Customer_Orders
    FROM Order_Delivery
    GROUP BY Customer_ID
)
SELECT
    CASE
        WHEN C.Customer_Orders > 1 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS Customer_Type,
    COUNT(*) AS Total_Orders,
    SUM(O.Late_Flag = 1) AS Late_Orders,
    ROUND(AVG(O.Late_Flag) * 100, 2) AS Late_Delivery_Rate_Percent
FROM Order_Delivery O
JOIN Customer_Types C
    ON O.Customer_ID = C.Customer_ID
GROUP BY Customer_Type
ORDER BY Late_Delivery_Rate_Percent DESC;


-- 4. Shipping Delay Duration vs. Profitability
-- Group orders by shipping delay duration.
-- Compare sales, profit, and profit margin across delay groups.
WITH Order_Delivery AS (
    SELECT
        `Order Id`,
        MAX(`Shipping Delay`) AS Shipping_Delay_Days,
        SUM(Sales) AS Order_Sales,
        SUM(`Order Profit Per Order`) AS Order_Profit
    FROM fact_order_items
    GROUP BY `Order Id`
)
SELECT
    CASE
        WHEN Shipping_Delay_Days <= 0 THEN 'No Delay'
        WHEN Shipping_Delay_Days = 1 THEN '1 Day Delay'
        WHEN Shipping_Delay_Days = 2 THEN '2 Days Delay'
        WHEN Shipping_Delay_Days >= 3 THEN '3+ Days Delay'
        ELSE 'Unknown'
    END AS Delay_Group,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Order_Sales), 2) AS Total_Sales,
    ROUND(SUM(Order_Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Order_Profit) / NULLIF(SUM(Order_Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM Order_Delivery
GROUP BY Delay_Group
ORDER BY
    CASE Delay_Group
        WHEN 'No Delay' THEN 1
        WHEN '1 Day Delay' THEN 2
        WHEN '2 Days Delay' THEN 3
        WHEN '3+ Days Delay' THEN 4
        ELSE 5
    END;


-- 5. Shipping Delay Impact by Market
-- Compare profit margins across shipping delay groups within each market.
-- Aggregate the data at the order level before grouping by market and delay.
WITH Order_Delivery AS (
    SELECT
        `Order Id`,
        MAX(Market) AS Market_Name,
        MAX(`Shipping Delay`) AS Shipping_Delay_Days,
        SUM(Sales) AS Order_Sales,
        SUM(`Order Profit Per Order`) AS Order_Profit
    FROM fact_order_items
    GROUP BY `Order Id`
)
SELECT
    Market_Name,
    CASE
        WHEN Shipping_Delay_Days <= 0 THEN 'No Delay'
        WHEN Shipping_Delay_Days = 1 THEN '1 Day Delay'
        WHEN Shipping_Delay_Days = 2 THEN '2 Days Delay'
        WHEN Shipping_Delay_Days >= 3 THEN '3+ Days Delay'
        ELSE 'Unknown'
    END AS Delay_Group,
    COUNT(*) AS Total_Orders,
    ROUND(
        SUM(Order_Profit) / NULLIF(SUM(Order_Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM Order_Delivery
GROUP BY
    Market_Name,
    Delay_Group
ORDER BY
    Market_Name,
    CASE Delay_Group
        WHEN 'No Delay' THEN 1
        WHEN '1 Day Delay' THEN 2
        WHEN '2 Days Delay' THEN 3
        WHEN '3+ Days Delay' THEN 4
        ELSE 5
    END;


-- 6. Order Status vs. Sales and Profitability
-- Compare order volume, total sales, average order value, total profit,
-- and profit margin across different order statuses.
WITH Order_Level AS (
    SELECT
        `Order Id`,
        MAX(`Order Status`) AS Order_Status,
        SUM(Sales) AS Order_Sales,
        SUM(`Order Profit Per Order`) AS Order_Profit
    FROM fact_order_items
    GROUP BY `Order Id`
)
SELECT
    Order_Status,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Order_Sales), 2) AS Total_Sales,
    ROUND(AVG(Order_Sales), 2) AS Avg_Order_Value,
    ROUND(SUM(Order_Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Order_Profit) / NULLIF(SUM(Order_Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM Order_Level
GROUP BY Order_Status
ORDER BY Total_Sales DESC;
```
