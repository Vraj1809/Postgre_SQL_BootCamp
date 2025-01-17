-- Creating customers table
create table customers (
	customer_id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(150),
	age int
);

-- selecting data from the customers
select * from customers;

-- adding single values
insert into customers(first_name, last_name, email, age) values ('Vraj', 'Desai', 'vraj@gmail.com', 20);

select * from customers;

-- adding multiple values in table
insert into customers(first_name, last_name) values
('Vipul','Desai'),
('Anuradha', 'Desai');

-- adding data with quote(')
insert into customers(first_name) values
('Bill''o brian');

-- return clause to return the inserted values
insert into customers(first_name) values
('Veer') returning *; -- * for returning the full row that is all columns

insert into customers(first_name) values
('Rashi') returning customer_id, first_name; -- only returning the specific columns

-- Update Single Column
update customers
set email='vipuldesai@gmail.com'
where first_name = 'Vipul' and last_name = 'Desai';

-- Update Multiple Columns
update customers
set 
email='anudesai@gmail.com',
age = 45
where first_name = 'Anuradha' and last_name = 'Desai';

-- returning the updated row
update customers
set
email='veerdesai@gmail.com',
age = 18
where customer_id = 5 returning *;

-- Updating the all of the rows at the same time
update customers
set
is_enable = 'Y' returning *;

-- Deleting a specific row from the table
delete from customers
where customer_id = 5 returning *;

-- deleting multiple rows from the table
delete from customers
where last_name is null and email is null returning *;

-- delete all of the records from the table
-- delete from table_name;


-- using upsert -> insert data, if it doesn't exit then it would add the data 
-- but if it alreadys exits do then either do nothing or update the data
create table t_tags(
	id serial primary key,
	tag text unique,
	update_date timestamp default now()
);

insert into t_tags (tag) values
('Pen'),
('Pencils');

select * from t_tags;

--on conflict do nothing
insert into t_tags (tag) values
('Pen')
on conflict (tag)
do 
	nothing;

-- on conflict update the data
insert into t_tags (tag) values
('Pen')
on conflict (tag)
do 
	update set
	tag = excluded.tag,
	update_date = now();








