/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Used the BULK INSERT command and the Import Flat File feature 
                     to load data from CSV files into bronze tables.
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    BEGIN TRY
        DECLARE 
            @start_time DATETIME, 
            @end_time DATETIME, 
            @full_start_time DATETIME, 
            @full_end_time DATETIME;

        SET @full_start_time = GETDATE();

        PRINT '_______________________________________';
        PRINT 'Loading Bronze Layer';
        PRINT '_______________________________________';

        PRINT '---------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '---------------------------------------';

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_olist_customers';
        TRUNCATE TABLE bronze.crm_olist_customers;

        PRINT '>> Inserting Data Into: bronze.crm_olist_customers';
        BULK INSERT bronze.crm_olist_customers
        FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_CRM\olist_cust.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        PRINT '========================================';
        PRINT 'Import File "olist_order_reviews_dataset.csv" Into bronze.crm_olist_order_reviews';
        PRINT '========================================';

        PRINT '>> Truncating Table: bronze.crm_product_category_name_translation';
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.crm_product_category_name_translation;

        PRINT '>> Inserting Data Into: bronze.crm_product_category_name_translation';
        BULK INSERT bronze.crm_product_category_name_translation
        FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_CRM\prod_cat_trans.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        PRINT '---------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '---------------------------------------';

        -- ERP Geolocation
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_olist_geolocation';
        TRUNCATE TABLE bronze.erp_olist_geolocation;

        PRINT '>> Inserting Data Into: bronze.erp_olist_geolocation';
        BULK INSERT bronze.erp_olist_geolocation
        FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_geolocation.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Order Items
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_olist_order_items';
        TRUNCATE TABLE bronze.erp_olist_order_items;

        PRINT '>> Inserting Data Into: bronze.erp_olist_order_items';
        BULK INSERT bronze.erp_olist_order_items
        FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_ord_items.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Order Payments
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_olist_order_payments';
        TRUNCATE TABLE bronze.erp_olist_order_payments;

        PRINT '>> Inserting Data Into: bronze.erp_olist_order_payments';
        BULK INSERT bronze.erp_olist_order_payments
        FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_ord_pay.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Orders
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_olist_orders';
        TRUNCATE TABLE bronze.erp_olist_orders;

        PRINT '>> Inserting Data Into: bronze.erp_olist_orders';
        BULK INSERT bronze.erp_olist_orders
        FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_ord.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Products
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_olist_products';
        TRUNCATE TABLE bronze.erp_olist_products;

        PRINT '>> Inserting Data Into: bronze.erp_olist_products';
        BULK INSERT bronze.erp_olist_products
        FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_prod.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '-------------';

        -- ERP Sellers
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_olist_sellers';
        TRUNCATE TABLE bronze.erp_olist_sellers;

        PRINT '>> Inserting Data Into: bronze.erp_olist_sellers';
        BULK INSERT bronze.erp_olist_sellers
        FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_sellers.csv"
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

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
