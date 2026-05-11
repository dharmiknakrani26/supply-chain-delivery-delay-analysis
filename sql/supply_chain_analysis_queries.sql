/*
Supply Chain Performance & Delivery Delay Analysis
SQL Analysis Queries

Dataset/table name used in these queries:
supply_chain_cleaned

Note:
If your SQL table name is different, replace supply_chain_cleaned with your actual table name.
*/

-- =========================================================
-- 1. Overall Supply Chain KPI Summary
-- =========================================================

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) AS late_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS late_delivery_rate_percent,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(delay_days), 2) AS average_delay_days
FROM supply_chain_cleaned;


-- =========================================================
-- 2. Late Delivery Rate by Shipping Mode
-- =========================================================

SELECT
    shipping_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) AS late_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS late_delivery_rate_percent,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(delay_days), 2) AS average_delay_days
FROM supply_chain_cleaned
GROUP BY shipping_mode
ORDER BY late_delivery_rate_percent DESC;


-- =========================================================
-- 3. Late Delivery Rate by Region
-- =========================================================

SELECT
    order_region,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) AS late_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS late_delivery_rate_percent,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(delay_days), 2) AS average_delay_days
FROM supply_chain_cleaned
GROUP BY order_region
ORDER BY late_delivery_rate_percent DESC;


-- =========================================================
-- 4. Profit Impact of Late Deliveries
-- =========================================================

SELECT
    delivery_result,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit), 2) AS average_profit,
    ROUND(AVG(delay_days), 2) AS average_delay_days,
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS profit_margin_percent
FROM supply_chain_cleaned
GROUP BY delivery_result
ORDER BY total_profit DESC;


-- =========================================================
-- 5. High-Volume Product Categories with Late Delivery Risk
-- =========================================================

SELECT
    category_name,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) AS late_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS late_delivery_rate_percent,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(delay_days), 2) AS average_delay_days
FROM supply_chain_cleaned
GROUP BY category_name
HAVING COUNT(DISTINCT order_id) >= 500
ORDER BY late_delivery_rate_percent DESC;


-- =========================================================
-- 6. Shipping Mode + Region Risk Analysis
-- =========================================================

SELECT
    shipping_mode,
    order_region,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) AS late_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS late_delivery_rate_percent,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(delay_days), 2) AS average_delay_days
FROM supply_chain_cleaned
GROUP BY shipping_mode, order_region
HAVING COUNT(DISTINCT order_id) >= 100
ORDER BY late_delivery_rate_percent DESC;


-- =========================================================
-- 7. Monthly Late Delivery Trend
-- =========================================================

SELECT
    order_year,
    order_month,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) AS late_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS late_delivery_rate_percent,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(delay_days), 2) AS average_delay_days
FROM supply_chain_cleaned
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- =========================================================
-- 8. Top 10 High Profit Regions
-- =========================================================

SELECT
    order_region,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS profit_margin_percent
FROM supply_chain_cleaned
GROUP BY order_region
ORDER BY total_profit DESC
LIMIT 10;


-- =========================================================
-- 9. Delivery Status Breakdown
-- =========================================================

SELECT
    delivery_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / (
        SELECT COUNT(DISTINCT order_id)
        FROM supply_chain_cleaned
    ), 2) AS order_share_percent
FROM supply_chain_cleaned
GROUP BY delivery_status
ORDER BY total_orders DESC;


-- =========================================================
-- 10. Customer Segment Delivery Performance
-- =========================================================

SELECT
    customer_segment,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) AS late_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN late_delivery_risk = 1 THEN order_id END) * 100.0
        / COUNT(DISTINCT order_id),
        2
    ) AS late_delivery_rate_percent,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM supply_chain_cleaned
GROUP BY customer_segment
ORDER BY late_delivery_rate_percent DESC;
