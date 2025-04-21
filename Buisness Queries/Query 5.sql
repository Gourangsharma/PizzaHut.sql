#List the top 5 most ordered pizza types along with their quantities.

with cte as(
select p.pizza_type_id pizza_types, sum(quantity) quantities
from order_details o join pizzas p
on o.pizza_id=p.pizza_id
group by p.pizza_type_id)

select p.name, quantities
from cte c join pizza_types p
on c.pizza_types = p.pizza_type_id
order by quantities desc
limit 5;