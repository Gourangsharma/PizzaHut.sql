#Analyze the cumulative revenue generated over date.


select order_date, sum(revenue) over (order by order_date) cummulative_revenue
from
(select o.order_date , round(sum(o1.quantity*p.price),2) revenue
from order_details o1 join pizzas p 
on o1.pizza_id = p.pizza_id
join orders o
on o1.order_id=o.order_id
group by o.order_date) as s;
