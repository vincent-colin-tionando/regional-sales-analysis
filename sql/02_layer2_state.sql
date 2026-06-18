-- Layer 2 -> State
WITH south_states AS(
    SELECT
        region,
        state,
        ROUND(SUM(sales::numeric), 2) AS total_sales,
        COUNT(DISTINCT order_id) AS num_orders,
        COUNT(DISTINCT customer_id) AS num_customers,
        ROUND((SUM(sales::numeric) / COUNT(DISTINCT order_id)), 2) AS avg_order_value,
        ROUND((SUM(sales::numeric) / COUNT(DISTINCT customer_id)), 2) AS sales_per_customer,
        ROUND((COUNT(DISTINCT order_id)::numeric / 
               COUNT(DISTINCT customer_id)::numeric), 2) AS orders_per_customer
    FROM sale
    WHERE region = 'South'
    GROUP BY region, state
	ORDER BY total_sales
),
south_benchmarks AS(
    SELECT
        ROUND(SUM(sales::numeric) / COUNT(DISTINCT order_id), 2) AS benchmark_aov,
        ROUND(SUM(sales::numeric) / COUNT(DISTINCT customer_id), 2) AS benchmark_spc,
        ROUND(COUNT(DISTINCT order_id)::numeric / 
              COUNT(DISTINCT customer_id)::numeric, 2) AS benchmark_opc
    FROM sale
    WHERE region = 'South'
)
SELECT
    ss.state,
    ss.total_sales, ss.num_orders, ss.num_customers,
	ss.avg_order_value, sb.benchmark_aov,
    ss.sales_per_customer, sb.benchmark_spc,
    ss.orders_per_customer, sb.benchmark_opc,
    ROUND(ss.avg_order_value - sb.benchmark_aov, 2) AS gap_aov,
    ROUND(ss.sales_per_customer - sb.benchmark_spc, 2) AS gap_spc,
    ROUND(ss.orders_per_customer - sb.benchmark_opc, 2) AS gap_opc
FROM south_states ss
CROSS JOIN south_benchmarks sb
WHERE
    ss.avg_order_value < sb.benchmark_aov AND
    ss.sales_per_customer < sb.benchmark_spc AND
    ss.orders_per_customer < sb.benchmark_opc
ORDER BY ss.total_sales;