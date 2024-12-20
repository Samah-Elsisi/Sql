--Easy:

-----Who is the senior most employee based on job title?

select TOP 1 * from employee
order by levels desc

-----Which countries have the most Invoices?

select count(invoice_id) as invoice,billing_country from invoice
group by billing_country
order by billing_country desc

-----What are top 3 values of total invoice?

select TOP 3 * from invoice
order by total desc 

-----Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select billing_city, sum(total) as total from invoice
group by billing_city
order by total desc

-----Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money

select TOP 1 c.customer_id , c.first_name , c.last_name , sum(i.total) as total from customer c 
join invoice i on c.customer_id = i.customer_id
group by c.customer_id , c.first_name, c.last_name
order by total desc

--Moderate:

-----Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A

select distinct email, first_name , last_name from customer c
join invoice i on i.customer_id= c.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
where track_id in (select track_id from track t
                    join genre g on g.genre_id = t.genre_id
					where g.name like 'Rock')
ORDER BY  email

-----Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands

SELECT TOP 10 a.artist_id, a.name,COUNT(a.artist_id) AS number_of_songs FROM track t
join album al on al.album_id = t.album_id
join artist a on a.artist_id = al.artist_id
join genre g on g.genre_id = t.genre_id
where g.name like 'Rock'
group by a.artist_id , a.name
order by number_of_songs desc 

-----Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select name, milliseconds from track
where milliseconds > (select avg(milliseconds) as avg_track_length from track )
order by milliseconds desc

--Advance:

-----Find how much amount spent by each customer on artists? Write a query to returncustomer name, artist name and total spent

WITH best_selling_artist AS (
    SELECT TOP 1 a.artist_id AS artist_id, a.name AS artist_name, SUM(il.unit_price*il.quantity) AS total_sales
    FROM invoice_line il
    JOIN track t ON t.track_id = il.track_id
    JOIN album al ON al.album_id = t.album_id
    JOIN artist a ON a.artist_id = al.artist_id
    GROUP BY a.artist_id, a.name
    ORDER BY total_sales DESC)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album al ON al.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = al.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC

-----We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres

WITH popular_genre AS 
(
    SELECT COUNT(il.quantity) AS purchases, c.country, g.name, g.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS RowNo 
    FROM invoice_line il
	JOIN invoice i ON i.invoice_id = il.invoice_id
	JOIN customer c ON c.customer_id = i.customer_id
	JOIN track t ON t.track_id = il.track_id
	JOIN genre g ON g.genre_id = t.genre_id
    GROUP BY c.country, g.name, g.genre_id
)
SELECT * FROM popular_genre WHERE RowNo <= 1
ORDER BY country ASC, purchases DESC

-----Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount

WITH Customter_with_country AS (
    SELECT 
        c.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending,
        ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
    FROM invoice i
    JOIN customer c ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, first_name, last_name, billing_country
)
SELECT * FROM Customter_with_country 
WHERE RowNo <= 1
ORDER BY total_spending DESC , billing_country asc