-- geo_nyc_borough_boundaries
select
trim(borough_code) as borough_code,
trim(borough_name) as borough_name,
round(borough_area,0) as borough_area,
round(borough_len,2) as borough_len
from bronze.geo_nyc_borough_boundaries;

-- routes
select
trim(route_id) as route_id,
trim(route_long_name) as route_long_name,
replace(route_describe,'"','') as route_describe,
route_type as route_type
from bronze.routes

--station_complexes
select
trim(complex_id) as complex_id,
trim(complex_name) as complex_name
from bronze.station_complexes;

--station_entrances
select
trim(division) as division,
trim(line) as line,
trim(station_name) as station_name,
station_lat,
station_lon,
trim(route_1) as route_1,
trim(route_2) as route_2,
trim(route_3) as route_3,
trim(route_4) as route_4,
trim(route_5) as route_5,
trim(route_6) as route_6,
trim(route_7) as route_7,
trim(route_8) as route_8,
trim(route_9) as route_9,
trim(route_10) as route_10,
trim(route_11)as route_11,
trim(entrance_type) as entrance_type,
case staff
	when 'NONE' then 'None'
	when 'FULL' then 'Full'
	when 'Spc Ev' then 'Special Event'
	when 'PART' then 'Partial'
	else staff
end as staff,
trim(staff_hours) as staff_hours,
trim(ada_notes),
case free_crossover
	when 'TRUE' then 'True'
	when 'FALSE' then 'False'
	else free_crossover
end as free_crossover,
trim(north_south_street) as north_south_street,
trim(east_west_street) as east_west_street,
case
	when trim(upper(corner)) is null then 'n/a'
	when trim(upper(corner)) = 'NW' then 'Northwest'
	when trim(upper(corner)) = 'N' then 'North'
	when trim(upper(corner)) = 'W' then 'West'
	when trim(upper(corner)) = 'SE' then 'Southeast'
	when trim(upper(corner)) = 'S' then 'South'
	when trim(upper(corner)) = 'SW' then 'Southwest'
	when trim(upper(corner)) = 'NE' then 'Norhteast'
	else trim(corner)
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





select
*
from bronze.station_entrances
where trim(station_name) not in (select trim(station_name) from bronze.stations);

SELECT *
FROM bronze.station_entrances se
WHERE NOT EXISTS (
    SELECT 1
    FROM bronze.stations s
    WHERE s.station_lat = se.station_lat
      AND s.station_lon = se.station_lon
);

select
*
from bronze.stations a
inner join bronze.station_entrances b
on a.station_lon = b.station_lon
and a.station_lat = b.station_lat
and a.station_name <> b.station_name

select
*
from bronze.stations
where station_name like '%Lexington%';
select
*
from bronze.station_entrances
where station_name like '%Lexington%';

-- stations
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
trim(north_direction_label) as structure,
trim(south_direction_label) as structure
from bronze.stations
where borough_name in (select borough_name from silver.geo_nyc_borough_boundaries)
-- and complex_id in (select complex_id from silver.station_complexes) Don't know if we can use station_complexes as the master table

select
distinct complex_id
from bronze.stations
where complex_id not in (select complex_id from bronze.station_complexes)

--stop_times
select
-- split up trip id into trip_id and service_id
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
and trip_id in (select trip_id from bronze.trips) -- only take trip_id records that can be found from the master table

-- subway_ridership_2013_present
select
trim(station_name),
-- remove routes column as it is redundant
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

--trips

select
trim(route_id) as route_id,
trim(service_id) as service_id,
substring(trip_id,CHARINDEX('_',trip_id)+1,6) as serial_id,
trim(trip_id) as trip_id,
trim(trip_headsign) as trip_headsign,
-- remove block_id, as there are only null values in the column. update silver_DDL accordingly.
trim(shape_id) as shape_id
from bronze.trips
where route_id in (select route_id from bronze.routes)
-- we assume trips table is the master table for trip_id
-- we assume routes table is the master table for route_id

select
distinct route_id
from bronze.trips
select
distinct route_id
from bronze.routes

-- where dropoff_type <> trim(dropoff_type)

