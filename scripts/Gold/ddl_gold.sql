/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customer
-- =============================================================================
IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
    DROP VIEW gold.dim_customer;
GO

CREATE VIEW gold.dim_customer AS
SELECT
    c.customer_id, 
    ROW_NUMBER() OVER (ORDER BY c.customer_id) AS customer_key, 
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    g.geolocation_city  AS customer_city,
    g.geolocation_state AS customer_state,
    g.geolocation_lat,
    g.geolocation_lng
FROM silver.crm_olist_customers c
LEFT JOIN silver.erp_olist_geolocation g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;
GO

-- =============================================================================
-- Create Dimension: gold.dim_product
-- =============================================================================
IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
    DROP VIEW gold.dim_product;
GO

CREATE VIEW gold.dim_product AS
SELECT
    p.product_id,
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_key,
    p.product_category_name,
    t.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    p.product_volume_l,
    p.weight_category
FROM silver.erp_olist_products p
LEFT JOIN silver.crm_product_category_name_translation t
    ON p.product_category_name = t.product_category_name;
GO

-- =============================================================================
-- Create Dimension: gold.dim_seller
-- =============================================================================
IF OBJECT_ID('gold.dim_seller', 'V') IS NOT NULL
    DROP VIEW gold.dim_seller;
GO

CREATE VIEW gold.dim_seller AS
SELECT
    s.seller_id,
    ROW_NUMBER() OVER (ORDER BY s.seller_id) AS seller_key,
    s.seller_zip_code_prefix,
    g.geolocation_city  AS seller_city,
    g.geolocation_state AS seller_state,
    g.geolocation_lat,
    g.geolocation_lng
FROM silver.erp_olist_sellers s
LEFT JOIN silver.erp_olist_geolocation g
    ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix;
GO

-- =============================================================================
-- Create Dimension: gold.dim_review
-- =============================================================================
IF OBJECT_ID('gold.dim_review', 'V') IS NOT NULL
    DROP VIEW gold.dim_review;
GO

CREATE VIEW gold.dim_review AS
SELECT
    r.review_id,
    ROW_NUMBER() OVER (ORDER BY r.review_id) AS review_key,
    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date,
    r.review_answer_timestamp,
    r.review_response_time_days
FROM silver.crm_olist_order_reviews r;
GO

-- =============================================================================
-- Create Fact Table: gold.fact_order
-- =============================================================================
IF OBJECT_ID('gold.fact_order', 'V') IS NOT NULL
    DROP VIEW gold.fact_order;
GO

CREATE VIEW gold.fact_order AS
SELECT
    o.order_id,
    c.customer_key,
    s.seller_key,
    p.product_key,
    r.review_key,
    oi.order_item_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    o.approval_days,
    o.shipping_days,
    o.delivery_days,
    o.is_late,
    oi.price,
    oi.freight_value,
    op.payment_sequential,
    op.payment_type,
    op.payment_installments,
    op.payment_value,
    op.installment_value,
    op.payment_value_category
FROM silver.erp_olist_orders o
LEFT JOIN gold.dim_customer c
    ON o.customer_id = c.customer_id
LEFT JOIN silver.erp_olist_order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN gold.dim_product p
    ON oi.product_id = p.product_id
LEFT JOIN gold.dim_seller s
    ON oi.seller_id = s.seller_id
LEFT JOIN silver.erp_olist_order_payments op
    ON o.order_id = op.order_id
LEFT JOIN gold.dim_review r
    ON o.order_id = r.review_id;
GO
