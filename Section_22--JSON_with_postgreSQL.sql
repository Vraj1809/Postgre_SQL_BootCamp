----------------------------------------- json with postgreSQL

------------------- exploring json objects

----- in postgre, we have to represent the json as '{"title" : "Lord"}'

select '{"title" : "Lord"}';
-- but it is represented as text not json

select '{"title" : "Lord"}' :: json;
-- now it is represented as json but we want to type the json data in the format it is normally used

select '{
	"title" : "Lord"
}' :: json
-- but it is also preserving the space here

-- so if we don''t want to preserve the space then
select '{
	"title" : "Lord"
}' :: jsonb




------------------------------- creating table with json data
create table books (
	id serial primary key,
	book_info jsonb
)

select * from books;

insert into books  (book_info) values
(
	'{
		"name" : "Book 1",
		"pages" : 100
	}'
),
(
	'{
		"name" : "Book 2",
		"pages" : 200
	}'
),
(
	'{
		"name" : "Book 3",
		"pages" : 300
	}'
),
(
	'{
		"name" : "Book 4",
		"pages" : 400
	}'
)

-------- accessing thhe json data
-- -> returns the json object field as a field in quotes
-- ->> returns the json object filed as text

select 
	book_info -> 'name' as "Book Name",
	book_info -> 'pages' as "Book Pages"
from books;

select
	book_info ->> 'name' as "Book Name",
	book_info ->> 'pages' as "Book Pages"
from books;




------------- update the json data
insert into books (book_info) values
(
	'{
		"name" : "Book 10",
		"pages" : 1000
	}'
)

select * from books;

------- for update, we will use || concate function  --> || will can be used to either add new field or update the existing field
update books
set book_info = book_info || '{"name" : "Vraj Book"}'
where
	book_info ->> 'name' = 'Book 10' returning *;
	

------- adding a new field
update books
set book_info = book_info || '{"Best Seller" : true}'
where
	book_info ->> 'name' = 'Vraj Book' returning *;


------- delete any field -> -(minus) operator would be used here
update books
set book_info = book_info - 'Best Seller'
where
	book_info ->> 'name' = 'Vraj Book' returning *;

-------- add nested array in the data
update books
set book_info = book_info || '{
"Availability Locations" : ["India", "America"]
}'
where
	book_info ->> 'name' = 'Vraj Book' returning *;


-------- delete from arrays via path
update books
set book_info = book_info - '{Availability Location, 1}'
where
	book_info ->> 'name' = 'Vraj Book' returning *;




------------------ Creating JSON from the table

----- directors table into json format
select row_to_json(directors) from directors;


---- converting only selected columns to json
select row_to_json(t) from 
(
	select 
		director_id,
		first_name,
		last_name,
		nationality
	from directors
) as t


----------------- using json_agg to aggregate the data
---- printing the director's table and with that in each row of director, having one extra column of movies that director have made
---- using json_agg(x) -> to unite all elements satisfying the condition such a way that it becomes json

select 
	first_name || ' ' || last_name as "Director Name",
	(
		select json_agg(x) as "All Movies" from 
		(
			select movie_name from movies
			where director_id = directors.director_id
		) as x
	)
from directors;




------------------------ building a json array -> 
-- using json_build_array(values) function --> will build json array
-- using json_build_object(values) --> will build json array, in a key-value format so have to give even values only that would be
-- of key-value
-- using json_object ({keys}, {values}) -> all keys and values in separate {} together and order should be same in both like if in
-- keys on 1st there is name then in values on 1st there should name

select json_build_array (1,2,3,4,5)

select json_build_object(1,2,3,4,5) -- will give error

select json_build_object(1,2,3,4,5,6)

select json_build_object('name', 'vraj', 'phone', '9510715980')

select json_object ('{name, phone}', '{"Vraj", 9510715980}') -- {} should be enclosed in ''

select json_object ('{phone, name}', '{"Vraj", 9510715980}')




----------- creating a document from data
insert into directors_docs (body)
	select row_to_json(data)::jsonb from (
		select 
			director_id,
			first_name,
			last_name,
			date_of_birth,
			nationality,
			(
				select json_agg(x) as "All Movies" from (
					select movie_name from movies
					where director_id = directors.director_id
				) as x
			)
		from directors
	) as data


----- creating a docs table and inserting data into it
create table directors_docs (
	id serial primary key,
	body jsonb
)

select * from directors_docs

--------------------------- Dealing with null values in json documents

----- jsonb_array_element -> used to access the json, but can't extract information
select jsonb_array_elements(body -> 'All Movies') from directors_docs

 
--------- populate data with empty array element for all movies
delete from directors_docs;

insert into directors_docs (body)
select row_to_json(data)::jsonb from (
		select 
			director_id,
			first_name,
			last_name,
			date_of_birth,
			nationality,
			(
				select case count(x) when 0 then '[]' else json_agg(x) end as "All Movies"
				from (
					select movie_name from movies
					where director_id = directors.director_id
				) as x
			)
		from directors
) as data


--------------- Existance Operator -> ?


-- select from director_docs where name is john

select * from directors_docs
where body->>'first_name' = 'John'

select * from directors_docs
where body->'first_name' ? 'John'


-- find all records with director_id = 1
select * from directors_docs
where body->>'director_id' = '1'

---- ?, existance operator expects both left and right values to be text but here in the data it would be integer nd we are passing
---- text, so data would be generated
select * from directors_docs
where body->'director_id' ? 1




---------------------- containment operator -> this operator is used when we want to find the data using the key-value format
---- @> is the containment operator


--- find all records where first_name is john
select * from directors_docs
where body @> '{"first_name" : "John"}' -- where body contains the key-value pair


--- find all records with director_id = 1
select * from directors_docs
where body @> '{"director_id" : 1}'


--- find the record for movie name "Toy Story"

--- movie_name is in "All movies" so have to go to "All movies" and then find pair of "movie_name" : "Toy Story" 
select * from directors_docs
where body -> 'All Movies' @> '[{"movie_name" : "Toy Story"}]'




------------------ json search with postgresql functions


-- find the records where first name starts with capital 'J'
select * from directors_docs
where body ->> 'first_name' like 'J%'


-- find all records where director_id is greater than 2
select * from directors_docs
where body ->> 'director_id' > '2'



-- find all records where director_id is in 1,2,3,4,5 and 10
select * from directors_docs
where body ->> 'director_id' in ('1','2','3','4','5','10')


-------------------- Creating gin index to speed up the process
create index idx_gin_directors_docs_body on directors_docs using gin (body jsonb_path_ops)

