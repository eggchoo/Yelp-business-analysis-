# Yelp-business-analysis
---
#### Yelp is a publicly-traded local business review and advertising platform that, in 2024, generated approximately US $1.41 billion in net revenue. As of mid-2025, Yelp serves around 515,000 paying advertiser locations, with over 308 million cumulative reviews posted on its site. This project analyzes Yelp data to identify key factors driving customer ratings, engagement, and business visibility. The insights aim to support businesses in improving their online reputation, attracting more customers, and enhancing overall performance on the platform.
--- 
## Business questions addressed 
1. Number of business in each category
2. Top 10 users have reviewed the most businesses in the 'restaurants' category 
3. The most popular categories of businesses (based on number of reviews)
4. The top3 most recent reviews for each business
5. The month with the highest number of reviews
6. The percentage of 5-star reviews for each business
7. The top 5 most reviewed business in each city
8. The average rating of businesses that have at least 100 reviews
9. The top 10 users who have written the most reviews, along with the businesses they reviewed
10. The top10 business with highest positive sentiment reviews 
---
## Data ETL process overview 
- _**Extracting**_ JSON data from Yelp website
- _**Transforming**_ JSON data to multiple files using Python 
- _**Uploading segmented files to AWS**_
- _**Loading data**_ into SNOWFLAKE and _**conducting sentiment analysis**_ using Python 
- _**Conducting business analysis**_ in SNOWFLAKE using SQL 
<img width="1777" height="458" alt="project overview" src="https://github.com/user-attachments/assets/aa051c56-4d4c-4a81-a955-cc3a81fdaca1" />

--- 
## Data structure 
The dataset contains a total of _**10,169,368 customer reviews**_ and _**150,346 business**_ in _**27 states**_ in the US _**from 2015 to 2022**_. The dataset consits of 2 tables: customer reviews and business. 

<img width="691" height="339" alt="ERD" src="https://github.com/user-attachments/assets/82cf0ca2-d94f-4d0b-9530-dc2ab4641823" />

