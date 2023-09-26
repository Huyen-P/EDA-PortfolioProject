-- Create New Tables
CREATE TABLE movie_reviewers
( [id] int, [name] NVARCHAR(255))

INSERT INTO movie_reviewers VALUES 
  ('201','Sarah Martinez')
 ,('202', 'Daniel Lewis')
 ,('203','Brittany Harris')
 ,('204','Mike Anderson')
 ,('205', 'John White')
 ,('206', 'Elizabeth Thomas')
 ,('207', 'James Cameron')
 ,('208', 'Asley White')


CREATE TABLE movie_ratings
( [reviewer_id] int, [movie_id] int, [stars] decimal, [rating_date] date)

INSERT INTO movie_ratings VALUES 
  ('201','101','2','2011-01-22')
 ,('201','101','4','2011-01-27')
 ,('202','106','4', TRY_CONVERT(DATE, 'None'))
 ,('203','103','2 ','2011-01-20')
 ,('203','108','3','2011-01-12')
 ,('203','108','3','2011-01-30')
 ,('204','101','2','2011-01-09')
 ,('205','103','3','2011-01-27')
 ,('205','103','2 ','2011-01-22')
 ,('205','108','4',TRY_CONVERT(DATE, 'None'))
 ,('206','107','3','2011-01-15')
 ,('206','106','5','2011-01-19')
 ,('207','107','5','2011-01-20')
 ,('208','104','3','2011-01-02')



 CREATE TABLE movies
( [id] int, [title] NVARCHAR(255), [year] int, [director] NVARCHAR(255))

INSERT INTO movies VALUES 
  ('101','Wanted','2008','Timur Bekmamvbetov')
 ,('102','Cloverfield','2008','Matt Reeves')
 ,('103','Twilight','2008', 'Stephenie Mayor')
 ,('104','E.T.','1982','Stephen Spielberg')
 ,('105','Titanic','1997','James Cameron')
 ,('106','Snow White','1937','None')
 ,('107','Avatar','2009','James Cameron')
 ,('108','Raiders of the Lost Ark','1981','Stephen Spielberg')

SELECT *
FROM movies

SELECT*
FROM movie_reviewers

SELECT *
FROM movie_ratings

---------------------------------------------------------------------------------------------------
-- 01 - Select the title and year of all movies and the name of the reviewer who rated the movie

SELECT m.title, m.year, mr.name
FROM movies AS m
	 JOIN movie_ratings AS ms ON m.id = ms.movie_id
	 JOIN movie_reviewers AS mr ON ms.reviewer_id = mr.id

---------------------------------------------------------------------------------------------------
-- 02. Select the name of the reviewer, the title of the movie, and the number of stars they gave the movie.

SELECT mr.name, m.title, ms.stars
FROM movies AS m
	 JOIN movie_ratings AS ms ON m.id = ms.movie_id
	 JOIN movie_reviewers AS mr ON ms.reviewer_id = mr.id

---------------------------------------------------------------------------------------------------
-- 03. Select the title of the movie and the average rating given to the movie by all reviewers.

SELECT m.id, m.title, AVG(ms.stars) AS avg_rating
FROM movies AS m
	 LEFT JOIN movie_ratings AS ms ON m.id = ms.movie_id
GROUP BY m.id, m.title
ORDER BY avg_rating DESC;

---------------------------------------------------------------------------------------------------
-- 04. Select the name of the reviewer, the title of the movie, and the number of stars they gave the movie, but only for movies released in 2008.

SELECT mr.name AS reviewer_name, m.title as movie_title, ms.stars
FROM movies AS m
	 LEFT JOIN movie_ratings AS ms ON m.id = ms.movie_id
	 LEFT JOIN movie_reviewers AS mr ON ms.reviewer_id = mr.id
WHERE m.year = 2008
ORDER BY 3 DESC;

---------------------------------------------------------------------------------------------------
-- 05. Join movies, movie_reviewers, and movie_ratings to get a list of all the reviewers and the number of movies they have reviewed, with at least 3 stars.

SELECT mr.name AS reviewer_name, COUNT(DISTINCT m.title) AS movie_count
FROM movies AS m
JOIN movie_ratings AS ms ON m.id = ms.movie_id
JOIN movie_reviewers AS mr ON ms.reviewer_id = mr.id
WHERE ms.stars > 2
GROUP BY mr.name
ORDER BY movie_count DESC

---------------------------------------------------------------------------------------------------
/* 
06. Return the title and rating spread of each movie sorted by rating spread from highest to lowest and then by ascending movie title, 
where rating spread is calculated as the difference between highest and lowest ratings given to that movie.
*/

SELECT m.title AS movie_title,  (MAX(ms.stars) - MIN(ms.stars)) AS rating_spread
FROM movies AS m
JOIN movie_ratings AS ms ON m.id = ms.movie_id
JOIN movie_reviewers AS mr ON ms.reviewer_id = mr.id
GROUP BY m.title
ORDER BY rating_spread DESC

---------------------------------------------------------------------------------------------------
-- 07. Return the reviewer name, movie title, and number of stars for any rating where the reviewer is the same as the movie's director.
SELECT mr.name AS reviewer_name, m.title AS movie_title, ms.stars
FROM movies AS m
JOIN movie_ratings AS ms ON m.id = ms.movie_id
JOIN movie_reviewers AS mr ON ms.reviewer_id = mr.id
WHERE m.director = mr.name

---------------------------------------------------------------------------------------------------