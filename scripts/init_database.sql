/*
=========================================
CREATE Database and Schemas
=========================================
Script Propuse:
  This SQL script creates the database Olist_Ecommerce_DWH on SQL Server.
  If the database already exists, the script will close all connections, stop any running tasks, and delete the database first.
  Creates a new database named 'Olist_Ecommerce_DWH'.
  Creates three schemas inside the new database: bronze, silver, and gold.
WARNING:
    Running this script will drop the entire 'Olist_Ecommerce_DWH' database if it exists. 
    All data in the database will be permanently deleted.
*/

IF exists (SELECT 1 FROM sys.databases WHERE name='Olist_Ecommerce_DWH')
Begin
    Alter database Olist_Ecommerce_DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	  DROP database Olist_Ecommerce_DWH 
END;
go 

CREATE database Olist_Ecommerce_DWH;
go 

use Olist_Ecommerce_DWH;
go

CREATE SCHEMA bronze;
go

CREATE SCHEMA Silver;
go 

CREATE SCHEMA Gold;
