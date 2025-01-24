
---------------------------------- View

---------- can be caled reusable query or function 
---------- let's say we have selected some columns from the table to use, now everytime we have to use those columns we have to write 
---------- the whole select statement again and again instead we will create a view with only those columns and everytime we need those columns
---------- we will use that view instead

-------- syntax 
------ create or relpace view view_name as query
------ query can be any select with subquery or select with join or any query needed

-------- creating quick movie view with movie name, length and release date

create or replace view view_movie_quick as
select 
	movie_name,
	movie_length,
	release_date
from movies


----- create a view with all movies with directors first_name and last_name
create or replace view view_movies_directors as
select 
	movies.movie_name,
	directors.first_name,
	directors.last_name
from movies
join directors using (director_id)


---------- view a view
select * from view_movie_quick


select * from view_movies_directors

-------------- Rename a view 
alter view view_movie_quick rename to view_movies_quick

-------------- drop a view
----- drop view view_movie_quick



------------------- create a view to list all movies released after 1997

create or replace view view_movies_after_1997 as
select * from movies
where release_date > '1997-12-31'
order by release_date

select * from view_movies_after_1997



---------------- select all movies with english only language from the view

select * from view_movies_after_1997
where movie_lang = 'English'


---------- select all movies with directors with American, and Japanese Nationalities

create or replace view view_movies_directors_nationality as
select 
	movies.movie_name as "Movie Name",
	directors.first_name || ' ' || directors.last_name as "Director Name",
	directors.nationality as "Nationality"
from directors
inner join movies using (director_id)
where directors.nationality in ('American', 'Japanese')
order by 3

select * from view_movies_directors_nationality





---------------- a view using select and union with multiple tables

------------- view for all people in movies like actors and directors with first and last name

create view view_all_actor_director as
select
	first_name,
	last_name,
	'actor' as People_Type
from actors
union all
select
	first_name,
	last_name,
	'director' as People_Type
from directors

select * from view_all_actor_director


------------------- connecting multiple tables with a single view

-------- connect movies, directors, movies_revenues tables with a single view

create or replace view view_movies_directors_revenues as
select 
	*
from movies
inner join directors using (director_id)
inner join movies_revenues using (movie_id)

select * from view_movies_directors_revenues 


---- filtering data with only giving movies with age certificate = 12

---- without view
select 
	*
from movies
inner join directors using (director_id)
inner join movies_revenues using (movie_id)
where movies.age_certificate = '12'


-- with view
select * from view_movies_directors_revenues
where age_certificate = '12'



--------------- rearranging a column in  existing view

--------- can;t rearrnage columns

create or replace view view_directors as
select
	first_name,
	last_name
from directors

---- can't rearrange columns
create or replace view view_directors as
select
	last_name,
	first_name
from directors

--first rename view to old_view
alter view view_directors rename to old_view_directors

-- create a new view with the same  name and rearrnage the columns there
create or replace view view_directors as
select
	last_name,
	first_name
from directors

--- delete the old view
drop view old_view_directors

select * from view_directors



---------------- delete a column in a view
--- can't directly drop columns
create or replace view view_directors as
select 
	first_name
from directors

--- same as rearrangiing the columns


----------- adding a new column in the view
create or replace view view_directors as
select
	last_name,
	first_name,
	nationality
from directors

select * from view_directors




-------------------- updatable view -> can only perform insert, update and delete operation with where clause

create or replace view vu_directors as
select 
	first_name,
	last_name
from directors

select * from vu_directors

insert into vu_directors (first_name, last_name) values ('Vraj', 'Vipul')

-- data is also inserted into the directors table
select * from directors





----------------------- updatable view with with check option

------ so let's say we have a cities table 
create table cities 
(
	country_code varchar(5),
	city_name varchar(20)
)

insert into cities (country_code, city_name) values
('IN', 'Navsari'),
('IN', 'Navsari'),
('US', 'New York'),
('IN', 'Navsari'),
('US', 'New Jersy')

----- we are creating a view with only indian cities in it
create or replace view view_city_india as
select 
	* 
from cities
where country_code = 'IN'

------ now let's say a user adds a US city in the view then it would not be reflected in the view cause it would first inserted 
------ in the main table and then from there view will find only city with country code IN
------ but although the data is shown still it is added to the table
insert into view_city_india (country_code, city_name) values ('US', 'Chicago')

select * from view_city_india

select * from cities

------ to avoid this creating a view with  with check option

create or replace view view_city_india as
select
	*
from cities
where country_code = 'IN'
with check option

insert into view_city_india (country_code, city_name) values ('US', 'Chicago')



----------------------------------------- updatable view with with cascade option

--- now let's create a new view from view_city_indian where only city starting with N can be entered

create or replace view view_city_start_N as 
select 
	*
from view_city_india
where city_name like 'N%'
with check option

insert into view_city_start_N (country_code, city_name) values ('IN', 'Nagpur')

select * from view_city_start_N

-- data is also added in the cities table 

---- now let's try adding city New Orlando even though its country_code is 'US'
insert into view_city_start_N (country_code, city_name) values ('IN', 'view Orlando')




------------------------ Creating a materialized view

create materialized view if not exists mv_directors_data as
select 
	first_name,
	last_name
from directors
with data

select * from mv_directors_data;


create materialized view if not exists my_directors_no_data as
select 
	first_name,
	last_name
from directors
with no data


select * from my_directors_no_data

-- it is not populated so the data would not be displayed
-- so first have to populate it

-- refreshing the materialized view
refresh materialized view my_directors_no_data

-- now it will show the result
select * from my_directors_no_data


--------------- updating the materialized view
select * from mv_directors_data

-- can't directly change the materilized view but have to change the underlying table first and then refresh the materialized view
insert into mv_directors_data (first_name) values ('Vraj')

insert into directors (first_name) values ('Vraj') returning *;

refresh materialized view mv_directors_data;

select * from mv_directors_data

----- all crud operations first have to be performed on underlying table first then refresh the material view


----------- checking if the materialized view is populated or not
select relispopulated from pg_class where relname = 'mv_directors_data'


----------- refresh the materilized view concurrently
refresh materialized view concurrently mv_directors_data

------ have to create a unique index here for the view
create unique index idx_u_mv_directors_data_first_name_last_name on mv_directors_data (first_name, last_name)

select * from mv_directors_data
