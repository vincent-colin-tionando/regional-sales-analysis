-- Cabang mana yang kinerjanya buruk?
-- Layer 1 -> Region
SELECT
	region, 
	ROUND(SUM(sales::numeric), 2) AS total_sales,
	COUNT(DISTINCT order_id) AS num_orders,
	COUNT(DISTINCT customer_id) AS num_customers,
	ROUND((SUM(sales::numeric) / COUNT(DISTINCT order_id)), 2) AS avg_order_value,
	ROUND((SUM(sales::numeric) / COUNT(DISTINCT customer_id)), 2) AS sales_per_customer,
	ROUND((COUNT(DISTINCT order_id)::numeric / COUNT(DISTINCT customer_id)::numeric), 2) AS orders_per_customer
FROM sale
GROUP BY region
ORDER BY total_sales;