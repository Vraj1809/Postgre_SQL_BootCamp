
----------------------------------- Using Date/Time Functions


------------- System Month Date Settings
show datestyle;

-- gives type and format
-- type  -> iso, postgres, sql or german
-- format -> mdy - month, date, year
		--   dmy - date, month, year
		--   ymd - year, month, date
-- changnig the date style

set datestyle = 'iso, dmy';

show datestyle;

set datestyle = 'iso, mdy';



--------- time formats
----> hh:mm:ss, hour:minute:second
----> hh:mm:ss.p, hour:minute:second.precision

-------- timestamp formats
----> yyyy-mm-dd hh:mm:ss, year-month-date hour:minute:second.precision

-------------- date / time input format
-- allballs -> time
-- now() -> date, time, timestamp
-- today, tomorrow, yesterday, epoch, infinity, -infinity -> date, timestamp


----------- to_date()
select to_date('9th dec 2020', 'DDth mon yyyy');
-- in this in the right where the format is specified, it has to be matching with the date given in the right side, 
-- so we are specifying to the system the that given date is in this format, but after that postgres will automatically convert that
-- to yyyy-mm-dd format.



---------- to_timestamp() -> gives in timestamp with timezone
select to_timestamp('2025-01-01 01:12:12', 'yyyy-mm-dd hh:mi') -- the seconds are given in the value but not mentioned in the format
---- so it will give seconds as 00
select to_timestamp('2025-01-01 01:12:12', 'yyyy-mm-dd mi:ss')

select to_timestamp('2025-01-01 01:12:12', 'yyyy-mm-dd mi:ms')



-------------- Formatting dates

-------- using to_char() -> in this in the right we have to right the format in which we want the output to be
select
	current_timestamp,
	to_char(current_timestamp, 'dd-mm-yy');

SELECT 
    to_char('2012-12-12 12:12:12.31532536+05:30' :: timestamptz, 'ddth Month, yyyy hh:mm:ss.p tz');


-------------- selecting movie release dates
select
	movie_name,
	release_date,
	to_char(release_date, 'ddth Month, yyyy')
from movies;

	

----------------- Date Construction Functions

------- make_date(yyyy,mm,dd)

select make_date(2025,1,1) -- don't even need to put 01-01 it will understand it automatically


-------- make_time (hh, mm, ss)
select make_time(13,12,12)

--------- make_timestamp (yyyy, mm, dd, hh, mm, ss)
select make_timestamp(2025,12,1,14,45,30)



-------- make_interval (year, month, week, days, hour, minutes, seconds)

select make_interval(2025,1,1,1,12,12,12);

------ effect of weeks
select
	make_interval(2025,1,1,1,12,12,12),
	make_interval(2025,1,2,1,12,12,12),
	make_interval(2025,1,3,1,12,12,12),
	make_interval(2025,1,4,1,12,12,12);

----- named notation
select make_interval(weeks => 1)
select make_interval(months => 1, weeks => 1)
select make_interval(years => 1, weeks => 1)
select make_interval(weeks => 1, hours => 1)




--------------- make_timestamptz

select * from pg_timezone_names;


select make_timestamptz (2025,01,01,00,01,00.00,'PST');
select pg_typeof(make_timestamptz (2025,01,01,00,01,00.00,'PST'));





---------------------------- Date Value Extractor

---- extract (field from time)

select extract('day' from current_timestamp) as "Day",
	extract ('month' from current_timestamp) as "Month",
	extract('year' from current_timestamp) as "Year",
	extract('century' from current_timestamp) as "Century";





-------------- using math operators with dates

-- addition
--date
select 
	date '2020-01-01' + 1

select '2020-10-1'::date + 1

-- time with interval
select '12:12:12' :: time + interval '12 minutes'

-- date and time together to give timestamp
select 
	'2020-1-1'::date + '12:12:12'::time;

-- two intervals
select interval '30 minutes' + interval '30 minutes';

-- subtraction
--date
select 
	date '2020-01-01' - 1

select '2020-10-1'::date - 1

-- time with interval
select '12:12:12' :: time - interval '12 minutes'

-- date and time together to give timestamp
select 
	'2020-1-1'::date - '12:12:12'::time;

-- two intervals
select interval '30 minutes' - interval '30 minutes';



--------------- overlaps function
----- used to check whether two date ranges are overlapped?
----- (date1, date2) overlaps (date1,date2)
----- if even one date from the right range in the left range then it would return true

select ('2020-01-01':: date, '2021-01-01'::date) overlaps ('2022-09-18'::date, '2021-09-18');

----- can also use interval
select ('2020-01-01':: date, interval '1 year') overlaps ('2019-12-01'::date, interval '32 days');




-------------- date / time functions

select
	current_date,
	current_time,
	current_timestamp,
	localtime,
	localtimestamp;
--- here the precision points are all displayed till 6

--- with precision
select 
	current_date,
	current_time(2),
	current_timestamp(2),
	localtime(2),
	localtimestamp(2);



------------- PostgreSQL date/time functions
select
	now(),
	transaction_timestamp(), -- same as now()
	clock_timestamp(), -- shows the current date and time, but will show the chnage in time during the statement execution
	statement_timestamp() -- shows time of execution of this statment


select timeofday();



----------- age function -> gives years, months, days between two dates
select age('2025-01-21', '2003-09-18');

----- age with no starting date, then have to explicitly change the datatype of that string
select age('2003-09-18' :: date)

---- age with interval
select age(current_date, current_date - interval '1235 days')




----------- date accuracy with epoch

-- in age it would give 2 months
select age('2020-12-10', '2020-10-10');


-- however using epoch 
select(
	extract(epoch from '2020-12-10':: timestamptz) - extract(epoch from '2020-10-10':: timestamptz )
) / 60 / 60 / 24;
-- it will show 61 days, which means 2 months plus 1 day




------------ using date, time and timestamps in tables

create table times(
	times_id serial primary key,
	start_date date,
	start_time time,
	start_timestamp timestamp
)

select * from times;

insert into times (start_date, start_time, start_timestamp) values
('today', 'allballs', 'now()'); -- allballs can be only added to time field cause it only contains time

insert into times (start_time, start_date, start_timestamp) values
('now', 'now','now' );

insert into times (start_time, start_date, start_timestamp) values
('now', 'epoch','epoch' ); -- epoch can be only added to date and timestamp cause it doesn't contain time






----------------------------------- How to Handle Timezone


show time zone;

------- so we always have to use timezone with date and time both that is with timestamp only not with date only or time only
------- using the timezone in thhe database will help the people/client from different timezones understand the data entry clearly
------- let's say in india the entry was made at 12 pm and one client is from america and timezone differnece is of 12 hours,
------- so if we use timezone here then although we would be seeing 12pm in our database because of our current timezone, the 
------- client would see the data entry according to his timezone 

alter table times
add column update_timestamp timestamptz;

alter table times
add column update_time time with time zone;


select * from times;


-- the data was update in US/Pacific and +6 hours ahead for 20-06-2020
insert into times (update_timestamp, update_time) values 
('2020-06-20 11:30:00 US/Pacific', '11:30:00+6');

select * from times;
-- the newly added data would be displayed to us in our timezone, so like what time was it here in our timezone when the data was
-- added from US/Pacific region 

--ading the data currently
insert into times (update_timestamp, update_time) values
(current_timestamp, current_time);

-- the data would be giving the current time of our region no conversion would be done
select * from times;

-- now let's convert the time zone and see the result 
-- the first data about the 20-06-2020 11:30:00 would be displayed to us as it was added because we are currently in the US/Pacific region
-- but our current_timestamp, current_date data would be converted to US/Pacific time

set timezone = 'US/Pacific';

select * from times;
-- so this is how the timezones are handled

-- setting back to our timezone

select * from pg_timezone_names;

set timezone = 'Asia/Calcutta';



------------------- date_part() function
select date_part('year', '2020-02-01'::timestamp);

select 
date_part('year', '2020-02-01'::timestamp) as "Year",
date_part('quarter', '2020-02-01'::timestamp) as "Quarter",
date_part('month', '2020-02-01'::timestamp) as "Month",
date_part('decade', '2020-02-01'::timestamp) as "Decade",
date_part('century', '2020-02-01'::timestamp) as "Century";

select
date_part('week', current_timestamp) as "Week",
date_part('dow', current_timestamp) as "Day of Week",
date_part('doy', current_timestamp) as "Day of year",
date_part('day', current_timestamp) as "Day",
date_part('hour', current_timestamp) as "Hour",
date_part('minute', current_timestamp) as "Minute",
date_part('second', current_timestamp) as "Second";


-- week of release_date  
select 
	movie_name,
	release_date,
	date_part('week', release_date) as "Release Week",
	date_part('doy', release_date) as "Release Day of Year"
from movies
order by 4 desc;




--------------------------------------- date_trunc() function
-------- date_trunc(date_part_value, filed) -> field value would be timestamp orinterval
-- wil give value till the date_part_value mentioned

select 
	date_trunc('hour', current_timestamp) as "Hours",
	date_trunc('minute', current_timestamp) as "Minutes",
	date_trunc('second', current_timestamp) as "Seconds";


------- count the number of movie by release month
select
	date_trunc('month', release_date) "release_month",
	count(movie_id)
from movies
group by release_month
order by 2 desc;

