select
*
from silver.stations s1
where not exists 
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

select
*
from silver.station_complexes
select
*
from silver.stations
select
*
from silver.geo_nyc_borough_boundaries

select
station_id
from silver.stations
group by station_id
having count(*) > 1

select
*
from bronze.subway_ridership_2013_present
select
*
from silver.stations
select
*
from silver.station_entrances

select
stop_id
from silver.stop_times
group by stop_id
having count(*) > 1

exec silver.load_silver

select
*
from bronze.subway_ridership_2013_present
select
distinct daytime_routes,
station_name
from silver.stations
order by station_name desc

select
*
from bronze.subway_ridership_2013_present
where station_name = '111 St'
select
station_name
from bronze.subway_ridership_2013_present
group by station_name
having count(*) > 1
