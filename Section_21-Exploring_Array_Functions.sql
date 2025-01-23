------------------------------- constructing arrays and ranges

------- array accessing can be used with indexing but the indexing here starts with 1 not 0

----------- constructing ranges

------- range_type (lower_bound, upper_bound, open_close) -> [] -> range is close, () -> range is open

select
	int4range(1,6),  --- if we don't specify then bydefalut it would be [) -> close - open
	numrange(1,6, '[]')  as "[] closed - closed",
	daterange('20200101', '20200110', '()')   as "() open-open",
	tsrange(localtimestamp, localtimestamp + interval '10 days', '(]')   as "(] open-close"



------------- constructing arrayys
select 
	array[1,2,3] as "int arrays", -- if we don't specify the datatype here then postgresql will evaluate the type itself
	array[2.2::float,2.34::float] as "float arrays",
	array[current_date, current_date + 5]





------------------------- using comparison operators -> =, <>, < , >, <=, =>

------- in array
select
	array[1,2,3,4] = array[1,2,3,4] as " = ",
	array[1,2,3,4] = array[2,3,4] as " = ",
	array[1,2,3,4] <> array[1,2,3,4] as " <> ",
	array[1,2,3,4] > array[1,2,3,4] as " > ",
	array[1,2,3,4] >= array[1,2,3,4] as " >= ",
	array[1,2,3,4] < array[1,2,3,4] as " < ",
	array[1,2,3,4] <= array[1,2,3,4] as " <= "


------ in ranges
select
	int4range(1,4) @> int4range(0,3) as "contains",
	daterange(current_date, current_date + 30) @> current_date + 15 as "contains value",
	numrange(1.6,5.2) && numrange(2,6) as "contains range"

--------------- inclusion operators -> @>, <@, &&
---- a @> b  --> whether a contains b
---- a <@ b  --> whether a is contained by b or in other words, whether b contains a
---- a && b  --> whether a and b are overlapped


--- for array
select 
	array[1,2,3,4] @> array[1,2,3] as "contains",
	array[2,3,4] <@ array[3,4,5,6] as "contained by",
	array[1,2,3,4] && array[1,2,3] as "Overlapped"



----------------------- Array construction

------ using concatination

select
	array[1,2,3] || array[4,5,6] as "Using ||",
	array_cat(array[1,2,3], array[4,5,6]) as "Using array_cat"

----- prepending array
select 
	4 || array[1,2,3] as "using ||",
	array_prepend(4, array[1,2,3]) as "using array_prepend"
--  array_prepend(array[1,2,3], 4) -- will give error cause the syntax of array_prepend is that first giive the number that you want to prepand thgen array


----- appending array
select 
	array[1,2,3] || 4 as "using ||",
	array_append(array[1,2,3],4) as "using array_append"
--  array_append(4,array[1,2,3]) -- will give error cause the syntax of array_append is that first giive the array then number




----------------- array metadata functions

select 
	array_ndims(array[[1,2],[2,3]]),  -- returns the dimension of array as an integer
	array_dims(array[[1],[2]]) , -- represents array dimension in text format
	array_length(array[[1,2],[2,3],[3,4]], 2), -- gives array length, in a given dimension
	array_lower(array[[-2,2],[2,3],[3,4],[4,5]],2), -- returns lower bound of the array as int
	array_upper(array[[-2,2],[2,3],[3,4],[4,5]],2)



-------------------- array search functions

------ array_position(array, element, start_position) --> if indexing not specified then takes as 1, as indexing starts from 1
---------- will only give you the first oocurance only

select 
	array_position(array[1,2,3,4], 3) as "Start_Position not given",
	array_position(array['Jan','Feb','Mar','April','Feb'], 'Feb', 3) as "Start_Position given"

------- array_positions(array, element) -- when multiple same elements in the array and want to have all of those indexes
select 
	array_positions(array['Jan','Feb','Mar','April','Feb'], 'Feb')





------------------ array modification functions
------ for all of these functions, array must be 1 dimensional
------ array_cat, array_prepend, array_append functions that we have seen before

--- array_remove (array, element) --> remove alll occurance of that element from the array
select 
	array_remove(array[1,2,3,4,4], 4)

--- array_replace (array, old, new) --> replace all occurance of that element with the new element
select
	array_replace (array[1,2,3,4,3], 3, 6)




-------------------- array comparison with in, all, any and some

------- in operator
---- expression in () -> right_hand side is parenthesized scalar expression
---- returns true if left expression's result is equal to any of the right side expression

select
	20 in (1,2,3,20),
	5 in (1,2,3,4);
	

----- not in operator
select
	20 not in (1,2,3,20),
	5 not in (1,2,3,4);


----- all operator -> if expression to left is equal to all values of the expression to right then only true or else false
select
	20 = all(array[1,2,3,20]),
	5 = all(array[5,5,5,5]);


--------- any/some operator -> if any value is equal then equals true
select
	20 = any(array[1,2,3,20]),
	5 = any(array[5,5,5,5]),
	20 <> any(array[1,null,3,20]),
	5 <> any(array[5,5,5,null]), -- null is not compared and thus returned null
	20 <> any(array[1,2,3,20]),
	5 <> any(array[5,5,5,5]);


--------- formatting and converting array

-------- string_to_array  (string, delimiter, element_to_convert_null) -- convert string to array

select
	string_to_array ('1,2,3,4', ',') as "Not Specifdying element to convert to null",
	string_to_array ('1,2,3,4,ABC', ',', 'ABC') as "Specifdying element to convert to null",
	string_to_array ('1,2,3,', ',', '') as "Empty value to null"


------- array_to_string (string, separator, value_to_convert_null_to) -> convert array to string -> if vaue not specified then the null value is not included in the string
select 
	array_to_string (array[1,2,3,4], '|'),
	array_to_string (array[1,2,null,4], '|'),
	array_to_string (array[1,2,null,4], '|', 'Empty Data');




--------------- using arrays in table -> using [] after the datatype

-------- creating array columns
create table teachers(
	teacher_id serial primary key,
	name varchar(150),
	phone text []
)

select * from teachers;

--------- inserting values in to the array
---- non text values
-- using array -> array[1,2,3]
-- without array -> '{1,2,3}'

--- text values
-- using array -> array['text1','text2','text3']
-- without array -> '{"text1", "text2", "text3"}'

insert into teachers (name, phone) values
('vraj', '{"(951)-071-5980", "(798)-465-4599"}'), -- without using array
('vipul', array['(942)-816-0946', '(799)-006-2715']) -- with using array

select * from teachers;



----------------- Query Array Data
----- find all phone records
select 
	name,
	phone
from teachers;


---- accessing array elements
select
	name,
	phone[2] -- second phone number
from teachers;


---- filtering array data
select * from teachers
where phone[1] = '(951)-071-5980';


----- search an array for all rows
select * from teachers
where '(951)-071-5980' = any(phone)



--------------- modifying array data
update teachers
set phone [1] = '(942)-816-0946'
where teacher_id = 3 returning *;




----------- postgreSQL ignores the dimensions
create table teachers2(
	teacher_id serial primary key,
	name varchar(150),
	phone text array[1]
)

-- now it should generate an that we have specified array with only 1 length but it would not so it somehow ignore the array dimension
insert into teachers2 (name, phone) values
('vraj', '{"(951)-071-5980", "(798)-465-4599"}'),
('vipul', array['(942)-816-0946', '(799)-006-2715'])

select * from teachers2;



------------ display all elements, not like in the {} format but individual records
----- using unnest (array)

select 
	name,
	unnest(phone) as "Phone"
from teachers;




-------------------- multi dimensional array
create table student_grades(
	id serial primary key,
	s_name varchar(50),
	s_grade_year int[][] -- first [] tell it is array and second [] tells that it is still array but another dimension is added into it
)

insert into student_grades (s_name, s_grade_year) values 
('Vraj', array[[90,2020],[100,2021]]),
('Vipul', array[[100,2020],[100,2021]])

select * from student_grades

select 
	s_name,
	s_grade_year[1][1] || ' | ' || s_grade_year[1][2]
from student_grades
