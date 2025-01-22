---------------------------- joining multiple tables
-------- inner join

-- select
--	 table1.column1,
	 table2.column1
-- from table1 inner join table2
-- on table1.column1 = talbe2.column2

--- let's combine movies and directors table
select *
from movies inner join directors
on movies.director_id = directors.director_id

---- joining using aliases
select 
	mv.movie_name,
	d.first_name || ' ' || d.last_name as "Director Name"
from movies mv inner join directors d
on mv.director_id = d.director_id


--- filtering records
select 
	mv.movie_name,
	d.first_name || ' ' || d.last_name as "Director Name",
	mv.movie_lang
from movies mv inner join directors d
on mv.director_id = d.director_id
where mv.movie_lang = 'English'




------------------ inner joins with using

-- don't have to use aliases
select *
from movies inner join directors 
using (director_id)




----- connecting movies and movies_revenues table
select * from movies;
select * from movies_revenues;

select * 
from movies inner join movies_revenues
using (movie_id)





---------- connecting more than two tables 
--- connecting movies, directors, movies_revenues

select *
from movies
inner join directors using (director_id)
inner join movies_revenues using (movie_id)



------------ inner join with filter data

--select movie name, director name, domestic revenues for all japanese movies
select
	movies.movie_name as "Movie Name",
	directors.first_name ||  ' ' || directors.last_name as "Director Name",
	movies_revenues.revenues_domestic as "Domestic Revenue"
from movies
inner join directors using (director_id)
inner join movies_revenues using (movie_id)
where movies.movie_lang = 'Japanese'






---- select movie name, director name for all english, chinese and japanese movies where domestic revenue is greater than 100
select 
	movies.movie_name, 
	directors.first_name || ' ' || directors.last_name,
	movies.movie_lang
from movies
inner join directors using (director_id)
inner join movies_revenues using (movie_id) 
where movies.movie_lang in ('Japanese', 'English', 'Chinese') and 
movies_revenues.revenues_domestic > 100
order by 3




----- select movie name, director name, movie language and total revenues for all top 5 movies

select
	movies.movie_name as "Movie Name",
	directors.first_name || ' ' || directors.last_name as "Director Name",
	movies.movie_lang as "Movie Language",
	movies_revenues.revenues_domestic + movies_revenues.revenues_international as "Total Revenue"
from movies
inner join directors using (director_id)
inner join movies_revenues using (movie_id)
order by 4 desc nulls last
limit 5




-------- what was the top 10 most profitable movies between year 2005 and 2008. print the movies name, director name, movie language and total revenue

select 
	movies.movie_name as "Movie Name",
	movies.movie_lang as "Movie Language",
	directors.first_name || ' ' || directors.last_name as "Director Name",
	movies_revenues.revenues_domestic + movies_revenues.revenues_international as "Total Revenues"
from movies
inner join directors using (director_id)
inner join movies_revenues using (movie_id)
where movies.release_date between '2005-01-01' and '2008-12-31'
order by 4 desc nulls last
limit 10





--------------- inner join tables with different column data types
create table t1 ( test int);

create table t2 ( test varchar(2));

-- can't join because different datatypes have to use cast
select * from 
t1 inner join t2 using (test)


select * from t1
inner join t2 on t1.test::varchar = t2.test


insert into t1 (test) values (1), (2)

insert into t2 (test) values ('a'), ('b')

select * from t2



--------------------- left join
----- data that matches between both left and right and plus left data too
----- if there is no match in data then the result is showing null

create table left_products (
	product_id serial primary key,
	product_name varchar(100)
);

create table right_products(
	product_id serial primary key,
	product_name varchar(100)
);


insert into left_products (product_id, product_name) values
(1, 'Computers'),
(2, 'Laptops'),
(3, 'Monitors'),
(5, 'Mics');

select * from left_products;

insert into right_products (product_id, product_name) values
(1, 'Computers'),
(2, 'Laptops'),
(3, 'Monitors'),
(4, 'Pen'),
(7, 'Paper');

select * from right_products;



------ joining table using left join
select 	* from
left_products left join right_products using (product_id)



---- list all movies with directors first and last name and movie name

select 
	directors.first_name,
	directors.last_name,
	movies.movie_name
from movies
left join directors using (director_id)



----- reversing the directors and movies table
select 
	directors.first_name,
	directors.last_name,
	movies.movie_name
from directors
left join movies using (director_id)



------------------ adding a where condition in this
--- get the list of english and chinese movies only
select 
	directors.first_name,
	directors.last_name,
	movies.movie_name
from movies
left join directors using (director_id)
where movies.movie_lang in ('English', 'Chinese')


------- count all movies for each director
select 
	directors.first_name || ' ' || directors.last_name as "Director Name",
	count(*) as "Movies Done"
from directors
left join movies using (director_id)
group by directors.director_id
order by 2 desc


-------- get all movies with age certification for all directors where nationality are 'American', 'Chinese', and 'Japanese'
select
	directors.first_name || ' ' || directors.last_name as "Director Name",
	movies.movie_name as "Movie Name",
	movies.age_certificate as "Age Certificate"
from directors
left join movies using (director_id)
where directors.nationality in ('American', 'Chinese', 'Japanese')



--------- get all the total revenues done by each films for each directors
select 
	directors.first_name,
	directors.last_name,
	sum (movies_revenues.revenues_domestic + movies_revenues.revenues_international) as "Total Revenue"
from directors
left join movies using (director_id)
left join movies_revenues using (movie_id)
group by directors.first_name, directors.last_name
-- to remove null values
having sum (movies_revenues.revenues_domestic + movies_revenues.revenues_international) > 0
order by 3 desc nulls last



--------------------- right join
----- data that matches between both left and right and plus right data too
----- if there is no match in data then the result is showing null


select * from left_products;

select * from right_products;

select * 
from left_products right join right_products using (product_id)


------ list all movies with directors first and last names and movies name
select 
	movies.movie_name as "Movie Name",
	directors.first_name || ' ' || directors.last_name as "Director Name"
from directors right join movies using (director_id)


---- reversing the tables of directors and movies
select 
	movies.movie_name as "Movie Name",
	directors.first_name || ' ' || directors.last_name as "Director Name"
from movies right join directors using (director_id)



----- get list of english and chinese movies only
select 
	movies.movie_name as "Movie Name",
	directors.first_name || ' ' || directors.last_name as "Director Name"
from directors right join movies using (director_id)
where movies.movie_lang in ('English', 'Chinese')



---- count all movies for each directors
select
	directors.first_name, 
	directors.last_name,
	count(*) as "Movies"
from movies 
right join directors using (director_id)
group by directors.first_name, directors.last_name
order by 3 desc





------------------------------------- Full joins
----------- gives all the data from all the tables



----- join left_products and right_products via full join

select * 
from left_products
full join right_products using (product_id)


------------------- join and inner join are the same, if only inner join not specified and only join is used then by default it
------------------- will run inner join query


-------------------------- self join -> comapre rows within the same table
--------- uusecases -> query hierarchical data 

select * from 
left_products self join left_products using (product_id)


------ self join directors table
select * from directors
self join directors using (director_id)


------ alll pairs of movies that have the same length
SELECT 
	m1.movie_name,
	m2.movie_name,
	m1.movie_length
FROM 
    movies m1
JOIN 
    movies m2 
on m1.movie_length = m2.movie_length and m1.movie_id <> m2.movie_id
order by 3 desc



------------------- cross join
--- all combinations of first table to second table

select *
from left_products cross join right_products

--- order does matter
select * 
from right_products cross join left_products


--------- equivalents to cross product
-- method 1
select * 
from left_products, right_products

-- method 2
select * 
from left_products inner join right_products on true;


-------cross join actors with directors
select * from
actors, directors


---------------------- natural join
--- join table based on the same column names

-- can be inner, left or right
-- if not specified then bydefault inner

select * from 
left_products natural join right_products

select * from 
left_products natural inner join right_products

select * from 
left_products natural left join right_products

select * from 
left_products natural right join right_products



---------- natural join movies and directors table
select * from 
movies natural join directors






----------------------------------------- Append Table with different Columns

-- giving output such a way that if table1 and table2 have same columns then it takes the values of table1 instead of table2 but
-- if table1 has no value then value from table2 is taken
create table table1 (
	add_date date,
	col1 int,
	col2 int,
	col3 int
)

create table table2(
	add_date date,
	col1 int,
	col2 int,
	col3 int,
	col4 int,
	col5 int
)

insert into table1 (add_date, col1, col2, col3) values
('2020-01-01', 1,2,3),
('2020-01-01', null,2,3),
('2020-01-01', 1,null,3);

insert into table2 (add_date, col1, col2, col3,col4, col5) values
('2020-01-01', 1,2,3,4,5),
('2020-01-01', 1,2,3,4,5),
('2020-01-01', 1,2,3,4,5);


--- coalesce is used, so coalesce (value1, value2) then always the first value is taken but if not first then only second value  
select 
	coalesce(table1.add_date, table2.add_date),
	coalesce(table1.col1, table2.col1),
	coalesce(table1.col2, table2.col2),
	coalesce(table1.col3, table2.col3),
	table2.col4,
	table2.col5
from table1
full outer join table2 using (add_date)

	
