---------------------- Sequences

---- create a sequence
create sequence if not exists my_seq

----- advance sequence and return new value
select nextval('my_seq')

----- return the current value
select currval('my_seq')

----- set a sequence with value
select setval('my_seq', 100)

---- set a sequence, but we don't want skip over, means that currval value will still give the previous value but once we use 
---- nextval it will go to set value 200 then it will start with 200

select setval('my_seq', 200, false)
---create sequence if not exists my_seq start with 100


----- restart the sequence value
alter sequence my_seq restart with 100;

----- rename the sequence
alter sequence my_seq rename to test_seq;
alter sequence test_seq rename to my_seq;`


---------- create new sequence with max, min, increment and start with
create sequence if not exists my_seq2
minvalue 400
maxvalue 1000
increment 100
start with 500

alter sequence my_seq2
restart with 400;


select nextval('my_seq2');



---------- create sequences as specific type

-- bydefault the sequence is in bigint 
create sequence if not exists sequence_int as int
create sequence if not exists sequence_smallint as smallint

--------- cyclic sequence 
-- normally in sequence when it reaches max value then after that it is not updated and in factwould give error
-- but using cycle we can restart the sequence with the start value

create sequence if not exists seq_asc
minvalue 1
maxvalue 3
increment 1
start with 1
cycle;

select nextval('seq_asc');

-------- descending sequence 
--- normal sequence is in ascending format which increments
create sequence if not exists seq_desc
minvalue 1
maxvalue 3
increment -1
start with 3
cycle;

select nextval('seq_desc');




------------ deleting a sequence
drop sequence my_seq2;



--------- attaching a sequence with the column

create table sample(
	id serial primary key,
	data varchar(20)
)

insert into sample (data) values 
('hgdhssdg'),
('wrrgab');

select * from sample;

-- now the serial is implementing sequence in the backend so when we use serial as data type, it gives sequence as default value to
-- id 

alter sequence sample_id_seq restart with 100


------- now creating the table with no sequence but adding the sequence into it
create table sample_no_sequence(
	id int primary key,
	data varchar(20)
)

---- now to add the sequence there are twosteps
---- first creating the sequence
create sequence sample_no_sequence_id_seq start with 1000;

----- second attach that sequenceas the default value of the id
alter table sample_no_sequence
alter column id set default nextval('sample_no_sequence_id_seq');

insert into sample_no_sequence (data) values 
('hgdhssdg'),
('wrrgab');

select * from sample_no_sequence;




---------- sharing the sequence between two tables

create table share_table(
	id int default nextval('sample_no_sequence_id_seq'),	
	data varchar(20)
)

insert into share_table (data) values ('data1');

select * from share_table;



-------- create a alpha numeric sequence

create sequence alpha_numeric start with 1

create table alpha_num (
	id text primary key not null default ('ID' || nextval('alpha_numeric')),
	data varchar(20)
);

alter sequence alpha_numeric owned by alpha_num.id

insert into alpha_num (data) values ('Vraj1')

select * from alpha_num;


