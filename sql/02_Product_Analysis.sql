
-- Select the target database
USE dataco_supply_chain;

-- 1. Product Category Performance
-- Compare product categories by product count, orders, quantity sold, sales, profit, and profit margin
SELECT
    `Category Name`,
    COUNT(DISTINCT `Product Card Id`) AS Total_Products,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    SUM(`Order Item Quantity`) AS Total_Quantity_Sold,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(
        SUM(`Order Profit Per Order`) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM fact_order_items
GROUP BY `Category Name`
ORDER BY Total_Sales DESC;


-- 2. Individual Product Performance
-- Analyze each product's order volume, quantity sold, sales, profit, and profit margin
SELECT
    `Product Card Id`,
    `Product Name`,
    `Category Name`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    SUM(`Order Item Quantity`) AS Total_Quantity_Sold,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(
        SUM(`Order Profit Per Order`) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM fact_order_items
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY Total_Sales DESC;


-- 3. Top 10 Products by Total Profit
-- Identify the ten products with the highest recorded total profit
SELECT
    `Product Card Id`,
    `Product Name`,
    `Category Name`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    SUM(`Order Item Quantity`) AS Total_Quantity_Sold,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(
        SUM(`Order Profit Per Order`) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM fact_order_items
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY Total_Profit DESC
LIMIT 10;


-- 4. Bottom 10 Products by Total Profit
-- Identify the ten products with the lowest recorded total profit
SELECT
    `Product Card Id`,
    `Product Name`,
    `Category Name`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    SUM(`Order Item Quantity`) AS Total_Quantity_Sold,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Total_Profit,
    ROUND(
        SUM(`Order Profit Per Order`) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin_Percent
FROM fact_order_items
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY Total_Profit ASC
LIMIT 10;
```
