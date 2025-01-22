---------------------- Using Group by------------

----- select 
----- column1
----- aggrerate_function (column2)
----- from tablename
----- group by column1

------- get total count of all movies group by movie language

select 
	movie_lang,
	count(movie_lang)
from movies
group by movie_lang;


------ get average movie length group by movie language
select
	movie_lang,
	avg(movie_length)
from movies
group by movie_lang
order by movie_lang;



------ get the sum total movie length as per age certificate
select 
	age_certificate,
	sum(movie_length)
from movies
group by age_certificate;



------ list minimum and moaximum movie length group by movie language
select
	movie_lang,
	max(movie_length) as "Maximum Movie length",
	min(movie_length) as "Minimum Movie length"
from movies
group by movie_lang;



-------- group by without aggregate function

select
	movie_length
from movies
group by movie_length



---------- grouping by more than 1 column
------- get average movie length group by movie language and age certiification

select 
	movie_lang,
	age_certificate,
	avg (movie_length)
from movies
group by movie_lang, age_certificate


----- we have to use group by on columns appearing in the query, and if we don't want to then either out them in the aggregate function

-- this will error
select 
	movie_lang,
	age_certificate,
	avg (movie_length)
from movies
group by movie_lang



------------ filtering some records
---- get average movie length group by movie language and age certification where movie length greater than 100

select 
	movie_lang,
	age_certificate,
	avg(movie_length)
from movies
where movie_length > 100
group by movie_lang, age_certificate



-------  get average movie length group by movie age certification where age certificate = PG

select 
	age_certificate,
	avg(movie_length)
from movies
where age_certificate = 'PG'
group by age_certificate;



---------- how many directors are there per each nationality

select * from directors;

select
	nationality,
	count(*)
from directors
group by nationality
order by 2 desc;



--------- get total sum movie length for each age certificate and movie language combination

select
	age_certificate,
	movie_lang,
	sum(movie_length)
from movies
group by age_certificate, movie_lang
order by movie_lang;




-------------- group by on aggregate function column
-- we can't use group by on aggregate function column, but can use agggregate function using having clause


-- will give an error
select
	age_certificate,
	movie_lang,
	sum(movie_length)
from movies
group by age_certificate, movie_lang, 3
order by movie_lang;


--------------- Order of Execution with group by clause and others combined
-- 1) from
-- 2) where -- conditions
-- 3) group by -- grouping 
-- 4) having -- filter again
-- 5) select -- columns
-- 6) distinct -- unique columns
-- 7) order by -- sorting 
-- 8) limit-- limit the output 



---------------------------- Having clause
-- search condition for a group or aggregate function
-- used with grup by to further columns
-- can't use column aliases as having executed before select

----- list moviie languagge where sum total length of the movies is greater than 200

select
	movie_lang,
	sum(movie_length)
from movies
group by movie_lang
having sum(movie_length) > 200
order by 2 desc



------ list directors where the sum total movie length is greater than 200
select
	director_id,
	sum(movie_length)
from movies
group by director_id
having sum(movie_length) > 200
order by 1;





------------- where vs having 
----- where works on selected column not groups
----- having works on result group

--- get the movie language where their total sum movie length is greater than 200

-- using having 
select 
	movie_lang,
	sum(movie_length)
from movies
group by movie_lang
having sum(movie_length) > 200
order by 1


--- using where -> will give error -> aggregate function not allowed in where
select 
	movie_lang,
	sum(movie_length)
from movies
where sum(movie_length) > 200
group by movie_lang
order by 1


------- handling nulll values with group by


create table employee_test(
	id serial primary key,
	department varchar(50)
);

insert into employee_test (department) values
('IT'),
('Finance'),
(null),
('IT'),
('Finance'),
(null);

select * from employee_test;

-- here the null value will be shown 
select
	department,
	count(*) as "Total Employees"
from employee_test
group by department
order by 1

---- to say that no department then we can use coalesce (source, '')

select
	coalesce(department, '* No Department *'),
	count(*) as "Total Employees"
from employee_test
group by department
order by 1


