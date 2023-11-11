create table appleStore_description_combined as 

select * from appleStore_description1

union ALL

select * from appleStore_description2

union ALL

select * from appleStore_description3

union ALL

select * from appleStore_description4

**EXPLATATORY DATA ANALYSIS**

-- check the number of unique apps in both tablesAppleStoreAppleStore

select count(DISTINCT id) as UniqueAppIDs
from AppleStore

select count(DISTINCT id) as UniqueAppIDs
from appleStore_description_combined

--check for any missing values in key fields 

select count(*) as MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is NULL

select count(*) as MissingValues
from appleStore_description_combined
where app_desc is NULL

-- Find out the number of apps per genre 

select prime_genre, COUNT(*) as NumApps 
from AppleStore
GROUP BY prime_genre
order by NumApps DESC

--Get an overview of the apps' ratings

SELECT min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
From AppleStore


**DATA ANALYSIS**

--Determine whether paid apps have higher ratings then free apps

select case 
			when price > 0 then 'Paid'
            else 'Free'	
		end as App_Type,
        avg(user_rating) as Avg_Rating
From AppleStore
group by App_Type

--Check if apps with more supported languages have higher ratings 

select case 
			when lang_num < 10 then '<10 languages'
            when lang_num > 10 and 30 then '10-30 languages'
            else '>30 languages'
		end as language_bucket,
        avg(user_rating) as Avg_Rating
from AppleStore
group by language_bucket
order by Avg_Rating DESC

--Check genres with low ratingsAppleStore

select prime_genre,
		avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC
limit 10

--Check if there is correlation between the length of the app description and the user rating

select case 
			when length(b.app_desc) <500 then 'Short'
            when length(b.app_desc) between 500 and 1000 then 'Medium'
            else 'Long'
         end as description_length_bucket,
         avg(a.user_rating) as average_rating
            
from 
	AppleStore as a
JOIN
	appleStore_description_combined as b
on 
	a.id = b.id 
 
group by description_length_bucket
order by average_rating DESC
