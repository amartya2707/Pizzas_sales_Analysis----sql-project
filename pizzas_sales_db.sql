create database Pizza_Sales_Analysis;

CREATE TABLE orders(
	order_id INT,
	order_date DATE,
	order_time TIME
);

CREATE TABLE orders_detail (
    order_details_id INT,
    order_id INT,
    pizza_id text,
    quantity INT
);

CREATE TABLE pizza_types (
    pizza_type_id text,
    name text,
    category text,
    ingredients text
);

CREATE TABLE pizzas (
    pizza_id text,
    pizza_type_id text,
    size text,
    price double
);