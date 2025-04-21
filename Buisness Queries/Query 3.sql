#Identify the highest-priced pizza.

select p.name Highest_priced_pizza,p1.price
from pizza_types p join pizzas p1
on p.pizza_type_id=p1.pizza_type_id
/*where price>=(select max(price)
from pizzas) ;*/
order by p1.price desc
limit 1;