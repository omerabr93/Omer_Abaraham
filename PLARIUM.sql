--Amount of players by state , Spend and income = revenue

select s.Country , sum(s.regs) as Amount_of_players , sum(s.spend) as Total_Spend , sum(s.deposit_amount_d30) as Total_income , sum(s.Deposit_Amount_D30 -s.spend ) as revenue 
from ['data set$'] s
group by s.Country


select *
from ['data set$'] s

--spend and income per player for month and country


select s.Country ,month(s.date) as Months, sum(s.regs) as Amount_of_players , sum(s.spend) as Total_Spend , sum(s.Deposit_Amount_D30) as Total_income , sum(s.Deposit_Amount_D0 -s.spend ) as revenue , 
sum(s.spend) / sum(s.regs) as avg_Spend_per_player , sum(s.deposit_amount_d30) / sum(s.regs) as avg_income_per_player 
from ['data set$'] s
group by s.Country , month(s.date)
order by 2


--amount of registered and precntage of staying in the game

select s.Country , sum(s.regs) as Registered , sum(s.complete_tutorial) as Tutorials_complete, sum(s.ret_day1) as ReturnedFirstTime,  sum(s.Ret_Day7) as WeekPlayTime ,
sum(s.ret_day7) / sum(s.regs) as OneWeekStayPrecentage
from ['data set$'] s 
group by s.Country


-- amounth of income and spend by country and month


select s.Country , month(s.date) as MonthOfPlay ,sum(s.Deposit_Amount_D10) as Tendaysincome ,sum(s.deposit_amount_d30) as Total_income , sum(s.spend) as Total_Spend ,
sum(s.deposit_amount_d10) / sum(s.deposit_amount_d30) as TenDaysPrentage
from ['data set$'] s 
group by s.Country , month(s.date)
order by 2


-- spend and income per affiliate per month

select s.Affiliate ,  month(s.date) as MonthOfPlay ,sum(s.Deposit_Amount_D10) as Tendaysincome ,sum(s.deposit_amount_d30) as Total_income , sum(s.spend) as Total_Spend ,
sum(s.Deposit_Amount_D30) / sum(s.Spend) as Income_Precentage
from ['data set$'] s
group by s.Affiliate , month(s.date)
order by 1 , 2

--avg income per month and country 
select month(s.date) as Months , s.Country , sum(s.spend) as Total_spend , sum(s.Deposit_amount_d30) as Total_income , sum(s.Deposit_amount_d30) / sum(s.spend) as Income_Precentage 
from ['data set$'] s
group by s.Country , month(s.date)
order by 1

--avg income per month and country at the last 2 months 

select  month(s1.date) , s1.Country,sum(s1.deposit_amount_d30) / sum(s1.spend) as Last_two_Months_income_precentage
from ['data set$'] s1
group by month(s1.date) , s1.Country
having month(s1.date) > 4


--Deposits and depositors per country and month

select month(s.date) as Months , s.country , sum(s.Depositors_D0) as Depositors0  ,sum(s.Depositors_D1) as Depositors01 , sum(s.Depositors_D7) as DepositorsD7 , sum(s.Depositors_D10) as Depositors10 , sum(s.Depositors_D30) as Depositors30,
 sum(s.Deposits_D0) as Deposits0  ,sum(s.Deposits_D1) as Deposits1 , sum(s.Deposits_D7) as Deposits7 , sum(s.Deposits_D10) as Deposits10 , sum(s.Deposits_D30) as Deposits30
from ['data set$'] s 
group by month(s.date) ,  s.Country
order by 2

--Devide by months and country , for avg spend and income per players ,

select month(s.date) as months , s.country , sum(s.deposit_amount_d30) as Total_Income, sum(s.spend) as Total_spend , sum(s.deposits_d30) as Total_deposits , sum(s.depositors_d30) as Total_depositors , sum(s.Deposit_Amount_D30) / sum(s.deposits_d30) as avg_income_per_deposit ,  sum(s.Deposits_D30) / sum(s.depositors_d30) as avg_deposit,
sum(s.spend) / sum(s.regs) as avg_spend
from ['data set$'] s
group by  month(s.date) , s.country
order by 1