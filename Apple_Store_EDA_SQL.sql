/*-- we create a table with the 4 parts of the .csv combined */
CREATE TABLE ApplesStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL 

SELECT * FROM appleStore_description2

UNION ALL 

SELECT * FROM appleStore_description3

UNION ALL 

SELECT * FROM appleStore_description4;

/*--looking for unique values IDs in AppleStore*/
select count (distinct id) as UniqueAppIDs
from AppleStore

/*--looking for unique values IDs in AApplesStore_description_combined */
select count (distinct id) as UniqueAppIDs
from ApplesStore_description_combined

/*--check for missing values in track?name from ApApplesStore_description_combined*/
SELECT COUNT (*) AS MissingValues
FROM ApplesStore_description_combined
WHERE track_name IS null

/*--cheking unique IDS values from ApplesStore_description_combined*/
select count (distinct id) as UniqueAppIDs
from ApplesStore_description_combined
--How many apps are in each category
select prime_genre, count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC

/*-- miniimum, maximum and average rating of the total of apps*/
select min(user_rating) as MinRating,  
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore

/*--average rating of free and Paid apps*/
SELECT CASE
			when price > 0 then 'Paid'
            ELSE 'Free'
       END AS App_Type,
       avg(user_rating) as Avg_Rating
      
From AppleStore

Group BY App_Type

/*--does the numer of languages supported by an app impact in the rating of it?*/
SELECT CASE
			WHEN lang_num < 10 then '<10 languajes'
			WHEN lang_num between 10 and 30 then '10-30 languajes'
            else '>30 languajes'
       END AS languaje_bucket,
       avg(user_rating) as Avg_Rating
FROM AppleStore
group by languaje_bucket
Order BY Avg_Rating DESC

/*--does the description of the app impact in the rating of it?*/          
SELECT CASE
           WHEN LENGTH(b.app_desc) < 500 THEN 'short'
           WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'medium'
           ELSE 'long'
       END AS description_length_bucket,
       AVG(a.user_rating) AS average_rating
FROM AppleStore AS a
JOIN ApplesStore_description_combined AS b
ON a.id = b.id
GROUP BY description_length_bucket
ORDER BY average_rating DESC;

/*--top apps from every app genre*/
SELECT
	prime_genre,
    track_name,
    user_rating
from (
  	SELECT
  	prime_genre,
  	track_name,
  	user_rating,
  	RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
  	from 
  	AppleStore
  ) as a
 where 
 a.rank = 1