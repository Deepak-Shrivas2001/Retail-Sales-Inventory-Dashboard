create database if not exists retail;
use retail;
create table if not exists products
(product_id int primary key auto_increment,
product_name varchar(50) not null,
category varchar(50) not null,
unit_cost decimal(10,2) not null,
unit_price decimal(10,2) not null);
create table store (
store_id int primary key auto_increment,
store_name varchar(50) not null,
region varchar(30) not null,
manager varchar(50) not null);
create table salse(
sale_id int primary key auto_increment,
sale_date date not null,
product_id int not null,
store_id int not null,
quantity_sold int not null,
foreign key (product_id) references products(product_id),
foreign key (store_id) references store(store_id));
INSERT INTO store (store_name, region, manager) VALUES
('Central Tech', 'North', 'Rahul Sharma'),
('Metro Appliances', 'South', 'Priya Patel'),
('Urban Style', 'East', 'Amit Verma'),
('Westside Hub', 'West', 'Neha Gupta');
drop table salse;
drop table store;
drop table products;
INSERT INTO products (product_name, category, unit_cost, unit_price) VALUES
('Laptop', 'Electronics', 40000.00, 55000.00),
('Wireless Mouse', 'Electronics', 400.00, 800.00),
('Desk Chair', 'Furniture', 3000.00, 5500.00),
('Mechanical Keyboard', 'Electronics', 1500.00, 3000.00),
('Coffee Table', 'Furniture', 2000.00, 3800.00);
INSERT INTO sales (sale_date, product_id, store_id, quantity_sold) VALUES
('2026-01-05', 1, 1, 3),
('2026-01-07', 2, 1, 15),
('2026-01-10', 3, 2, 5),
('2026-01-12', 4, 3, 8),
('2026-01-15', 1, 4, 2),
('2026-02-01', 5, 2, 4),
('2026-02-03', 2, 3, 20),
('2026-02-10', 3, 1, 7),
('2026-02-14', 4, 4, 12),
('2026-02-20', 1, 2, 4);
alter table salse
rename to sales;
select 
date_format(sales.sale_date,'%y-%m') as sale_month,
sum(sales.quantity_sold) as Total_uints_sold,
sum(sales.quantity_sold*products.unit_price) as gross_revenue,
sum(sales.quantity_sold*(products.unit_price-products.unit_cost))
 as gross_profit
from sales
inner join products
on sales.product_id = products.product_id
inner join store
on sales.store_id = store.store_id
group by date_format(sales.sale_date,'%y-%m')
order by sale_month asc;
select
store_name,region,
sum(sales.quantity_sold*products.unit_price) as Total_revenue
from store
inner join sales
on store.store_id = sales.store_id
inner join products
on products.product_id = sales.product_id
group by store_name,region
order by sum(sales.quantity_sold*products.unit_price) desc;
select products.
product_id,product_name,category,
coalesce(sum(sales.quantity_sold),0) as total_unit_sold_in_30days
from products
left join sales
on products.product_id = sales.product_id
and sales.sale_date >= current_date - interval 30 day
group by category,product_name,products.product_id
having total_unit_sold_in_30days < 5
order by  total_unit_sold_in_30days asc;












