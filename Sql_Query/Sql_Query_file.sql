create database Caps4;
use caps4;

# Total Hotels
SELECT COUNT(*) AS Total_Hotels
FROM hotels;

# Total Bookings
SELECT COUNT(*) AS Total_Bookings
FROM bookings;

# Total Revenue
SELECT SUM(total_amount) AS Total_Revenue
FROM bookings;



# Average Rooms per Hotel
SELECT AVG(total_rooms) AS Avg_Rooms_Per_Hotel
FROM hotels;

# Total Cities
SELECT COUNT(DISTINCT city) AS Total_Cities
FROM hotels;

# Revenue by City
SELECT
    h.city,
    SUM(b.total_Amount) AS Total_Revenue
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN transactions t
    ON b.booking_id = t.booking_id
GROUP BY h.city
ORDER BY Total_Revenue DESC;

# Top 10 Hotels by Revenue
SELECT
    h.hotel_name,
    SUM(b.total_amount) AS Total_Revenue
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN transactions t
    ON b.booking_id = t.booking_id
GROUP BY h.hotel_name
ORDER BY Total_Revenue DESC
LIMIT 10;



# Bookings by Room Type
SELECT
    room_type,
    COUNT(booking_id) AS Total_Bookings
FROM bookings
GROUP BY room_type;

# Bookings by City
SELECT
    h.city,
    COUNT(b.booking_id) AS Total_Bookings
FROM hotels h
JOIN bookings b
ON h.hotel_id=b.hotel_id
GROUP BY h.city;

##– Customer & Transaction Insights

#Total Transactions
SELECT COUNT(*) AS Total_Transactions
FROM transactions;

# Completed Transactions
SELECT COUNT(*) AS Complete_Transactions
FROM transactions
WHERE transaction_status='complete';

# Pending Transactions
SELECT COUNT(*) AS Pending_Transactions
FROM transactions
WHERE transaction_status='incomplete';

# Transaction Success Rate
SELECT
ROUND(
COUNT(CASE WHEN transaction_status='complete' THEN 1 END)*100.0
/
COUNT(*),2
) AS Success_Rate
FROM transactions;

# Average Rating



# Positive Rating %
SELECT
ROUND(
COUNT(CASE
WHEN ratings IN ('Excellent','Very Good','Good')
THEN 1
END)*100.0
/
COUNT(*),2
) AS Positive_Rating_Percentage
FROM ratings;



# Rating Distribution
SELECT
ratings,
COUNT(*) AS Total
FROM ratings
GROUP BY ratings
ORDER BY Total DESC;


## Advanced  Queries

# Top Revenue Hotel using RANK()
SELECT *
FROM
(
SELECT
h.hotel_name,
SUM(b.total_amount) AS Revenue,
RANK() OVER(
ORDER BY SUM(b.total_amount) DESC
) AS Hotel_Rank
FROM hotels h
JOIN bookings b
ON h.hotel_id=b.hotel_id
JOIN transactions t
ON b.booking_id=t.booking_id
GROUP BY h.hotel_name
)x
WHERE Hotel_Rank<=10;

# Revenue by City using CTE
WITH CityRevenue AS
(
SELECT
h.city,
SUM(b.total_amount) AS Revenue
FROM hotels h
JOIN bookings b
ON h.hotel_id=b.hotel_id
JOIN transactions t
ON b.booking_id=t.booking_id
GROUP BY h.city
)

SELECT *
FROM CityRevenue
ORDER BY Revenue DESC;