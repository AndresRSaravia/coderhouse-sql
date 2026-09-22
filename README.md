# Entrega Coderhouse SQL - Proyecto Capstone - Tienda mayorista de libros

## Contenido del repositorio

- `README.md`: Pasos para ejecutar el código, descripción del problema de negocio, hallazgos principales.
- `estructura.sql`: Scripts de SQL de creación de las tablas de clientes, productos y pedidos e inserción de datos.
- `analisis.sql`: Consultas utilizadas en el análisis.

Orden de ejecución:  `estructura.sql` $\rightarrow$ `analisis.sql`

## Introducción
Somos un analista de datos que trabaja para una incipiente tienda mayorista de libros. Se nos ha asignado la tarea de revisar las ventas entre los meses de junio, julio y agosto de libros de autores hispanos. Entre las consultas, se busca saber:
1. Top 5 clientes por gasto total: Los cinco clientes que más han gastado en la tienda en todo el periodo.
2. Ventas totales por mes: La suma de todas las ventas segmentada por cada mes.
3. Top 3 libros menos vendidos: Los tres libros que menos se hayan vendido.
4. Ranking de pedidos por categoría/género: El ranking de cada género por número de libros pedidos.

## Tablas

Para este análisis, contamos con tres tablas principales: Clientes, productos (libros) y pedidos (compras).
- Cada cliente tiene un ID, un nombre, su fecha de nacimiento y su email.
- Cada producto tiene su ID, su nombre, su descripción, autor, fecha de salida, género y precio en pesos argentinos.
- Cada pedido tiene su ID, la de un cliente y un producto, la cantidad de productos que tiene y la fecha del pedido.

De esto se puede deducir que un cliente puede tener múltiples pedidos, un producto puede estar en múltiples pedidos, y, por diseño de la base de datos, un pedido tiene un único cliente y un único producto, aunque una cantidad variable por pedido.

## Consultas

Cada una de las consultas mencionadas en la introducción tienen por detrás cuatro objetivos

1. Top 5 clientes por gasto total: Saber cuáles son los clientes más valiosos para la tienda.
2. Ventas totales por mes: Conocer el rendimiento de la temporada de invierno.
3. Top 3 libros menos vendidos: Retirar los libros que menos venden del inventario.
4. Ranking de pedidos por categoría/género: Entender qué géneros son tendencia actualmente.

### Top 5 clientes

Para saber el top 5 de clientes, se calcula para cada cliente la suma acumulada de sus gastos en cada pedido (`total_bought`). Para más información contextual de cada uno de estos clientes, se tienen además el total de libros comprados (`q_books`) y la cantidad de pedidos realizados (`q_orders`).

```sql
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
```

Con esto tenemos los cinco clientes más valiosos que durante los meses de junio a agosto han gastado entre 2.2 a 2.7 millones de pesos, siendo Valentina García la persona que más ha invertido en la tienda. Dada la distribución de gasto y las diferencias del orden de 100 a 200 mil pesos entre cada cliente, no hay un jugador fuerte que destaque lo suficiente. Esto nos da la idea de que la clientela es lo suficientemente variada y que el modelo de negocios no depende de un solo comprador.

| ID de cliente | Nombre | Nacimiento | Gasto total | Q de libros | Q de órdenes |
|---:|:-----|:-----------|-------:|--------:|---------:|
| 27 | Valentina Garcia | 1983-11-30 | 2_704_500.00 | 101 | 28 |
| 140 | Santiago Gonzalez | 1996-01-08 | 2_554_500.00 | 89 | 28 |
| 291 | Camila Sanchez | 1991-09-19 | 2_435_500.00 | 90 | 28 |
| 224 | Lucia Martinez | 1972-03-17 | 2_422_500.00 | 91 | 29 |
| 195 | Lucas Martin | 1988-11-24 | 2_294_500.00 | 86 | 26 |

### Ventas totales por mes

En el área de ventas totales, se agrupan los pedidos en periodos de la forma año y mes (`month_period`) y se calcula la suma acumulada en cada uno (`month_sum`).

```sql
-- ventas totales por mes
select
	to_char(o.order_date,'YYYYMM') as month_period,
	sum(coalesce(o.quantity * p.price_ars,0)) as month_sum
from
	orders o inner join products p on o.product_id = p.product_id
group by to_char(o.order_date,'YYYYMM');
```

El número de ventas totales se ha mantenido casi constante con una diferencia entre 1 y 3 millones de pesos mes a mes. Se puede notar una baja en julio con la llegada de las vacaciones de invierno con una recuperación leve en agosto. Queda por ver si los gastos de personal, inventario, logística y alquiler de en cada uno de estos meses compensan y dan ganancias a la tienda.

| Periodo | Ventas totales |
|:---|---:|
| 202608 | 132_809_000.00 |
| 202607 | 131_262_000.00 |
| 202606 | 134_906_000.00 |

### Top 3 libros menos vendidos

Sobre los libros menos vendidos, se considera para cada libro la suma de sus unidades a través de todos los pedidos hechos.

```sql
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
```

Esto nos dan tres libros relacionados a la novela negra, novela histórica y drama histórico para no renovar stock y retirar vía descuentos o liquidaciones.

| ID de producto | Título | Autor/a | Género | Unidades |
|---:|:------|------:|
| 190 | Temporada de huracanes | Fernanda Melchor | Novela negra | 39 |
| 111 | Bomarzo | Manuel Mújica Láinez | Novela histórica | 42 |
| 76 | Fuenteovejuna | Lope de Vega | Drama histórico | 42 |

### Ranking de pedidos por categoría/género

Finalmente, para el ranking de pedidos por género, se considera el número de libros vendidos en cada pedido por el género

```sql
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
```

Considerando apenas el top 10, se puede ver que el género de las novelas históricas triplican el género de cuentos en el puesto dos con diferencia. Existe entonces una oportunidad de negocio de tener más stock y variedad de este género.

| Género | Q de libros | Ranking |
|:---|---:|---:|
| Novela histórica | 1621 | 1 |
| Cuentos | 585 | 2 |
| Realismo mágico | 525 | 3 |
| Ficción contemporánea | 470 | 4 |
| Poesía | 470 | 4 |
| Novela negra | 423 | 6 |
| Novela psicológica | 391 | 7 |
| Novela política | 370 | 8 |
| Realismo | 359 | 9 |
| Ciencia ficción | 343 | 10 |

## Conclusión

Las cuatro consultas reflejan las oportunidades y potenciales de crecimiento y adaptación que puede tener la tienda de libros. A pesar de que sean los tres primeros meses de registros, las finanzas son constantes, la clientela es diversa y se sabe qué libros hay que renovar stock o liquidar.
