USE DATABASE YELP;

create or replace table yelp_reviews (review_text variant)

COPY INTO yelp_reviews 
FROM 's3://echoooo/yelp/'
CREDENTIALS=(
    AWS_KEY_ID='AKIAZV5UQJIXKS5UMRXY'
    AWS_SECRET_KEY='qAI5kTQWHEYMuDNSXAhqoV7tDUVs4ck6bR7MsNAz'
)
FILE_FORMAT = (TYPE = JSON); 

create or replace table tbl_yelp_reviews as 
select 
review_text:business_id::string AS business_id,
review_text:user_id::string AS user_id,
left(review_text:date::string, 10)::date AS review_date,
review_text:stars::number AS review_stars,
review_text:text::string AS review_text,
analyze_sentiment(review_text) AS sentiments
from yelp_reviews;

select* from tbl_yelp_reviews limit 100
select* from tbl_yelp_business limit 100

-- 1- number of business in each category 
with cte as(
select 
business_id, 
trim(A.value) AS category 
from tbl_yelp_business, 
lateral split_to_table(categories, ',')as A) 

select category, count(*) as number_of_business
from cte
group by category 
order by number_of_business DESC;


-- 2- top 10 users have reviewed the most businesses in the 'restaurants' category 

select 
r.user_id,
count(distinct r.business_id) as number_of_business_reviews
from tbl_yelp_reviews as r 
inner join tbl_yelp_business as b
on r.business_id=b.business_id
where b.categories ilike'%restaurant%' 
group by r.user_id
order by number_of_business_reviews DESC
limit 10; 

--3- the most popular categories of businesses (based on number of reviews)
with cte as(
select 
business_id, 
trim(A.value) AS category 
from tbl_yelp_business, 
lateral split_to_table(categories, ',')as A) 

select category, 
count(*) as no_of_reviews
from cte 
left join tbl_yelp_reviews as r 
on cte.business_id= r.business_id
group by category 
order by no_of_reviews desc; 




--4- the top3 most recent reviews for each business 
with cte as (
select r.*, b.name as business_name,
row_number()over(partition by r.business_id order by review_date desc)as rn
from tbl_yelp_reviews as r 
inner join tbl_yelp_business as b 
on r.business_id=b.business_id
where review_date is not null) 

select review_date, business_name, review_text
from cte 
where rn <=3; 


--5- the month with the highest number of reviews 
select extract(month from review_date) as month, count(*) as no_of_reviews,
from tbl_yelp_reviews
group by extract(month from review_date)
order by no_of_reviews desc;

--6- find the percentage of 5-star reviews for each business 

select 
r.business_id, b.name,
round(avg(case when review_stars=5 then 1 
when review_stars <>5 then 0 END)*100,2)as percentage 
from tbl_yelp_reviews as r 
inner join tbl_yelp_business as b 
on r.business_id=b.business_id
group by r.business_id, b.name

--7- find the top 5 most reviewed business in each city 
with cte as (
select b.city,
b.business_id,
b.name,
count(*) as no_of_reviews
from tbl_yelp_reviews as r
left join tbl_yelp_business as b 
on r.business_id=b.business_id
group by b.city,b.business_id,b.name) 

select *
from cte 
qualify row_number()over(partition by city order by no_of_reviews desc)<=5;


--8- find the average rating of businesses that have at least 100 reviews 

select b.business_id,
b.name,
avg(review_stars)as avg_rating, 
count(*) as total_reviews
from tbl_yelp_reviews as r 
left join tbl_yelp_business as b on r.business_id=b.business_id
group by b.business_id, b.name
having total_reviews >= 100 
order by total_reviews desc; 

--9- list the top 10 users who have written the most reviews, along with the businesses they reviewed 

with cte as(
select 
user_id,
count(*) as total_reviews
from tbl_yelp_reviews 
group by user_id
order by total_reviews desc
limit 10) 

select user_id,business_id
from tbl_yelp_reviews 
where user_id in (select user_id from cte)
group by user_id, business_id
order by user_id, business_id


--10- find top10 business with highest positive sentiment reviews 
select r.business_id, b.name,count(*) as total_reviews 
from tbl_yelp_reviews as r 
left join tbl_yelp_business as b on r.business_id=b.business_id
where sentiments ='Positive'
group by r.business_id, b.name
order by total_reviews desc
limit 10; 