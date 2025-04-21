#Determine the top 3 most ordered pizza types based on revenue for each pizza category.

with cte as
(select category ,name ,revenue, rank() over (partition by category order by revenue desc) as rn
from
(select p1.category,p1.name,round(sum(o.quantity*p.price),2) revenue
from pizza_types p1 join pizzas p
on p1.pizza_type_id = p.pizza_type_id
join order_details o 
on o.pizza_id=p.pizza_id
group by p1.category,p1.name) as s)

select category,name,revenue
from cte
where rn<=3;
