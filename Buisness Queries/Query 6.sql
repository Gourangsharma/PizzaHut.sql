#Join the necessary tables to find the total quantity of each pizza category ordered.

select p1.category,sum(o.quantity) quantity
from order_details o join pizzas p
on o.pizza_id=p.pizza_id
join pizza_types p1
on p.pizza_type_id=p1.pizza_type_id
group by p1.category
order by quantity desc;
