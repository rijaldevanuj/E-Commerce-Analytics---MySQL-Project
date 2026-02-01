#-------------------------------Cohort Analysis (Customer Retention)-----------------------------#

# 1 — Find Each Customer’s First Purchase (Cohort)

CREATE OR REPLACE VIEW ecommerce_staging.customer_cohort AS
SELECT
    customer_unique_id,

    MIN(order_date) AS first_purchase_date,

    DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS cohort_month

FROM ecommerce_staging.fact_revenue
GROUP BY customer_unique_id;
SELECT * 
FROM ecommerce_staging.customer_cohort;



# 2 — Track All Customer Purchases

CREATE OR REPLACE VIEW ecommerce_staging.cohort_activity AS
    SELECT 
        f.customer_unique_id,
        c.cohort_month,
        f.order_date,
        TIMESTAMPDIFF(MONTH,
            c.first_purchase_date,
            f.order_date) AS month_number
    FROM
        ecommerce_staging.fact_revenue f
            JOIN
        ecommerce_staging.customer_cohort c ON f.customer_unique_id = c.customer_unique_id;


# 3- Final Cohort Retention Table

CREATE OR REPLACE VIEW ecommerce_staging.cohort_retention AS
SELECT
    cohort_month,

    month_number,

    COUNT(DISTINCT customer_unique_id) AS active_customers

FROM ecommerce_staging.cohort_activity
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;
SELECT *
FROM ecommerce_staging.cohort_retention;

# 4- Calculation of Retention percentage 

SELECT
    cohort_month,
    month_number,

    active_customers,

    ROUND(
        100 * active_customers /
        FIRST_VALUE(active_customers)
        OVER (PARTITION BY cohort_month ORDER BY month_number),
        2
    ) AS retention_percent

FROM ecommerce_staging.cohort_retention;
