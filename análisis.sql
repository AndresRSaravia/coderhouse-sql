-- top 5 clientes (por gasto total)
select
	c.client_id,
	c.name,
	c.birthdate,
	sum(coalesce(o.quantity * p.price_ars,0)) as total_bought,
	sum(coalesce(o.quantity,0)) as q_books,
	count(o.order_id) as q_orders
from
	clients c
	inner join orders o on c.client_id = o.client_id
	inner join products p on o.product_id = p.product_id
group by
	c.client_id,
	c.name
order by total_bought desc
limit 5;
-- ventas totales por mes
select
	to_char(o.order_date,'YYYYMM') as month_period,
	sum(coalesce(o.quantity * p.price_ars,0)) as month_sum
from
	orders o inner join products p on o.product_id = p.product_id
group by to_char(o.order_date,'YYYYMM');
-- tres productos menos vendidos
select
	p.product_id,
	p.product_name,
	p.author,
	p.genre,
	sum(coalesce(o.quantity,0)) as sum_books
from
	orders o inner join
	products p on o.product_id = p.product_id
group by
	p.product_id,
	p.product_name
order by sum_books asc
limit 3;
-- ranking de pedidos por categoría
with
genre_total as (
	select
		p.genre,
		sum(coalesce(o.quantity,0)) as total_books
	from
		orders o inner join products p on o.product_id = p.product_id
	group by p.genre
)
select
	*,
	rank() over (
		order by total_books desc
	) as ranking
from
	genre_total
order by ranking asc;
