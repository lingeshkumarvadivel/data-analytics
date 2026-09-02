use ride_booking_db;

select * from customers;

select * from drivers where status = 'Active';

SELECT  * FROM DRIVERS WHERE CITY = 'Chennai';

select driver_id as 'Driver ID' , count(*) AS 'Rides Competed' from rides group by driver_id;

select driver_id as 'Driver ID' , count(*) AS 'Rides Competed' from rides group by driver_id having count(*) > 4;

select sum(fare_amount) as 'Total Revenue' from rides where ride_status = 'Completed' ;

select driver_id as 'Driver ID' , sum(fare_amount) as 'Total Revenue' from rides where ride_status = 'Completed' group by driver_id;

select driver_id as 'Driver ID' , sum(fare_amount) as 'Total Revenue' from rides where ride_status = 'Completed' group by driver_id ORDER BY `Total Revenue` desc LIMIT 10;

select * from rides;

select customer_id,count(*) as 'Ride Count' from rides group by customer_id having count(*) > 3;

select * from rides;

select customer_id,sum(fare_amount) as 'Amount Spent' from rides group by customer_id order by `Amount Spent` desc;

select customer_id,sum(fare_amount) as 'Amount Spent' from rides group by customer_id order by `Amount Spent` desc limit 1;

select v.vehicle_type as 'Vehicle Type' ,avg(r.fare_amount)  as 'Average Amount' from rides  as r
join vehicles as v
on v.vehicle_id = r.vehicle_id group by v.vehicle_type;

select v.vehicle_type as 'Vehicle Type' ,count(*)  as 'Used Count' from rides  as r
join vehicles as v
on v.vehicle_id = r.vehicle_id group by v.vehicle_type limit 1;


SELECT DATE(booking_time) AS ride_date, DATE_FORMAT(booking_time, '%Y-%m') AS ride_month, COUNT(ride_id) AS completed_rides, SUM(fare_amount) AS revenue FROM rides
WHERE ride_status = 'Completed' GROUP BY DATE(booking_time), DATE_FORMAT(booking_time, '%Y-%m') ORDER BY ride_date;

SELECT YEAR(booking_time) AS ride_year,MONTH(booking_time) AS ride_month_number,MONTHNAME(booking_time) AS ride_month_name,COUNT(ride_id) AS completed_rides,SUM(fare_amount) AS monthly_revenue
FROM rides WHERE ride_status = 'Completed' GROUP BY YEAR(booking_time), MONTH(booking_time), MONTHNAME(booking_time) ORDER BY ride_year, ride_month_number;


select * from rides;
select * from vehicles;

select v.vehicle_type as 'Vehicle Type',round(avg(r.distance_km),2) as 'Average distance travelled' from rides as r
join vehicles as v
on r.vehicle_id = v.vehicle_id group by v.vehicle_type;

select * from ratings;

select driver_id as 'Driver ID' , avg(customer_rating) AS 'Average Rating' from ratings group by driver_id having avg(customer_rating) > 4.5 ;

select * from rides;
select * from vehicles;

WITH driver_revenue AS (
    SELECT d.driver_id, d.driver_name, v.vehicle_type, SUM(r.fare_amount) AS total_revenue FROM drivers d
    JOIN vehicles v
        ON d.driver_id = v.driver_id
    JOIN rides r
        ON d.driver_id = r.driver_id
       AND v.vehicle_id = r.vehicle_id
    WHERE r.ride_status = 'Completed'
    GROUP BY d.driver_id,d.driver_name, v.vehicle_type )
SELECT driver_id, driver_name, vehicle_type, total_revenue,
    RANK() OVER ( PARTITION BY vehicle_type  ORDER BY total_revenue DESC) AS revenue_rank
FROM driver_revenue ORDER BY vehicle_type, revenue_rank;


SELECT c.customer_id,c.customer_name, MIN(r.booking_time) AS first_booking, MAX(r.booking_time) AS latest_booking FROM customers c
LEFT JOIN rides r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.customer_name ORDER BY c.customer_id;


SELECT d.driver_id, d.driver_name, COUNT(r.ride_id) AS total_bookings,
    SUM(
        CASE
            WHEN r.ride_status = 'Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS cancelled_rides,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN r.ride_status = 'Cancelled'
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(r.ride_id), 0),
        2
    ) AS cancellation_percentage

FROM drivers d LEFT JOIN rides r     
ON d.driver_id = r.driver_id
GROUP BY  d.driver_id, d.driver_name ORDER BY  cancellation_percentage DESC;



SELECT
    d.driver_id,
    d.driver_name,
    d.city,
    v.vehicle_type,

    COUNT(
        CASE
            WHEN r.ride_status = 'Completed'
            THEN r.ride_id
        END
    ) AS completed_rides,

    COALESCE(
        SUM(
            CASE
                WHEN r.ride_status = 'Completed'
                THEN r.fare_amount
                ELSE 0
            END
        ),
        0
    ) AS total_revenue,

    COUNT(r.ride_id) AS total_bookings,

    COUNT(
        CASE
            WHEN r.ride_status = 'Cancelled'
            THEN r.ride_id
        END
    ) AS cancelled_rides,

    ROUND(
        100.0 *
        COUNT(
            CASE
                WHEN r.ride_status = 'Cancelled'
                THEN r.ride_id
            END
        ) / NULLIF(COUNT(r.ride_id), 0),
        2
    ) AS cancellation_rate_percentage,

    ROUND(AVG(rt.driver_rating), 2) AS average_rating,

    ROUND(
        AVG(
            CASE
                WHEN r.ride_status = 'Completed'
                THEN r.distance_km
            END
        ),
        2
    ) AS average_ride_distance_km

FROM drivers d

LEFT JOIN vehicles v
    ON d.driver_id = v.driver_id

LEFT JOIN rides r
    ON d.driver_id = r.driver_id
   AND v.vehicle_id = r.vehicle_id

LEFT JOIN ratings rt
    ON r.ride_id = rt.ride_id

GROUP BY
    d.driver_id,
    d.driver_name,
    d.city,
    v.vehicle_type

ORDER BY
    total_revenue DESC;