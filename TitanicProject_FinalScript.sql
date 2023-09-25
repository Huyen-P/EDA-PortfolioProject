-- Retrieve the first row in the table titanic
SELECT *
FROM titanic
WHERE PassengerId = 1
-- note: I dont understand why the statement is error - check with your mentor the reason why?

SELECT *
FROM titanic

-- Retrieve the name, age, and "Pclass" columns from the titanic table
SELECT "Name", "Age", "Pclass"
FROM titanic

SELECT Name, Age, Pclass
FROM titanic

SELECT name, age, pclass
FROM titanic
-- Note: it doesn't show the differences in these ways of performing the statements. Is it neccesary to use quotation marks?

-- Retrieve the 3 passengers who paid the cheapest ticket fare
SELECT *
FROM titanic
WHERE Fare = 0
ORDER BY Pclass
-- Note: Again it doesn't work with the LIMIT clause - check with your mentor.

-- Find the Average Age of the passengers
SELECT AVG(Age) AS AVGAge
FROM titanic


-- Retrieve the names of the passengers who paid a fare greater than $30
SELECT name, fare
FROM titanic
WHERE Fare > 30
ORDER BY 2

-- Group the passengers by their ticket class (Pclass) and count the number of passengers in each class
SELECT Pclass, COUNT(Pclass) AS NumberOfPassengers
FROM titanic
GROUP BY Pclass
ORDER BY 2 DESC

-- Find the total fare paid by the passengers who embarked from port 'C'
SELECT SUM (Fare) AS TotalFare_CPort
FROM titanic
WHERE Embarked = 'C'


-- Find the average fare by male and female passengers
SELECT *
FROM titanic

SELECT Sex, AVG(Fare) AS AVGFare 
FROM titanic
GROUP BY Sex

-- What is the percentage of male passengers?
SELECT COUNT(*)*100/ (SELECT Count(*)
					  FROM titanic) AS MalePercentage
FROM titanic
WHERE Sex = 'male'

-- Group the passengers by their ticket class (Pclass) and find the survival rate (%) of the passengers in each class
SELECT Pclass, AVG(Survived)*100 AS SurvivalRate
FROM titanic
GROUP BY Pclass
ORDER BY 2 DESC

-- Find the average fare paid by the passengers grouped by their embarkation port (Embarked) and ticket class (Pclass)
SELECT  Pclass, Embarked, AVG(Fare) AS AverageFare
FROM titanic
GROUP BY Embarked, Pclass
ORDER BY 1,3 DESC

-- Find the survival rate of the passengers grouped by their ticket class (Pclass) and age range
SELECT  Pclass,
		CASE WHEN "Age" < 18 THEN '1.Teenager'
			 WHEN "Age" > = 18 AND "Age" < 26 THEN '2.Young Adult'
			 WHEN "Age" > 25 AND "Age" < 65 THEN '3.Adult'
			 ELSE '4.Elder' END AS "Age Range",
		SUM(Survived)*100/ COUNT(*) AS "Survival Rate"
FROM titanic
WHERE "Age" is not null
GROUP BY Pclass, 
	CASE 
        WHEN "Age" < 18 THEN '1.Teenager'
		WHEN "Age" > = 18 AND "Age" < 26 THEN '2.Young Adult'
		WHEN "Age" > 25 AND "Age" < 65 THEN '3.Adult'
		ELSE '4.Elder' 
    END
ORDER BY 1,2,3 DESC



