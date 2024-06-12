

#EDA on Clean Data:
#First Moment Business Decision - Measures of Central Tendency

#Mean
select avg(duration), avg(probability), avg(fps)
from clean_data;

#Median
with median_finder as (
  select duration, probability, fps, row_number() over (order by duration, probability, fps) as row_id,count(*) over() as ct
  from clean_data
)
select avg(duration) as median_duration, avg(probability) as median_probability, avg(fps) as median_fps 
from median_finder
where row_id between ct/2.0 and ct/2.0 + 1;

#Mode
SELECT duration as mode_duration, COUNT(duration) AS frequency
FROM clean_data
GROUP BY duration
ORDER BY frequency DESC
LIMIT 1; 


SELECT fps as mode_fps, COUNT(fps) AS frequency
FROM clean_data
GROUP BY fps
ORDER BY frequency DESC
LIMIT 1;

SELECT probability as mode_probability, COUNT(probability) AS frequency
FROM clean_data
GROUP BY probability
ORDER BY frequency DESC
LIMIT 1;

#Second Moment Business Decision - Measures of Dispersion

#Variance
SELECT VARIANCE(duration) AS duration_var, VARIANCE(probability) AS probability_var, VARIANCE(fps) AS fps_var
FROM clean_data;

#Standard Deviation
SELECT stddev(duration) AS duration_sdev, stddev(probability) AS probability_sdev, stddev(fps) AS fps_sdev
FROM clean_data;

#Range
SELECT MAX(duration) - MIN(duration) as range_duration,
MAX(probability) - MIN(probability) as range_probability,
MAX(fps) - MIN(fps) as range_fps
FROM clean_data;


#Third Moment Business Decision - Skewness
SELECT
    (
        SUM(POWER(duration - (SELECT AVG(duration) FROM clean_data), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(duration) FROM clean_data), 3))
    ) AS duration_skewness,
	(
        SUM(POWER(probability - (SELECT AVG(probability) FROM clean_data), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(probability) FROM clean_data), 3))
    ) AS probability_skewness,
    (
        SUM(POWER(fps - (SELECT AVG(fps) FROM clean_data), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(fps) FROM clean_data), 3))
    ) AS fps_skewness
    from clean_data;
    
    
#Fourth Moment Business Decision - Kurtosis
SELECT
    (
        (SUM(POWER(duration - (SELECT AVG(duration) FROM clean_data), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(duration) FROM clean_data), 4))) - 3
    ) AS duration_kurtosis,
    (
        (SUM(POWER(probability - (SELECT AVG(probability) FROM clean_data), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(probability) FROM clean_data), 4))) - 3
    ) AS probability_kurtosis,
    (
        (SUM(POWER(fps - (SELECT AVG(fps) FROM clean_data), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(fps) FROM clean_data), 4))) - 3
    ) AS fps_kurtosis
FROM clean_data;


-- BUSINESS INSIGHTS

-- unique no. of persons
select distinct user_name from clean_data;

-- unique behaviour class
select distinct class_name from clean_data;


-- which behaviour is most commonly seen?
select class_name, count(*) as frequency
from clean_data
group by class_name
order by frequency desc;

-- which behaviour class has the highest avg duration?
select class_name, round(avg(duration),2) as avg_timestamp
from clean_data
group by class_name
order by avg_timestamp desc;


-- no. of classes per person
select distinct user_name, count(distinct class_name) as class_count
from clean_data
group by user_name
order by class_count desc;


-- no. of person in a specific behaviour class
select class_name, count(distinct user_name)
from clean_data
group by class_name
order by count(distinct user_name) desc;

-- no. of videos w.r.t fps
select fps, count(distinct asd_project34_video_id)
from clean_data
group by fps
order by fps desc;

-- unique videos
select distinct asd_project34_video_id 
from clean_data 
order by asd_project34_video_id;


-- to see whether there is any change in the duration and probability of occuring the behaviour
SELECT WEEK(date_time) AS week_no,
       Month(date_time) as month_no,
       YEAR(date_time) AS year_no,
       round(avg(duration),2) AS avg_d,
       round(avg(probability),2) as avg_p
FROM clean_data
GROUP BY week_no, month_no, year_no
ORDER BY year_no, month_no, week_no;





