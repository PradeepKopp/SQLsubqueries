 /*1- write a query to find premium customers from orders data.
Premium customers are those who have done more orders than 
average no of orders per customer. */


select * from Orders
--Subquery
select customer_id,  count(*) as Total_orders
from Orders
group by customer_id 
having count( distinct order_id) >
(select AVG(No_Orders_customer) as Avg_orders 
 from (select customer_id, count( distinct order_id) as No_Orders_customer
from Orders
group  by customer_id)as Total_orders)
 
--With CTE
 with no_of_orders_each_customer as (
select customer_id,count(distinct order_id) as no_of_orders
from Orders 
group by customer_id)
select COUNT(*) from 
no_of_orders_each_customer where no_of_orders > (select avg(no_of_orders) from no_of_orders_each_customer)


 /*2- write a query to find employees whose salary is more than
average salary of employees in their department */

select * from employee

with a as (select t1.emp_name,t1.salary,t2.Avg_salary
from 
employee t1 inner join 
(select dept_id, AVG(salary) as Avg_salary
from employee
group by dept_id) t2
 on t1.dept_id = t2. dept_id)
select emp_name
from a
where salary > Avg_salary


/*3- write a query to find employees 
whose age is more than average age of all the employees. */
select * from employee

select emp_name
from employee
where emp_age>
(select AVG(emp_age) as avg_age
from employee)

 /*4.write a query to print emp name, salary and 
dep id of highest salaried employee in each department */


select * from employee

 select t1.emp_name, t1.salary,t1.dept_id, t2.high_salary
 from employee t1 inner join 
(select dept_id, MAX(salary) as high_salary
from employee
group by dept_id) t2
 on t1.dept_id =t2. dept_id 
 where t1.salary= t2.high_salary
 order by salary desc


 /*5- write a query to print emp name, salary and dep id of highest salaried overall */

 select * from employee

 select  top 1 emp_name, salary, dept_id
 from employee
 group by emp_name, salary, dept_id
 order by salary desc
 
 /*6- write a query to print product id and
 total sales of highest selling products (by no of units sold) in each category */

 select * from Orders
 select category, product_id, Ttl_qty, Ttl_sales
 from (
 select  top 1 category, product_id, SUM(quantity) as Ttl_qty, SUM(sales) as Ttl_sales
 from Orders
 where category ='Technology'
 group by category, product_id
 order by Ttl_qty desc) as b 
 

 union all
 select category, product_id, Ttl_qty, Ttl_sales
 from (
 select top 1 category, product_id, SUM(quantity) as Ttl_qty, SUM(sales) as Ttl_sales
 from Orders
 where category ='Office Supplies'
 group by category, product_id
 order by Ttl_qty desc) ab
 union all 
select category, product_id, Ttl_qty, Ttl_sales
 from (
 select top 1 category, product_id, SUM(quantity) as Ttl_qty, SUM(sales) as Ttl_sales
 from Orders
 where category ='Furniture'
 group by category, product_id
 order by Ttl_qty desc) abw


 with product_quantity as (
select category,product_id,sum(quantity) as total_quantity
from Orders 
group by category,product_id)
,cat_max_quantity as (
select category,max(total_quantity) as max_quantity from product_quantity 
group by category
)
select *
from product_quantity pq
inner join cat_max_quantity cmq on pq.category=cmq.category
where pq.total_quantity  = cmq.max_quantity