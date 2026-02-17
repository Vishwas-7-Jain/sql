
--1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
with city_spend as
(select city, sum(amount) as spend from cc_transactions
group by city),
total_spend as 
(select sum(amount) as total_cc_spend from cc_transactions)
select top 5 city_spend.city, spend, cast(round((spend*100.00/total_cc_spend),2) as decimal (10,2)) as contribution_percentage 
from city_spend
inner join total_spend on 1=1
order by spend desc;

--2- write a query to print highest spend month and amount spent in that month for each card type
with cte as
(select card_type, datepart(year,transaction_date)as spend_year, datepart(month,transaction_date) as spend_month, sum(amount) as max_spend from cc_transactions 
group by card_type, datepart(year,transaction_date), datepart(month,transaction_date)),
rn as 
(select *, rank() over (partition by card_type order by max_spend desc) as rn from cte)
select * from rn
where rn=1;

--3- write a query to print the transaction details(all columns from the table) for each card type when it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
with cte as 
(select * , sum(amount) over(partition by card_type order by transaction_date,transaction_id) as cum_spend from cc_transactions),
cte1 as
(select *, rank() over (partition by card_type order by cum_spend) as rn from cte where cum_spend>=1000000) 
select * from cte1 where rn=1;

--4- write a query to find city which had lowest percentage spend for gold card type
--a
with cte as 
(select city, card_type, sum(amount) as spend from cc_transactions
group by city, card_type),
cte1 as
(select city, sum(spend) as total_city_spend from cte
group by city),
cte2 as
(select a.city,a.card_type,a.spend,b.total_city_spend from cte a
left join cte1 b on a.city=b.city),
cte3 as
(select *, cast((spend*1.0/total_city_spend) as decimal (10,5)) as per_spend from cte2
where card_type='gold')
select city,per_spend from (select *, rank() over (order by per_spend asc) as rn from cte3) t
where rn=1;

--b
SELECT TOP 1
       city,
       SUM(CASE WHEN card_type = 'Gold' THEN amount ELSE 0 END) * 1.0
       / SUM(amount) AS gold_ratio
FROM cc_transactions
GROUP BY city
HAVING SUM(CASE WHEN card_type = 'Gold' THEN amount ELSE 0 END) > 0
ORDER BY gold_ratio ASC;

--5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
with cte as 
(select *, rank() over (partition by city order by city_spend desc) as drn, rank() over (partition by city order by city_spend asc) as arn from (select city, exp_type, sum(amount) as city_spend from cc_transactions
group by city, exp_type) t )
select city, max(case when drn=1 then exp_type end) as highest_expense_type, max(case when arn=1 then exp_type end) as lowest_expense_type from cte
group by city;

--6- write a query to find percentage contribution of spends by females for each expense type
--a
with cte as(
select exp_type, sum(amount) as total_spend from cc_transactions
group by exp_type),
cte1 as 
(select exp_type, gender, sum(amount) as spend from cc_transactions
group by exp_type, gender)
select b.exp_type, b.gender, spend*1.0/total_spend as per_f_cont from cte a
inner join cte1 b on a.exp_type=b.exp_type
where gender='F';
--b
select exp_type,
sum(case when gender='F' then amount else 0 end)*1.0/sum(amount) as percentage_female_contribution
from cc_transactions
group by exp_type
order by percentage_female_contribution desc;

--7- which card and expense type combination saw highest month over month growth in Jan-2014
select * from cc_transactions
with cte as (
select card_type, exp_type, datepart(year,transaction_date) as s_year, datepart(month,transaction_date) as s_month, sum(amount) as total_spend from cc_transactions
group by card_type, exp_type, datepart(year,transaction_date), datepart(month,transaction_date))
select top 1 *, (total_spend-prev_month_spend) as mom_growth from 
(select *, lag(total_spend,1) over (partition by card_type,exp_type order by s_year, s_month) as prev_month_spend from cte)t
where prev_month_spend is not null and s_year ='2014' and s_month='1'
order by mom_growth desc;

--8- during weekends which city has highest total spend to total no of transcations ratio 
select top 1 city, sum(amount)*1.0/count(transaction_id) as ratio
from cc_transactions
where datepart(weekday, transaction_date) in (1,7)
group by city
order by ratio desc;

--9- which city took least number of days to reach its 500th transaction after the first transaction in that city
select * from cc_transactions
with cte as 
(select *, ROW_NUMBER() over (partition by city order by transaction_date,transaction_id) as tran_num from cc_transactions)
select top 1 city, DATEDIFF(day,min(transaction_date),max(transaction_date)) as days_taken from cte
where tran_num=1 or tran_num=500
group by city
having count(1)=2
order by days_taken;




