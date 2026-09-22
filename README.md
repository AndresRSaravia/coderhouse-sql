# Entrega Coderhouse SQL - Proyecto Capstone - Tienda mayorista de libros

## Contenido del repositorio

- `README.md`: Pasos para ejecutar el código, descripción del problema de negocio, hallazgos principales.
- `estructura.sql`: Scripts de SQL de creación de las tablas de clientes, productos y pedidos e inserción de datos.
- `analisis.sql`: Consultas utilizadas en el análisis.

Orden de ejecución:  `estructura.sql` $\rightarrow$ `analisis.sql`

## Introducción
Somos un analista de datos para una tienda mayorista de libros. Se nos ha asignado la tarea de revisar las ventas de entre los meses de junio, julio y agosto de libros de autores hispanos. Entre las consultas, se busca saber:
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

Cada una de las consultas tienen por detrás cuatro objetivos

1. Saber cuáles son los clientes más valiosos para la tienda
2. Conocer el rendimiento de la temporada de invierno
3. Retirar los libros que menos venden del inventario
4. Entender qué géneros son tendencia actualmente

Objetivo Simular el flujo de trabajo de un analista de datos: limpiar, analizar e interpretar un dataset real, y documentar los hallazgos como si fueran para un equipo directivo.


## 


3. Análisis: escribir consultas que resuelvan al menos 3 de estos 4 puntos (queries + conclusiones + comentarios + interpretación):
Ranking de pedidos por categoría con RANK() (Window Function).
4. Documentación: el README.md debe explicar el problema de negocio, los hallazgos y cómo correr el código.

El README.md incluye conclusiones interpretadas (no solo descripción del código).
Comentarios que describen qué hace el código (-- selecciono clientes) en lugar de por qué (-- filtramos clientes con más de 3 compras para identificar el segmento leal).
