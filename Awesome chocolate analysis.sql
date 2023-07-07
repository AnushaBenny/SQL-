# Select everything from sales table
select * from sales;

#Show just a few columns from sales table
select SaleDate, Boxes, Customers from sales;

#Adding a calculated column with SQL
Select SaleDate, Amount, Boxes, Amount / boxes  from sales;

#Naming a field with AS in SQL
Select SaleDate, Amount, Boxes, Amount / boxes as amount_per_box from sales;
# using where clause in sql
select * from sales where amount>1000;
#Showing sales data where amount is greater than 10,000 by descending order
select * from sales where amount>10000
order by amount desc;
#Showing sales data where geography is g1 by product ID & descending order of amounts
 select * from sales where geoid="g1"
 order by pid, amount desc;
 ------------------------------------------------------------------------------------
#Working with dates in SQL

Select * from sales
where amount > 10000 and SaleDate >= "2022-01-01";

#Using year() function to select all data in a specific year
select * from sales 
where year(saledate)="2022";

# BETWEEN condition in SQL with < & > operators

select * from sales 
where amount<10000 and amount>5000;

#Using the between operator in SQL
select * from sales 
where boxes between 100 and 500;

#Using weekday() function in SQL
select SaleDate, Amount, Boxes,weekday(saledate) as "Day of week"
from sales
where weekday(saledate)=4;
-----------------------------------------------------------------
#Working with People table

select * from people;

#OR operator in SQL
select * from people 
where team ='yummies' or 'Delish';

#IN operator in SQL

select * from people
where team in ('Delish','Jucies');

#LIKE operator in SQL
select * from people where salesperson like "b%";

select * from sales;
#Using CASE to create branching logic in SQL

select amount,customers,
(
case
when amount<1000 then "under 1k"
when amount<5000 then "under 5k"
when amount<10000 then "under 10k"
else "10k or more"
end) as Amount_category
from sales;

#GROUP BY in SQL
select team, count(*) from people
group by team;
------------------------------------------------------
-- Select everything from sales table
select * from sales;
select * from products;
select * from people;
select * from geo;

#1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * from sales 
where amount>2000 and boxes<100;

#2. How many shipments (sales) each of the sales persons had in the month of January 2022?

select b.salesperson, count(*) as ship_count
from sales a join people b
on a.SPID=b.SPID
where saledate between "2022-1-1" and "2022-1-31"
group by 1;

#3. Which product sells more boxes? Milk Bars or Eclairs?
select b.product ,sum(a.boxes) from 
sales a join products b
on a.pid=b.pid
where product in ("milk bars","eclairs")
group by 1
order by 2 desc;

#4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
select b.product,sum(a.boxes) as total 
from sales as a join products as b
on a.pid=b.pid
where product in ("Milk bars","eclairs") and saledate between "2022-02-01" and "2022-02-07"
group by 1;

#5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
select spid,dayname(saledate) from sales
where customers<100 and boxes<100;

#HARD PROBLEMS
# These require concepts not covered in the video
select * from sales;
select * from products;
select * from people;
select * from geo;

#1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
select distinct a.salesperson
from people as a join sales as b
on a.spid=b.spid
where b.saledate between "2022-01-01" and "2022-01-07";

#2. Which salespersons did not make any shipments in the first 7 days of January 2022?
select salesperson from people where salesperson not in (select distinct a.salesperson
from people as a join sales as b
on a.spid=b.spid
where b.saledate between "2022-01-01" and "2022-01-07");

#3. How many times we shipped more than 1,000 boxes in each month?
select  year(saledate) as "year",monthname(saledate) as "month",count(*) from sales
where boxes>1000
group by 2,1
order by 2,1;

#4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
select c.product,b.geo,monthname(a.saledate) as "month",year(a.saledate) as "year",a.boxes
from sales as a join geo as b on a.geoid=b.geoid
                 join products as c on a.pid=c.pid
where c.product="After Nines" and b.geo="new zealand"
order by year asc;

