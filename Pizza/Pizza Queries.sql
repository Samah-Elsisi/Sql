----------Basic:

--Retrieve the total number of orders placed.

select Count(order_id) as "Total Orders" from orders

--Calculate the total revenue generated from pizza sales.

select sum(p.price*od.quantity) as "Total Revenue" from order_details od
join pizzas p on p.pizza_id=od.pizza_id

--Identify the highest-priced pizza.

select Top 3 pt.name , max(p.price) as "Highest Price" from pizzas p
join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
group by pt.name
order by "Highest Price" desc

--Identify the most common pizza size ordered.

select top 1 size , count(*) as "Order Count" from order_details od
join pizzas p on p.pizza_id=od.pizza_id
group by size
order by "Order Count" desc

--List the top 5 most ordered pizza types along with their quantities.

select TOP 5 pt. name , sum(od.quantity) as "Total Quantity" from pizzas p
join  order_details od on p.pizza_id=od.pizza_id
join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
group by pt.name
order by "Total Quantity" desc

----------Intermediate:

--Find the total quantity of each pizza category ordered (this will help us to understand the category which customers prefer the most).

select pt. category , sum(od.quantity) as "Total Quantity" from pizzas p
join  order_details od on p.pizza_id=od.pizza_id
join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
group by pt.category
order by "Total Quantity" desc

--Determine the distribution of orders by hour of the day (at which time the orders are maximum (for inventory management and resource allocation).

select DATEPART(HOUR, time) as "Hour Order" , count(*) as "Order Count" from orders 
group by DATEPART(HOUR, time)
order by "Order Count" desc

--Find the category-wise distribution of pizzas (to understand customer behaviour).

select pt. category , count (*) as "Order Count" from pizzas p
join  order_details od on p.pizza_id=od.pizza_id
join pizza_types pt on p.pizza_type_id=pt.pizza_type_id
group by pt.category
order by "Order Count" desc

--Group the orders by date and calculate the average number of pizzas ordered per day.

select TOP 5 o.date , avg(od.quantity) as "Avg Pizza per Day" from orders o
join order_details od on od.order_id=o.order_id
GROUP BY o.date
ORDER BY "Avg Pizza per Day" desc

--Determine the top 3 most ordered pizza types based on revenue (let's see the revenue wise pizza orders to understand from sales perspective which pizza is the best selling)

select TOP 3 pt.name , sum(p.price*od.quantity) as "Total Revenue" from pizzas p
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
join order_details od on od.pizza_id = p.pizza_id
group by pt.name
order by "Total Revenue"

----------Advanced:

--Calculate the percentage contribution of each pizza type to total revenue (to understand % of contribution of each pizza in the total revenue)

select pt.name , sum(p.price*od.quantity)/ 
   (select sum(p.price*od.quantity) from order_details od 
   join pizzas p on p.pizza_id = od.pizza_id) * 100 AS "Revenue Percentage"
from order_details od
join pizzas p on p.pizza_id = od.pizza_id
join pizza_types pt on pt.pizza_type_id=p.pizza_type_id
group by pt.name
order by "Revenue Percentage" desc

--Analyze the cumulative revenue generated over time.

select o.date , ROUND(sum(p.price*od.quantity),0) as "Daily Revenue" ,
                sum(ROUND(sum(p.price*od.quantity),0)) over (order by o.date) as "Cumulative Revenue"
from orders o
join order_details od on od.order_id=o.order_id
join pizzas p on p.pizza_id = od.pizza_id
group by o.date
order by  o.date desc

--Determine the top 3 most ordered pizza types based on revenue for each pizza category (In each category which pizza is the most selling)

select TOP 3 pt.category , pt. name ,  sum(p.price*od.quantity) as "Total Revenue" from order_details od
join pizzas p on p.pizza_id = od.pizza_id
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
group by pt.name , pt.category
order by "Total Revenue" desc
