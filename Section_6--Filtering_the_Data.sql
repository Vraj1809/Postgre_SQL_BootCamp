--Where clause is used while filtering the data like where clause in cunjunction with and / or operator

-- 1) Logical AND operator, making sure that whenever we are comparing any text values from the table they are only surrounded by single quotes
-- not the double quotes, they are treated as column


-- for single condition
select * from movies
where 
	movie_lang = 'English';


select * from movies
where 
	movie_lang = 'Japanese';


-- for multiple conditions
select * from movies
where
	movie_lang = 'English' and
	age_certificate = '18';

-- 2) Logical or operator

select * from movies
where
	movie_lang = 'English' or
	movie_lang = 'Chinese'
order by
	movie_lang;


select * from movies
where
	movie_lang = 'English' and 
	director_id = 8;

-- Combining and & or operators

--get all english or chinese movies and movies with age_certificate equal to 12

-- we are not using parenthesis here in the query so, if we are not using parenthesis here the order would matter the most and 
-- since the langugae is first here then we would get the chinese and english movies but the age_certificate will not be filtered
select * from movies
where
	movie_lang = 'Chinese' or movie_lang = 'English' and
	age_certificate = '12';

-- using parenthesis
select * from movies
where
	(movie_lang = 'Chinese' or movie_lang = 'English') and
	(age_certificate = '12');


-- using column alias name with where, we can't use this.
select 
	movie_lang,
	age_certificate as 'Age for Movie'
from movies
where
	'Age for Movie' = '18';


------------Logical operators

-- get movie length greater than 100
select * from movies
where 
	movie_length > 100
;

-- get movie length greater than or equal to 104
select * from movies
where 
	movie_length >= 104
order by 
	movie_length;


-- get movie length greater less than 100
select * from movies
where 
	movie_length < 100
order by 
	movie_length;

-- get movie length less than or equal to 104
select * from movies
where 
	movie_length <= 104
order by 
	movie_length;

-- working with dates -> first have to check for the date formate in which the date s stored like if we use date datatype then
-- bydefault it would be saved in YYYY-MM-DD format

select * from movies
where
	release_date > '2000-12-31'  --- have to use the quotes here otherwise iit won't work
order by 
	release_date;

-- getting movies greater than english language
select * from movies
where 
	movie_lang > 'English'
order by
	movie_lang;

-- getting movies less than english language
select * from movies
where 
	movie_lang < 'English'
order by
	movie_lang;

-- getting movies which is not english language
select * from movies
where
	movie_lang <> 'English'
order by
	movie_lang;

select * from movies
where
	movie_lang != 'English'
order by
	movie_lang;


-------------- Using Limit to limit the output records

-- get the top 5 biggest movie by movie length
select * from movies
order by
	movie_length desc
limit 5;

-- get the top 5 oldest american directors
select * from directors;

select
	first_name || ' ' || last_name as "Full Name",
	date_of_birth as "Birthday"
from directors
where
	nationality = 'American'
order by 
	date_of_birth
limit 5;



-- get the top 10 youngest female actors
select * from actors;

select 
	first_name || ' ' || last_name as "Full Name",
	date_of_birth as "Birthday"
from actors
where 
	gender = 'F'
order by
	date_of_birth desc
limit 10;



-- get the top 10 most domestic profitable movies
select * from movies_revenues;

select * from movies_revenues
order by 
	revenues_domestic desc nulls last
limit 10;



-- get the top 10 least domestic profitable movies
select * from movies_revenues
order by 
	revenues_domestic
limit 10;



------------- using offset -> it is used to indicate from which index(row) the operation have to be performed

-- list 5 films starting from the fourth one ordered by movie_id
select * from movies
limit 5 offset 4;


-- list top 5 movies after the top 5 highest domestic profit movies
select * from movies_revenues
order by
	revenues_domestic desc nulls last
limit 5 offset 5;



------------- Using Fetch

--get the first 5 rows of movies table
select * from movies
fetch first 5 rows only;

-- get the top 5 biggest movies by moive length
select * from movies
order by
	movie_length desc nulls last
fetch first 5 rows only;


-- get the top 5 oldest directors
select * from directors;

select * from directors
order by
	date_of_birth
fetch first 5 rows only;


-- get the top 10 youngest female actors
select * from actors;

select * from actors
where
	gender = 'F'
order by date_of_birth desc
fetch first 10 rows only;


-- get the first 5 movies from the 5th record onwards by long movie length
select * from movies
order by movie_length desc nulls last
offset 5
fetch first 5 rows only;




----------- Using in and not in operator

-- get all movies for english, chinese and japanese languages
select * from movies
where movie_lang in ('English', 'Chinese', 'Japanese')
order by
	movie_lang;

-- get all movies where age certification is 12 and PG type
select * from movies
where age_certificate in ('12', 'PG')
order by
	age_certificate;

-- get all movies where director id is not 13 or 10
select * from movies
where director_id not in (13,10)
order by
	director_id;


-- get all actors where actor_id is not 1,2,3,4
select * from actors
where actor_id not in (1,2,3,4)
order by
	actor_id;




------------- using between and not between 

-- get all actors where birth_date between 1991 and 1995
select * from actors
where
	date_of_birth between '1991-01-01' and '1995-12-31'
order by
	date_of_birth;


-- get movies released between 1998 and 2002
select * from movies
where
	release_date between '1998-01-01' and '2002-12-31'
order by
	release_date;

-- get all movies where domestic revenues as between 100 and 300
select * from movies_revenues;

select * from movies_revenues
where 
	revenues_domestic between 100 and 300
order by
	revenues_domestic;


-- get all english movies where movie length is between 100 and 200
select * from movies
where 
	movie_lang = 'English' and
	movie_length between 100 and 200
order by
	movie_length;


---------------- like and ilike operators

------------like -> % for 0 or more sequences of characters, _ for only one character

-- full pattern matching
select 'hello' like 'hello';

-- partial pattern matching
select 'hello' like 'h%';

select 'hello' like '%e%';

select 'hello' like '%ll';

-- single character searching using '-'

select 'hello' like '_llo';

-- using 5 and _ together
select 'hello' like '_el%';


-- get all actors name where first name starting withh 'A'

select * from actors
where
	first_name like 'A%'
order by
	first_name;


-- get all actor names where last name ending with 'a'

select * from actors
where
	last_name like '%a'
order by
	last_name;



-- get all characters name where first name with 5 characters only
select * from actors
where 
	first_name like '_____'
order by
	first_name;


-- get all actors name where first name contains 'l' on the second place
select * from actors
where
	first_name like '_l%'
order by
	first_name;


----- like is case sensitive
select * from actors
where
	first_name like '%Tim%';

select * from actors
where
	first_name like '%tim%';



------------------- ilike is case insensitive
select * from actors
where
	first_name ilike '%Tim%';

select * from actors
where
	first_name ilike '%tim%';


------------ is null and is not null

--find the list of actors with missing dte of birth
select * from actors
where
	date_of_birth is null
order by
	date_of_birth;


-- find list of actors 	with missing birth date or missing first name
select * from actors
where
	date_of_birth is null or
	first_name is null;

-- get the list of movies where domestic revenues is null
select * from movies_revenues
where 
	revenues_domestic is null;


-- get the list of movies where either domestic or international revenues is null
select * from movies_revenues
where 
	revenues_domestic is null or
	revenues_international is null;


-- get the list of movies where both domestic and international revenues is null
select * from movies_revenues
where 
	revenues_domestic is null and
	revenues_international is null;


-- movies where domestic revenues is not null
select * from movies_revenues
where 
	revenues_domestic is not null
order by
	revenues_domestic nulls first
;





------------------------- Concatinate Techniques

--- || -> to concate strings together
--- select concat(column1, column2) as new_string -> to concate columns together
--- select concat_ws('|', column1, column2) as new_string -> to concate string into one by a particular separator



-- combine string 'hello' and 'world'
select 'hello' || ' ' || 'world';

-- combine actor first_name and last_name as Actor Name:
select 
	first_name || ' ' || last_name as "Actor Name"
from actors;

select 
	concat(first_name,' ',last_name) as "Actor Name"
from actors
order by 
	first_name;


-- print first name, last name and date of birth of all actors separator by comma

select
	concat_ws(',', first_name, last_name, date_of_birth) as "Actor Info"
from 
	actors
order by
	first_name;







----------- Handling null values while concatination

---- concat function keeps the null values, does't ignore it
select 
	revenues_domestic,
	revenues_international,
	concat(revenues_domestic, ' | ', revenues_international) as "Profit"
from 
	movies_revenues;

-- where concat_ws automatically ignores the null values 
select 
	revenues_domestic,
	revenues_international,
	concat_ws(' | ', revenues_domestic, revenues_international) as "Profit"
from 
	movies_revenues;



