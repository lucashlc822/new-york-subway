# Data Catalog for the Gold Layer

## Overview
The gold layer provides a **business-level representation** of the data, consisting of three **dimension** tables and one **fact** table.

---

### View #1: **gold.dim_stations**
- **Purpose:** This table stores all of the station information, including structure and geographics.
- **Columns:**

| Column Name | Data Type | Description |
| ------------|-----------|-------------|
| station_key | INT | Surrogate key that identifies each station record in the table. |
| station_name  | NVARCHAR(200) | String representing the given name of the station. |
| complex_id | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| complex_name | NVARCHAR(50) | String representing the customer's first name |
| gifts_stop_id | NVARCHAR(50) | Unique alphanumeric identifier assigned to the station stop, per the General Transit Feed Specification Data. |
| divison | NVARCHAR(50) | MTA operational division to which the station belongs (e.g., IRT, BMT, IND). |
| line | NVARCHAR(50) | Subway line(s) served by the station (e.g., "1", "2", "3"). |
| borough_code | NVARCHAR(50) | Numeric code representing the NYC borough where the station is located. |
| borough_name | NVARCHAR(50) | Name of the borough (e.g., Manhattan, Bronx, Brooklyn). |
| borough_area | FLOAT | Area (in square miles) of the borough. |
| borough_length | FLOAT | Approximate length or extent of the borough. |
| daytime_routes | NVARCHAR(50) | List of routes that stop at the station during daytime hours. |
| structure | NVARCHAR(50) | Type of station structure (e.g., elevated, underground). |
| label_going_north | NVARCHAR(100) | Directional signage label for northbound service. |
| label_going_south | NVARCHAR(100) | Directional signage label for southbound service. |
| latitude | FLOAT | Geographic latitude coordinate of the station. |
| longitude | FLOAT | Geographic longitude coordinate of the station. |

---

## View #2: **gold.dim_products**
- **Purpose:** This table stores all of the product information, including the category, cost, and product_line.
- **Columns:**

| Column Name | Data Type | Description |
| ------------|-----------|-------------|
| product_key | INT | Surrogate key that identifies each product record in the table. |
| produt_id | INT | Unique numerical identifier assigned to each product. |
| product_number | NVARCHAR(50) | Alphanumeric identifier representing the product, used for tracking and referencing. |
| product_name | NVARCHAR(50) | String representing the name of the product |
| category_id | NVARCHAR(50) | String representing the identifier for each product category. |
| category | NVARCHAR(50) | String representing the product category. |
| subcategory | NVARCHAR(50) | String representing the product subcategory. |
| maintenance | NVARCHAR(50) | String stating whether the product requires maintenance (e.g., Yes, No)
| cost | INT | Cost of the product in whole currency units (e.g., 100). |
| product_line | NVARCHAR(50) | String representing the product line (e.g., Road, Mountain).
| start_date | DATE | The date when the product became available for sale or use (e.g., 2011-09-07). | |

---

## View #3: **gold.fact_sales**
-  **Purpose:** This table stores all of the sales information, including the order date, sales amount, and prices.
-  **Columns:**

| Column Name | Data Type | Description |
| ------------|-----------|-------------|
| order_number | NVARCHAR(50) | Alphanumeric identifier representing the order, used for tracking and referencing. |
| product_key | INT | Key for navigating to the customer referenced from **gold.dim_customer**. |
| customer_key | INT | Key for navigating to the product referenced from **gold.dim_products**.|
| order_date | DATE | The date that the product was ordered. |
| shipping_date | DATE | The date that the product was shipped. |
| due_date | DATE | The date when the order payment is due (e.g., (1999-01-01). |
| sales_amount | INT | The amount purchased from the sale, in whole currency units (e.g., 1000) |
| quantity | INT | The quantity of the product that was purchased, in whole units (e.g., 3) |
| price | INT | The price per unit of the product that was purchased, in whole currency units (e.g., 100). |
