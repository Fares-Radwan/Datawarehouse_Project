# Data Catalog for Gold Layer

## Overview
The **Gold Layer** is the business-level data representation, structured to support analytical and reporting use cases.  
It consists of **dimension tables** and **fact tables** containing enriched business data for decision-making.

---

## 1. gold.dim_customer
**Purpose:** Stores customer details enriched with geographic and location data.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INT | **Surrogate key** uniquely identifying each customer record in the dimension table. |
| customer_id | NVARCHAR(50) | Unique identifier assigned to each customer in the source system. |
| customer_unique_id | NVARCHAR(50) | Unique alphanumeric ID for the customer, used for tracking across systems. |
| customer_zip_code_prefix | NVARCHAR(20) | Postal code prefix for the customer’s address. |
| customer_city | NVARCHAR(50) | Name of the customer’s city. |
| customer_state | NVARCHAR(10) | Abbreviation of the customer’s state or region. |
| geolocation_lat | DECIMAL(9,6) | Latitude coordinate for the customer’s location. |
| geolocation_lng | DECIMAL(9,6) | Longitude coordinate for the customer’s location. |

---

## 2. gold.dim_product
**Purpose:** Provides product information with detailed attributes for categorization and analysis.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INT | **Surrogate key** uniquely identifying each product record. |
| product_id | NVARCHAR(50) | Unique identifier assigned to the product in the source system. |
| product_category_name | NVARCHAR(100) | Original product category name in the source language. |
| product_category_name_english | NVARCHAR(100) | Translated product category name in English. |
| product_name_lenght | INT | Length of the product name in characters. |
| product_description_lenght | INT | Length of the product description in characters. |
| product_photos_qty | INT | Number of photos available for the product. |
| product_weight_g | DECIMAL(10,2) | Weight of the product in grams. |
| product_length_cm | DECIMAL(10,2) | Length of the product in centimeters. |
| product_height_cm | DECIMAL(10,2) | Height of the product in centimeters. |
| product_width_cm | DECIMAL(10,2) | Width of the product in centimeters. |
| product_volume_l | DECIMAL(10,2) | Volume of the product in liters. |
| weight_category | NVARCHAR(50) | Classification of the product based on weight range. |

---

## 3. gold.dim_seller
**Purpose:** Stores seller details enriched with location information.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| seller_key | INT | **Surrogate key** uniquely identifying each seller record. |
| seller_id | NVARCHAR(50) | Unique identifier assigned to the seller in the source system. |
| seller_zip_code_prefix | NVARCHAR(20) | Postal code prefix of the seller’s location. |
| seller_city | NVARCHAR(50) | Name of the seller’s city. |
| seller_state | NVARCHAR(10) | Abbreviation of the seller’s state or region. |
| geolocation_lat | DECIMAL(9,6) | Latitude coordinate for the seller’s location. |
| geolocation_lng | DECIMAL(9,6) | Longitude coordinate for the seller’s location. |

---

## 4. gold.dim_review
**Purpose:** Contains customer reviews, ratings, and feedback metrics.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| review_key | INT | **Surrogate key** uniquely identifying each review record. |
| review_id | NVARCHAR(50) | Unique identifier assigned to the review in the source system. |
| review_score | INT | Numerical score given by the customer (e.g., 1–5). |
| review_comment_title | NVARCHAR(MAX) | Short title or summary of the review. |
| review_comment_message | NVARCHAR(MAX) | Detailed comment or message provided by the customer. |
| review_creation_date | DATE | Date when the review was created. |
| review_answer_timestamp | DATETIME | Timestamp when the review was answered. |
| review_response_time_days | INT | Number of days taken to respond to the review. |

---

## 5. gold.fact_order
**Purpose:** Stores transactional order data linking customers, sellers, products, and reviews for analytical purposes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_id | NVARCHAR(50) | Unique identifier for the order. |
| customer_key | INT | **FK → dim_customer** – Links the order to the customer. |
| seller_key | INT | **FK → dim_seller** – Links the order to the seller. |
| product_key | INT | **FK → dim_product** – Links the order to the product. |
| review_key | INT | **FK → dim_review** – Links the order to the review. |
| order_item_id | INT | Unique identifier for the item within the order. |
| order_status | NVARCHAR(50) | Status of the order (e.g., 'delivered', 'shipped'). |
| order_purchase_timestamp | DATETIME | Timestamp when the order was placed. |
| order_approved_at | DATETIME | Timestamp when the order was approved. |
| order_delivered_carrier_date | DATETIME | Date when the order was handed to the carrier. |
| order_delivered_customer_date | DATETIME | Date when the order was delivered to the customer. |
| order_estimated_delivery_date | DATE | Estimated delivery date provided to the customer. |
| approval_days | INT | Number of days taken for order approval. |
| shipping_days | INT | Number of days taken to ship the order after approval. |
| delivery_days | INT | Number of days taken to deliver the order to the customer. |
| is_late | BIT | Indicates whether the delivery was late (1 = Yes, 0 = No). |
| price | DECIMAL(10,2) | Price of the product per unit. |
| freight_value | DECIMAL(10,2) | Shipping cost for the order item. |
| payment_sequential | INT | Sequence number of the payment attempt. |
| payment_type | NVARCHAR(50) | Payment method used (e.g., 'credit_card'). |
| payment_installments | INT | Number of installments for the payment. |
| payment_value | DECIMAL(10,2) | Total payment value for the order item. |
| installment_value | DECIMAL(10,2) | Value per installment. |
| payment_value_category | NVARCHAR(50) | Classification of payment value range. |
