CREATE TABLE projects.swiggy (
    id INT,
    cust_id VARCHAR(20),
    order_id INT,
    partner_code INT,
    outlet VARCHAR(20),
    bill_amount INT,
    order_date DATE,
    Comments VARCHAR(20)
);
 insert into projects.swiggy
 values
(1, "SW1005",700, 50, "KFC", 753 ,"2021-10-10", "Door locked"),
(2, "SW1006",710 ,59, "Pizza hut", 1496, "2021-09-01", "In-time delivery"),
(3, "SW1005",720 ,59,"Dominos", 990 ,"2021-12-10",NULL),
(4, "SW1005",707, 50, "Pizza hut", 2475, "2021-12-11",NULL),
(5,"SW1006",770 ,59,"KFC", 1250 ,"2021-11-17" ,"No response"),
(6, "SW1020",1000 ,119,"Pizza hut", 1400,"2021-11-18","In-time delivery"),
(7, "SW2035",1079, 135 ,"Dominos", 1750,"2021-11-19",NULL),
(8,"SW1020",1083 ,59,"KFC", 1250,"2021-11-20",NULL),
(11,"SW1020",1100 ,150 ,"Pizza hut", 1950, "2021-12-24","Late delivery"),
(9, "SW2035",1095, 119, "Pizza hut", 1270 ,"2021-11-21","Late delivery"),
(10,"SW1005",729, 135, "KFC", 1000, "2021-09-10","Delivered"),
(1, "SW1005",700 ,50, "KFC", 753 ,"2021-10-10","Door locked"),
(2, "SW1006",710 ,59,"Pizza hut" ,1496,"2021-09-01","In-time delivery"),
(3, "SW1005",720 ,59, "Dominos", 990 ,"2021-12-10",NULL),
(4,"SW1005",707 ,50,"Pizza hut", 2475,"2021-12-11",NULL);
 select * from projects.swiggy;
 
#Q1: find the count of duplicate rows in the swiggy table

select *, count(*) as duplicount,
row_number() over(partition by id,cust_id,order_id,partner_code,outlet,bill_amount,order_date,comments order by id desc) as row_num
from projects.swiggy
group by id,cust_id,order_id,partner_code,outlet,bill_amount,order_date,comments
having duplicount>=2;
----------------------------------------------------------------------------------------------------------------------------------------

#Q2: Remove Duplicate records from the table
# create a permenant table projects.nswiggy

create table projects.nswiggy
as
select * from (
select *, 
row_number() over(partition by id,cust_id,order_id,partner_code,outlet,bill_amount,order_date,comments order by id desc) as row_num
from projects.swiggy) as a
where row_num=1;
# delete main table projects.swiggy
drop table projects.swiggy;
#rename new table
rename table projects.nswiggy to projects.swiggy;
select * from projects.swiggy;
-----------------------------------------------------------------------------------------------------------------------
#Q3: Print records from row number 4 to 9
 
 select * from
 (select *, row_number() over( order by id asc) as rownumber
 from projects.swiggy) as a
 where rownumber>=4 and rownumber<=9;
 -------------------------------------------------------------------------
 #Q4: Find the latest order placed by customers.
 with latest_order as
(select cust_id, outlet, order_date,
row_number() over(partition by cust_id order by order_date desc) as latest_ord_dt
from projects.swiggy) select cust_id, outlet, order_date from latest_order where latest_ord_dt = 1;
    
 ---------------------------------------------------------------------
 #Q5: Print order_id, partner_code, order_date, comment (No issues in place of null else comment)
 
select  order_id, partner_code, order_date,ifnull(comments,"No issues") as comments
from projects.swiggy;
#or
    Select order_id, partner_code,order_date,
(case
when comments is null then 'No issues'
else comments end) as comments
from projects.swiggy;
----------------------------------------------------------------------------------
 #Q6: Print outlet wise order count, cumulative order count, total bill_amount, cumulative bill_amount.
 select a.outlet,a.order_count,
 @cumulative order_count:= a.order_count+@cumulative order_count as cumulative_cnt,
 a.total bill_amount,
  @cumulative bill_amount:= @cumulative bill_amount+ a.total bill_amount as cum_sale
 from
 (select outlet,count(order_id) as order_count,sum(bill_amount) as total bill_amount from projects.swiggy
 group by 1) as a
 join
 (select @cumulative order_count:=0,
       @cumulative bill_amount:=0) as b
  order by 1;
 
 -----------------------------------------------------------------------------------------------------------
# Q7: Print cust_id wise, Outlet wise 'total number of orders'
Select cust_id,
sum(if(outlet='KFC',1,0)) KFC,
sum(if(outlet='Dominos',1,0)) Dominos,
sum(if(outlet='Pizza hut',1,0)) Pizza_hut
from projects.swiggy
group by 1;
-----------------------------------------------------------------------------------
#Q8: Print cust_id wise, Outlet wise 'total sales'.
Select cust_id,
sum(if(outlet='KFC',bill_amount,0)) KFC,
sum(if(outlet='Dominos',bill_amount,0)) Dominos,
sum(if(outlet='Pizza hut',bill_amount,0)) Pizza_hut
from projects.swiggy
group by 1;




 








