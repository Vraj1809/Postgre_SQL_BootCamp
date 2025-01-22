
----------------------------------- Creation of Schema
create schema hr
create schema sales

----------------- alter/rename schema
alter schema sales rename to pprogramming

--------------- delete the schema 
drop schema pprogramming
drop schema hr




--------------------------------- creations of new schema
create schema humanresources

---- after adding new table in that schema 

--- accessing the table 

--- if access without schema name then directly the table from public schema is used
select * from employees;

select * from humanresources.employees;




---------------------------- move a table to new schema
alter table humanresources.test_move set schema public;




--------------------------- scehma search path
----- normally when we use select * from orders; then by default it is using a search path to run the query for that table,
----- it is using search path to get to that table

-- using this we will see "$user", public in the output which means there are only two search paths now, currently our new shcema
-- humanresources is not in the search path
-- but if we use schema_name.table_name then other table from the schema can also be executed 
show search_path;

select * from humanresources.test_move;


----- now let's say there is only one table unique in all of the schemas but it is not in the public table and we want to execute it
----- normally without the schema name so we have add the schema to the search_path

set search_path to '$user', public, humanresources;


-- now accessing the table from humanresources without the schema name
select * from test_search_path;


-- the order in which the search_path is set is also important because here test_move is in both schemas public and humanresources 
-- and if we use that table without schema name then it will go from first to last in order and in whichever schema it would come first
-- would be executed, so here first public come so test_move from public is executed

-- now changing the order and checking whether the table from humanresources is executed or not
set search_path to '$user', humanresources, public;

select * from test_move;

-- so the search_part order is important


