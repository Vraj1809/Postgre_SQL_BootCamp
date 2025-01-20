
-------------------- Constraints

----------- Types -> 1) column level 2) table level

-------- Constraints
----- not null -> column level
----- unique -> column level
----- default -> column level
----- primary key -> table level
----- foreign key -> table level
----- check -> table level / column level



------------------------------ not null constraint

----- null means non existance it is not meaning as empty or zero

create table table_nn(
	id serial primary key,
	tag text not null
);

select * from table_nn;

insert into table_nn (tag) values ('Vraj');

-- can add empty space as it is not considered null
insert into table_nn (tag) values ('');

-- can't add null
insert into table_nn (tag) values (null);

select * from table_nn;



--- updating the table which don't have not null property

create table table_nn2(
	id serial primary key,
	tag text
);

insert into table_nn2 (tag) values ('Vraj');

-- can add empty space
insert into table_nn2 (tag) values ('');

-- can add null
insert into table_nn2 (tag) values (null);

select * from table_nn2;

update table_nn2
set tag = '0' where tag is null;

alter table table_nn2
alter column tag set not null;

insert into table_nn2 (tag) values (null);





------------------------------------- Unique Constraint

---- adding the unique contraints
create table table_emails(
	id serial primary key,
	emails varchar(30) unique
);

insert into table_emails (emails) values ('abc@gmail.com');

select * from table_emails;


------- adding unique to multiple columns
create table sample_unique(
	id serial primary key,
	unique1 varchar(2),
	unique2 varchar(2),
	unique (unique1, unique2)
);

insert into sample_unique (unique1, unique2) values (2,1);

select * from sample_unique;



------- altering the column to have the unique constraint
create table table_products(
	id serial primary key,
	product_code varchar(10),
	product_name varchar(10)
);

alter table table_products
add constraint unique_values unique (product_code, product_name);

insert into table_products (product_code, product_name) values ('1', 'table');







----------------------------------- Default constraint

------ creating default in table creation
create table employee_default(
	id serial primary key,
	em_name varchar(20),
	is_enable varchar(1) default 'N'
);

insert into employee_default (em_name) values ('Vraj');
insert into employee_default (em_name, is_enable) values ('Vraj', 'y');

select * from employee_default;


------ adding default constraint to the existing

alter table employee_default
alter column is_enable set default 'Y';

insert into employee_default (em_name) values ('Vraj');
insert into employee_default (em_name, is_enable) values ('Vraj', 'N');


------- drop a default value

alter table employee_default 
alter column is_enable drop default;

insert into employee_default (em_name) values ('Vraj');





------------------------- Primary key constraint
create table items(
	item_id serial primary key,
	item_name varchar(20)
);

insert into items (item_id, item_name) values ('1', 'table');
insert into items (item_id, item_name) values ('2', 'pen');

select * from items;

----------- dropping the constraint
alter table items
drop constraint items_pkey;


------- altering the table to add primary key
alter table items
add primary key (item_name);

insert into items (item_id, item_name) values ('2', 'pen');

----------- multiple primary keys
alter table items
add primary key (item_name, item_id); -- the order in which the keys are added to make them primary is also important normallly if 
-- the whichever numbers of variety is larger will be put ahead of the another ones









----------------------------- Foreign key constraint


----- the table which contains the key that references to the foreign key is called parent table and the table that contains that foreign key is called child
----- the child table should be always executed first so that when parent table references to it there is no error



---- if the concept of foreign key is not used then let's product table have a supplier_id of 10 but the supplier table doesn't have it
---- so the data is authenticated
-- child table 
create table t_suppliers (
	supplier_id int primary key,
	supplier_name varchar(100) not null
);

-- parent table
create table t_products(
	product_id int primary key,
	product_name varchar(100) not null,
	supplier_id int not null,
	foreign key (supplier_id) references t_suppliers (supplier_id)
);


------ insert data
-- first insert into child table

insert into t_suppliers (supplier_id, supplier_name) values
(1, 'supplier 1'),
(2, 'supplier 2');


---- insert into parent
insert into t_products (product_id, product_name, supplier_id) values
(1, 'product 1', 1),
(2, 'product 2', 2);

---- inserting data into parent for which foreign table have no data of
insert into t_products (product_id, product_name, supplier_id) values
(3, 'product 3', 11);

--- first inset into child then only parent
insert into t_suppliers (supplier_id, supplier_name) values
(11, 'supplier 11');

select * from t_products;



-------- update the data
--- can't directly update parent first have to update the child
update t_products
set supplier_id = 12
where product_id = 1;


---- can't also update data without veryfing it with the parent table
insert into t_suppliers (supplier_id, supplier_name) values
(12, 'supplier 12');



------------- delete the data
------- can't delete the data from the supplier directly cause there will be a foreign key referencing to that data 
------ first have to delete the data from the parent then only parent

delete from t_products
where supplier_id = 12;

delete from t_suppliers where supplier_id = 12;



----dropping the constraint

alter table t_products
drop constraint t_products_supplier_id_fkey;



--------- add foreign key constraint on the existing table
alter table t_products
add constraint t_product_supplier_id_fkey foreign key (supplier_id) references t_suppliers (supplier_id);









-------------------------------------- Check Constraint

create table staff(
	id serial primary key,
	first_name varchar(20),
	last_name varchar(20),
	birth_date date check (birth_date > '2000-01-01'),
	joining_date date check (joining_date > (birth_date + interval'20 years')::date),
	salary numeric check (salary > 0)
);


insert into staff (first_name, last_name, birth_date, joining_date, salary) values
('Vraj', 'Desai', '2003-09-18', '2024-08-23', 15000);



--------- check constraint for existing table
create table prices(
	price_id serial primary key,
	product_id int not null,
	price numeric not null,
	discount numeric not null,
	valid_from date not null
);

alter table prices
add check (price > 0 and discount >= 0 and price > discount);

insert into prices (product_id, price, discount, valid_from) values ('1', 100, 200, '2020-01-01');


--- rename constraint 
alter table prices
rename constraint prices_check to prices_discount_check;


----- drop a constraint
alter table prices
drop constraint prices_discount_check;
