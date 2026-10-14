```sql
-- Select the target database
USE dataco_supply_chain;

-- Remove the existing table to recreate it for validation
DROP TABLE IF EXISTS fact_order_items;

-- Create the fact table with the required columns and data types
CREATE TABLE fact_order_items (
    `Type` VARCHAR(50),
    `Days for shipping (real)` INT,
    `Days for shipment (scheduled)` INT,
    `Benefit per order` DOUBLE,
    `Sales per customer` DOUBLE,
    `Delivery Status` VARCHAR(100),
    `Late_delivery_risk` INT,
    `Category Id` INT,
    `Category Name` VARCHAR(255),
    `Customer City` VARCHAR(255),
    `Customer Country` VARCHAR(255),
    `Customer Id` INT,
    `Customer Segment` VARCHAR(100),
    `Customer State` VARCHAR(255),
    `Department Id` INT,
    `Department Name` VARCHAR(255),
    `Latitude` DOUBLE,
    `Longitude` DOUBLE,
    `Market` VARCHAR(100),
    `Order City` VARCHAR(255),
    `Order Country` VARCHAR(255),
    `Order Customer Id` INT,
    `order date (DateOrders)` DATETIME,
    `Order Id` INT,
    `Order Item Cardprod Id` INT,
    `Order Item Discount` DOUBLE,
    `Order Item Discount Rate` DOUBLE,
    `Order Item Id` INT,
    `Order Item Product Price` DOUBLE,
    `Order Item Profit Ratio` DOUBLE,
    `Order Item Quantity` INT,
    `Sales` DOUBLE,
    `Order Item Total` DOUBLE,
    `Order Profit Per Order` DOUBLE,
    `Order Region` VARCHAR(255),
    `Order State` VARCHAR(255),
    `Order Status` VARCHAR(100),
    `Product Card Id` INT,
    `Product Category Id` INT,
    `Product Name` VARCHAR(255),
    `Product Price` DOUBLE,
    `Product Status` INT,
    `shipping date (DateOrders)` DATETIME,
    `Shipping Mode` VARCHAR(100),
    `Shipping Delay` INT,
    `On Time Delivery` INT,
    `Late Delivery Flag` INT,
    `Order Year` INT,
    `Order Quarter` INT,
    `Order Month` INT,
    `Order Month Name` VARCHAR(50),
    `Order Year Month` VARCHAR(50),
    `Profit Margin` DOUBLE,
    `Customer Order Count` INT,
    `Repeat Customer` INT
);

-- Validate the total number of rows and unique order items
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT `Order Item Id`) AS Unique_Items
FROM fact_order_items;

-- Check row count, unique item count, and the minimum and maximum item IDs
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT `Order Item Id`) AS Unique_Items,
    MIN(`Order Item Id`) AS Min_Item_ID,
    MAX(`Order Item Id`) AS Max_Item_ID
FROM fact_order_items;

-- Check missing values in key columns, date coverage, and business entity counts
SELECT
    COUNT(*) AS Total_Rows,
    SUM(`Sales` IS NULL) AS Missing_Sales,
    SUM(`Order Profit Per Order` IS NULL) AS Missing_Profit,
    SUM(`Order Id` IS NULL) AS Missing_Order_ID,
    MIN(`order date (DateOrders)`) AS First_Order_Date,
    MAX(`order date (DateOrders)`) AS Last_Order_Date,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    COUNT(DISTINCT `Customer Id`) AS Total_Customers
FROM fact_order_items;

-- Check whether an order contains multiple distinct recorded profit values
SELECT
    COUNT(*) AS Total_Orders,
    SUM(Profit_Variants > 1) AS Orders_With_Multiple_Profit_Values,
    SUM(Profit_Variants = 1) AS Orders_With_One_Profit_Value
FROM (
    SELECT
        `Order Id`,
        COUNT(DISTINCT `Order Profit Per Order`) AS Profit_Variants
    FROM fact_order_items
    GROUP BY `Order Id`
) AS Order_Profit_Check;

-- Check whether each order item has a unique recorded profit value
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT `Order Item Id`) AS Unique_Order_Items,
    COUNT(DISTINCT CONCAT(
        `Order Item Id`, '|',
        `Order Profit Per Order`
    )) AS Unique_Item_Profit_Combinations
FROM fact_order_items;

-- Compare recorded profit, benefit, calculated item profit, and average profit ratio
SELECT
    ROUND(SUM(`Order Profit Per Order`), 2) AS Sum_Order_Profit,
    ROUND(SUM(`Benefit per order`), 2) AS Sum_Benefit_Per_Order,
    ROUND(SUM(
        `Order Item Total` * `Order Item Profit Ratio`
    ), 2) AS Estimated_Item_Profit,
    ROUND(AVG(`Order Item Profit Ratio`) * 100, 2)
        AS Avg_Item_Profit_Ratio_Percent
FROM fact_order_items;

-- Compare recorded profit, order item value, sales, and their difference
SELECT
    ROUND(SUM(`Order Profit Per Order`), 2) AS Recorded_Profit,
    ROUND(SUM(`Order Item Total`), 2) AS Total_Order_Item_Value,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Item Total` - Sales), 2) AS Item_Value_Minus_Sales
FROM fact_order_items;

-- Validate the relationship between sales, item value, and discounts
SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(`Order Item Total`), 2) AS Total_Item_Value,
    ROUND(SUM(`Order Item Discount`), 2) AS Total_Discount,
    ROUND(
        SUM(Sales)
        - SUM(`Order Item Total`)
        - SUM(`Order Item Discount`),
        2
    ) AS Difference_After_Discount
FROM fact_order_items;

-- Examine profit aggregation and variation for orders containing multiple items
SELECT
    `Order Id`,
    COUNT(*) AS Order_Items,
    COUNT(DISTINCT `Order Profit Per Order`) AS Distinct_Profit_Values,
    ROUND(SUM(`Order Profit Per Order`), 2) AS Sum_Profit,
    ROUND(AVG(`Order Profit Per Order`), 2) AS Avg_Profit,
    ROUND(MIN(`Order Profit Per Order`), 2) AS Min_Profit,
    ROUND(MAX(`Order Profit Per Order`), 2) AS Max_Profit
FROM fact_order_items
GROUP BY `Order Id`
HAVING COUNT(*) > 1
ORDER BY Order_Items DESC
LIMIT 20;

-- Compare recorded profit with item-level calculated profit across all rows
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT `Order Item Id`) AS Unique_Order_Items,
    ROUND(SUM(`Order Profit Per Order`), 2)
        AS Sum_Recorded_Profit,
    ROUND(SUM(`Order Item Total` * `Order Item Profit Ratio`), 2)
        AS Calculated_Item_Profit,
    ROUND(SUM(`Benefit per order`), 2)
        AS Sum_Benefit,
    ROUND(AVG(`Order Item Profit Ratio`) * 100, 2)
        AS Avg_Item_Profit_Ratio_Percent
FROM fact_order_items;

-- Compare different profit aggregation methods at the order level
WITH Order_Profit AS (
    SELECT
        `Order Id`,
        COUNT(*) AS Order_Items,
        SUM(`Order Profit Per Order`) AS Sum_Profit,
        AVG(`Order Profit Per Order`) AS Avg_Profit,
        MIN(`Order Profit Per Order`) AS Min_Profit,
        MAX(`Order Profit Per Order`) AS Max_Profit
    FROM fact_order_items
    GROUP BY `Order Id`
)
SELECT
    COUNT(*) AS Total_Orders,
    SUM(Order_Items) AS Total_Order_Items,
    ROUND(SUM(Sum_Profit), 2) AS Profit_Using_Sum,
    ROUND(SUM(Avg_Profit), 2) AS Profit_Using_Average,
    ROUND(AVG(Order_Items), 2) AS Avg_Items_Per_Order,
    SUM(
        CASE
            WHEN Min_Profit = Max_Profit THEN 1
            ELSE 0
        END
    ) AS Orders_With_Constant_Profit
FROM Order_Profit;

-- Compare recorded and calculated profit across order-size groups
WITH Order_Size AS (
    SELECT
        `Order Id`,
        COUNT(*) AS Order_Items,
        SUM(`Order Profit Per Order`) AS Recorded_Profit,
        SUM(`Order Item Total` * `Order Item Profit Ratio`)
            AS Calculated_Profit
    FROM fact_order_items
    GROUP BY `Order Id`
)
SELECT
    CASE
        WHEN Order_Items = 1 THEN '1 Item'
        WHEN Order_Items = 2 THEN '2 Items'
        WHEN Order_Items BETWEEN 3 AND 5 THEN '3-5 Items'
        ELSE '6+ Items'
    END AS Order_Size_Group,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Recorded_Profit), 2) AS Recorded_Profit,
    ROUND(SUM(Calculated_Profit), 2) AS Calculated_Profit,
    ROUND(
        SUM(Calculated_Profit) - SUM(Recorded_Profit), 2
    ) AS Profit_Difference
FROM Order_Size
GROUP BY Order_Size_Group
ORDER BY
    CASE Order_Size_Group
        WHEN '1 Item' THEN 1
        WHEN '2 Items' THEN 2
        WHEN '3-5 Items' THEN 3
        ELSE 4
    END;

-- Measure absolute profit differences and count matching versus mismatching rows
SELECT
    COUNT(*) AS Total_Rows,
    ROUND(SUM(`Order Profit Per Order`), 2)
        AS Recorded_Profit,
    ROUND(SUM(
        `Order Item Total` * `Order Item Profit Ratio`
    ), 2) AS Calculated_Item_Profit,
    ROUND(SUM(ABS(
        `Order Profit Per Order`
        - (`Order Item Total` * `Order Item Profit Ratio`)
    )), 2) AS Total_Absolute_Difference,
    ROUND(MAX(ABS(
        `Order Profit Per Order`
        - (`Order Item Total` * `Order Item Profit Ratio`)
    )), 4) AS Max_Row_Difference,
    SUM(
        CASE
            WHEN ABS(
                `Order Profit Per Order`
                - (`Order Item Total` * `Order Item Profit Ratio`)
            ) < 0.01 THEN 1
            ELSE 0
        END
    ) AS Matching_Rows,
    SUM(
        CASE
            WHEN ABS(
                `Order Profit Per Order`
                - (`Order Item Total` * `Order Item Profit Ratio`)
            ) >= 0.01 THEN 1
            ELSE 0
        END
    ) AS Mismatching_Rows
FROM fact_order_items;
```
