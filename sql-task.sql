-- Create a new database
CREATE DATABASE ecommerce;

-- Use the ecommerce database
USE ecommerce;

-- Create customers table
create table customers (
 id int auto_increment primary key,
 name varchar(100) not null,
 email varchar(100) unique not null,
 address varchar(250)
);

-- insert data customers
insert into customers (name, email, address) values 
('Suriya','suriya@gmail.com','No.10 Kuniamuthur coimbatore'),
('Mohamad Safik','safik@gmail.com','No.8 Sugunapuram coimbatore'),
('Suresh Kumar','suresh@gmail.com','No.12 Ekkattuthagal chennai');

-- create products table 
create table products(
id int auto_increment primary key,
title varchar(100) not null,
price decimal(10,2) not null,
description text
);

-- insert data product
insert into products (title, price, description) values 
('Product A', 150.00, 'High-quality product A'),
('Product B', 130.00, 'Affordable product B'),
('Product C', 160.00, 'Popular product C'),
('Product D', 200.00, 'Primium product D');

-- create orders table
create table orders (
    id int auto_increment primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    foreign key (customer_id) references customers(id)
);

-- insert data orders
insert into orders (customer_id, order_date, total_amount) values
(1, curdate() - interval 10 day, 130.00),
(2, curdate() - interval 5 day, 200.00),
(1, curdate() - interval 40 day, 150.00),
(3, curdate() - interval 10 day, 300.00),
(2, curdate() - interval 5 day, 500.00),
(3, curdate() - interval 40 day, 350.00);

-- Queries
-- 1. Retrieve all customers who have placed an order in the last 30 days
select distinct c.name, c.email 
from customers c join orders o on c.id = o.customer_id 
where o.order_date >= CURDATE() - interval 30 day;

-- 2. Get the total amount of all orders placed by each customer
select c.name, SUM(o.total_amount) as total_spent
from customers c
join orders o on c.id = o.customer_id
group by c.id;

-- 3. Update the price of Product C to 45.00
update products set price = 45.00 where id = 3;

-- 4. Add a new column discount to the products table
alter table products add column discount decimal(5,2) default 0.00;

-- 5. Retrieve the top 3 products with the highest price
select title, price from products order by price desc limit 3;

-- Create Order Items Table
create table order_items (
    id int auto_increment primary key,
    order_id int,
    product_id int,
    quantity int default 1,
    foreign key (order_id) references orders(id),
    foreign key (product_id) references products(id)
);

-- Sample Order Items Data (mapping orders to products)
insert into order_items (order_id, product_id, quantity) values
(1, 1, 2),  -- Order 1 has 2x Product A
(1, 2, 1),  -- Order 1 has 1x Product B
(2, 3, 1),  -- Order 2 has 1x Product C
(3, 4, 1);  -- Order 3 has 1x Product D

-- Now Query: Get the names of customers who have ordered Product A
select distinct c.name
from customers c
join orders o on c.id = o.customer_id
join order_items oi on o.id = oi.order_id
join products p on oi.product_id = p.id
where p.title = 'Product A';

-- 7. Join orders and customers tables to retrieve the customer's name and order date for each order
select c.name as customer_name, o.order_date, o.total_amount
from orders o
join customers c on o.customer_id = c.id;

-- 8. Retrieve the orders with a total amount greater than 150.00
select *
from orders
where total_amount > 150.00;

-- 9. Retrieve the average total of all orders
select avg(total_amount) as avg_order_total
from orders;

select * from order_items
