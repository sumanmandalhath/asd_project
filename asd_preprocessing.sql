alter table data
rename column ï»¿uid to uid;


# Handling Missing Values
select * from data
where uid is null
or asd_project34_video_id is null
or user_name is null
or duration is null
or class_name is null
or probability is null
or fps is null
or date_time is null;


#Removing Duplicates
select distinct uid,
asd_project34_video_id , 
user_name, 
duration, 
class_name, 
probability, 
fps, 
date_time
from data;


SELECT 
uid,
asd_project34_video_id , 
user_name, 
duration, 
class_name, 
probability, 
fps, 
date_time,
count(*)
from data
GROUP BY 
uid,
asd_project34_video_id , 
user_name, 
duration, 
class_name, 
probability, 
fps, 
date_time
having count(*) > 1;


#Modify column datatype

ALTER TABLE data
MODIFY COLUMN duration FLOAT;

ALTER TABLE data
MODIFY COLUMN probability FLOAT;


# Handling outliers using Z-Score Method
-- Set Z-score threshold (e.g., 3 standard deviations away from the mean)
SET @z_score_threshold = 3;

-- Identify outliers using Z-score
SELECT duration
FROM data
WHERE ABS((duration - (SELECT AVG(duration) FROM data)) / (SELECT STDDEV(duration) FROM data)) > @z_score_threshold;

SELECT probability
FROM data
WHERE ABS((probability - (SELECT AVG(probability) FROM data)) / (SELECT STDDEV(probability) FROM data)) > @z_score_threshold;

SELECT fps
FROM data
WHERE ABS((fps - (SELECT AVG(fps) FROM data)) / (SELECT STDDEV(fps) FROM data)) > @z_score_threshold;

#There are 363 outliers found in the probability column.
#Removing the outliers

CREATE TEMPORARY TABLE filtered_data
SELECT *
FROM data
WHERE ABS((probability - (SELECT AVG(probability) FROM data)) / (SELECT STDDEV(probability) FROM data)) > @z_score_threshold;


select * from filtered_data;


-- Subtract one table from another using LEFT JOIN
SELECT data.*
FROM data
LEFT JOIN filtered_data ON data.probability = filtered_data.probability
WHERE filtered_data.probability IS NULL;


-- Saving the data into another table
create table clean_data
as (SELECT data.*
FROM data
LEFT JOIN filtered_data ON data.probability = filtered_data.probability
WHERE filtered_data.probability IS NULL);







