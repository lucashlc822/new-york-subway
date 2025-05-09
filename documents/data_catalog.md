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

## View #2: **gold.dim_station_entrances**
- **Purpose:** This table stores all the information for the station entrances, including the entrance type, routes, and geographics.
- **Columns:**

| Column Name | Data Type | Description |
| ------------|-----------|-------------|
| station_key | INT | Foreign key referencing dim_stations; uniquely identifies the parent station. |
| entrance_type | NVARCHAR(50) | Type of entrance (e.g., stair, ramp, elevator, easement). |
| station_corner | NVARCHAR(10) | Cardinal intersection corner (e.g., Northwest, Southeast). |
| north_south_street | NVARCHAR(100) | North-south street name where the entrance is located. |
| east_west_street | NVARCHAR(100) |  North-south street name where the entrance is located. |
| entrance_latitude | FLOAT | Latitude coordinate of the station entrance. |
| entrance_longitude | FLOAT | Longitude coordinate of the station entrance. |
| free_crossover | NVARCHAR(10) | True if free cross-platform/crossover is allowed; otherwise False. |
| entry | NVARCHAR(10) | 	True if entry is allowed at this entrance; otherwise False. |
| exit_only | NVARCHAR(10) | True if the entrance is exit-only; otherwise False. |
| route_1 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_2 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_3 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_4 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_5 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_6 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_7 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_8 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_9 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_10 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| route_11 | NVARCHAR(10) | Subway route served at the entrance (e.g., A, 6, J); n/a if not applicable. |
| staff_type | NVARCHAR(50) | Type of staffing (e.g., Full-time, Part-time, Spc Ev). |
| staff_hours | NVARCHAR(100) | Staffing hours (e.g., "6 am - 10 pm", "Varies"). |
| ada_compliant | NVARCHAR(10) | True if entrance is ADA-accessible; False if not. |
| ada_notes | NVARCHAR(255) | Notes related to ADA accessibility (e.g., elevator location, limitations). |

---

## View #3: **gold.dim_stop_times**
-  **Purpose:** This table stores all of the information on subway stop times, including arrival time, departure time, and the associated route.
-  **Columns:**

| Column Name | Data Type | Description |
| ------------|-----------|-------------|
| stop_key | INT | 	Surrogate key uniquely identifying each stop time record. |
| stop_id | NVARCHAR(20)| Unique alphanumeric identifier of the stop. |
| trip_id | NVARCHAR(50) | Unique alphanumeric identifier for a specific trip within a route and service. |
| service_id | NVARCHAR(50) | Identifies the service schedule (e.g., weekday, weekend, holiday). |
| serial_id | NVARCHAR(50) | Serial order or technical sequence identifier. |
| shape_id | NVARCHAR(50) | Identifier that references the shape of the route path for mapping purposes. |
| route_id | NVARCHAR(50) | Route identifier (e.g., "A", "7", "NQR"). |
| route_name | NVARCHAR(100) | Descriptive name of the subway route. |
| route_details | NVARCHAR(255) | Additional description of the route (e.g., stations, boroughs). |
| route_type | NVARCHAR(20) | Type of route (e.g., Subway, Bus) displayed as a GTFS type code. |
| trip_headsign | NVARCHAR(100) | Text displayed to passengers to identify the destination of the trip. |
| direction_id | NVARCHAR(10) | Indicates travel direction: 0 (e.g., southbound) or 1 (northbound). |
| arrival_time | TIME(0) | Time the train is scheduled to arrive at the stop. |
| departure_time | TIME(0) | Time the train is scheduled to depart from the stop. |
| stop_sequence | NVARHCAR(10) | Order of the stop within the trip (starts from 1 and increases sequentially). |
| pickup_type | NVARCHAR(10) | Indicates if passengers can be picked up: 0 (regular), 1 (no pickup), etc. |
| dropoff_type | NVARCHAR(10) | Indicates if passengers can be dropped off: 0 (regular), 1 (no drop-off), etc. |

---

## View #4: **gold.dim_trips**
-  **Purpose:** This table stores all of the information on subway stop times, including arrival time, departure time, and the associated route.
-  **Columns:**




