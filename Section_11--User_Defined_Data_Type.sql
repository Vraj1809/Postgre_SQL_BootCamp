---------------------------------------- User Define Datatype

------------- create domain data type

create domain addr varchar(100) not null

-- table with addr data type
create table locations(
	address addr
);

insert into locations (address) values ('100 100 100');

select * from locations;

---------- Positive Numeric domain with positive number

create domain pos_num int not null check (value > 0);

create table sample_num(
	num_id serial primary key,
	num pos_num
);

insert into sample_num (num) values (-10);
insert into sample_num (num) values (10);

select * from sample_num;



----------- Email verification using user defined data type
create domain email_veri as text check(
	value ~ '^[a-zA-Z][a-zA-Z0-9]+@[a-zA-Z]+.com$'
);

create table sample_email(
	em_id serial primary key,
	email email_veri
);

insert into sample_email (email) values ('45vrajdesai67@gmail.com');

select * from sample_email;



----------- create a enum or set of values domain data type
create domain color_check as text not null check (
	value in ('red', 'blue', 'yellow')
); 

create table sample_color(
	color_id serial primary key,
	color color_check
);

insert into sample_color (color) values ('red');
insert into sample_color (color) values ('green');

select * from sample_color;

-------- to get all of the user defined data types that is the domains, just go to schema -> public -> Domains




--------------------- Dropping the domain ------

---can't directly use, will give an error about other columns dependent on that datatype
drop domain color_check;

--- can use cascade, but will drop the domain as well as the columns that depend on it
---- drop domain color_check cascade;

------ just go the column that uses the domain and change its type and then drop that domain

alter table sample_color
alter column color type varchar(20);

drop domain color_check;




--------------------------- Composite Datatype -> return multiple values, as it stores multiple values

--creating composite type
create type address as (
	city varchar(20),
	country varchar(10)
);

create table address_composite (
	add_id serial primary key,
	address_name address
);

select * from address_composite;


----- adding data to the composite type using row
insert into address_composite (address_name) values (row('navsari', 'india'));
insert into address_composite (address_name) values (row('mumbai', 'india'));


----- accessing the invidual values in the composite type

--- can use (composite_type).field
--- if dealing with multiple tables then (table.composite_type).field

select (address_name).city from address_composite;

select (address_composite.address_name).country from address_composite;





-------------------------  Create a composite 'inventoryy_item' data_type
create type inventory_item as (
	item_name varchar(20),
	supplier_id int,
	price numeric
);

create table composite_inventory(
	inventory_id serial primary key,
	item inventory_item
);

insert into composite_inventory (item) values 
	(row('table', 32, 1500)),
	(row('chair', 33, 2500)),
	(row('book', 34, 1000)),
	(row('sofa', 35, 15000));

select * from composite_inventory;

select 
	(item).item_name as "Item Name",
	(composite_inventory.item).supplier_id as "supplier Id",
	(item).price as "Price"
from composite_inventory;






------------------- create a enum data type and add new value in that enum

--creating enum
create type currency as enum('usd', 'rupee', 'chf');

--adding new value into the enum
alter type currency add value 'eur' after 'rupee';

create table composite_stocks(
	stock_id serial primary key,
	stock_currency currency
);

select * from composite_stocks;

insert into composite_stocks (stock_currency) values ('rupee');

--would not be added
insert into composite_stocks (stock_currency) values ('rupeedgsj');



---- dropping the enum type

create type colors as enum ('red', 'blue');

drop type colors;




--------------------------- alter the composite data type, change schema etc....

---the composite data type
create type address_alter as (
	city varchar(30),
	country varchar (20)
);

--- renaming the currency composite type to chalan
alter type address_alter rename to address_alter_type;


----- change the owner of type
--alter type currency owner to postgres

----- change the schema of type
--alter type currency set schema schema_name


------ adding new attribute to the type
alter type address_alter_type add attribute state varchar(20);





------------------------------ alter an enum data type

--- creating enum type
create type color_alter as enum ('red', 'blue','yellow');

--- listing all of the enum values in the type
select enum_range(null :: color_alter);


----- altering the enum type with renameing red with hot red
alter type color_alter rename value 'red' to 'hot red';


------ adding new enum valu, before and after 
alter type color_alter add value 'pink' after 'blue';
alter type color_alter add value 'hot pink' before 'blue';











----------------------- Update enum data in production server
create type job_status  as enum ('queued', 'waiting', 'running', 'done');

create table jobs_alter (
	job_id serial primary key,
	job_status job_status
);

insert into jobs_alter (job_status) values ('queued');
insert into jobs_alter (job_status) values ('waiting');
insert into jobs_alter (job_status) values ('running');
insert into jobs_alter (job_status) values ('done');

select * from jobs_alter;

--- deleting the waiting from the enum

-- first altering in the jobs_alter table

update jobs_alter set job_status = 'running' where job_status = 'waiting';

select * from jobs_alter;

-- rename the enm jobs_status to old
alter type job_status rename to old_job_status;

-- creating new data type for column
create type job_status as enum ('queued', 'running', 'done');

---- alter the table and adding the new data type to the column

alter table jobs_alter
alter column job_status type job_status using job_status::text::job_status;








-------------------- Creating an enum data type and assigning a default value to the column

---- the job_status is already created enum type

--- creating table with default value
create table jobs_default(
	job_id serial primary key,
	job_status job_status default 'running'
);

select * from jobs_default;

insert into jobs_default (job_id) values (1);
insert into jobs_default (job_status) values ('queued');
insert into jobs_default (job_id) values (3);
insert into jobs_default (job_status) values ('done');


