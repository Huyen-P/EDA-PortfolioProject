-- Question 1: How many sales does the company make each year?

SELECT COUNT(InvoiceId) AS "TotalSales", year(InvoiceDate) AS "Year"
FROM Invoice
GROUP BY year(InvoiceDate) 
ORDER BY "TotalSales" DESC

-- Question 2: How many song tracks are there?

SELECT COUNT(TrackId) AS "TotalSongTrack"
FROM Track

-- Question 3: What are the media types of the tracks in the database?

SELECT MediaType.Name AS MediaTypeName
FROM Track
JOIN MediaType ON Track.MediaTypeId = MediaType.MediaTypeId
GROUP BY MediaType.Name
ORDER BY MediaTypeName


-- Question 4: How many playlists are there?

SELECT COUNT(Playlist.Name) AS TotalPlaylist
FROM Playlist
ORDER BY TotalPlaylist

-- Question 5: How many songs are on each playlist?

SELECT COUNT(PlaylistTrack.TrackId) AS TotalSong, Playlist.PlaylistId
FROM Track
RIGHT JOIN PlaylistTrack ON PlaylistTrack.TrackId = Track.TrackId
RIGHT JOIN Playlist ON Playlist.PlaylistId = PlaylistTrack.PlaylistId
GROUP BY Playlist.PlaylistId
ORDER BY PlaylistId

-- Question 6: Which employee has the highest number of sales?

SELECT DISTINCT(SUM(Invoice.Total) OVER (PARTITION BY Employee.EmployeeId)) AS TotalSale, Employee.LastName, Employee.FirstName
FROM Employee
JOIN Customer ON Customer.SupportRepId = Employee.EmployeeId
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
ORDER BY TotalSale DESC

-- Question 7: Which city has the most customer staying there?

SELECT COUNT(*) OVER (PARTITION BY City) AS TotalCustomerStaying, City
FROM Customer
ORDER BY TotalCustomerStaying DESC


-- Question 8: Which city has the highest number of sales?/ Which city is the best market?

SELECT DISTINCT(SUM(Invoice.Total) OVER (PARTITION BY Invoice.BillingCity)) AS TotalSale, Invoice.BillingCity
FROM Employee
JOIN Customer ON Customer.SupportRepId = Employee.EmployeeId
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
ORDER BY TotalSale DESC


-- Question 9: Which month has the highest income?

SELECT YEAR(InvoiceDate) AS "Year", FORMAT (InvoiceDate,'%M') AS "Month", SUM (Total) AS "TotalSales"
FROM Invoice
GROUP BY YEAR(InvoiceDate), FORMAT (InvoiceDate,'%M')
ORDER BY "Year", "TotalSales"DESC

-- Question 10: What are the top 10 songs that appear the most in the playlists

SELECT  TOP 10
        Track."Name",
        COUNT("PlaylistId") AS "PlaylistCOUNT"
FROM Track
JOIN PlaylistTrack ON Track.TrackId=PlaylistTrack.TrackId
GROUP BY "Name"
ORDER BY 2 DESC

-- Question 11: Who are the top ten highest-earning artists?

SELECT  TOP 10
        ar.Name,
        SUM(i.Total) AS "TotalSales"
FROM    Invoice i
        JOIN InvoiceLine AS il ON il.InvoiceId = i.InvoiceId 
        JOIN Track AS t ON t.TrackId = il.TrackId
        JOIN Album AS al ON al.AlbumId = t.AlbumId
        JOIN Artist AS ar ON ar.ArtistId = al.ArtistId
GROUP BY ar.Name
ORDER BY 2 DESC


-- Question 12: What songs have the highest sales

SELECT  t.Name AS "Song",
        SUM(il.UnitPrice*il.Quantity) AS "TotalSales"
FROM    Track t
        JOIN InvoiceLine AS il ON t.TrackId = il.TrackId
GROUP BY t.Name
ORDER BY 2 DESC

-- Question 13: What songs have no sale?

SELECT t.Name
FROM Track t
WHERE t.TrackId NOT IN (SELECT TrackId FROM InvoiceLine)

-- Question 14: Identify the most popular genre for each country where a customer resides

With customer_countries AS (
SELECT  c.Country,
        g.GenreId,
        COUNT(DISTINCT c.CustomerId) AS "CustomerCount"
FROM    Customer c
        JOIN Invoice i ON c.CustomerId = i.CustomerId   
        JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
        JOIN Track t ON il.TrackId = t.TrackId
        JOIN genre g ON t.GenreId = g.GenreId
GROUP BY Country, g.GenreId
),
ranked_genres AS (
  SELECT  Country,
          GenreId,
          (SELECT "Name" FROM Genre WHERE Genre.GenreId = customer_countries.GenreId) AS Genre,
          CustomerCount,
          ROW_NUMBER() OVER(PARTITION BY Country ORDER BY CustomerCount DESC) AS "Rank"
  FROM    customer_countries
)
SELECT  Country, 
        GenreId, 
        Genre,
        CustomerCount
FROM ranked_genres
WHERE "Rank" = 1




