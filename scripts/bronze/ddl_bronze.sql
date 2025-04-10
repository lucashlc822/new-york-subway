/*
===============================================================================================================
DDL Script: Creating Bronze Tables
===============================================================================================================
Script Purpose:
	This script creates all tables required for the bronze schema, dropping any existing tables if they already exist.

	Run this script to redefine the Data Definition Language (DDL) of the Bronze Tables.
===============================================================================================================
*/

-- check if table with the same name exists and drop the table if so.
if object_id('bronze.geo_nyc_borough_boundaries','U') is not null
	drop table bronze.geo_nyc_borough_boundaries;
go

-- creating table named bronze.geo_nyc_borough_boundaries
create table bronze.geo_nyc_borough_boundaries (
	borough_code	NVARCHAR(50),
	borough_name	NVARCHAR(50),
	borough_area	FLOAT,
	borough_len		FLOAT
);
go

-- repeat process for all tables
if object_id('bronze.routes','U') is not null
	drop table bronze.routes;
go

create table bronze.routes (
	route_id			nvarchar(50),
	route_short_name	nvarchar(50),
	route_long_name		nvarchar(50),
	route_describe		nvarchar(500),
	route_type			nvarchar(10)
);
go

if object_id('bronze.station_complexes','U') is not null
	drop table bronze.station_complexes;
go

create table bronze.station_complexes (
	complex_id		NVARCHAR(50),
	complex_name	NVARCHAR(100)
);
go

if object_id('bronze.station_entrances','U') is not null
	drop table bronze.station_entrances;
go

create table bronze.station_entrances (
	division		NVARCHAR(10),
	line			NVARCHAR(50),
	station_name	NVARCHAR(50),
	station_lat		FLOAT,
	station_lon		FLOAT,
	route_1			NVARCHAR(10),
	route_2			NVARCHAR(10),
	route_3			NVARCHAR(10),
	route_4			NVARCHAR(10),
	route_5			NVARCHAR(10),
	route_6			NVARCHAR(10),
	route_7			NVARCHAR(10),
	route_8			NVARCHAR(10),
	route_9			NVARCHAR(10),
	route_10		NVARCHAR(10),
	route_11		NVARCHAR(10),
	entrance_type	NVARCHAR(20),
	staff			NVARCHAR(50),
	staff_hours		NVARCHAR(50),
	ada_notes		NVARCHAR(50),
	free_crossover	NVARCHAR(10),
	north_south_street	NVARCHAR(50),
	east_west_street	NVARCHAR(50),
	corner	NVARCHAR(10),
	entrance_lat	FLOAT,
	entrance_lon	FLOAT,
	entry	NVARCHAR(10),
	exit_only	NVARCHAR(10),
	vending		NVARCHAR(10),
	ada_compliant NVARCHAR(10)
);
go

if object_id('bronze.stations','U') is not null
	drop table bronze.stations;
go

create table bronze.stations (
	station_id NVARCHAR(10),
	complex_id	NVARCHAR(10),
	gifts_stop_id	NVARCHAR(10),
	divison	NVARCHAR(10),
	line	NVARCHAR(50),
	station_name	NVARCHAR(50),
	borough_name	NVARCHAR(50),
	daytime_routes	NVARCHAR(10),
	structure		NVARCHAR(50),
	north_direction_label	NVARCHAR(50),
	south_direction_label	NVARCHAR(50),
	station_lat	FLOAT,
	station_lon	FLOAT
);
go

if object_id('bronze.stop_times','U') is not null
	drop table bronze.stop_times;
go

create table bronze.stop_times (
	trip_id	NVARCHAR(200),
	arrival_time	NVARCHAR(10),
	departure_time NVARCHAR(50),
	stop_id	NVARCHAR(20),
	stop_sequence	NVARCHAR(10),
	stop_headsign	NVARCHAR(50),
	pickup_type	NVARCHAR(10),
	dropoff_type	NVARCHAR(10),
	shape_dist_traveled	NVARCHAR(50)
);
go

if object_id('bronze.subway_ridership_2013_present','U') is not null
	drop table bronze.subway_riders_2013_present;
go

create table bronze.subway_ridership_2013_present (
	station_name	NVARCHAR(50),
	routes	NVARCHAR(50),
	ridership_2013	INT,
	ridership_2014	INT,
	ridership_2015	INT,
	ridership_2016	INT,
	ridership_2017	INT,
	ridership_2018	INT,
	change_2018_raw	INT,
	change_2018_percent	FLOAT,
	rank_ridership_2018	INT
);
go

if object_id('bronze.trips','U') is not null
	drop table bronze.trips;
go

create table bronze.trips (
	route_id NVARCHAR(10),
	service_id	NVARCHAR(200),
	trip_id	NVARCHAR(200),
	trip_headsign	NVARCHAR(100),
	direction_id	NVARCHAR(10),
	block_id	NVARCHAR(10),
	shape_id	NVARCHAR(50)
);
go
