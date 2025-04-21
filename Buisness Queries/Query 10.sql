#Determine the top 3 most ordered pizza types based on revenue.

with cte as(
select p.pizza_type_id pizza_types, sum(o.quantity*p.price) revenue
from order_details o join pizzas p
on o.pizza_id=p.pizza_id
group by p.pizza_type_id)

select p.name, revenue
from cte c join pizza_types p
on c.pizza_types = p.pizza_type_id
order by revenue desc
limit 3;