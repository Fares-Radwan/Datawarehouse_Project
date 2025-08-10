/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
if OBJECT_ID('bronze.crm_olist_customers','U') IS not null
drop table bronze.crm_olist_customers;
go

CREATE table bronze.crm_olist_customers (
customer_id Nvarchar(100),
customer_unique_id Nvarchar(100),
customer_zip_code_prefix int,
customer_city Nvarchar(50),
customer_state Nvarchar(5)
);
go

if OBJECT_ID('bronze.crm_olist_order_reviews','U') IS not null
drop table bronze.crm_olist_order_reviews;
go

CREATE table bronze.crm_olist_order_reviews(
review_id Nvarchar(100),
order_id Nvarchar(100),
review_score int,
review_comment_title Nvarchar(100),
review_comment_message Nvarchar(100),
review_creation_date DATETIME ,
review_answer_timestamp DATETIME 
);
go 

if OBJECT_ID('bronze.crm_product_category_name_translation','U') IS not null
drop table bronze.crm_product_category_name_translation;
go

CREATE table bronze.crm_product_category_name_translation(
product_category_name Nvarchar(100),
product_category_name_english Nvarchar(100)
);
go

if OBJECT_ID('bronze.erp_olist_orders','U') IS not null
drop table bronze.erp_olist_orders;
go

CREATE table bronze.erp_olist_orders(
order_id Nvarchar(100),
customer_id Nvarchar(100),
order_status Nvarchar(50),
order_purchase_timestamp DATETIME,
order_approved_at DATETIME,
order_delivered_carrier_date DATETIME,
order_delivered_customer_date DATETIME,
order_estimated_delivery_date DATETIME,
);
go

if OBJECT_ID('bronze.erp_olist_order_payments','U') IS not null
drop table bronze.erp_olist_order_payments;
go

CREATE table bronze.erp_olist_order_payments(
order_id Nvarchar(100),
payment_sequential int,
payment_type Nvarchar(50),
payment_installments int,
payment_value Decimal(12,2)
);
go

if OBJECT_ID('bronze.erp_olist_order_items','U') IS not null
drop table bronze.erp_olist_order_items;
go

CREATE table  bronze.erp_olist_order_items(
order_id Nvarchar(100),
order_item_id int,
product_id Nvarchar(100),
seller_id Nvarchar(100),
shipping_limit_date DATETIME,
price Decimal(12,2),
freight_value Decimal(12,2)
);
go

if OBJECT_ID('bronze.erp_olist_products','U') IS not null
drop table bronze.erp_olist_products;
go

CREATE table bronze.erp_olist_products(
product_id Nvarchar(100),
product_category_name Nvarchar(50),
product_name_lenght int,
product_description_lenght int,
product_photos_qty int,
product_weight_g int,
product_length_cm int,
product_height_cm int,
product_width_cm int
);
go

if OBJECT_ID('bronze.erp_olist_geolocation','U') IS not null
drop table bronze.erp_olist_geolocation;
go

CREATE table bronze.erp_olist_geolocation(
geolocation_zip_code_prefix int,
geolocation_lat REAL,
geolocation_lng REAL,
geolocation_city Nvarchar(50),
geolocation_state Nvarchar(5)
);
go

if OBJECT_ID('bronze.erp_olist_sellers','U') IS not null
drop table bronze.erp_olist_sellers;
go

CREATE table bronze.erp_olist_sellers(
seller_id Nvarchar(100),
seller_zip_code_prefix int,
seller_city Nvarchar(50),
seller_state Nvarchar(5)
);
