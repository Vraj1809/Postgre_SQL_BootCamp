
--------------------------------------- Conversion Functions


--------- to_char function

select to_char(
	123456,
	'0,99999'
);

select 
	release_date,
	to_char(release_date, 'dd-mm-yyyy'),
	to_char(release_date, 'dy-dd-mm-yyyy')
from movies;

-- conveting timestamp to string
select 
	to_char(
		timestamp '121212 121212',
		'hh24:mm:ss'
	);

-- adding symbols before values
select 
	movie_id,
	revenues_domestic,
	to_char(revenues_domestic, '$9999D99')
from movies_revenues;



----------- to_number function

select
	to_number(
	'123456',
	'999999'
	) as "Normal Conversion",
	to_number(
	'123.456',
	'9999.99'
	) as "Decimal Conversion using .",
	to_number(
	'123.456',
	'9999D99'
	) as "Decimal Conversion using D",
	-- currency converter
	to_number(
	'$ 1,234,567',
	'L9999999'
	) as "Currency Separator";





---------- to_date function

select 
	to_date(
	'2020-01-01',
	'yyyy-mm-dd'
	),
	to_date(
	'01012023',
	'ddmmyyyy'
	),
	to_date(
	'7 may 2023',
	'dd month yyyy'
	);





---------------------- to_timestamp function
select to_timestamp(
	'121212 121212',
	'ddmmyy hh24mmss'
);
