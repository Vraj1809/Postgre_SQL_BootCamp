------------------------------------------- Aggregation Functions


------------------------------- Count Functions

------------ count(*) -> give count of all of the rows of the table
------------ count(column_name) -> gives count of all of the rows of the specific column

------ count total number of movies
select count(*) from movies;

------ count records for the specific column
select count(movie_length) from movies;

------ count the total number of movie languages
select count(movie_lang) from movies;

------ use distinct because of same language appearing many times
select count(distinct (movie_lang)) from movies;

------ count all distnct movie directors
select count(distinct (director_id)) from movies;


------ count alll movies with english langugae
select count(*) from movies
where movie_lang = 'English';


--------------------------------------------- Sum with sum function -> can only run this function on columns where there are integer values

------- total domestic revenue records for all moviies
select sum(revenues_domestic) from movies_revenues;


------- total domestic revenues for movies where domestic revenue > 200
select 
	sum(revenues_domestic)
from movies_revenues
where revenues_domestic > 200;


-------- total movie length of all english language movies
select
	sum(movie_length)
from movies
where movie_lang = 'English';


------- sum with distinct

select 
	sum(revenues_domestic) as With_Distinct,
	sum(distinct revenues_domestic) as Without_Distinct
from movies_revenues;





--------------------------- mn and max function

------- longest length movie in movies_table

select 
	max(movie_length)
from movies;

-------- shortest length movies
select
	min(movie_length)
from movies;


------ longest english langugae movie
select
	max(movie_length)
from movies
where movie_lang = 'English';


----- latest released english movie
select 
	max(release_date)
from movies
where movie_lang = 'English';


------ first chinese movie released
select
	min(release_date)
from movies
where movie_lang = 'Chinese';

---------- max/min function would treat the string type column differently rather than giving the answer based on the length of
---------- string, it would sort the column ascending / descending and for max would sort in descending and give the first value
---------- and for min, sort in ascending and would give the first value

select 
	max(movie_name) as "Maximum on movie name",
	min(movie_name) as "Minimum on movie name"
from movies;





------------------------------------ greatest/least functions -> select largest/smallest value from the list

select greatest(10,20,45);
select least(20,-10,30);

select greatest('a','b','c');
select least('a','b','c');

----- list should be of common datatype
select greatest('a', 1,2,'c');


select
	-- greatest(revenues_domestic) as "Grestest Domestic Revenue",
	least(revenues_domestic) as "Least Domestic Revenue"
from movies_revenues;






---------------------------------- avg function

-------- avg movie length for all of the movies
select avg(movie_length) from movies;


-------- avg movie length for english based movies
select avg(movie_length) 
from movies
where movie_lang = 'Chinese';


-------- avg with distinct
select avg(distinct movie_length)
from movies
where movie_lang = 'Chinese';


------ can't use on charcter verying

------- avg, while calculating ignores null values

------ avg and sum for all english based movies
select 
	sum(movie_length) as Sum,
	avg(movie_length) as Average
from movies
where movie_lang = 'English';



------------ using arithmatic operation on columns
--------- when using it if any value in thhe column is null then that operation for that row is igonred and the result given is null
select
	movie_id,
	revenues_domestic,
	revenues_international,
	revenues_domestic + revenues_international as "Total Revenue"
from movies_revenues;


-------- order the highest revenue movie
select
	movie_id,
	revenues_domestic,
	revenues_international,
	revenues_domestic + revenues_international as "Total Revenue"
from movies_revenues
order by 4 desc nulls last;


select
	movie_id,
	revenues_domestic,
	revenues_international,
	revenues_domestic + revenues_international as "Total Revenue"
from movies_revenues
where revenues_domestic + revenues_international is not null
order by 4 desc;

