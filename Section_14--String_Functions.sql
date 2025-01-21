------------------------------------- String Functions

------------ upper / lower - convert full string into upper case / lower case

select 
	upper('hello') as "Upper Case",
	lower('HELLO') as "Lower Case";


----------- initcap - converting first letter each word divided by space into upper case
select 
	initcap (
		concat(first_name, ' ', last_name)
	)
from directors
order by first_name;



---------- left and right functions

-- from left side 2 position
select left ('abcd', 1);

-- from left to right everything but don't include positions from right 
select right ('abcd', -1);

-- from right side 2 position
select right ('abcd', 2);

-- from right to left everything but don't include positions from left 
select right ('abcd', -1);


---- getting the initials of directors
select left(first_name, 1) as Initials
from directors
order by 1;

------ getting the initials as well count of that initials in the whole directors tablw
select 
	left(first_name,1) as Initials,
	count(*) as Total_initials
from directors
group by 1
order by 1;

-------- get first 6 six characters of all of the movies
select 
	left(movie_name, 6)
from movies;


------- find all directors where the last names end with 'on'
select
	last_name
from directors
where right(last_name,2) = 'on';



--------------------- reverse -> arrange string in reverse order
select reverse('Amazing PostgreSQL');




------------------- split_part Function -> splits function on specific delimiter and return the substring
---- split_part (string, delimiter, position)
select split_part ('A|B|C|D', '|', 2);


---- only works on string
select 
	movie_name,
	release_date,
	split_part(release_date, '-', 1) as release_year --won't work cause release_date is in date format not string
from movies;

select 
	movie_name,
	release_date,
	split_part(release_date::text, '-', 1) as release_year --will work cause of explicit conversion
from movies;





----------------------- trim functions

----- trim -> removes the longest string that contains that specific character
----- ltrim -> removes all characters, spaces by default, from the beginning of a string
----- rtrim -> removes all characters, spaces by default, from the end of a string
----- btrim -> combination of both ltrim and rtrim


select 
	trim(
		leading from
		' Amazing PostgreSQL ' -- doesn't remove space from the end
	),
	trim(
		trailing from
		' Amazing PostgreSQL ' -- doesn't remove space from the beginning
	),
	trim(
		' Amazing PostgreSQL ' -- removes space from both ends
	);


-------- removing leading 0 from the number
select 
	trim(
		leading '0' from
		000123456 :: text            -- will only work on text so have to explicit conversion
	);



select 
	ltrim ('yummy', 'y') as Left_trim,
	rtrim ('yummy', 'y') as Right_trim,
	btrim ('yummy', 'y') as B_trim;





------------------ Padding functions
---------- we give a total length of how much we want the string to be, in that the given string length would be minus and the
---------- remaining space is padded with the sequence of characters we have given
-- lpad -> padding to the left side
-- rpad -> padding to the right side

select lpad('Database', 15, '*');
select rpad('Database', 15, '*');

select lpad('1111', 6, 'A');





----------------- Length function

-----length / char_length
select 
	length('VRAJ') as Word_Length,
	length('') as empty_string_length,
	length(' ') as space_length,
	length(null) as null_length;



------- total length of all director's full name
select
	first_name || ' ' || last_name as "Last Name",
	length(first_name || ' ' || last_name) as "Length of Full Name"
from directors
order by 
2 desc;



-------------------- position function
------ position (sub_string in string) -- gives the position of 1st occurance of the substring in the string

select position ('amazing' in 'amazing postgresql')
select position ('is' in 'this is a computer')
select position ('A' in 'klickAnalytics.com')



-------- display the first_name, last_name and the position of aspecific substring 'on' which must exist within the column last_name 
-------- of the direcotrs
select 
	first_name,
	last_name,
	position ('on' in last_name)
from directors
where 
	position('on' in last_name) > 0;

	

--------------- substring function
------ substring (string, start_pos, substring_length) --> if start_postion not given then start from 1

select substring('what a wonderful world', 2,8);
select substring('what a wonderful world', 8,10);
select substring('what a wonderful world', 7);



---------- get initials from directors table using substring
select
	first_name as First_Name,
	substring(first_name, 1,1) as Initials
from directors;




--------------- Repeat function -> repeat a string specific number of times
select repeat ('A', 10);
select repeat (null, 10);
select repeat ('', 10);
select repeat (' ', 10);




---------------- Replace function -> replace all occurance of a specified string

---- replace (string, original__substring, new_substring)

select replace('ABC XYZ', 'X', 'V');

select replace(null, null, 'None');

select replace('', '', 'X');

select replace(1122233 :: text, '2', '4');
