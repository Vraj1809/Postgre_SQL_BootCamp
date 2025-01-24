------------------------------- Indexing 

------- normal indexing syntax
---- create index idx_tableName_columnName on tableName (columnName)

----------- creating indexing on order_date on orders table

create index idx_orders_order_date on orders (order_date)


---------- creating index on ship_city on orders table

create index idx_orders_ship_city on orders (ship_city)



-------------- creating index on multiple columns  -> at a time we can define index for 32 columns
----- creating on customer_id, order_id

create index idx_orders_customer_id_order_id on orders (customer_id, order_id)


----- important to note that the order in which the columns are given in the indexes should be like the most selective ahead of less selective


------ creating index using pgadmin on shippers




------------------------ Creating unique Indexes
------- normally primary key is included in the unique index
------- if multiple columns are defined as the unique index then the combined values in these column can't be duplicated

--------------- Creating unique index on products table on product_id
create unique index idx_u_products_product_id on products (product_id)


-------------- creating unique index on employee table on employee_id
create unique index idx_u_employees_employee_id on employees (employee_id)


------------- creating unique index on multiple columns
-------- on order_id, customer_id

create unique index idx_u_order_id_customer_id on orders (order_id, customer_id)

---------- emplyee_id, hire_date
create unique index idx_u_employee_id_hire_date on employees (employee_id, hire_date)


--------------- Trying into insert values with same values for the columns that are in the index to check whether the unique index is working or not

----- on employees table
select * from employees

--- creating index with colums that is not primary key, first_name and last_name
create unique index idx_u_employees_first_name_last_name on employees (first_name, last_name)

-- will return error even though the employee_id (primary key) is unique
insert into employees (employee_id, first_name, last_name) values (11, 'Davolio', 'Nancy');




-------------- list all indices

select * from pg_indexes


----- for specific tables
select * from pg_indexes where tablename = 'employees'



----------------- size of table index

select pg_indexes_size('employees')

-- more readable format
select pg_size_pretty(pg_indexes_size('employees'))


---- list count of all indexes
select * from pg_stat_all_indexes



----------------- Dropping an index
------ syntax
---- drop index [concurrently]
---- [if exists] index_name
---- [cascade | restrict] ;  --> cascade means removing the object as well as all other objects that depend on it and restrict
--------------------------------- means it would restrict postgre to delete it, bydefault restrict is used


----- dropping the employees first_name, last_name index

drop index idx_u_employees_first_name_last_name




--------------- Types of indexes

------ B Tree index
---- used when comparision of < , <= , = , >= , betwen , in, is null, is not null
---- pattern matching etc...
---- bydefault used index

------ hash index
---- used only for equality operator
---- not for range or disequality, larger than b trees

--- creating hash index on order_date

create index idx_orders_order_date_hash on orders using hash (order_date)

-- here index scan but the id_orders_order_date, btree index is used
explain select * from orders order by order_date

-- here index scan but since there is equallity comparison hash index is used
explain select * from orders where order_date = '2020-01-01';





