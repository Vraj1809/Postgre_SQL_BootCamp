
------------------------------------ Data type conversion

------ implicit -> done auomatically
------ explicit -> done using cast, :: or direct data type writen

select * from movies;

--same data type
select * from movies
where movie_id = 1;

-- different data type -. string to integer -> implicit
select * from movies
where movie_id = '1';

-- explicit conversion without using cast or ::
select * from movies
where movie_id = integer '1';


------------------- Using Cast for explicit conversion

---- cast (expression as new_data_type);

-- to integer
select cast('10' as integer);
select cast('10n' as integer);

-- to date
select
	cast('2020-01-01' as date),
	cast('1-may-2020' as date);

-- to boolean
select
	cast ('true' as boolean),
	cast ('false' as boolean),
	cast ('1' as boolean),
	cast ('0' as boolean),
	cast ('y' as boolean),
	cast ('n' as boolean);


-- to double precision
select cast ('14.676437' as double precision);



-------------------- using :: for conversion

select '14' :: integer;

select '12/12/20 121212' :: timestamp;

select '12/12/20 121212' :: timestamptz;

--- converting to interval
select 
	'1 day' :: interval,
	'1 minute' :: interval,
	'1 hour' :: interval,
	'1 year' :: interval,
	'1 week' :: interval;










---------------------------- Implicit to Explicit Conversion

select 
	round(10, 4) as "implicit conversion",
	round(10 :: bigint, 4) as "Expicit conversion";


select substr('hello', 2) as "Implicit Conversion",
	substr('hello' :: text, 2) as "Explicit conversion";









----------------------- Table data conversion using the case conditional operator

create table ratings(
	rating_id serial primary key,
	rating varchar(1)not null
);

select * from ratings;

insert into ratings (rating) values
('a'),
('b'),
('c'),
('d');

insert into ratings (rating) values
('1'),
('2'),
('3'),
('4');


-- now only getting the values that are numeric from the rating as the rating and converting them to integer otherwise converting others to 0 
select 
	rating_id,
	case
		when rating~E'^\\d+$' then
		cast (rating as integer)
	else 0
	end as rating
from ratings;
