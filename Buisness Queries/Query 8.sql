#Join relevant tables to find the category-wise distribution of pizzas.

select category ,count(name) Total_pizzas
from pizza_types
group by category
order by Total_pizzas desc;