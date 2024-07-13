USE SocialMedia;
SELECT * 
FROM people;

DROP TABLE IF EXISTS platforms;

CREATE TABLE platform AS
SELECT platform, interests ,demographics, time_spent
FROM people;

SELECT * 
FROM platform;

ALTER TABLE people 
DROP COLUMN time_spent;

ALTER TABLE people 
DROP COLUMN platform;

ALTER TABLE people 
DROP COLUMN interests,
DROP COLUMN demographics,
DROP COLUMN Owns_car;

ALTER TABLE people
ADD COLUMN user_id INT AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE platform
ADD COLUMN user_id INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- Check the length of our DATA: 
SELECT COUNT(*) 
FROM people;

-- Check the count grouped by gender: 

SELECT gender , COUNT(*) AS total
FROM people
GROUP BY gender
ORDER BY total DESC;

-- Check the gender grouped by location: 

SELECT location,gender,COUNT(*)
FROM people 
GROUP BY location, gender;
-- Check the count grouped by location: 

SELECT location , COUNT(*) AS total
FROM people
GROUP BY location
ORDER BY total DESC;

-- Check the count grouped by profession: 

SELECT profession , COUNT(*) AS total
FROM people
GROUP BY profession
ORDER BY total DESC;

-- Check the count grouped by age and profession: 

SELECT age ,profession , COUNT(*) AS total
FROM people
GROUP BY age ,profession
ORDER BY age ASC;

-- Check the count grouped by indebt: 

SELECT indebt ,profession , COUNT(*) AS total
FROM people
GROUP BY indebt,profession;

-- CHECK Average , max and min of age and income:

SELECT ROUND(AVG(age),0) AS average_age ,MIN(age) AS minimum_age,MAX(age) AS maximum_age
FROM people;

SELECT ROUND(AVG(income),2) AS average_income,MIN(income) AS minimum_income,MAX(income) AS maximum_income
FROM people;

-- show all users that has age higher then average age order by age: 

SELECT * 
FROM people 
WHERE age> (SELECT ROUND(AVG(age),0) AS 'average_age' FROM people)
ORDER by age ASC;

-- show count of users that has an age higher then the average age:
SELECT COUNT(*) 
FROM people 
WHERE age> (SELECT ROUND(AVG(age),0) AS 'average_age' FROM people);

-- show professions of users that has an incore higher then the average income:
SELECT profession , ROUND(AVG(income),2) AS average_income
FROM people 
GROUP BY profession
HAVING average_income >= (SELECT ROUND(AVG(income),2) AS 'average_income' FROM people);

-- see different platforms that users use:

SELECT distinct platform
FROM platform;

-- see count of users for each platform : 
SELECT  platform , count(*)
FROM platform
GROUP BY platform;

-- total time spent and average for each platform: 

SELECT platform , SUM(time_spent) AS total_time , AVG(time_spent) AS average_time , ROUND((SUM(time_spent)/24),0) AS days_time
FROM platform
GROUP BY platform;

-- what are the different intersts we have ? and count for each one.

SELECT distinct interests , COUNT(*)
FROM platform
GROUP BY interests;

-- see how many user uses specific platform for a specific interest

SELECT platform, interests , COUNT(*) AS number_of_users
FROM platform
GROUP BY interests,platform;

-- see average time spent for each interest in each platform:

SELECT platform, interests, ROUND(AVG(time_spent),2) AS time_spent
FROM platform
GROUP BY interests,platform
ORDER BY time_spent DESC;

-- what are the different demographics we have ? 

SELECT distinct demographics
FROM platform;

-- demography of users:

SELECT demographics,COUNT(*) AS users_number
FROM platform
GROUP BY demographics;

-- demography and interests of users:

SELECT demographics,interests,COUNT(*) AS users_number
FROM platform
GROUP BY demographics,interests
ORDER BY users_number DESC;

-- see time spent in social media grouped by demographics:

SELECT demographics , ROUND(AVG(time_spent),2) AS average_time
FROM platform
GROUP BY demographics;

-- let's join the 2 tables to see count of genders in each platform : 

SELECT pp.gender , pl.platform , COUNT(*) AS users_number
FROM people pp
JOIN platform pl
USING (user_id)
GROUP BY pp.gender, pl.platform;

-- let's join the 2 tables to see count of profession in each platform : 

SELECT pp.profession , pl.platform , COUNT(*) AS count
FROM people pp
JOIN platform pl
USING (user_id)
GROUP BY pp.profession, pl.platform;

-- let's join the 2 tables to see average time spent in social media for each profession : 

SELECT pp.profession , ROUND(AVG(pl.time_spent),2) AS average_time, count(pp.profession) AS users_number
FROM people pp 
JOIN platform pl 
USING (user_id)
GROUP BY pp.profession;

-- which profession has the users that spends more time is social media:

SELECT pp.profession, ROUND(AVG(pl.time_spent), 2) AS average_time
FROM people pp
JOIN platform pl 
USING (user_id)
GROUP BY pp.profession
HAVING ROUND(AVG(pl.time_spent), 2) > (SELECT ROUND(AVG(pl2.time_spent), 2) FROM platform pl2);