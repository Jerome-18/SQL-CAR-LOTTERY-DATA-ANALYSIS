

-- CAR LOTTERY DATA ANALYSIS--

use project;
show tables;
--- to show all the data in the table----

select * from car;


--- to show all the car models with year----

SELECT serial_no,brand,model,year from car;



--- to show unique cars in 2018 ---

SELECT distinct brand, model
from car
where year = 2018;




--- to show no.of  brands from every year for sale ---

SELECT brand,year,count(BRAND)
over (partition by year) AS NO_OF_CARS
from car;




---- to show max number of brands in a year for sale ---

SELECT brand,year,count(BRAND)
over (partition by year)
from car;




----- to show most expensive car for sale ----

SELECT BRAND,MODEL,YEAR,
MAX(PRICE)
FROM CAR;



----- to show most expensive car in each year for sale----


SELECT BRAND,MODEL,YEAR,
MAX(PRICE) as expensive
FROM CAR GROUP BY YEAR;



--- NO CARS WILL HAVE PRICE 0,IN 1997 WE CAN SEE THAT CAR WITH PRICE 0 ---

------- to check no. of clean vehicles in a year for sale ----

SELECT title_status,year,count(vin)
from car 
where title_status ='clean vehicle'
group by year;



--- to get the count of vehicles in each brand for sale ---


SELECT brand,count(vin) as no_of_cars
from car
group by brand 
order by no_of_cars ;



--- to get the count of vehicles where the brand is mercedes or harley davidson and the vehicle is clean available for sale---

select brand,count(*)
from car
where brand in( 'mercedes-benz' , 'harley-davidson') 
and title_status = 'clean vehicle'
group by brand;



---- to get the count of vehicles for each color  when the brand is mercedes ---

select color,count(*) as no_of_cars
from car 
where brand = 'mercedes-benz'
group by color;



-- to get the count of vehicles for each year when the car is clean ---

select year, count(*)
from car
where title_status="clean vehicle"
group by year
order by year;



--- to get the count of vehicles in descending order where the vehicle is clean ---

SELECT brand,count(*) as num_of_vehicle
from car
where title_status ='clean vehicle'
group by brand
order by num_of_vehicle desc;




--- top 5 states with max number of cars for sale ---

select state,count(*) as no_of_cars
from car
where country=' usa'
group by state
order by no_of_cars desc
limit 5;



--- country with max number of cars for sale  ---

select country, count(*) as max_cars
from car
order by max_cars desc limit 1;



--- ranking the car brands according to avg price ---


select brand, avg_price, dense_rank() over(order by avg_price desc) as r from
(
select brand, avg(price) as avg_price
from car
group by brand 
) as car_price;



-- select brand & model get average price for each model and rank them within the brand ---

select brand,model,avg_price,dense_rank() over (partition by brand order by avg_price ) as ranking
from (
select brand,model,avg(price)  as avg_price
from car
group by brand,model) as car_price_avg; 



--- ranking the year based on number of cars -- 

select year,no_of_cars,dense_rank() over (order by no_of_cars desc) as ranking from
(
select year,count(lot) as no_of_cars
from car
group by year) as year_by_car;



--- brand with the best mileage ---

select brand,avg(mileage)
from car
group by brand
order by mileage desc limit 1; 



--- state having high price ---

select state, avg(price) as avg_price
from car
group by state
order by avg_price desc limit 1;



--- count the number of cars whose mileage>25000 ---

select brand, count(brand) as car
from car 
where mileage > 250000
group by brand;



--- to get the count of vehicles  for brands who have clean vehicle and the price is 0 ---

select brand,count(brand) as no_of_cars
from car 
where title_status = 'clean vehicle' and price = 0
group by brand;



--- get the count of vehicles of brands who have salvage vehicle and the price is 0 in descending order---

select brand,count(brand) as no_of_cars
from car 
where title_status = 'salvage insurance' and price = 0 
group by brand
order by no_of_cars desc;



---get the count of vehicles for each year  who have salvage vehicle and the price is 0 in descending order ---

select year,count(brand) as no_of_cars
from car 
where title_status = 'salvage insurance' and price = 0 
group by year
order by no_of_cars desc;



--- count of cars for each brand who have the price above average ---

select brand,count(vin) as no_of_cars from  car
where price > (
select avg(price) as price
from car) group by brand;



--- create a column flag & create 4 groups based on minutes,hours, days and listing expired ---

select brand,model,year,
case
when vehiclecondition like"%minutes%" then 'limited'
when vehiclecondition like "%hours%" then 'hours left'
when vehiclecondition like"%days%" then 'days left'
else 'closed'
end as 'vcondition'
from car;



-- the count of vehicle in each category ---

select vcondition,no_of_cars from 
(select count(vin) as no_of_cars,
case
when vehiclecondition like"%minutes%" then 'limited'
when vehiclecondition like "%hours%" then 'hours left'
when vehiclecondition like"%days%" then 'days left'
else 'closed'
end as 'vcondition'
from car
group by vcondition
)as cartable;




--- for each category get the count of vehicles brandwise ---

select brand,vcondition,no_of_cars from 
(select brand,count(vin) as no_of_cars,
case 
when vehiclecondition like"%minutes%" then 'limited'
when vehiclecondition like "%hours%" then 'hours left'
when vehiclecondition like"%days%" then 'days left'
else 'closed'
end as 'vcondition'
from car
group by brand,vcondition
order by brand,vcondition
)
as cartable;




--- rank no. of cars from the previous view & take only rank 1 ---

select brand,vcondition,ranking from
(select brand,vcondition,no_of_cars, 
dense_rank() over(partition by brand order by no_of_cars) as ranking
from 
(select brand,count(vin) as no_of_cars,
case 
when vehiclecondition like"%minutes%" then 'limited'
when vehiclecondition like "%hours%" then 'hours left'
when vehiclecondition like"%days%" then 'days left'
else 'closed'
end as 'vcondition'
from car
group by brand,vcondition
order by brand,vcondition
)as cccc
)as cartable
where ranking=1;



-----------------------X--------------------------X-------------------------X------------------------------------X----------------------X---------------------------------X---------------------
