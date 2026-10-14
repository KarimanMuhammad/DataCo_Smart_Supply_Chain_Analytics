
USE dataco_supply_chain;

-- 1. Shipping Mode Performance
-- Compare shipping modes based on order volume, shipping duration, late delivery rate, sales, and profit.
SELECT
    `Shipping Mode`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    ROUND(AVG(`Days for shipping (real)`), 2) AS Avg_Actual_Shipping_Days,
    ROUND(AVG(`Days for shipment (scheduled)`), 2) AS Avg_Scheduled_Shipping_Days,
    ROUND(AVG(`Late Delivery Flag`) * 100, 2) AS Late_Delivery_Rate_Percent,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit
FROM fact_order_items
GROUP BY `Shipping Mode`
ORDER BY Late_Delivery_Rate_Percent DESC;


-- 2. Delivery Delay by Market and Region
-- Identify markets and regions with the highest late delivery rates.
SELECT
    Market,
    `Order Region`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    ROUND(AVG(`Days for shipping (real)`), 2) AS Avg_Actual_Shipping_Days,
    ROUND(AVG(`Days for shipment (scheduled)`), 2) AS Avg_Scheduled_Shipping_Days,
    ROUND(AVG(`Late Delivery Flag`) * 100, 2) AS Late_Delivery_Rate_Percent
FROM fact_order_items
GROUP BY
    Market,
    `Order Region`
ORDER BY Late_Delivery_Rate_Percent DESC;


-- 3. Late Delivery by Shipping Mode and Region
-- Analyze late delivery rates for each shipping mode within each market and region.
-- Include only groups containing at least 100 distinct orders to focus on sufficiently large groups.
SELECT
    Market,
    `Order Region`,
    `Shipping Mode`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    ROUND(
        AVG(`Late Delivery Flag`) * 100,
        2
    ) AS Late_Delivery_Rate_Percent,
    ROUND(
        AVG(`Days for shipping (real)`),
        2
    ) AS Avg_Actual_Shipping_Days,
    ROUND(
        AVG(`Days for shipment (scheduled)`),
        2
    ) AS Avg_Scheduled_Shipping_Days
FROM fact_order_items
GROUP BY
    Market,
    `Order Region`,
    `Shipping Mode`
HAVING COUNT(DISTINCT `Order Id`) >= 100
ORDER BY
    Late_Delivery_Rate_Percent DESC,
    Total_Orders DESC;


-- 4. Validate Delivery Status at Order Level
-- Aggregate item-level records into one record per order.
-- Check whether an order has conflicting late delivery flags across its item rows.
WITH Order_Delivery AS (
    SELECT
        `Order Id`,
        COUNT(DISTINCT `Late Delivery Flag`) AS Late_Flag_Variants,
        MAX(`Late Delivery Flag`) AS Late_Flag,
        MAX(`Days for shipping (real)`) AS Actual_Shipping_Days,
        MAX(`Days for shipment (scheduled)`) AS Scheduled_Shipping_Days,
        COUNT(*) AS Order_Item_Rows
    FROM fact_order_items
    GROUP BY `Order Id`
)
-- Summarize order-level delivery status and shipping duration.
SELECT
    COUNT(*) AS Total_Orders,
    SUM(Late_Flag = 1) AS Late_Orders,
    SUM(Late_Flag = 0) AS Non_Late_Orders,
    SUM(Late_Flag_Variants > 1) AS Orders_With_Conflicting_Flags,
    ROUND(AVG(Actual_Shipping_Days), 2) AS Avg_Actual_Shipping_Days,
    ROUND(AVG(Scheduled_Shipping_Days), 2) AS Avg_Scheduled_Shipping_Days
FROM Order_Delivery;
```
