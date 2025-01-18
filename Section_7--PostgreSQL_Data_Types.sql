----------- Boolean Datatype
-- can have only three values -> true, false, null

--TRUE, true, 't', 'y', 'yes', '1' --> for true values, except TRUE,true every one have to be in '' parenthesis
--FALSE, false, 'f', 'n', 'no', '0' --> for false values, except FALSE,false everyone have to be in '' parenthesis

create table boolean_table(
	bool_id serial primary key,
	bool_value boolean not null
);

-- will give an error
insert into boolean_table (bool_value) values
(false),
('1'),
('0'),
('y'),
('n'),
('yes'),
('no'),
('f'),
('t')
;

select * from boolean_table;

-- conditional searching
select * from boolean_table
where
	bool_value = true;

select * from boolean_table
where
	bool_value = '0';

-- conditional with not operator

select * from boolean_table
where
	bool_value;      --bydefault it takes the true value

select * from boolean_table
where
	not bool_value;

--set default values for boolean columns
alter table boolean_table
alter column bool_value
set default false;

-- entering new data
insert into boolean_table (bool_id) values
(11);





--------------------- CHAR, VARCHAR and TEXT

--character(n) , char(n) -> for fixed length, if given less than remaining space is padded, -- n is bydefault 1
-- character varying(n), varchar(n) -> variable length with length limit, if given less then no padding
-- text, varchar -> variable unlimited length



----- char(n) -> used for fixed length like country iso code

select cast('vraj' as char(10)) as "Name";
select 'vraj2' :: char(10) as "Name";
--"vraj      "
select 'vraj' :: char as "Name";
--'v'


------- varchar(n)
select 'vraj' :: varchar(10); --"vraj"
select 'my name is vraj vipul desai' :: varchar(10);



-- text
select 'my name is vraj vipul desai my name is vraj vipul desai my name is vraj vipul desai my name is vraj vipul desai my name is vraj vipul desai my name is vraj vipul desai' :: text;







------------------------ NUMERIC

----------- Integers

------- smallint
------- integer
------- bigint


----serial -> autoincremented integer type

--smallserial
--serial
--bigserial

create table serial_table (
	product_id serial,
	product_name varchar(50)
);

select * from serial_table;

insert into serial_table (product_name) values
('table'),
('chair'),
('book');

-- serial will not get updated automatically if any item from the table is deleted
delete from serial_table
where
	product_name = 'table';
--will discuss later how to auto update the serial




----------- Decimals

-----data type -> numeric, decimal - > storage type-> fixed point
-- numeric (precision, scale) -> precision for number of digits allowed on both side, scale for number of digits allowed on the right side

-----data type -> 1)real 2)double -> storage type- -> floating point
-- real -> 6 decimal digits
-- double -> 15 decimal digits


create table table_number(
	col_numeric numeric(20,5),
	col_real real,
	col_double double precision
);


select * from table_number;

insert into table_number (col_numeric, col_real, col_double) values
(0.9,0.9,0.9),
(3.13579,3.13579,3.13579),
(4.1357987654,4.1357987654,4.1357987654);









-------------------- Date and Time Datatype

------ date -> date only, year, month, date
------ time -> time only, hour, minute, second
------ timestamp -> date and time, year, month, date, hour, minute, second
------ timestamptz -> date, time and timestamp(timezone)
------ interval -> stores difference between the two date/time datatype values




----- Date type
-- by default in yyyy-mm-dd format
-- current_date to get the current date

create table table_date(
	employee_id serial primary key,
	employee_name varchar(50),
	hire_date date not null,
	add_date date default current_date
);

select * from table_date;

insert into table_date (employee_name, hire_date) values
('Vraj', '2024-12-23'),
('Aneri', '2024-12-16');

-- to get the current date -> only year, month, date
select current_date;

-- to get the current everything -> yer, month, date, hour, minute, second, timezone
select now();




------ Time Data type

--- time(precision) -> precision not always needed, upto 6 digits

--- common formats 
--hh:mm
--hh:mm:ss
--hhmmss

--mm:ss.pppppp
--hh:mm:ss.pppppp
--hhmmss.pppppp

create table table_time(
	class_id serial primary key,
	class_name varchar(50),
	start_time time not null,
	end_time time not null
);

select * from table_time;

insert into table_time (class_name, start_time, end_time) values
('Maths', '11:11:11', '121111'),
('Physics', '121211', '011211.123456');

-- to get the current time -> only hour, minute, second, precision and timezone
select current_time;

-- to get the local time -> without time zone
select localtime;

select localtime, current_time;

-- using arithmatic operations on time
select time'120000' - time'040000' as result;

-- using interval for arithmatic operations -> interval(number type) -> type can be second, minute, hours, year, month, date....
select time'120000' + interval '2 hours' as result;




----- timestamp and timestamtz datatype
-- with timestamptz -> value timezone is first converted to the UTC, then stored.
				--		if not time zone is specifiec then it would take the system's timezone parameter
				--		when the timestamp is shown from the database then, it is converted according to the current timezone of the user

create table table_timestamptz(
	ts timestamp,
	tz timestamptz
);

select * from table_timestamptz;

insert into table_timestamptz (ts, tz) values
('2025-01-01 12:12:12-07', '2025-01-01 121212-07');

-- to get the current timezone
show timezone;

-- to get the local time -> without time zone
set timezone='Asia/Singapore';

select timeofday();








----------------------------- UUID Datatype
-- more powerful than serial cause, serial only generte unique numbers for a single table or database but when we are having multiple datbases then uuid is the best

--installing uuid extension
create extension if not exists "uuid-ossp";

-- sample uuid value
select uuid_generate_v1(); -- v1 -> version 1, which would generate value based on current timestamp and mac address so it would be so unique
select uuid_generate_v4(); -- v4 -> but version 4 would generate values completely randomly


create table table_uuid (
	product_id uuid default uuid_generate_v1(),
	product_name varchar(10)
);

select * from table_uuid;

insert into table_uuid (product_name) values ('ABC');

alter table table_uuid
alter column product_id
set default uuid_generate_v4();








--------------------- Array Datatype

create table table_array(
	e_name varchar(10),
	e_phone text []
);

select * from table_array;

insert into table_array (e_name, e_phone) values
('Vraj', array['951-071-5980', '799-006-2715']),
('Vipul', array['798-465-4599', '942-816-0946']);

-- here indexing starts from 1
select
	e_name,
	e_phone [1]
from table_array;

select e_name from table_array
where
	e_phone[2] = '942-816-0946';






------- hstore Datatype

-- value in key-value pair format
-- can only be text strings only

create extension if not exists hstore;


create table table_hstore(
	book_name varchar(10),
	book_info hstore
);


-- when inserting the key-values, then it should be surrounded by ""
insert into table_hstore (book_name, book_info) values
(
	'def',
	'
		"publisher" => "vipul",
		"pages" => "100",
		"price" => "1500"
	'
);

select * from table_hstore;

-- when selecting the keys then it should be surrounded by ''
select
	book_name as "Book Name",
	book_info -> 'price' as "Price"
from table_hstore;











----------------------- JSON datatype

-- JSON data type -> it is storing in the text format but only stroing
-- JOSNB data type -> not only stroing but can use indexing to search the data using @> operator

create table table_json(
	id serial primary key,
	docs json
);

select * from table_json;

insert into table_json(docs) values
('[1,2,3,4,5,6]'), -- stored as key, value, key, value pattern
('{"key" : "value"}');

select docs from table_json;


-- search the specific data in the json column
select * from table_json
where docs @> '2';
-- will give error cause can't use it on JSON data type, have to convert it to JSONB

alter table table_json
alter column docs
type jsonb;

-- creating gin index on json column to make the operations faster
create index on table_json using gin (docs jsonb_path_ops);








------------------------------ Network Address Data Type
------- better to use these instead of text type to store network address cause, it gives error checking and specialized operations

-- cidr -> ipv4 and ipv6 networks
-- inet -> ipv4 and ipv6 host and networks
-- macaddr -> mac addresses
-- macaddr8 -> mac addresses 

create table table_network (
	id serial primary key,
	ip inet
);

insert into table_network (ip) values
('4.35.221.243'),
('5.36.222.244'),
('6.37.223.245'),
('7.38.224.246'),
('8.39.225.247'),
('9.40.226.248'),
('10.41.227.249');

select * from table_network;


-- set_masklen function
select
	ip,
	set_masklen(ip,24)
from table_network;


-- conveting to the cidr 
select
	ip,
	ip::cidr,
	set_masklen(ip,24),
	set_masklen(ip::cidr, 24)
from table_network;




