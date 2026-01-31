#------------------ REVENUE FACT TABLE -------------------#

CREATE TABLE ecommerce_staging.fact_revenue AS
SELECT
    o.order_id,
    oi.order_item_id,
    o.customer_id,
    c.customer_unique_id,

    oi.product_id,
    p.product_category_name,

    oi.seller_id,

    o.purchase_time,
    DATE(o.purchase_time) AS order_date,

    oi.price,
    oi.freight_value,

    (oi.price + oi.freight_value) AS gross_revenue,

    o.order_status
FROM ecommerce_staging.orders_clean o
JOIN ecommerce_staging.order_items_clean oi
    ON o.order_id = oi.order_id
JOIN ecommerce_staging.customers_clean c
    ON o.customer_id = c.customer_id
LEFT JOIN ecommerce_staging.products_clean p
    ON oi.product_id = p.product_id;


ALTER TABLE ecommerce_staging.fact_revenue
MODIFY order_id VARCHAR(50),
MODIFY customer_id VARCHAR(50),
MODIFY customer_unique_id VARCHAR(50),
MODIFY product_id VARCHAR(50),
MODIFY seller_id VARCHAR(50);

ALTER TABLE ecommerce_staging.fact_revenue
ADD INDEX idx_category (product_category_name(50));

SHOW INDEX FROM ecommerce_staging.fact_revenue;
SELECT COUNT(*) FROM ecommerce_staging.fact_revenue;

select* from ecommerce_staging.fact_revenue;



