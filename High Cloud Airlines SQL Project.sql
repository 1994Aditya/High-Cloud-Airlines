select * from maindata;
show tables;
select count(*) from maindata;
describe maindata;

describe calender;
select * from calender;

drop table calender;

alter table maindata
add column date_column date;

update maindata
set date_column=str_to_date(
concat(year, '-' ,LPAD(month,2,'0'),'-',LPAD(day,2,'0')), '%Y-%m-%d');




/*Q1.calcuate the following fields from the Year	Month (#)	Day  fields ( First Create a Date Field from Year , Month , Day fields)"
--A.Year B.Monthno C.Monthfullname D.Quarter(Q1,Q2,Q3,Q4) E. YearMonth ( YYYY-MMM) F. Weekdayno G.Weekdayname H.FinancialMOnth I. Financial Quarter */

create table calender(
Datekey date,
year int,
month int,
day int,
week int,
monthname varchar(30),
weekday int,
yearmonth varchar(30),
dayname varchar(30),
quarters varchar(30),
financial_month varchar(30),
financial_quarters varchar(30)
);

insert into maindata(date_column)
select concat(YEAR, '-' , MONTH, '-',DAY) as from maindata ;

	insert into calender (Datekey, year, month, day, week, monthname, weekday, yearmonth, dayname, quarters, financial_month, financial_quarters)
	select concat(YEAR, '-' , MONTH, '-',DAY) as Datekey,
	year(Date_column) as YEAR,
	month(Date_column)  as MONTH,
	day(Date_column) as DAY,
	week(Date_column) as WEEK,
	monthname(Date_column) as monthname,
	dayofweek(Date_column) as weekday,
	concat(year(Date_column),'-',monthname(Date_column)) as yearmonth,
	dayname(Date_column) as dayname,

	case when monthname(Date_column) in ('January','February','March') then 'Q1'
	when monthname(Date_column) in('April','May','June') then 'Q2'
	when monthname(Date_column) in ('July','August', 'September') then 'Q3'
	else 'Q4' end as quarters,

	case
	when monthname(Date_column) in ('January' )then 'FM10'
	when monthname(Date_column) = 'February' then 'FM11'
	when monthname(Date_column) ='March' then 'FM12'
	when monthname(Date_column) = 'April' then 'FM1'
	when monthname(Date_column) = 'May' then 'FM2'
	when monthname(Date_column) = 'June 'then 'FM3'
	when monthname(Date_column) = 'July' then 'FM4'
	when monthname(Date_column) = 'August' then 'FM5'
	when monthname(Date_column) = 'September' then 'FM6'
	when monthname(Date_column) = 'October' then 'FM7'
	when monthname(Date_column) = 'November' then 'FM8'
	when monthname(Date_column) = 'December'then 'FM9	'
	end financial_Month,

	case when monthname(Date_column) in ('January','February','March') then 'FQ4'
	when monthname(Date_column) in('April','May','June') then 'fQ1'
	when monthname(Date_column) in ('July','August', 'September') then 'fQ2'
	else 'FQ3' end as financial_quarter
	from maindata;

select * from maindata;
select * from calender;


/*2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)*/
select year(date_column) as year, 
ifnull(concat(round(avg(Transported_Passengers/Available_Seats)*100,2),"%"),0) as Load_factor_percentage 
from maindata
group by Year;

select 
case when monthname(Date_column) in ('January','February','March') then 'Q1'
	when monthname(Date_column) in('April','May','June') then 'Q2'
	when monthname(Date_column) in ('July','August', 'September') then 'Q3'
	else 'Q4' end as quarters,
ifnull(concat(round(avg(Transported_Passengers/Available_Seats)*100,2),"%"),0) as Load_factor_percentage 
from maindata
group by quarters order by quarters ;

select monthname(Date_column) as monthname, 
ifnull(concat(round(avg(Transported_Passengers/Available_Seats)*100,2),"%"),0) as Load_factor_percentage 
from maindata
group by monthname order by Load_factor_percentage;




/* 3. Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)  */
select Carrier_Name,
ifnull(concat(round(avg(Transported_Passengers/Available_Seats)*100,2),"%"),0) as Load_factor_percentage 
from maindata
group by Carrier_Name
order by Load_factor_percentage	desc 
limit 10;


/* 4. Identify Top 10 Carrier Names based passengers preference  */
select Carrier_Name, count(Transported_Passengers) as Total_passangers
from maindata
group by Carrier_Name
order by Total_passangers desc limit 10;


/* 5. Display top Routes ( from-to City) based on Number of Flights */
select From_To_City, sum(Departures_Performed) as Flight_count
from maindata
group by From_To_City
order by Flight_count desc limit 10;


/* 6. Identify the how much load factor is occupied on Weekend vs Weekdays.  */
select 
case
when dayofweek(date_column) in (1,7)
then 'Weekend' else 'Weekday'
end as Day_category,
concat(round(avg(Transported_Passengers/Available_Seats)*100,2),"%") as Load_factor_percentage
from maindata
group by Day_category;


/*7. Identify number of flights based on Distance group */
select distance_interval, count(Airline_ID) as Total_flights
from maindata join distance_group on maindata.Distance_Group_ID=distance_group.distance_group_id
group by distance_interval
order by Total_flights desc;







