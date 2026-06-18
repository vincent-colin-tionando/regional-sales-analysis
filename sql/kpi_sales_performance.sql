-- Sales Performances KPI

-- 1. Total Sales
-- 2. Total Orders
-- 3. Total Customers
-- 4. Average Order Value

SELECT
    ROUND(SUM(sales::numeric), 2) AS national_total_sales,
    COUNT(DISTINCT order_id) AS national_num_orders,
    COUNT(DISTINCT customer_id) AS national_num_customers,
    ROUND(SUM(sales::numeric) / COUNT(DISTINCT order_id), 2) AS national_aov
FROM sale;