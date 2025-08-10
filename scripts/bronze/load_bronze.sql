/*
=======================================================
Stored Procedure: Bulk Inser(load) Data Into Tables In 'bronze' schema 
=======================================================
Script purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.
Parametaers:
    None.
     The storge procedure does not accept any prameter or return any values.
Usage Example:
     EXEC bronze.load_bronze;
=======================================================
*/
CREATE Or ALTER Procedure bronze.load_bronze 
AS
BEGIN 
BEGIN TRY

 DECLARE @start_time DATETIME , @end_time DATETIME,@full_start_time DATETIME, @full_end_time DATETIME;

 SET @full_start_time = GETDATE();

PRINT '_______________________________________';
PRINT 'Loading Bronze Layer';
PRINT '_______________________________________';

PRINT '---------------------------------------';
PRINT 'Loading CRM Tables';
PRINT '---------------------------------------';

SET @start_time= GETDATE();

PRINT '>> Truncating Table:crm_olist_customers';

Truncate table bronze.crm_olist_customers;

PRINT '>> Inserting Data Into:crm_olist_customers';

bulk insert bronze.crm_olist_customers
FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_CRM\olist_cust.csv"
With (
		firstrow=2,
		FIELDTERMINATOR=',',
		TABLOCK
);

SET @end_time= GETDATE();

PRINT 'Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS Nvarchar) +' Seconds';
PRINT '-------------';

PRINT '========================================';
PRINT 'Import File  "olist_order_reviews_dataset.csv" Into bronze.crm_olist_order_reviews';
PRINT '========================================';
 
PRINT '>> Truncating Table: bronze.crm_product_category_name_translation';

SET @start_time= GETDATE();

Truncate table bronze.crm_product_category_name_translation;
 
PRINT '>> Inserting Data Into: bronze.crm_product_category_name_translation';

bulk insert bronze.crm_product_category_name_translation
FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_CRM\prod_cat_trans.csv"
With (
		firstrow=2,
		FIELDTERMINATOR=',',
		TABLOCK
);

SET @end_time= GETDATE();

PRINT 'Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS Nvarchar) +' Seconds';
PRINT '-------------';

PRINT '---------------------------------------';
PRINT 'Loading ERP Tables';
PRINT '---------------------------------------';

SET @start_time= GETDATE();

PRINT '>> Truncating Table: bronze.erp_olist_geolocation';

Truncate table bronze.erp_olist_geolocation;

PRINT '>> Inserting Data Into: bronze.erp_olist_geolocation';

bulk insert bronze.erp_olist_geolocation
FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_geolocation.csv"
With (
		firstrow=2,
		FIELDTERMINATOR=',',
		TABLOCK
);

SET @end_time= GETDATE();

PRINT 'Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS Nvarchar) +' Seconds';
PRINT '-------------';

SET @start_time= GETDATE();

PRINT '>> Truncating Table: bronze.erp_olist_order_items';

Truncate table bronze.erp_olist_order_items;
 
PRINT '>> Inserting Data Into: bronze.erp_olist_order_items';

bulk insert bronze.erp_olist_order_items
FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_ord_items.csv"
With (
		firstrow=2,
		FIELDTERMINATOR=',',
		TABLOCK
);

SET @end_time= GETDATE();

PRINT 'Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS Nvarchar) +' Seconds';
PRINT '-------------';

SET @start_time= GETDATE();

PRINT '>> Truncating Table: bronze.erp_olist_order_payments';

Truncate table bronze.erp_olist_order_payments; 

PRINT '>> Inserting Data Into: bronze.erp_olist_order_payments';

bulk insert bronze.erp_olist_order_payments
FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_ord_pay.csv"
With (
		firstrow=2,
		FIELDTERMINATOR=',',
		TABLOCK
);
SET @end_time= GETDATE();

PRINT 'Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS Nvarchar) +' Seconds';
PRINT '-------------';

SET @start_time= GETDATE();

PRINT '>> Truncating Table: bronze.erp_olist_orders';

Truncate table bronze.erp_olist_orders; 

PRINT '>> Inserting Data Into: bronze.erp_olist_orders';

bulk insert bronze.erp_olist_orders
FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_ord.csv"
With (
		firstrow=2,
		FIELDTERMINATOR=',',
		TABLOCK
);

SET @end_time= GETDATE();

PRINT 'Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS Nvarchar) +' Seconds';
PRINT '-------------';

SET @start_time= GETDATE();

PRINT '>> Truncating Table: bronze.erp_olist_products';

Truncate table bronze.erp_olist_products;
 
PRINT '>> Inserting Data Into: bronze.erp_olist_products';

bulk insert bronze.erp_olist_products
FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_prod.csv"
With (
		firstrow=2,
		FIELDTERMINATOR=',',
		TABLOCK
);
SET @end_time= GETDATE();

PRINT 'Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS Nvarchar) +' Seconds';
PRINT '-------------';

SET @start_time= GETDATE();

PRINT '>> Truncating Table: bronze.erp_olist_sellers';

Truncate table bronze.erp_olist_sellers;

PRINT '>> Inserting Data Into: bronze.erp_olist_sellers';

bulk insert bronze.erp_olist_sellers
FROM "E:\Programming\Projects\SQL projects\Olist_Ecommerce_DWH\Dataset\Source_ERP\olist_sellers.csv"
With(
      Firstrow=2,
	  FIELDTERMINATOR=',',
	  TABLOCK
)

SET @end_time= GETDATE();

PRINT 'Load Duration:'+ CAST(DATEDIFF(second,@start_time,@end_time) AS Nvarchar) +' Seconds';
PRINT '-------------';

SET @full_end_time=GETDATE();

PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @full_start_time, @full_end_time) AS NVARCHAR) + ' Seconds';
		PRINT '=========================================='

END TRY

    BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END



