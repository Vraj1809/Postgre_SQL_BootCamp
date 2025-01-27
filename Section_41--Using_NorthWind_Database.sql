

----------- orders shipping to USA or France

select * from orders

select * from orders
where ship_country in ('USA', 'France')
order by ship_country


------------- count total number of orders shipping to USA or France

select
	ship_country,
	count(*) as "Total Orders"
from orders
where ship_country in ('USA', 'France')
group by ship_country


----------- orders shipping to any countries within latin america

select * from orders

select * from orders
where ship_country in ('Brazil', 'Mexico', 'Argentina', 'Venezuela')
order by ship_country



------------- show order total amount per each order line

select * from order_details

select
	order_id,
	unit_price * quantity - discount as "Total Amount"
from order_details


------------ find the first and the latest order dates

select
	min (order_date) as "First Order",
	max (order_date) as "Latest Order"
from orders


-------------- total products in each category

select * from products

select 
	category_name,
	count(*) as "Total Products"
from products
inner join categories using (category_id)
group by category_name
order by category_name


--------------- list products that needs re-ordering
select * from products

select
	product_id,
	product_name,
	units_in_stock,
	reorder_level
from products
where units_in_stock <= reorder_level
order by reorder_level desc


-------------------- list top 5 highest freight charges

select * from orders

select
	ship_country,
	avg(freight)
from orders
group by ship_country
order by 2 desc nulls last
limit 5


--------------------- list top 5 highest freight charges in year 1997

select
	ship_country,
	avg(freight)
from orders
where shipped_date between '1997-01-01' and '1997-12-31'
group by ship_country
order by 2 desc nulls last
limit 5


------------------- find customers with no id
select 
	customer_id,
	order_id
from customers
left join orders using (customer_id)
where order_id is null


------------------ top customers with total orders amount spend
select 
	customer_id,
	sum(unit_price * quantity - discount)
from customers
join orders using (customer_id)
join order_details using (order_id)
group by customer_id
order by 2 desc nulls last



------------------ orders with many lines of ordered items

select
	order_id,
	count(*)
from order_details
group by order_id
order by 2 desc



------------------- list all late shipped orders

select * from orders

select
	order_id,
	required_date,
	shipped_date
from orders
where required_date < shipped_date


--------------------- list employees with let shipped orders
select 
	employees.first_name || ' ' || employees.last_name as "Employee Name",
	count(*) as "Total Late Orders"
from orders
inner join employees using (employee_id)
where orders.required_date < orders.shipped_date
group by 1
order by 2 desc



---------------------- countries with customers or suppliers
select 
	country,
	'Customer' as tablename
from customers
union
select
	country,
	'Suppplier' as tablename
from suppliers
group by country
order by 2


------------------------ showing customers countries and supplier countries as separate columns
------------ with cte query

with customer_countries as
(
	select distinct country from customers
),
supplier_countries as
(
	select distinct country from suppliers
)
select 
	customer_countries.country as "Customer Countries",
	supplier_countries.country as "Supplier Countries"
from customer_countries
full join supplier_countries using (country)


------------------------------------- customers with multiple orders

select
	customer_id,
	count(*) as "Total Orders"
from customers
join orders using (customer_id)
group by customer_id
having count(*) > 1
order by 2 desc



------------------------- first order from each country

select 
	ship_country,
	min (order_date) as "First Order"
from orders
group by ship_country
order by ship_country


