

select *
from DailyData D inner join Transactions t on t.PlayerID = d.PlayerID inner join Prices Pr on t.PriceID = pr.PriceID and d.Date = t.Date

--Revenue and Transactions per player each day

select d.PlayerID , d.Date ,sum(cast(p.pricevalue as integer))  as Revenue , count(d.playerID) as Transactions
from DailyData D right join Transactions T on D.PlayerID = T.PlayerID inner join Prices p on p.PriceID = t.PriceID inner join Players Pl on pl.PlayerID = t.PlayerID and d.Date = t.Date
where pl.IsSpender = 'Yes'
group by D.PlayerID , d.Date
order by 1,2


-- creating New Data

SELECT s.PlayerID , s.Date , s.TimeOnApp , s.Games , sub.Revenue , sub.Transactions 
into DailyDataNew10
FROM DailyData s left join (select d.PlayerID , d.Date , sum(cast(p.pricevalue as integer))  as Revenue , count(d.playerID) as Transactions
from DailyData D right join Transactions T on D.PlayerID = T.PlayerID inner join Prices p on p.PriceID = t.PriceID inner join Players Pl on pl.PlayerID = t.PlayerID and d.Date = t.Date
group by D.PlayerID, d.Date) as sub on sub.PlayerID = s.PlayerID and sub.Date = s.Date;


--Total Revenue and Transactions per player

select PlayerID , sum(Revenue) as New_Revenue , sum(Transactions) as Total_Transactions
from DailyDataNew4
group by PlayerID
order by 1 , 2

-- יצירת טבלה עם המשתנים הרלוונטים של השחקנים
Select p.PlayerID ,p.Platform , p.InstallDate , p.Country , p.LoginType , (p.LifeTimeRevenue + New_Revenue) as LTRevenueNew  , D2.minOrderDate , d2.MaxOrderDate , da.isSpenderNew , da.Seniority
into PlayersNew17
from Players P inner join 
(select d.PlayerID , sum(d.Revenue) as New_Revenue , min(d.Date) as MinOrderDate , max(d.Date) as MaxOrderDate 
from DailyDataNew d
group by d.PlayerID) as s on p.PlayerID = s.PlayerID
left join (select d1.PlayerID , min(d1.date) as minOrderDate , max(d1.date) as MaxOrderDate
from DailyDataNew d1
where d1.date > '2020-11-26' and d1.Revenue > 0
group by d1.PlayerID) as D2 on d2.PlayerID = p.PlayerID
inner join DailyDataNew9 Da on da.PlayerID = p.PlayerID

--Including IsSpenderNew and Seniority for mix with tables

select t.Playerid , t.isSpenderNew , t.Seniority
into DailyDataNew9
from NewTable t inner join DailyDataNew7  d on t.PlayerId = d.PlayerID



select *,CASE WHEN p2.LTRevenueNew > 0 THEN 'Yes'
		else 'No' end as IsSpenderNew ,
		Case When DATEDIFF(DAY, p2.InstallDate,getDate()) < 365 then '0-1'
		when DATEDIFF(DAY, p2.InstallDate,getDate()) < 1095 then '2-3'
		else '3+' end as Seniority
from PlayersNew p2 left join Players pl on p2.PlayerID = pl.PlayerID

select d1.PlayerID , min(d1.date) as minOrderDate , max(d1.date) as MaxOrderDate
from DailyDataNew d1
where d1.date > '2020-11-26' and d1.Revenue > 0 and d1.PlayerID = 9973
group by d1.PlayerID

--Creating new table that includes ALL of the information

select p.PlayerID , p.Country , p.LoginType , p.InstallDate , p.LTRevenueNew , p.MaxOrderDate , p.minOrderDate , d.Date , d.Games , d.TimeOnApp , p.platform , p.seniority , p.isSpenderNew , d.Revenue , d.Transactions,
	CASE WHEN d.Date = p.minOrderDate then '1'
	else '0' end as FTD
into DailyDataAll10
from PlayersNew17 p inner join DailyDataNew d on p.PlayerID = d.PlayerID
 --Delete Multiply Columns and create into a new data organized

select distinct*
into DailyDataAll11
from DailyDataAll10

--Query the data to manipulate in EXCEL
select d.Date , d.Country , d.LoginType , d.Platform , cast(d.seniority as nvarchar) as Seniority , count(d.PlayerID) as DailyPlayers , count(d.transactions) as PayingPlayers , sum(cast(d.FTD as int)) as FirstPurchase ,  sum(d.Revenue) as DailyRevenue , sum(cast(d.Transactions as int)) as DailyTransactions  , sum(cast(d.TimeOnApp as float)) as DailyTimePlay  , sum(cast(d.Games as int)) as DailyGames
from DailyDataAll11 d
group by  d.Date , d.Country , d.LoginType , d.Platform , d.seniority 

