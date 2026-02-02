#----------------RFM Segmentation--------------------


# 1 — Calculate Base RFM Metrics
CREATE OR REPLACE VIEW ecommerce_staging.rfm_base AS
SELECT
    customer_unique_id,

    MAX(order_date) AS last_purchase_date,

    COUNT(DISTINCT order_id) AS frequency,

    SUM(gross_revenue) AS monetary

FROM ecommerce_staging.fact_revenue
GROUP BY customer_unique_id;


# Add Recency (days since last order)
CREATE OR REPLACE VIEW ecommerce_staging.rfm_metrics AS
SELECT
    customer_unique_id,

    DATEDIFF(
        (SELECT MAX(order_date) FROM ecommerce_staging.fact_revenue),
        last_purchase_date
    ) AS recency,

    frequency,
    monetary

FROM ecommerce_staging.rfm_base;

SELECT * FROM ecommerce_staging.rfm_metrics ;



# 2 — Create RFM Scores 
CREATE OR REPLACE VIEW ecommerce_staging.rfm_scores AS
SELECT
    customer_unique_id,

    recency,
    frequency,
    monetary,

    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency) AS f_score,
    NTILE(5) OVER (ORDER BY monetary) AS m_score

FROM ecommerce_staging.rfm_metrics;



# 3 — Create Final Segment Labels

CREATE OR REPLACE VIEW ecommerce_staging.rfm_segments AS
SELECT
    *,

    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'VIP Customers'

        WHEN f_score >= 4
            THEN 'Loyal Customers'

        WHEN r_score <= 2
            THEN 'Churn Risk'

        WHEN f_score = 1
            THEN 'One-Time Buyers'

        ELSE 'Regular Customers'
    END AS segment

FROM ecommerce_staging.rfm_scores;


SELECT segment, COUNT(*) AS customers
FROM ecommerce_staging.rfm_segments
GROUP BY segment;


