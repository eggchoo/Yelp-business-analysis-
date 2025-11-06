USE DATABASE YELP;
create or replace table yelp_business (business_text variant)

COPY INTO yelp_business
FROM 's3://echoooo/yelp/yelp_academic_dataset_business.json'
CREDENTIALS=(
    AWS_KEY_ID='AKIAZV5UQJIXKS5UMRXY'
    AWS_SECRET_KEY='qAI5kTQWHEYMuDNSXAhqoV7tDUVs4ck6bR7MsNAz'
)
FILE_FORMAT = (TYPE = JSON); 

create or replace table tbl_yelp_business as 
select 
business_text: business_id::string as business_id, 
business_text: city::string as city,
business_text: categories::string as categories,
business_text: name::string as name,
business_text: state::string as state,
business_text: review_count::string as review_count,
business_text: stars::integer as stars,
from yelp_business 

select*from tbl_yelp_business limit 100
