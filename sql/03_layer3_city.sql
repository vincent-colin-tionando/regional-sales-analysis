-- Layer 3 -> City
WITH city_metrics AS(
	SELECT 
		state, city,
		ROUND(SUM(sales::numeric), 2) AS total_sales,
		COUNT(DISTINCT order_id) AS num_orders,
	    COUNT(DISTINCT customer_id) AS num_customers,
	    ROUND((SUM(sales::numeric) / COUNT(DISTINCT order_id)), 2) AS avg_order_value,
	    ROUND((SUM(sales::numeric) / COUNT(DISTINCT customer_id)), 2) AS sales_per_customer,
	    ROUND((COUNT(DISTINCT order_id)::numeric / 
	    	COUNT(DISTINCT customer_id)::numeric), 2) AS orders_per_customer
	FROM sale
	WHERE state IN ('Tennessee', 'North Carolina', 'Florida')
	GROUP BY state, city
),
states_benchmarks AS(
	SELECT
		state,
		ROUND(SUM(sales::numeric) / COUNT(DISTINCT order_id), 2) AS benchmark_aov,
	    ROUND(SUM(sales::numeric) / COUNT(DISTINCT customer_id), 2) AS benchmark_spc,
	    ROUND(COUNT(DISTINCT order_id)::numeric / 
	    	COUNT(DISTINCT customer_id)::numeric, 2) AS benchmark_opc
	FROM sale
	WHERE  state IN ('Tennessee', 'North Carolina', 'Florida')
	GROUP BY state
)
SELECT
    cm.state, cm.city,
    cm.total_sales, cm.num_orders, cm.num_customers,
	cm.avg_order_value, sb.benchmark_aov,
    cm.sales_per_customer, sb.benchmark_spc,
    cm.orders_per_customer, sb.benchmark_opc,
    ROUND(cm.avg_order_value - sb.benchmark_aov, 2) AS gap_aov,
    ROUND(cm.sales_per_customer - sb.benchmark_spc, 2) AS gap_spc,
    ROUND(cm.orders_per_customer - sb.benchmark_opc, 2) AS gap_opc
FROM city_metrics cm JOIN states_benchmarks sb ON cm.state = sb.state 
WHERE
    cm.avg_order_value < sb.benchmark_aov AND
    cm.sales_per_customer < sb.benchmark_spc AND
    cm.orders_per_customer < sb.benchmark_opc
ORDER BY cm.state, cm.total_sales;