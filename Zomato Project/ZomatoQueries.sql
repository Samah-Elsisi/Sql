
--what is total amount each customer spent on zomato ?

select customer_id, sum(total_amount) as Total_Amount from orders
group by customer_id
order by customer_id desc

--How many days has each customer visited zomato?

select customer_id , count(distinct order_date) as visit_day from orders
group by customer_id
order by visit_day desc

--what was the first product purchased by each customer?

WITH FirstPurchase AS (
    SELECT customer_id, order_date, order_item, 
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn
    FROM 
        orders
)
SELECT customer_id, order_date AS first_purchased_date, order_item AS first_product
FROM 
    FirstPurchase
WHERE 
    rn = 1

--what is most purchased item on menu & how many times was it purchased by all customers ?

select TOP 1 order_item , count(order_item) as purchas_count from orders
group by order_item
order by purchas_count desc

--which item was most popular for each customer?

SELECT customer_id, order_item, COUNT(order_item) AS purchas_count FROM orders
GROUP BY customer_id, order_item
ORDER BY customer_id, purchas_count DESC

--without repeat---
WITH RankedOrders AS (
    SELECT customer_id, order_item, COUNT(order_item) AS purchas_count,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY COUNT(order_item) DESC) AS rn
    FROM orders
    GROUP BY customer_id, order_item
)
SELECT customer_id, order_item, purchas_count FROM RankedOrders
WHERE rn = 1
ORDER BY customer_id

--which item was purchased first by customer after they become a member ?

select TOP 1 o.customer_id, o.order_item , o.order_date from orders o
join customers c on o.customer_id = c.customer_id
where o.order_date >= c.reg_date
order by o.customer_id , o.order_date

--which item was purchased just before the customer became a member?

select TOP 1 o.customer_id, o.order_item , o.order_date from orders o
join customers c on o.customer_id = c.customer_id
where o.order_date < c.reg_date
order by o.customer_id desc , o.order_date desc

--what is total orders and amount spent for each member before they become a member?

select o.customer_id, count(o.order_id) as total_orders , sum(o.total_amount) as total_amount from orders o
join customers c on o.customer_id = c.customer_id
where o.order_date < c.reg_date
GROUP BY o.customer_id
order by o.customer_id desc 

--In the first year after a customer joins the gold program (including the join date ) irrespective of what customer has purchased earn 5 zomato points for every 10rs spent who earned more more 1 or 3 what int earning in first yr ? 1zp = 2rs

SELECT o.customer_id, SUM(CASE WHEN o.order_date BETWEEN c.reg_date AND DATEADD(year, 1, c.reg_date) THEN o.total_amount / 2 ELSE 0 END) AS first_year_points FROM orders o 
join customers c on o.customer_id = c.customer_id
GROUP BY o.customer_id

--rank all transaction of the customers

SELECT customer_id, order_id, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS transaction_rank FROM orders 
ORDER BY customer_id, transaction_rank

--rank all transaction for each member whenever they are zomato gold member for every non gold member transaction mark as null

SELECT o.customer_id, o.order_id,
    CASE WHEN o.order_date >= c.reg_date THEN RANK() OVER (PARTITION BY o.customer_id ORDER BY o.order_date)
        ELSE Null
    END AS member_transaction_rank
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.customer_id




