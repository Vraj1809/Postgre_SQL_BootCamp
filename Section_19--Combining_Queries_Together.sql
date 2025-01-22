--------------------------------- Combining Queries together

------------------ union

------- union left_products and right_products

select * from left_products 
union all
select * from right_products



-------- union gives unique records from both that is combine data from all tables and gives only unique data  
insert into right_products (product_id, product_name) values ('10', 'Pen') returning *;



-------- combining directors and actors table
select 
	first_name,
	last_name,
	date_of_birth
from actors
union
select 
	first_name,
	last_name,
	date_of_birth
from directors;


--------- using union with order by
select 
	first_name,
	last_name,
	date_of_birth
from actors
union
select 
	first_name,
	last_name,
	date_of_birth
from directors
order by first_name


------------- union with filters and conditions

-- combine all directors where nationality are American, Chinese and Japanese with all female actor
select
	first_name || ' ' || last_name as "Full Name",
	'Directors' as tablename
from directors
where nationality in ('American', 'Chinese','Japanese')
union
select
	first_name || ' ' || last_name as "Full Name",
	'Female Actor' as tablename
from actors
where gender = 'F'



------ select first name and last name of all directors and actors which are born after 1990
select
	first_name,
	last_name,
	date_of_birth,
	'director' as "Tablename"
from directors
where date_of_birth > '1990-12-31'
union
select
	first_name,
	last_name,
	date_of_birth,
	'actor' as "Tablename"
from actors
where date_of_birth > '1990-12-31'
order by date_of_birth


---- select the first name and last name of all directors and actors where thier first names starts with 'A'
select
	first_name,
	last_name,
	'director' as "Tablename"
from directors
where first_name like 'A%'
union
select
	first_name,
	last_name,
	'actor' as "Tablename"
from actors
where first_name like 'A%'




------------- combining tables with different columns

create table t1(
	col1 int,
	col2 int
)

create table t2(
	col3 int
)

-- would give error cause for union the number of columns must be same
select
	col1,
	col2
from t1
union
select
	col3
from t2


-- using null as column
select
	col1,
	col2
from t1
union
select
	null as col1,
	col3
from t2


drop table t1, t2



--------------------- intersect with tables
---- requirement same as union, order and number of columns must be same and they must be of compatible datatypes


--- using intersect on left_products and right_products

select * 
from left_products
intersect
select * 
from right_products


----- intersect first_name and last_name of directors and actors tables

select
	first_name,
	last_name
from directors
intersect
select
	first_name,
	last_name
from actors





------------------------------- Except with tables
------ requirement same as union and intersect
------ returns the rows in the first query that don't appear in the output of the second query



------ using except on left_products and right_products
select * from left_products
except
select * from right_products

------ so in short it is A - B



--------- except first and last names of directors and actors tables

-- will show only directors minus who are in the actors tables as well like bruce lee won't be shown
select
	first_name,
	last_name
from directors
except
select
	first_name,
	last_name
from actors
order by first_name



----- list all directors first and last name unless they have the same first_name in female actors

select
	first_name,
	last_name
from directors
except
select
	first_name,
	last_name
from actors
where gender = 'F'

	
