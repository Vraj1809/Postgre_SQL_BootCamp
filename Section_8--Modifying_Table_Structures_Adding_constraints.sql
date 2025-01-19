
------ Creating table and then adding new columns after the table has been created

create table persons(
	p_id serial primary key,
	first_name varchar(50),
	last_name varchar(50)
);

select * from persons;

---- alter table to add new column
alter table persons
add column age int not null;


-- adding multiple columns
alter table persons
add column nationality varchar(10) not null,
add column email varchar(20) unique;






-------------------- MOdifying Table Structure, Add/ Modifying Constraints

-------- rename table 

alter table users
rename to persons;

-- select * from users;


-------- rename columns

alter table persons
rename column age to person_age;

select * from persons;


--------- drop column
alter table persons
drop column person_age;

--------- add column
alter table persons
add column age varchar(20);


---------- change datatype of the column

alter table persons 
alter column age type int   -- can't change directly from character to integer have to use ::
using age::integer;
-- integer to varchar, there is no function needed but varchar to integer using is needed


--------- set a default value
alter table persons
add column is_enable varchar(1);

alter table persons
alter column is_enable set default 'Y';

insert into persons (first_name, last_name, nationality, email, age) values
('Vraj', 'Desai', 'Indian', 'vraj@gmail.com', 21);










-------------------------------------- Adding COnstraints to the column
create table web_links(
	link_id serial primary key,
	link_url varchar(20),
	link_target varchar(10)
);

select * from web_links;

insert into web_links( link_url, link_target, is_enable) values ('https://www.hotstar.com', '_blank','N');


----- to get the unique link_url adding constraints

alter table web_links
add constraint link_url unique (link_url);


----- to set column to accept only allowed values

alter table web_links
add column is_enable varchar(2);

update web_links
set is_enable = 'N';

alter table web_links
add check (is_enable in ('Y', 'N'));


