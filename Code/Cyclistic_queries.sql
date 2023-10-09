SELECT 
	COUNT(DISTINCT ride_id) AS total_trips,
	COUNT(*) AS total_entries
FROM [Cyclistic Data].[dbo].[2023-tripdata]
--- 190445 Total Trips

SELECT 
	COUNT(DISTINCT ride_id) AS total_trips,
	COUNT(*) AS total_entries
FROM [Cyclistic Data].[dbo].[2022-tripdata]
--- 181806 Total Trips

SELECT 
	COUNT(DISTINCT ride_id) AS total_trips,
	COUNT(*) AS total_entries
FROM [Cyclistic Data].[dbo].[2021-tripdata]
---247540 Total Trips

SELECT 
	COUNT(DISTINCT ride_id) AS total_trips,
	COUNT(*) AS total_entries
FROM [Cyclistic Data].[dbo].[2020-tripdata]
---131573 Total Trips

SELECT ride_id, started_at, ended_at, member_casual 
  INTO combined_data
  FROM (
	SELECT ride_id, started_at, ended_at, member_casual
	FROM [Cyclistic Data].[dbo].[2023-tripdata]
	UNION
	SELECT ride_id, started_at, ended_at, member_casual
	FROM [Cyclistic Data].[dbo].[2022-tripdata]
	UNION
	SELECT ride_id, started_at, ended_at, member_casual
	FROM [Cyclistic Data].[dbo].[2021-tripdata]
	UNION
	SELECT ride_id, started_at, ended_at, member_casual
	FROM [Cyclistic Data].[dbo].[2020-tripdata]
) alias

SELECT 
	COUNT(DISTINCT ride_id) AS total_trips,
	COUNT(*) AS total_entries
FROM combined_data

SELECT * FROM combined_data

------------------------------------------------------------------

CREATE TABLE date_entries(
	ride_id varchar(50),
	start_time SMALLDATETIME,
	end_time SMALLDATETIME,
	membership_type nvarchar(50)
)
INSERT INTO date_entries(ride_id, start_time, end_time, membership_type)
SELECT ride_id, started_at, ended_at, member_casual
FROM combined_data

SELECT * FROM date_entries ORDER BY start_time

--SELECT ride_id, start_time, end_time, DATEPART(dw, start_time) AS day_of_week,
--	(CASE 
--		WHEN DATEDIFF(MINUTE, end_time, start_time) < 0
--			THEN DATEDIFF(MINUTE, end_time, start_time) * -1
--			ELSE DATEDIFF(MINUTE, end_time, start_time)
--	 END) AS time_diff_minutes
--FROM date_entries
--ORDER BY time_diff_minutes DESC

CREATE TABLE date_time(
	ride_id varchar(50),
	day_of_week int,
	time_diff_minutes int,
	membership_type nvarchar(50)
)
INSERT INTO date_time(ride_id, day_of_week, time_diff_minutes, membership_type)
SELECT ride_id, DATEPART(dw, start_time),
	(CASE 
		WHEN DATEDIFF(MINUTE, end_time, start_time) < 0
			THEN DATEDIFF(MINUTE, end_time, start_time) * -1
			ELSE DATEDIFF(MINUTE, end_time, start_time)
	 END),
	 membership_type
FROM date_entries

SELECT * 
FROM date_time
ORDER BY time_diff_minutes DESC

---- MAXIMUM TRIP TIME 
SELECT MAX(time_diff_minutes) as maximum_time, membership_type
FROM date_time
GROUP BY membership_type

---- MINIMUM TRIP TIMES
SELECT ride_id, time_diff_minutes
FROM date_time
WHERE time_diff_minutes = 0

---- COUNT OF MINIMUM TRIP TIMES
SELECT COUNT(ride_id) AS trips_with_smallest_time, membership_type
FROM date_time
WHERE time_diff_minutes = 0
GROUP BY membership_type

---- DAY OF WEEK WITH MOST TRIPS FOR EACH MEMBERSHIP TYPE
SELECT day_of_week AS Mode, membership_type
FROM date_time
GROUP BY day_of_week, membership_type
ORDER BY COUNT(day_of_week) DESC

---- AVERAGE TRIP TIME (MINUTES)
SELECT AVG(time_diff_minutes) as average_trip_time, membership_type
FROM date_time
GROUP BY membership_type

---- AVERAGE RIDE LENGTH BY DAY
SELECT AVG(time_diff_minutes) as average_trip_time, day_of_week
FROM date_time
GROUP BY day_of_week
ORDER BY average_trip_time DESC

---- NUMBER OF RIDES BY DAY
SELECT COUNT(ride_id) as number_of_rides, day_of_week
FROM date_time
GROUP BY day_of_week
ORDER BY day_of_week

DROP TABLE combined_data
DROP TABLE date_time
DROP TABLE date_entries
