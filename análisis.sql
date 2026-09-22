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
	to_char(o.order_date,'YYYYMM'),
	sum(coalesce(o.quantity * p.price_ars,0))
from
	orders o inner join products p on o.product_id = p.product_id
group by to_char(o.order_date,'YYYYMM');
-- tres productos menos vendidos
select
	p.product_id,
	p.product_name,
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
select
	o.order_id,
	o.client_id,
	p.product_id,
	p.genre,
	p.price_ars,
	o.quantity,
	coalesce(o.quantity * p.price_ars,0) as total_sale,
	o.order_date,
	row_() over (
		partition by genre
		order by coalesce(o.quantity * p.price_ars,0) desc
	) as ranking
from
	orders o inner join products p on o.product_id = p.product_id
order by ranking asc;
