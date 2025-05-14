/*
======================================================================================================
Stored Procedure: Loading the Silver Tables (Bronze -> Silver)
======================================================================================================
Script Purpose:
This stored procedure performs the ETL (extract, transform, load) to populate the silver schema tables.
Actions Performed:
	- Truncating the silver schema tables.
	- Inserting transformed and cleansed data from the bronze to the silver tables.

Paramters:
This stored procedure does not accept any parameters and does not return any values.

Usage Example:
EXEC silver.load_silver;
======================================================================================================
*/

create or alter procedure silver.load_silver as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = GETDATE();
		
		print '====================================';
		print 'Loading Silver Layer';
		print '====================================';

		-- start loading the first table bronze.geo_nyc_borough_boundaries
		set @start_time = GETDATE();
		print 'Truncating Table: silver.geo_nyc_borough_boundaries';
		truncate table silver.geo_nyc_borough_boundaries;
		print 'Inserting Data Into: silver.geo_nyc_borough_boundaries';
		insert into silver.geo_nyc_borough_boundaries (
		borough_code,
		borough_name,
		borough_area,
		borough_len
		)
		select
		trim(borough_code) as borough_code,
		trim(borough_name) as borough_name,
		round(borough_area,0) as borough_area,
		round(borough_len,2) as borough_len
		from bronze.geo_nyc_borough_boundaries;
		
		set @end_time = GETDATE();
		print 'Load Duration: ' + cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';
		print '--------------------------------------------'
		
		set @start_time = GETDATE();
		print 'Truncating Table: silver.routes';
		truncate table silver.routes;
		print 'Inserting Data Into: silver.routes';
		insert into silver.routes (
		route_id,
		route_long_name,
		route_describe,
		route_type
		)
		select
		trim(route_id) as route_id,
		trim(route_long_name) as route_long_name,
		trim(replace(route_describe,'"','')) as route_describe,
		trim(route_type) as route_type
		from bronze.routes;

		set @end_time = GETDATE();
		print 'Load Duration: '	+ cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';
		print '--------------------------------------------'

		--station_complexes
		set @start_time = GETDATE();
		print 'Truncating Table: silver.station_complexes';
		truncate table silver.station_complexes;
		print 'Inserting Data Into: silver.station_complexes'
		insert into silver.station_complexes(
		complex_id,
		complex_name
		)
		select
		trim(complex_id) as complex_id,
		trim(complex_name) as complex_name
		from bronze.station_complexes;

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';
		print '--------------------------------------------';

		set @start_time = GETDATE();
		print 'Truncating Table: silver.stations';
		truncate table silver.stations;
		print 'Inserting Data Into: silver.stations';
		insert into silver.stations (
		station_id,
		station_name,
		station_lat,
		station_lon,
		divison,
		line,
		complex_id,
		borough_name,
		gifts_stop_id,
		daytime_routes,
		structure,
		north_direction_label,
		south_direction_label
		)

		select
		trim(station_id) as station_id,
		trim(station_name) as station_name,
		station_lat,
		station_lon,
		trim(divison) as divison,
		trim(line) as line,
		trim(complex_id)as complex_id,
		trim(borough_name) as borough_name,
		trim(gifts_stop_id) as gifts_stop_id,
		trim(daytime_routes) as daytime_routes,
		trim(structure) as structure,
		trim(north_direction_label) as north_direction_label,
		trim(south_direction_label) as south_direction_label
		from bronze.stations s1
		where borough_name in (select borough_name from silver.geo_nyc_borough_boundaries)
		and not exists 
		(select
		1 from 
		(select
		station_lat,
		station_lon
		from bronze.stations
		group by station_lat, station_lon
		having count(*) > 1) s2
		where s1.station_lat = s2.station_lat
		and s1.station_lon = s2.station_lon
		);

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast(datediff(second, @end_time, @start_time) as nvarchar) + 'seconds';
		print '--------------------------------------------';

				set @start_time = GETDATE();
		print 'Truncating Table: silver.station_entrances';
		truncate table silver.station_entrances;
		print 'Inserting Data Into: silver.station_entrances';
		insert into silver.station_entrances (
		division,
		line,
		station_name,
		station_lat,
		station_lon,
		route_1,
		route_2,
		route_3,
		route_4,
		route_5,
		route_6,
		route_7,
		route_8,
		route_9,
		route_10,
		route_11,
		entrance_type,
		staff,
		staff_hours,
		ada_notes,
		free_crossover,
		north_south_street,
		east_west_street,
		corner,
		entrance_lat,
		entrance_lon,
		entry,
		exit_only,
		vending,
		ada_compliant
		)

		select
		trim(division) as division,
		trim(line) as line,
		trim(station_name) as station_name,
		station_lat as station_latitude,
		station_lon as station_longitude,
		trim(isnull(route_1,'n/a')) as route_1,
		trim(isnull(route_2,'n/a')) as route_2,
		trim(isnull(route_3,'n/a')) as route_3,
		trim(isnull(route_4,'n/a')) as route_4,
		trim(isnull(route_5,'n/a')) as route_5,
		trim(isnull(route_6,'n/a')) as route_6,
		trim(isnull(route_7,'n/a')) as route_7,
		trim(isnull(route_8,'n/a')) as route_8,
		trim(isnull(route_9,'n/a')) as route_9,
		trim(isnull(route_10,'n/a')) as route_10,
		trim(isnull(route_11,'n/a')) as route_11,
		trim(entrance_type) as entrance_type,
		case staff
			when 'NONE' then 'None'
			when 'FULL' then 'Full'
			when 'Spc Ev' then 'Special Event'
			when 'PART' then 'Partial'
			else staff
		end as staff,
		trim(isnull(staff_hours,'n/a')) as staff_hours,
		trim(isnull(ada_notes,'n/a')) as ada_notes,
		case free_crossover
			when 'TRUE' then 'True'
			when 'FALSE' then 'False'
			else trim(isnull(free_crossover,'n/a'))
		end as free_crossover,
		trim(isnull(north_south_street,'n/a')) as north_south_street,
		trim(isnull(east_west_street,'n/a')) as east_west_street,
		case
			when trim(upper(corner)) is null then 'n/a'
			when trim(upper(corner)) = 'NW' then 'Northwest'
			when trim(upper(corner)) = 'N' then 'North'
			when trim(upper(corner)) = 'W' then 'West'
			when trim(upper(corner)) = 'SE' then 'Southeast'
			when trim(upper(corner)) = 'S' then 'South'
			when trim(upper(corner)) = 'SW' then 'Southwest'
			when trim(upper(corner)) = 'NE' then 'Norhteast'
			else trim(isnull(corner,'n/a'))
		end as corner,
		entrance_lat,
		entrance_lon,
		case trim(upper(entry))
			when 'TRUE' then 'True'
			when 'FALSE' then 'False'
			else 'n/a'
		end as entry,
		case trim(upper(exit_only))
			when 'TRUE' then 'True'
			when 'FALSE' then 'False'
			else 'n/a'
		end as exit_only,
		case trim(upper(vending))
			when 'TRUE' then 'True'
			when 'FALSE' then 'False'
			else 'n/a'
		end as vending,
		case trim(upper(ada_compliant))
			when 'TRUE' then 'True'
			when 'FALSE' then 'False'
			else 'n/a'
		end as ada_compliant
		from bronze.station_entrances;

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';
		print '--------------------------------------------';

		set @start_time = GETDATE();
		print 'Truncating Table: silver.stop_times';
		truncate table silver.stop_times;
		print 'Inserting Data Into: silver.stop_times';
		insert into silver.stop_times (
		trip_id,
		arrival_time,
		departure_time,
		stop_id,
		stop_sequence,
		pickup_type,
		dropoff_type
		)

		select
		trim(trip_id) as trip_id,
		cast(arrival_time as time(0)) as arrival_time, --specify precision as time(0) to removem miliseconds
		cast(departure_time as time(0)) as departure_time, --specify precision as time(0) to removem miliseconds
		trim(stop_id) as stop_id,
		trim(stop_sequence) as stop_seuqence,
		trim(pickup_type) as pickup_type,
		trim(dropoff_type) as dropoff_type
		-- remove stop_headsign column because all columns are null
		-- remove shape_dist_traveled column because all columns are null
		from bronze.stop_times
		where (case
		when len(arrival_time) > 7 then cast(substring(arrival_time,1,2) as int)
		else cast(substring(arrival_time,1,1) as int)
		end) < 24
		and
		(case
		when len(departure_time) > 7 then cast(substring(departure_time,1,2) as int)
		else cast(substring(departure_time,1,1) as int)
		end) < 24 -- filter out times that are beyond the 24-hour clock
		and trip_id in (select trip_id from bronze.trips)

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast(datediff(second, @end_time, @start_time)as nvarchar) + 'seconds';
		print '--------------------------------------------';

		set @start_time = GETDATE();
		print 'Truncating table: silver.subway_ridership_2013_present';
		truncate table silver.subway_ridership_2013_present;
		print 'Inserting Data Into: silver.subway_ridership_2013_present';
		insert into silver.subway_ridership_2013_present (
		station_name,
		routes,
		ridership_2013,
		ridership_2014,
		ridership_2015,
		ridership_2016,
		ridership_2017,
		ridership_2018,
		change_2018_raw,
		change_2018_percent,
		rank_ridership_2018
		)

		select
		trim(station_name) as station_name,
		-- remove routes column as it is redundant
		replace(replace(routes,'"',''),',',' ') as routes,
		ridership_2013,
		ridership_2014,
		ridership_2015,
		ridership_2016,
		ridership_2017,
		ridership_2018,
		change_2018_raw,
		round(change_2018_percent*100,2) as change_2018_percent,
		rank_ridership_2018
		from bronze.subway_ridership_2013_present
		where station_name in (select distinct station_name from silver.stations) --only taking stations that are in the stations table, assume it is the master (most up to date)
		
		set @end_time = GETDATE();
		print 'Load Duration: ' + cast(datediff(second, @end_time, @start_time) as nvarchar);
		print '--------------------------------------------';

		set @start_time = GETDATE();
		print 'Truncating Table: silver.trips';
		truncate table silver.trips;
		print 'Inserting Data Into: silver.trips';
		insert into silver.trips (
		route_id,
		service_id,
		serial_id,
		trip_id,
		trip_headsign,
		direction_id,
		shape_id
		)

		select
		trim(route_id) as route_id,
		trim(service_id) as service_id,
		substring(trip_id,CHARINDEX('_',trip_id)+1,6) as serial_id,
		trim(trip_id) as trip_id,
		trim(trip_headsign) as trip_headsign,
		trim(direction_id) as direction_id,
		trim(shape_id) as shape_id
		from bronze.trips
		where route_id in (select route_id from bronze.routes)
		-- we assume trips table is the master table for trip_id
		-- we assume routes table is the master table for route_id

		set @end_time = GETDATE();
		print 'Load Duration: ' + cast(datediff(second, @end_time, @start_time) as nvarchar) + 'seconds';
		print '--------------------------------------------';

		set @batch_end_time = GETDATE();
		print '==========================================';
		print 'Loading Silver Layer Completed';
		print 'Total Duration: ' + cast(datediff(second, @batch_end_time, @batch_start_time) as nvarchar) + 'seconds';
		print '==========================================';

	end try

	begin catch
		print '====================================';
		print 'Error Loading Silver Layer';
		print 'Error Message: ' + ERROR_MESSAGE();
		print 'Error Number: ' + cast(error_number() as nvarchar);
		print 'Error State: ' + cast(error_state() as nvarchar);
		print '====================================';
	end catch
end