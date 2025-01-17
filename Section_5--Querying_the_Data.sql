-- selecting all of the columns and rows from the table
select * from actors;

select * from movies;

-- selecting only selected columns from the table
select first_name, last_name from actors;

select movie_name, movie_lang from movies;

-- Adding Aliases to the columns, can only use ""
select first_name as "First Name" from actors;

select 
	movie_name as "Movie Name",
	movie_lang as "Language"
from movies;

-- as keyword is optional but for better readability use it
select 
	movie_name "Movie Name",
	movie_lang "Language"
from movies;

-- select statements for expressions, 
-- || is used for concatination in postgresql 
-- can only use ' ' for space, for the concatination 
select 
	first_name || ' ' || last_name
from actors;

-- using alias name for this concatinated column
select 
	first_name || ' ' || last_name as "Full Name"
from actors;

-- using expresion to get output without the column name
select 10 / 2;

select * from movies;

-- Using order by to sort the data, bydefault the order by is in ascending order
select * from movies
order by
	release_date;

-- sort in descending order
select * from movies
order by 
	release_date desc;

-- sorting based on multiple columns, it is based on the order
-- first based on release_date then movie_name
select * from movies
order by
	release_date desc,
	movie_name;

-- first based on movie_name then release_date
select * from movies
order by
	movie_name asc,
	release_date desc;


-- using order by on alias name
select 
	first_name,
	last_name as "Surname"
from actors
order by 
	"Surname";

select 
	first_name,
	last_name as "Surname"
from actors
order by 
	"Surname" desc;


-- using order by to sort rows using expression
select 
	first_name,
	length(first_name) as "Length"
from actors
order by
	"Length";
	
select 
	first_name,
	length(first_name) as "Length"
from actors
order by
	"Length" desc;


-- Using Order by with column name or column number
select 
	first_name,
	last_name,
	date_of_birth
from actors
order by
	date_of_birth,
	first_name desc;
-- now using the column number so what order we are following in the select statement that would be given number starting from 1 and would be used 
select 
	first_name,
	last_name,
	date_of_birth
from actors
order by
	3,
	1 desc;  -- we have to folloow the order

-- using order by with null values
create table test_null(
	num integer
);

insert into test_null values
(1),(2),(3),(null);

select * from test_null;

-- by default the order by is in ascending order so all the null values would be in the last that is nulls last
select * from test_null
order by 
	num;

select * from test_null
order by 
	num nulls last;


-- if the order by is changed to descending order then all the null values would be in first place that is nulls first
select * from test_null
order by 
	num desc;

select * from test_null
order by 
	num desc nulls first;

select * from test_null
order by 
	num desc nulls last;

select * from test_null
order by 
	num nulls first;

drop table test_null;


-- Selecting distinct values from the table
select movie_lang from movies;

select 
	distinct movie_lang 
from movies
order by movie_lang;

-- for multiple columns 
select 
	distinct movie_lang, director_id
from movies
order by movie_lang;

-- Getting allUnique values from the movies
select 
	distinct *
from movies;
