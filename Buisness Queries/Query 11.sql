#Calculate the percentage contribution of each pizza type to total revenue.

/*with cte as(
select round(((sum(o.quantity*p.price))/(select (sum(o.quantity*p.price)) total_revenue
from order_details o join pizzas p
on o.pizza_id=p.pizza_id))*100,2) percentage_revenue, p.pizza_type_id pizza_types
from order_details o join pizzas p
on o.pizza_id=p.pizza_id
group by p.pizza_type_id)

select p.name, percentage_revenue
from cte c join pizza_types p
on c.pizza_types = p.pizza_type_id
order by percentage_revenue desc*/

select p1.category, round(((sum(o.quantity*p.price))/(select (sum(o.quantity*p.price)) 
from order_details o join pizzas p
on o.pizza_id=p.pizza_id))*100,2) percentage_revenue
from pizza_types p1 join pizzas p
on p1.pizza_type_id = p.pizza_type_id
join order_details o
on o.pizza_id = p.pizza_id
group by p1.category
order by percentage_revenue desc;
 
