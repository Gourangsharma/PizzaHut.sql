#Identify the most common pizza size ordered.

select p.size size, count(o.order_details_id) total_orders
from pizzas p join order_details o
on p.pizza_id = o.pizza_id
group by p.size
order by total_orders desc
limit 1;