DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR (150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

SELECT * FROM netflix;

select type,
count(*) as total_content
from netflix
GROUP BY type;

--------------------
select 
	type,
	rating
from 
(
	select 
		type, 
		rating,
		count(*),
		rank() over(partition by type order by count(*) desc) as ranking
	from netflix 
	group by 1, 2
) as t1
where 
ranking =1

---------------------

select * from netflix
where 
	type = 'Movie'
	AND 
	release_year = 2020
-----------------------
-- find the top 5 countries with the mot content

select 
	unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
	limit 5

------------------
select 
	unnest(string_to_array(country, ',')) as new_country
	
from netflix


--------------------
select * from netflix
where 
	type = 'Movie'
	and	
	duration = (select max(duration) from netflix)



------------------
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--------------------------
select * from netflix
where director ilike '%Rajiv Chilaka%'

----------
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
---------------------------
select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(*) as total_content
from netflix
group by 1;

------\
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

select * from netflix
where listed_in like '%Documentaries';


select * from netflix
where director is null;


select * from netflix
where casts like '%Salman Khan%'
and release_year > extract(year from current_date) -10;

select 
unnest(string_to_array(casts, ',')) as actor,
count(*)
from netflix
where country = 'India'
group by actor 
order by count(*) desc
limit 10;

select 
	category,
	count(*) as content_count
from (
	select 
		case 
	 		when description ILIKE '%Kill' or description ILIKE '%violence%' then 'Bad' else 'Good'
	END as category
	from netflix
) as categorized_content
group by category;







