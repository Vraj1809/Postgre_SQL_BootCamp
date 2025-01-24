---------------- selecting first or last 10 records in a table

(select * from stocks_prices
limit 10)
union
(select * from stocks_prices
order by price_id desc
limit 10) order by price_id


---------------- selecting to get the first or last record per each group
select 
	symbol_id,
	min(price_date) as "First Record",
	max(price_date) as "Last Record"
from stocks_prices
group by symbol_id
order by symbol_id



--------------- Calculating cube root
select 
	close_price,
	cbrt(close_price)
from stocks_prices
