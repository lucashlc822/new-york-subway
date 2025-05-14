/*
==============================
Stored Procedure: Load the Bronze Layer (Source -> Bronze)
==============================
Script Purpose:
	This stored procedure loads data into the bronze schema from external CSV files.
	It performs the following steps:
	- Truncates all of the bronze tables before loading any data.
	- Uses the bulk insert command to load the data
	- Identifies the time duration to load the batch of files, as well as the duration to load each table.

Parameters:
	None. This stored procedure does not accept paraemeters or return any values.

Usage Examples:
EXEC bronze.load_bronze
==============================
*/

create or alter procedure bronze.load_bronze as 
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = GETDATE();
		print '==============================';
		print 'Loading Bronze Layer';
		print '==============================';

		print '==============================';
		print 'Loading Tables';
		print '==============================';

		-- BRONZE.GEO_NYC_BOROUGH_BOUNDARIES
		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.geo_nyc_borough_boundaries';
		truncate table bronze.geo_nyc_borough_boundaries; --clear out the table before uploading data
		print '>> Inserting Data into Table: bronze.geo_nyc_borough_boundaries';
		bulk insert bronze.geo_nyc_borough_boundaries
		from 'D:\Data Analytics\Projects\Bigquery - New York Subway\Dataset\cleaned\geo_nyc_borough_boundaries.csv'
		with (
				firstrow = 2,-- first row of data starts on row 2, which is right beneath the header. 
				fieldterminator = ',', -- this denotes the delimiter of the csv file.
				rowterminator = '0x0d0a', -- windows-style newline.
				codepage = '65001', -- to ensure ETF-8 encoding
				tablock -- lock the entire table until the transaction is completed (bulk insert).
		);
		set @end_time = getdate();
		print '>> Load Duration: '+ cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';

		-- repeat process for the rest of the tables:

		-- BRONZE.ROUTES
		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.routes';
		truncate table bronze.routes; --clear out the table before uploading data
		print '>> Inserting Data into Table: bronze.routes';
		bulk insert bronze.routes
		from 'D:\Data Analytics\Projects\Bigquery - New York Subway\Dataset\formatted\routes.txt'
		-- since one of the string columns have commas within it, change the delimiter of the file to be tab separated.
		with (
				firstrow = 2,-- first row of data starts on row 2, which is right beneath the header. 
				fieldterminator = '\t', -- this denotes the delimiter of the csv file.
				rowterminator = '0x0d0a', -- windows-style newline.
				codepage = '65001', -- to ensure ETF-8 encoding
				tablock -- lock the entire table until the transaction is completed (bulk insert).
		);
		set @end_time = getdate();
		print '>> Load Duration: '+ cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';

		-- BRONZE.STATION_COMPLEXES
		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.station_complexes';
		truncate table bronze.station_complexes; --clear out the table before uploading data
		print '>> Inserting Data into Table: bronze.station_complexes';
		bulk insert bronze.station_complexes
		from 'D:\Data Analytics\Projects\Bigquery - New York Subway\Dataset\formatted\station_complexes.csv'
		with (
				firstrow = 2,-- first row of data starts on row 2, which is right beneath the header. 
				fieldterminator = ',', -- this denotes the delimiter of the csv file.
				rowterminator = '0x0d0a', -- windws-style newline.
				codepage = '65001', -- to ensure ETF-8 encoding
				tablock -- lock the entire table until the transaction is completed (bulk insert).
		);
		set @end_time = getdate();
		print '>> Load Duration: '+ cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';

		-- BRONZE.STATION_ENTRANCES
		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.station_entrances';
		truncate table bronze.station_entrances; --clear out the table before uploading data
		print '>> Inserting Data into Table: bronze.station_entrances';
		bulk insert bronze.station_entrances
		from 'D:\Data Analytics\Projects\Bigquery - New York Subway\Dataset\original\station_entrances.csv'
		with (
				firstrow = 2,-- first row of data starts on row 2, which is right beneath the header. 
				fieldterminator = ',', -- this denotes the delimiter of the csv file.
				rowterminator = '0x0d0a', -- windws-style newline.
				codepage = '65001', -- to ensure ETF-8 encoding
				tablock -- lock the entire table until the transaction is completed (bulk insert).
		);
		set @end_time = getdate();
		print '>> Load Duration: '+ cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';

		-- BRONZE.STATIONS
		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.stations';
		truncate table bronze.stations; --clear out the table before uploading data
		print '>> Inserting Data into Table: bronze.stations';
		bulk insert bronze.stations
		from 'D:\Data Analytics\Projects\Bigquery - New York Subway\Dataset\original\stations.csv'
		with (
				firstrow = 2,-- first row of data starts on row 2, which is right beneath the header. 
				fieldterminator = ',', -- this denotes the delimiter of the csv file.
				rowterminator = '0x0d0a', -- windws-style newline.
				codepage = '65001', -- to ensure ETF-8 encoding
				tablock -- lock the entire table until the transaction is completed (bulk insert).
		);
		set @end_time = getdate();
		print '>> Load Duration: '+ cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';

		-- BRONZE.STOP_TIMES
		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.stop_times';
		truncate table bronze.stop_times; --clear out the table before uploading data
		print '>> Inserting Data into Table: bronze.stop_times';
		bulk insert bronze.stop_times
		from 'D:\Data Analytics\Projects\Bigquery - New York Subway\Dataset\original\stop_times.csv'
		with (
				firstrow = 2,-- first row of data starts on row 2, which is right beneath the header. 
				fieldterminator = ',', -- this denotes the delimiter of the csv file.
				rowterminator = '0x0d0a', -- windws-style newline.
				codepage = '65001', -- to ensure ETF-8 encoding
				tablock -- lock the entire table until the transaction is completed (bulk insert).
		);
		set @end_time = getdate();
		print '>> Load Duration: '+ cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';

		-- BRONZE.SUBWAY_RIDERSHIP_2013_PRESENT
		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.subway_ridership_2013_present';
		truncate table bronze.subway_ridership_2013_present; --clear out the table before uploading data
		print '>> Inserting Data into Table: bronze.subway_ridership_2013_present';
		bulk insert bronze.subway_ridership_2013_present
		from 'D:\Data Analytics\Projects\Bigquery - New York Subway\Dataset\formatted\subway_ridership_2013_present.txt'
		with (
				firstrow = 2,-- first row of data starts on row 2, which is right beneath the header. 
				fieldterminator = '\t', -- this denotes the delimiter of the csv file.
				rowterminator = '0x0d0a', -- windws-style newline.
				codepage = '65001', -- to ensure ETF-8 encoding
				tablock -- lock the entire table until the transaction is completed (bulk insert).
		);
		set @end_time = getdate();
		print '>> Load Duration: '+ cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';

		-- BRONZE.TRIPS
		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.trips';
		truncate table bronze.trips; --clear out the table before uploading data
		print '>> Inserting Data into Table: bronze.trips';
		bulk insert bronze.trips
		from 'D:\Data Analytics\Projects\Bigquery - New York Subway\Dataset\original\trips.csv'
		with (
				firstrow = 2,-- first row of data starts on row 2, which is right beneath the header. 
				fieldterminator = ',', -- this denotes the delimiter of the csv file.
				rowterminator = '0x0d0a', -- windws-style newline.
				codepage = '65001', -- to ensure ETF-8 encoding
				tablock -- lock the entire table until the transaction is completed (bulk insert).
		);
		set @end_time = getdate();
		print '>> Load Duration: '+ cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';

	end try

	begin catch

		print '===================================================';
		print 'Error Loading Bronze Layer';
		print 'Error Message: ' + error_message();
		print 'Error Number: ' + cast(error_number() as nvarchar);
		print 'Error State: ' + cast(error_state() as nvarchar);
		print '===================================================';

	end catch
end
