/*
======================================================
DDL Script: Gold Layer
======================================================
Script Purpose:
	This script creates views for the gold layer in the data warehouse.
	The Gold Layer represents the final dimension and fact tables.

	Each view performs transformations and combines data from the Silver Layer to produce a clean, enriched, and biusiness-ready dataset.

Usage:
	- These views can be queried directly for analytics and reporting.
======================================================
*/

-- ===================================
-- Create Dimension: gold.dim_stations
-- ===================================
if object_id('gold.dim_stations','V') is not null
	drop view gold.dim_stations;
go

create view gold.dim_stations as
select
ROW_NUMBER() over (order by station_id asc) as station_key, --surrogate key
ss.station_name as station_name,
ss.complex_id as complex_id,
sc.complex_name as complex_name,
ss.gifts_stop_id as gifts_stop_id,
ss.divison as divison,
ss.line as line,
gb.borough_code as borough_code,
ss.borough_name as borough_name,
gb.borough_area as borough_area,
gb.borough_len as borough_length,
ss.daytime_routes as daytime_routes,
ss.structure as structure,
ss.north_direction_label as label_going_north,
ss.south_direction_label as label_going_south,
ss.station_lat as latitude,
ss.station_lon as longitude
from silver.stations ss
left join silver.station_complexes sc
on ss.complex_id = sc.complex_id
left join silver.geo_nyc_borough_boundaries gb
on ss.borough_name = gb.borough_name;
go

-- ===================================
-- Create Dimension: gold.dim_trips
-- ===================================
if object_id('gold.dim_trips','V') is not null
	drop view gold.dim_trips;
go

create view gold.dim_trips as 
select
st.trip_id as trip_id,
st.service_id as service_id,
st.serial_id as serial_id,
st.shape_id as shape_id,
st.route_id as route_id,
sr.route_long_name as route_name,
sr.route_describe as route_details,
sr.route_type as route_type,
st.trip_headsign as trip_headsign,
st.direction_id as direction_id
from silver.trips st
left join silver.routes sr
on st.route_id = sr.route_id
go

-- =====================================
-- Create Dimension: gold.dim_stop_times
-- =====================================

if object_id('gold.dim_stop_times','V') is not null
	drop view gold.dim_stop_times;
go

create view gold.dim_stop_times as 
select
row_number() over (order by st.trip_id, st.stop_id) as stop_key,
st.stop_id as stop_id,
st.trip_id as trip_id,
gt.service_id as service_id,
gt.serial_id as serial_id,
gt.shape_id as shape_id,
gt.route_id as route_id,
gt.route_name as route_name,
gt.route_details as route_details,
gt.route_type as route_type,
gt.trip_headsign as trip_headsign,
gt.direction_id as direction_id,
st.arrival_time as arrival_time,
st.departure_time as departure_time,
st.stop_sequence as stop_sequence,
st.pickup_type as pickup_type,
st.dropoff_type as dropoff_type
from silver.stop_times st
left join gold.dim_trips gt
on st.trip_id = gt.trip_id;
go

-- =====================================
-- Create Dimension: gold.dim_stop_times
-- =====================================

if object_id('gold.dim_station_entrances','V') is not null
	drop view gold.dim_station_entrances;
go

create view gold.dim_station_entrances as
select
s.station_key as station_key,
e.entrance_type,
e.corner as station_corner,
e.north_south_street as north_south_street,
e.east_west_street as east_west_street,
e.entrance_lat as entrance_latitude,
e.entrance_lon as entrance_longitude,
e.free_crossover as free_crossover,
e.entry as entry,
e.exit_only as exit_only,
e.route_1 as route_1,
e.route_2 as route_2,
e.route_3 as route_3,
e.route_4 as route_4,
e.route_5 as route_5,
e.route_6 as route_6,
e.route_7 as route_7,
e.route_8 as route_8,
e.route_9 as route_9,
e.route_10 as route_10,
e.route_11 as route_11,
e.staff as staff_type,
e.staff_hours as staff_hours,
ada_compliant as ada_compliant,
ada_notes as ada_notes
from silver.station_entrances e
left join gold.dim_stations s
on e.station_lat = s.latitude
and e.station_lon = s.longitude;
go

-- ============================================
-- Create Dimension: gold.fact_subway_ridership
-- ============================================

if object_id('gold.fact_subway_ridership','V') is not null
	drop view gold.fact_subway_ridership;
go

create view gold.fact_subway_ridership as
select
gs.station_key as station_key,
sr.ridership_2013 as ridership_2013,
sr.ridership_2014 as ridership_2014,
sr.ridership_2015 as ridership_2015,
sr.ridership_2016 as ridership_2016,
sr.ridership_2017 as ridership_2017,
sr.ridership_2018 as ridership_2018,
sr.change_2018_raw as change_2018,
sr.change_2018_percent as percentage_change_2018,
sr.rank_ridership_2018 as rank_ridership_2018
from silver.subway_ridership_2013_present sr
left join gold.dim_stations gs
on sr.station_name = gs.station_name
where gs.daytime_routes like '%'+ sr.routes + '%';
go