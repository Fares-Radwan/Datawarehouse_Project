# 📊 Data Catalog – Gold Layer

## 📝 Overview
The **Gold Layer** represents the business-level data in our Data Warehouse.  
It contains curated **dimension tables** and **fact tables** designed to support advanced analytics and reporting.  
This layer follows a **Star Schema** model to ensure high query performance, scalability, and clear business logic representation.

---

## 📂 Table of Contents
1. [Entity Relationship Diagram](#-entity-relationship-diagram)
2. [Dimension Tables](#-dimension-tables)
   - [gold.dim_customer](#1-golddim_customer)
   - [gold.dim_product](#2-golddim_product)
   - [gold.dim_seller](#3-golddim_seller)
   - [gold.dim_review](#4-golddim_review)
3. [Fact Tables](#-fact-tables)
   - [gold.fact_order](#5-goldfact_order)
4. [Design Notes](#-design-notes)

---

## 🗺 Entity Relationship Diagram
![Gold Layer ERD](images/gold_layer_erd.png)

The diagram above illustrates the relationships between **Fact** and **Dimension** tables using a Star Schema design.

---

## 🧩 Dimension Tables

### 1. gold.dim_customer
**Purpose:** Stores customer details enriched with geographic and location data.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INT | **Surrogate key** uniquely identifying each customer record. |
| customer_id | NVARCHAR(50) | Unique identifier assigned to each customer in the source system. |
| customer_unique_id | NVARCHAR(50) | Alphanumeric ID for cross-system tracking. |
| customer_zip_code_prefix | NVARCHAR(20) | Postal code prefix for the customer’s address. |
| customer_city | NVARCHAR(50) | City of the customer. |
| customer_state | NVARCHAR(10) | State/region abbreviation. |
| geolocation_lat | DECIMAL(9,6) | Latitude coordinate. |
| geolocation_lng | DECIMAL(9,6) | Longitude coordinate. |

---

### 2. gold.dim_product
**Purpose:** Contains product details and attributes for categorization and analysis.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INT | **Surrogate key** uniquely identifying each product. |
| product_id | NVARCHAR(50) | Source system product ID. |
| product_category_name | NVARCHAR(100) | Category name in original language. |
| product_category_name_english | NVARCHAR(100) | Category name translated to English. |
| product_name_lenght | INT | Name length (characters). |
| product_description_lenght | INT | Description length (characters). |
| product_photos_qty | INT | Number of product photos. |
| product_weight_g | DECIMAL(10,2) | Weight in grams. |
| product_length_cm | DECIMAL(10,2) | Length in cm. |
| product_height_cm | DECIMAL(10,2) | Height in cm. |
| product_width_cm | DECIMAL(10,2) | Width in cm. |
| product_volume_l | DECIMAL(10,2) | Volume in liters. |
| weight_category | NVARCHAR(50) | Weight classification. |

---

### 3. gold.dim_seller
**Purpose:** Stores seller details enriched with location data.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| seller_key | INT | **Surrogate key** uniquely identifying each seller. |
| seller_id | NVARCHAR(50) | Source system seller ID. |
| seller_zip_code_prefix | NVARCHAR(20) | Postal code prefix. |
| seller_city | NVARCHAR(50) | City of the seller. |
| seller_state | NVARCHAR(10) | State/region abbreviation. |
| geolocation_lat | DECIMAL(9,6) | Latitude coordinate. |
| geolocation_lng | DECIMAL(9,6) | Longitude coordinate. |

---

### 4. gold.dim_review
**Purpose:** Contains customer reviews, ratings, and feedback.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| review_key | INT | **Surrogate key** uniquely identifying each review. |
| review_id | NVARCHAR(50) | Source system review ID. |
| review_score | INT | Rating score (1–5). |
| review_comment_title | NVARCHAR(MAX) | Review title. |
| review_comment_message | NVARCHAR(MAX) | Review message content. |
| review_creation_date | DATE | Creation date. |
| review_answer_timestamp | DATETIME | Response timestamp. |
| review_response_time_days | INT | Days to respond to the review. |

---

## 📦 Fact Tables

### 5. gold.fact_order
**Purpose:** Stores transactional order data linking customers, sellers, products, and reviews.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_id | NVARCHAR(50) | Unique order identifier. |
| customer_key | INT | **FK → dim_customer** |
| seller_key | INT | **FK → dim_seller** |
| product_key | INT | **FK → dim_product** |
| review_key | INT | **FK → dim_review** |
| order_item_id | INT | Order item identifier. |
| order_status | NVARCHAR(50) | Status of the order. |
| order_purchase_timestamp | DATETIME | Purchase timestamp. |
| order_approved_at | DATETIME | Approval timestamp. |
| order_delivered_carrier_date | DATETIME | Carrier delivery date. |
| order_delivered_customer_date | DATETIME | Customer delivery date. |
| order_estimated_delivery_date | DATE | Estimated delivery date. |
| approval_days | INT | Days to approve order. |
| shipping_days | INT | Days to ship order. |
| delivery_days | INT | Days to deliver order. |
| is_late | BIT | Late delivery flag. |
| price | DECIMAL(10,2) | Unit price. |
| freight_value | DECIMAL(10,2) | Shipping cost. |
| payment_sequential | INT | Payment sequence number. |
| payment_type | NVARCHAR(50) | Payment method. |
| payment_installments | INT | Installment count. |
| payment_value | DECIMAL(10,2) | Total payment value. |
| installment_value | DECIMAL(10,2) | Value per installment. |
| payment_value_category | NVARCHAR(50) | Payment value classification. |

---

## 💡 Design Notes
- **Schema:** Follows a **Star Schema** for simplicity and performance.
- **Keys:** Uses **Surrogate Keys** in Dimensions and **Foreign Keys** in Fact tables.
- **Granularity:** Fact table stores order-item level data.
- **Enrichment:** Dimensions enriched with geographic and descriptive attributes.

---
