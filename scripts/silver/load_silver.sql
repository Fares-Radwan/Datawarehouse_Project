/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    BEGIN TRY
        DECLARE @start_time DATETIME,
                @end_time DATETIME,
                @full_start_time DATETIME,
                @full_end_time DATETIME;

        SET @full_start_time = GETDATE();

        PRINT '_______________________________________';
        PRINT 'Loading Silver Layer';
        PRINT '_______________________________________';

        PRINT '---------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '---------------------------------------';

        -- CRM Customers
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_olist_customers';
        TRUNCATE TABLE silver.crm_olist_customers;

        PRINT '>> Inserting Data Into: silver.crm_olist_customers';
        INSERT INTO silver.crm_olist_customers (
            customer_id,
            customer_unique_id,
            customer_zip_code_prefix,
            customer_city,
            customer_state
        )
        SELECT
            customer_id,
            customer_unique_id,
            customer_zip_code_prefix,
            customer_city,
            UPPER(customer_state) AS customer_state
        FROM bronze.crm_olist_customers;

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- CRM Order Reviews
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_olist_order_reviews';
        TRUNCATE TABLE silver.crm_olist_order_reviews;

        PRINT '>> Inserting Data Into: silver.crm_olist_order_reviews';
        INSERT INTO silver.crm_olist_order_reviews (
            review_id,
            order_id,
            review_score,
            review_comment_title,
            review_comment_message,
            review_creation_date,
            review_answer_timestamp,
            review_response_time_days
        )
        SELECT
            review_id,
            order_id,
            review_score,
            CASE WHEN review_comment_title IS NULL THEN 'no comment' ELSE LOWER(review_comment_title) END AS review_comment_title,
            CASE WHEN review_comment_message IS NULL THEN 'no comment' ELSE LOWER(review_comment_message) END AS review_comment_message,
            review_creation_date,
            review_answer_timestamp,
            DATEDIFF(DAY, review_creation_date, review_answer_timestamp) AS review_response_time_days
        FROM bronze.crm_olist_order_reviews;

        -- CRM Product Category Name Translation
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_product_category_name_translation';
        TRUNCATE TABLE silver.crm_product_category_name_translation;

        PRINT '>> Inserting Data Into: silver.crm_product_category_name_translation';
        INSERT INTO silver.crm_product_category_name_translation (
            product_category_name,
            product_category_name_english
        )
        SELECT
            product_category_name,
            product_category_name_english
        FROM bronze.crm_product_category_name_translation;

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        PRINT '---------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '---------------------------------------';

        -- ERP Geolocation
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_olist_geolocation';
        TRUNCATE TABLE silver.erp_olist_geolocation;

        PRINT '>> Inserting Data Into: silver.erp_olist_geolocation';
        INSERT INTO silver.erp_olist_geolocation (
            geolocation_zip_code_prefix,
            geolocation_lat,
            geolocation_lng,
            geolocation_city,
            geolocation_state
        )
        SELECT
            geolocation_zip_code_prefix,
            geolocation_lat,
            geolocation_lng,
            LOWER(geolocation_city) AS geolocation_city,
            UPPER(geolocation_state) AS geolocation_state
        FROM bronze.erp_olist_geolocation;

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Order Items
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_olist_order_items';
        TRUNCATE TABLE silver.erp_olist_order_items;

        PRINT '>> Inserting Data Into: silver.erp_olist_order_items';
        INSERT INTO silver.erp_olist_order_items (
            order_id,
            order_item_id,
            product_id,
            seller_id,
            shipping_limit_date,
            price,
            freight_value,
            total_price
        )
        SELECT
            order_id,
            order_item_id,
            product_id,
            seller_id,
            shipping_limit_date,
            price,
            freight_value,
            (price + freight_value) AS total_price
        FROM bronze.erp_olist_order_items;

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Order Payments
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_olist_order_payments';
        TRUNCATE TABLE silver.erp_olist_order_payments;

        PRINT '>> Inserting Data Into: silver.erp_olist_order_payments';
        INSERT INTO silver.erp_olist_order_payments (
            order_id,
            payment_sequential,
            payment_type,
            payment_installments,
            payment_value,
            installment_value,
            payment_value_category
        )
        SELECT
            order_id,
            payment_sequential,
            REPLACE(payment_type, '_', ' ') AS payment_type,
            payment_installments,
            payment_value,
            CASE
                WHEN payment_installments > 0 THEN CAST((payment_value / payment_installments) AS DECIMAL(10, 2))
                ELSE 0
            END AS installment_value,
            CASE
                WHEN payment_value < 100 THEN 'low'
                WHEN payment_value BETWEEN 100 AND 500 THEN 'medium'
                ELSE 'high'
            END AS payment_value_category
        FROM bronze.erp_olist_order_payments;

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Orders
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_olist_orders';
        TRUNCATE TABLE silver.erp_olist_orders;

        PRINT '>> Inserting Data Into: silver.erp_olist_orders';
        INSERT INTO silver.erp_olist_orders (
            order_id,
            customer_id,
            order_status,
            order_purchase_timestamp,
            order_approved_at,
            order_delivered_carrier_date,
            order_delivered_customer_date,
            order_estimated_delivery_date,
            approval_days,
            shipping_days,
            delivery_days,
            is_late
        )
        SELECT
            order_id,
            customer_id,
            order_status,
            order_purchase_timestamp,
            order_approved_at,
            order_delivered_carrier_date,
            order_delivered_customer_date,
            order_estimated_delivery_date,
            DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) AS approval_days,
            DATEDIFF(DAY, order_approved_at, order_delivered_carrier_date) AS shipping_days,
            DATEDIFF(DAY, order_delivered_carrier_date, order_delivered_customer_date) AS delivery_days,
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
                ELSE 0
            END AS is_late
        FROM bronze.erp_olist_orders;

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Products
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_olist_products';
        TRUNCATE TABLE silver.erp_olist_products;

        PRINT '>> Inserting Data Into: silver.erp_olist_products';
        INSERT INTO silver.erp_olist_products (
            product_id,
            product_category_name,
            product_name_lenght,
            product_description_lenght,
            product_photos_qty,
            product_weight_g,
            product_length_cm,
            product_height_cm,
            product_width_cm,
            product_volume_l,
            weight_category
        )
        SELECT
            product_id,
            product_category_name,
            product_name_lenght,
            product_description_lenght,
            product_photos_qty,
            product_weight_g,
            product_length_cm,
            product_height_cm,
            product_width_cm,
            CAST((product_length_cm * product_height_cm * product_width_cm) / 1000.0 AS DECIMAL(10, 2)) AS product_volume_l,
            CASE
                WHEN product_weight_g < 500 THEN 'light'
                WHEN product_weight_g BETWEEN 500 AND 2000 THEN 'medium'
                ELSE 'heavy'
            END AS weight_category
        FROM bronze.erp_olist_products;

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Sellers
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_olist_sellers';
        TRUNCATE TABLE silver.erp_olist_sellers;

        PRINT '>> Inserting Data Into: silver.erp_olist_sellers';
        INSERT INTO silver.erp_olist_sellers (
            seller_id,
            seller_zip_code_prefix,
            seller_city,
            seller_state
        )
        SELECT
            seller_id,
            seller_zip_code_prefix,
            seller_city,
            seller_state
        FROM bronze.erp_olist_sellers;

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        SET @full_end_time = GETDATE();

        PRINT '==========================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @full_start_time, @full_end_time) AS NVARCHAR) + ' Seconds';
        PRINT '==========================================';
    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;
