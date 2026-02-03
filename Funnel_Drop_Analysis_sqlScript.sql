# --------------- Funnel Drop Analysis --------------------

# 1 — Basic Funnel Counts
CREATE OR REPLACE VIEW ecommerce_staging.funnel_counts AS
SELECT

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(order_status IN ('shipped','delivered')) AS shipped_orders,

    SUM(order_status = 'delivered') AS delivered_orders

FROM ecommerce_staging.orders_clean;

SELECT * FROM ecommerce_staging.funnel_counts;


# 2 — Add Review Stage
CREATE OR REPLACE VIEW ecommerce_staging.review_stage AS
SELECT
    COUNT(DISTINCT order_id) AS reviewed_orders
FROM ecommerce_staging.reviews_clean;


# 3 — Final Funnel Metrics View (Main Output)

CREATE OR REPLACE VIEW ecommerce_staging.funnel_kpis AS
SELECT
    f.total_orders,
    f.shipped_orders,
    f.delivered_orders,
    r.reviewed_orders,

    ROUND(100 * f.shipped_orders / f.total_orders, 2) AS shipped_percent,
    ROUND(100 * f.delivered_orders / f.total_orders, 2) AS delivered_percent,
    ROUND(100 * r.reviewed_orders / f.total_orders, 2) AS reviewed_percent,

    ROUND(100 * (f.total_orders - f.delivered_orders) / f.total_orders, 2)
        AS drop_off_percent

FROM ecommerce_staging.funnel_counts f
CROSS JOIN ecommerce_staging.review_stage r;
SELECT * FROM ecommerce_staging.funnel_kpis;


# 4 — Delivery Delay Analysis

CREATE OR REPLACE VIEW ecommerce_staging.delivery_delay_kpis AS
SELECT

    COUNT(*) AS delivered_orders,

    ROUND(AVG(DATEDIFF(delivered_time, purchase_time)), 2) AS avg_days,

    SUM(delivered_time > estimated_delivery) AS late_orders,

    ROUND(
        100 * SUM(delivered_time > estimated_delivery) / COUNT(*),
        2
    ) AS late_percent

FROM ecommerce_staging.orders_clean
WHERE delivered_time IS NOT NULL;



