
-- Q1) List all the states in which we have customers who have bought cellphones 
-- from 2005 till today.

-- Soln:

SELECT
*
FROM
DIM_CUSTOMER, DIM_DATE, DIM_LOCATION, DIM_MANUFACTURER, DIM_MODEL, FACT_TRANSACTIONS;

SELECT
STATE
FROM
DIM_LOCATION A
JOIN
FACT_TRANSACTIONS B
ON
A.IDLocation= B.IDLocation
WHERE
DATE BETWEEN 
(SELECT
MIN(DATE) AS MIN_DATE
FROM
FACT_TRANSACTIONS
WHERE
YEAR(DATE) = 2005)

AND GETDATE();


-- Q2) What state in the US is buying the most 'Samsung' cell phones? 

-- Soln:

SELECT
TOP 1 STATE , COUNT(*) NO_USERS
FROM
DIM_MODEL A 
JOIN
FACT_TRANSACTIONS B
ON
A.IDModel= B.IDModel
JOIN
DIM_MANUFACTURER C
ON
C.IDManufacturer = A.IDManufacturer
JOIN
DIM_LOCATION D
ON
D.IDLocation= B.IDLocation
WHERE
Manufacturer_Name = 'SAMSUNG' AND Country = 'US'
GROUP BY
STATE
ORDER BY
NO_USERS DESC;


-- Q3) Show the number of transactions for each model per zip code per state.

-- Soln:

SELECT
State, ZipCode, IDModel, COUNT(*) NO_OF_TRANS
FROM
FACT_TRANSACTIONS A
INNER JOIN
DIM_LOCATION B
ON
A.IDLocation= B.IDLocation
GROUP BY
State, ZipCode, IDModel


-- Q4) Show the cheapest cellphone (Output should contain the price also)
-- Soln:

SELECT
TOP 1 MODEL_NAME, MIN(UNIT_PRICE) MIN_PRICE
FROM
DIM_MODEL
GROUP BY
MODEL_NAME
ORDER BY
MIN_PRICE ;


-- Q5) Find out the average price for each model in the top5 manufacturers in 
-- terms of sales quantity and order by average price.

-- Soln:

select
Manufacturer_Name, model_name, avg(unit_price) avg_pri
FROM
DIM_MODEL A
JOIN
FACT_TRANSACTIONS B
ON
A.IDModel = B.IDModel
JOIN
DIM_MANUFACTURER C
ON
A.IDManufacturer= C.IDManufacturer
where
Manufacturer_Name in 
(select
Manufacturer_Name
from
(SELECT
Manufacturer_Name  ,  dense_rank() over (order by SUM(QUANTITY) desc) rk
FROM
DIM_MODEL A
JOIN
FACT_TRANSACTIONS B
ON
A.IDModel = B.IDModel
JOIN
DIM_MANUFACTURER C
ON
A.IDManufacturer= C.IDManufacturer
GROUP BY
Manufacturer_Name) as aa
where
rk<=5)

group by
Manufacturer_Name, model_name
order by
Manufacturer_Name


-- Q6) List the names of the customers and the average amount spent in 2009, 
-- where the average is higher than 500

-- Soln:

select
Customer_Name, avg(TotalPrice) avg_pri
from
DIM_CUSTOMER a
inner join
FACT_TRANSACTIONS b
on
a.IDCustomer= b.IDCustomer
where
year(date) = 2009
group by
Customer_Name
having
avg(TotalPrice) > 500


-- Q7) List if there is any model that was in the top 5 in terms of quantity, 
-- simultaneously in 2008, 2009 and 2010 

-- Soln:

with cte1 as
(select
Model_Name, dense_rank() over (order by sum(quantity) desc) rk
from
DIM_MODEL a
inner join
FACT_TRANSACTIONS b
on
a.IDModel= b.IDModel
where
year(date) in (2009, 2008, 2010)
group by
Model_Name)

select
model_name
from
cte1
where
rk<=5

-- Q8) Show the manufacturer with the 2nd top sales in the year of 2009 and the 
-- manufacturer with the 2nd top sales in the year of 2010. 

-- Soln:

(select
*
from
(select
manufacturer_name, year(date) as y, dense_rank() over (order by sum(totalprice) desc) rk
from
DIM_MODEL A
JOIN
FACT_TRANSACTIONS B
ON
A.IDModel = B.IDModel
JOIN
DIM_MANUFACTURER C
ON
A.IDManufacturer= C.IDManufacturer
where
year(date) = 2009
group by
manufacturer_name,  year(date)) a
where
rk= 2)

union all

(select
*
from
(select
manufacturer_name, year(date) as y, dense_rank() over (order by sum(totalprice) desc) rk
from
DIM_MODEL A
JOIN
FACT_TRANSACTIONS B
ON
A.IDModel = B.IDModel
JOIN
DIM_MANUFACTURER C
ON
A.IDManufacturer= C.IDManufacturer
where
year(date) = 2010
group by
manufacturer_name,  year(date)) a
where
rk= 2)

-- Q9) Show the manufacturers that sold cellphones in 2010 but did not in 2009.

-- Soln:

select
Manufacturer_Name
from
FACT_TRANSACTIONS a
inner join
DIM_MODEL b
on
a.IDModel = b.IDModel
inner join
DIM_MANUFACTURER c
on
c.IDManufacturer = b.IDManufacturer
where
year(date) = 2010 and not year(date) = 2009

-- Q10) Find top 100 customers and their average spend, average quantity by each 
-- year. Also find the percentage of change in their spend. 

-- Soln:

select
top 100 Customer_Name , year(date) yy,  avg(totalprice) avg_tot, avg(quantity) avg_qty
from
DIM_CUSTOMER a
inner join
FACT_TRANSACTIONS b
on
a.IDCustomer = b.IDCustomer
group by
Customer_Name, year(date)
order by
Customer_Name


select
*
from
FACT_TRANSACTIONS





