-- Checking our data
SELECT * 
FROM listings
ORDER BY 1 ASC;

SELECT COUNT(*)
FROM listings;

-- Cleaning the data
-- Dropping columns that have null values
ALTER TABLE listings DROP COLUMN license;
ALTER TABLE listings DROP COLUMN neighbourhood_group;
ALTER TABLE listings MODIFY host_id VARCHAR(255);

-- Looking at the most popular room types
SELECT room_type, COUNT(*) as listings
FROM listings
GROUP BY room_type;

-- Looking at the most popular locations
SELECT neighbourhood, COUNT(*) as listings
FROM listings
GROUP BY neighbourhood
ORDER BY 2 DESC;

-- Looking at listings averages by neighbourhood and room type 
SELECT neighbourhood, avg(calculated_host_listings_count) as avglistings
FROM listings 
GROUP BY neighbourhood
ORDER BY avglistings DESC;

SELECT room_type , avg(calculated_host_listings_count) as avglistings
FROM listings 
GROUP BY room_type 
ORDER BY avglistings DESC;

-- Analysing prices of listings and looking at the average price per room type and neighbourhood

SELECT neighbourhood, room_type, price
FROM listings 
ORDER BY price DESC;

SELECT room_type, count(*) as listings, avg(price) as avgprice
FROM listings
GROUP BY room_type
ORDER BY 2 DESC;

SELECT neighbourhood , count(*) as listings, avg(price) as avgprice
FROM listings
GROUP BY neighbourhood
ORDER BY 2 DESC;

-- Creating a price range to determine what the distribution is. I can now see that half of the listings are under 100.
SELECT  count(*) AS listings,
	CASE
		WHEN price < 100  THEN '0 - 100'
		WHEN price < 200  THEN '100 - 200'
		ELSE 'Over 200'
	END as price_range
	
FROM listings 
GROUP BY price_range
ORDER BY listings DESC;


-- Analysing bookings and projected revenue

-- Bookings by room type
SELECT room_type , sum(365 - (availability_365)) as bookedout
FROM listings
WHERE availability_365 != 0
GROUP BY room_type
ORDER BY 2 DESC;

-- Bookings by neighbourhood 
SELECT neighbourhood, sum(365 - (availability_365)) as bookedout
FROM listings
WHERE availability_365 != 0
GROUP BY neighbourhood
ORDER BY 2 DESC;

-- Top 10 listings by price and projected revenue. Projected revenue is calculated using the availibity column to determine how many days it has been booked and multiplying this by the price.
SELECT host_name , neighbourhood, name, room_type, price, availability_365, 365 - (availability_365) as bookedout, (365 - availability_365) * price  as projectedrev
FROM listings
WHERE availability_365 != 0
ORDER BY projectedrev DESC LIMIT 10;

-- Top 10 Hosts by projected revenue
SELECT host_name, sum(365 - (availability_365)) as bookedout, sum((365 - availability_365) * price) as projectedrev
FROM listings
WHERE availability_365 != 0
GROUP BY host_name
ORDER BY projectedrev DESC LIMIT 10;

-- Top 10 Hosts with most listings
SELECT host_name, neighbourhood, room_type, sum(calculated_host_listings_count)
FROM listings
GROUP BY host_name, room_type, neighbourhood 
ORDER BY 4 DESC LIMIT 10;


-- Analysing Reviews
SELECT host_name, number_of_reviews, reviews_per_month, last_review 
FROM listings
WHERE number_of_reviews != 0;

-- Top 10 most reviewed hosts
SELECT host_name, sum(number_of_reviews) as total_reviews, avg(price) as avgprice, 
CASE
		WHEN price < 100  THEN '0 - 100'
		WHEN price < 200  THEN '100 - 200'
		ELSE 'Over 200'
	END as price_range
FROM listings
WHERE number_of_reviews != 0
GROUP BY host_name, price_range
ORDER BY total_reviews DESC LIMIT 10;

-- Top 10 average reviews by host in the last 12 months
SELECT host_name, avg(number_of_reviews_ltm) as avgreviews, avg(price) as avgprice,
CASE
		WHEN price < 100  THEN '0 - 100'
		WHEN price < 200  THEN '100 - 200'
		ELSE 'Over 200'
	END as price_range
FROM listings
WHERE number_of_reviews != 0
GROUP BY host_name, price_range
ORDER BY avgreviews DESC LIMIT 10;


-- Average reviews by neighbourhood in the last 12 months
SELECT neighbourhood, AVG(number_of_reviews_ltm) as avgreviewsltm, COUNT(*) as listings
FROM listings
GROUP BY neighbourhood
ORDER BY avgreviewsltm DESC;

-- Average reviews by room type in the last 12 months
SELECT room_type , AVG(number_of_reviews_ltm) as avgreviewsltm, COUNT(*) as listings
FROM listings
GROUP BY room_type 
ORDER BY avgreviewsltm DESC;

-- Looking at what price ranges have the most reviews
SELECT 
CASE
		WHEN price < 100  THEN '0 - 100'
		WHEN price < 200  THEN '100 - 200'
		ELSE 'Over 200'
	END as price_range,
SUM(number_of_reviews_ltm) as totalreviews
FROM listings
GROUP BY price_range 
ORDER BY totalreviews DESC;
