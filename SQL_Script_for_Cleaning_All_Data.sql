
#------------------------------------------------------------------------------------------------------------------------------#


#----------------- We Clean the orders table (olist_orders_dataset)---------------------------------------------------#
CREATE TABLE ecommerce_staging.orders_clean AS
SELECT DISTINCT
    order_id,
    customer_id,
    order_status,

    STR_TO_DATE(NULLIF(order_purchase_timestamp, ''), '%Y-%m-%d %H:%i:%s') 
        AS purchase_time,

    STR_TO_DATE(NULLIF(order_approved_at, ''), '%Y-%m-%d %H:%i:%s') 
        AS approved_time,

    STR_TO_DATE(NULLIF(order_delivered_carrier_date, ''), '%Y-%m-%d %H:%i:%s') 
        AS carrier_time,

    STR_TO_DATE(NULLIF(order_delivered_customer_date, ''), '%Y-%m-%d %H:%i:%s') 
        AS delivered_time,

    STR_TO_DATE(NULLIF(order_estimated_delivery_date, ''), '%Y-%m-%d %H:%i:%s') 
        AS estimated_delivery

FROM new_schema.olist_orders_dataset
WHERE order_id IS NOT NULL;

ALTER TABLE ecommerce_staging.orders_clean ADD PRIMARY KEY(order_id);
ALTER TABLE ecommerce_staging.orders_clean ADD INDEX(customer_id);
ALTER TABLE ecommerce_staging.orders_clean ADD INDEX(purchase_time);


SELECT * 
FROM ecommerce_staging.orders_clean;





#---------------------------------- Clean Customers Table --------------------------------#

CREATE TABLE ecommerce_staging.customers_clean AS
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    LOWER(TRIM(customer_city)) AS city,
    UPPER(TRIM(customer_state)) AS state
FROM new_schema.olist_customers_dataset
WHERE customer_id IS NOT NULL;

ALTER TABLE ecommerce_staging.customers_clean ADD PRIMARY KEY(customer_id);
ALTER TABLE ecommerce_staging.customers_clean ADD INDEX(customer_unique_id);

DESCRIBE ecommerce_staging.customers_clean;
select* from ecommerce_staging.customers_clean;





#----------------------ORDER ITEMS (REVENUE) Table CLEANED---------------------------------#
CREATE TABLE ecommerce_staging.order_items_clean AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value
FROM new_schema.olist_order_items_dataset
WHERE order_id IS NOT NULL;

ALTER TABLE ecommerce_staging.order_items_clean
MODIFY order_id VARCHAR(50),
MODIFY product_id VARCHAR(50),
MODIFY seller_id VARCHAR(50);


ALTER TABLE ecommerce_staging.order_items_clean
MODIFY order_id VARCHAR(50),
MODIFY product_id VARCHAR(50),
MODIFY seller_id VARCHAR(50);

 DESCRIBE ecommerce_staging.order_items_clean;
select* from ecommerce_staging.order_items_clean;






#---------------------Products Data Cleaned---------------#

CREATE TABLE ecommerce_staging.products_clean AS
SELECT DISTINCT
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM new_schema.olist_products_dataset
WHERE product_id IS NOT NULL;

ALTER TABLE ecommerce_staging.products_clean
MODIFY product_id VARCHAR(50) NOT NULL ;

ALTER TABLE ecommerce_staging.products_clean
ADD PRIMARY KEY(product_id);


DESCRIBE ecommerce_staging.products_clean;


-- select* from ecommerce_staging.products_clean;
 
 
 
 
 
 #---------------------------------PAYMENTS DATA CLEANED ---------------------------#

CREATE TABLE ecommerce_staging.payments_clean AS
SELECT
    order_id,
    payment_type,
    payment_installments,
    payment_value
FROM new_schema.olist_order_payments_dataset
WHERE order_id IS NOT NULL;

ALTER TABLE ecommerce_staging.payments_clean
MODIFY COLUMN order_id VARCHAR(50) NOT NULL;

ALTER TABLE ecommerce_staging.payments_clean
ADD INDEX (order_id);


select* from ecommerce_staging.payments_clean;



#--------------------REVIEWS CLEANED -------------------------#

CREATE TABLE ecommerce_staging.reviews_clean AS
SELECT DISTINCT
    review_id,
    order_id,
    review_score,
    STR_TO_DATE(NULLIF(review_creation_date, ''), '%Y-%m-%d %H:%i:%s') AS review_time
FROM new_schema.olist_order_reviews_dataset
WHERE order_id IS NOT NULL;

ALTER TABLE ecommerce_staging.reviews_clean
MODIFY COLUMN review_id VARCHAR(50) NOT NULL,
MODIFY COLUMN order_id VARCHAR(50) NOT NULL;

ALTER TABLE ecommerce_staging.reviews_clean ADD INDEX (order_id);
ALTER TABLE ecommerce_staging.reviews_clean ADD INDEX (review_score);

select* from new_schema.olist_order_reviews_dataset;
select* from ecommerce_staging.reviews_clean;



#-----------------Final VALIDATION OF CLEANED DATA --------------#

SHOW TABLES FROM ecommerce_staging;
SELECT COUNT(*) FROM ecommerce_staging.orders_clean;
SELECT COUNT(DISTINCT order_id)
FROM ecommerce_staging.order_items_clean;





