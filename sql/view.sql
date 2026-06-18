-- 01. View 1 — Layer 1 Regional 
CREATE OR REPLACE VIEW v_layer1_regional AS
WITH regional_metrics AS (
    SELECT
        region,
        ROUND(SUM(sales::numeric), 2) AS total_sales,
        COUNT(DISTINCT order_id) AS num_orders,
        COUNT(DISTINCT customer_id) AS num_customers,
        ROUND((SUM(sales::numeric) / COUNT(DISTINCT order_id)), 2) AS avg_order_value,
        ROUND((SUM(sales::numeric) / COUNT(DISTINCT customer_id)), 2) AS sales_per_customer,
        ROUND((COUNT(DISTINCT order_id)::numeric / 
               COUNT(DISTINCT customer_id)::numeric), 2) AS orders_per_customer
    FROM sale
    GROUP BY region
),
national_benchmark AS (
    SELECT
        ROUND(SUM(sales::numeric), 2) AS national_total_sales,
        COUNT(DISTINCT order_id) AS national_num_orders,
        COUNT(DISTINCT customer_id) AS national_num_customers,
        ROUND(SUM(sales::numeric) / COUNT(DISTINCT order_id), 2) AS national_aov
    FROM sale
),
regional_benchmark AS (
    SELECT
        ROUND(AVG(sales_per_customer), 2) AS benchmark_spc,
        ROUND(AVG(orders_per_customer), 2) AS benchmark_opc
    FROM regional_metrics
)
SELECT
    rm.*,
    nb.*,
    rb.*,
    -- Gap
    ROUND(rm.avg_order_value - nb.national_aov, 2) AS gap_aov,
    ROUND(rm.sales_per_customer - rb.benchmark_spc, 2) AS gap_spc,
    ROUND(rm.orders_per_customer - rb.benchmark_opc, 2) AS gap_opc,
    -- KPI Status
    CASE WHEN rm.avg_order_value >= nb.national_aov 
         THEN 'At/Above Target' ELSE 'Below Target' END AS kpi_aov_status,
    CASE WHEN rm.sales_per_customer >= rb.benchmark_spc 
         THEN 'At/Above Target' ELSE 'Below Target' END AS kpi_spc_status,
    CASE WHEN rm.orders_per_customer >= rb.benchmark_opc 
         THEN 'At/Above Target' ELSE 'Below Target' END AS kpi_opc_status,
    -- KPI Overall
    CASE
        WHEN rm.avg_order_value >= nb.national_aov
             AND rm.sales_per_customer >= rb.benchmark_spc
             AND rm.orders_per_customer >= rb.benchmark_opc THEN 'Healthy'
        WHEN rm.avg_order_value < nb.national_aov
             AND rm.sales_per_customer < rb.benchmark_spc
             AND rm.orders_per_customer < rb.benchmark_opc THEN 'Critical'
        ELSE 'Warning'
    END AS kpi_overall
FROM regional_metrics rm
CROSS JOIN national_benchmark nb
CROSS JOIN regional_benchmark rb;


-- 02. View 2 — Layer 2 State

CREATE OR REPLACE VIEW v_layer2_state AS
WITH south_states AS (
    SELECT
        region, state,
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
),
national_benchmark AS (
    SELECT
        ROUND(SUM(sales::numeric), 2) AS national_total_sales,
        COUNT(DISTINCT order_id) AS national_num_orders,
        COUNT(DISTINCT customer_id) AS national_num_customers,
        ROUND(SUM(sales::numeric) / COUNT(DISTINCT order_id), 2) AS national_aov
    FROM sale
),
south_benchmark AS (
    SELECT
        ROUND(SUM(sales::numeric) / COUNT(DISTINCT customer_id), 2) AS benchmark_spc,
        ROUND(COUNT(DISTINCT order_id)::numeric / 
              COUNT(DISTINCT customer_id)::numeric, 2) AS benchmark_opc
    FROM sale
    WHERE region = 'South'
)
SELECT
    ss.*,
    nb.*,
    sb.*,
    ROUND(ss.avg_order_value - nb.national_aov, 2) AS gap_aov,
    ROUND(ss.sales_per_customer - sb.benchmark_spc, 2) AS gap_spc,
    ROUND(ss.orders_per_customer - sb.benchmark_opc, 2) AS gap_opc,
    CASE WHEN ss.avg_order_value >= nb.national_aov 
         THEN 'At/Above Target' ELSE 'Below Target' END AS kpi_aov_status,
    CASE WHEN ss.sales_per_customer >= sb.benchmark_spc 
         THEN 'At/Above Target' ELSE 'Below Target' END AS kpi_spc_status,
    CASE WHEN ss.orders_per_customer >= sb.benchmark_opc 
         THEN 'At/Above Target' ELSE 'Below Target' END AS kpi_opc_status,
    CASE
        WHEN ss.avg_order_value >= nb.national_aov
             AND ss.sales_per_customer >= sb.benchmark_spc
             AND ss.orders_per_customer >= sb.benchmark_opc THEN 'Healthy'
        WHEN ss.avg_order_value < nb.national_aov
             AND ss.sales_per_customer < sb.benchmark_spc
             AND ss.orders_per_customer < sb.benchmark_opc THEN 'Critical'
        ELSE 'Warning'
    END AS kpi_overall
FROM south_states ss
CROSS JOIN national_benchmark nb
CROSS JOIN south_benchmark sb;


-- 03. View 3 — Layer 3 City
CREATE OR REPLACE VIEW v_layer3_city AS
WITH city_metrics AS (
    SELECT
        state, city,
        ROUND(SUM(sales::numeric), 2) AS total_sales,
        COUNT(DISTINCT order_id) AS num_orders,
        COUNT(DISTINCT customer_id) AS num_customers,
        ROUND((SUM(sales::numeric) / COUNT(DISTINCT order_id)), 2) AS avg_order_value,
        ROUND((SUM(sales::numeric) / COUNT(DISTINCT customer_id)), 2) AS sales_per_customer
    FROM sale
    WHERE state IN ('Tennessee', 'North Carolina', 'Florida')
    GROUP BY state, city
),
national_benchmark AS (
    SELECT
        ROUND(SUM(sales::numeric), 2) AS national_total_sales,
        COUNT(DISTINCT order_id) AS national_num_orders,
        COUNT(DISTINCT customer_id) AS national_num_customers,
        ROUND(SUM(sales::numeric) / COUNT(DISTINCT order_id), 2) AS national_aov
    FROM sale
),
state_benchmarks AS (
    SELECT
        state,
        ROUND(SUM(sales::numeric) / COUNT(DISTINCT customer_id), 2) AS benchmark_spc
    FROM sale
    WHERE state IN ('Tennessee', 'North Carolina', 'Florida')
    GROUP BY state
)
SELECT
    cm.*,
    nb.*,
    sb.benchmark_spc,
    ROUND(cm.avg_order_value - nb.national_aov, 2) AS gap_aov,
    ROUND(cm.sales_per_customer - sb.benchmark_spc, 2) AS gap_spc,
    CASE WHEN cm.avg_order_value >= nb.national_aov 
         THEN 'At/Above Target' ELSE 'Below Target' END AS kpi_aov_status,
    CASE WHEN cm.sales_per_customer >= sb.benchmark_spc 
         THEN 'At/Above Target' ELSE 'Below Target' END AS kpi_spc_status,
    CASE
        WHEN cm.avg_order_value >= nb.national_aov
             AND cm.sales_per_customer >= sb.benchmark_spc THEN 'Healthy'
        WHEN cm.avg_order_value < nb.national_aov
             AND cm.sales_per_customer < sb.benchmark_spc THEN 'Critical'
        ELSE 'Warning'
    END AS kpi_overall
FROM city_metrics cm
CROSS JOIN national_benchmark nb
JOIN state_benchmarks sb ON cm.state = sb.state;


SELECT * FROM v_layer1_regional;
SELECT * FROM v_layer2_state;
SELECT * FROM v_layer3_city;
