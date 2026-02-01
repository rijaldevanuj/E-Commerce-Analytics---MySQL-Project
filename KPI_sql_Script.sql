
#-------------------------------------DAILY KPI VIEW (Most Important)-------------------------#
CREATE OR REPLACE VIEW ecommerce_staging.daily_kpis AS
SELECT
    order_date,

    SUM(gross_revenue) AS total_revenue,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_unique_id) AS unique_customers,

    ROUND(
        SUM(gross_revenue) / COUNT(DISTINCT order_id), 2
    ) AS avg_order_value

FROM ecommerce_staging.fact_revenue
GROUP BY order_date
ORDER BY order_date;

SELECT * FROM ecommerce_staging.daily_kpis;



#--------------------------------DELIVERY SLA KPI VIEW (Operations Metrics)---------------------#

CREATE OR REPLACE VIEW ecommerce_staging.delivery_kpis AS
SELECT
    COUNT(*) AS total_delivered_orders,

    ROUND(
        AVG(DATEDIFF(delivered_time, purchase_time)), 2
    ) AS avg_delivery_days,

    SUM(delivered_time > estimated_delivery) AS late_deliveries,

    ROUND(
        100 * SUM(delivered_time > estimated_delivery) / COUNT(*), 2
    ) AS late_delivery_percent

FROM ecommerce_staging.orders_clean
WHERE delivered_time IS NOT NULL;

SELECT * FROM ecommerce_staging.delivery_kpis;


#----------------------------CATEGORY PERFORMANCE KPI ----------------------------#

CREATE OR REPLACE VIEW ecommerce_staging.category_kpis AS
SELECT
    product_category_name,

    SUM(gross_revenue) AS revenue,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(AVG(gross_revenue), 2) AS avg_item_value

FROM ecommerce_staging.fact_revenue
GROUP BY product_category_name
ORDER BY revenue DESC;

SELECT * FROM ecommerce_staging.category_kpis;





