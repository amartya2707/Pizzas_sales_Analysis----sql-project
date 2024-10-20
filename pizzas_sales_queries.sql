-- 1> Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_order
FROM
    orders;



-- 2> Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(orders_detail.quantity * pizzas.price),
            2) AS total_revenue
FROM
    orders_detail
        JOIN
    pizzas ON pizzas.pizza_id = orders_detail.pizza_id;
    


-- 3> Identify the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price DESC;



-- 4> Identify the most common pizza size ordered.
SELECT 
    pizzas.size,
    COUNT(orders_detail.order_details_id) AS order_count,
    SUM(orders_detail.quantity) AS quantity
FROM
    pizzas
        JOIN
    orders_detail ON pizzas.pizza_id = orders_detail.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

 
 
 -- 5> List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name, SUM(orders_detail.quantity) AS quantity
FROM
    pizzas
        JOIN
    orders_detail ON pizzas.pizza_id = orders_detail.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;



-- 6> Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(orders_detail.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_detail ON pizzas.pizza_id = orders_detail.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;



-- 7> Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time), COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);



-- 8> Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name) AS qunatity
FROM
    pizza_types
GROUP BY category;



-- 9> Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(pizzas_quantity), 0) AS avg_pizzas_ordered_per_day
FROM
    (SELECT 
        orders.order_date,
            SUM(orders_detail.quantity) AS pizzas_quantity
    FROM
        orders
    JOIN orders_detail ON orders.order_id = orders_detail.order_id
    GROUP BY orders.order_date) AS pizzas_quantity_ordered;
    
    
    
-- 10> Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM((pizzas.price) * (orders_detail.quantity)) AS revenue
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    orders_detail ON pizzas.pizza_id = orders_detail.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;



-- 11> Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    round((SUM((pizzas.price) * (orders_detail.quantity)) / (SELECT 
            ROUND(SUM(orders_detail.quantity * pizzas.price),2) AS total_revenue
        FROM
            orders_detail
                JOIN
            pizzas ON pizzas.pizza_id = orders_detail.pizza_id)) * 100,2) AS revenue
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    orders_detail ON pizzas.pizza_id = orders_detail.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;



-- 12> Analyze the cumulative revenue generated over time.
select order_date, sum(revenue) over (order by order_date) as cumm_revenue
from
(select
orders.order_date , sum(pizzas.price * orders_detail.quantity) as revenue
from orders join orders_detail
on orders.order_id = orders_detail.order_id
join pizzas
on pizzas.pizza_id = orders_detail.pizza_id
group by orders.order_date) as sales;



-- 13> Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category , name , revenue
from
(select category , name , revenue,
rank() over (partition by category order by revenue desc) as rn
from
(select
pizza_types.category, pizza_types.name, sum(pizzas.price * orders_detail.quantity) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_detail
on orders_detail.pizza_id = pizzas.pizza_id
group by pizza_types.category , pizza_types.name) as a ) as b
where rn <=3;
