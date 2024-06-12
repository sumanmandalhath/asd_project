create schema asd_project;

use asd_project;

select * from data;

#EDA:
#First Moment Business Decision - Measures of Central Tendency

#Mean
select avg(duration), avg(probability), avg(fps)
from data;

#Median
with median_finder as (
  select duration, probability, fps, row_number() over (order by duration, probability, fps) as row_id,count(*) over() as ct
  from data
)
select avg(duration) as median_duration, avg(probability) as median_probability, avg(fps) as median_fps 
from median_finder
where row_id between ct/2.0 and ct/2.0 + 1;

#Mode
SELECT duration as mode_duration, COUNT(duration) AS frequency
FROM data
GROUP BY duration
ORDER BY frequency DESC
LIMIT 1; 


SELECT fps as mode_fps, COUNT(fps) AS frequency
FROM data
GROUP BY fps
ORDER BY frequency DESC
LIMIT 1;

SELECT probability as mode_probability, COUNT(probability) AS frequency
FROM data
GROUP BY probability
ORDER BY frequency DESC
LIMIT 1;

#Second Moment Business Decision - Measures of Dispersion

#Variance
SELECT VARIANCE(duration) AS duration_var, VARIANCE(probability) AS probability_var, VARIANCE(fps) AS fps_var
FROM data;

#Standard Deviation
SELECT stddev(duration) AS duration_sdev, stddev(probability) AS probability_sdev, stddev(fps) AS fps_sdev
FROM data;

#Range
SELECT MAX(duration) - MIN(duration) as range_duration,
MAX(probability) - MIN(probability) as range_probability,
MAX(fps) - MIN(fps) as range_fps
FROM data;


#Third Moment Business Decision - Skewness
SELECT
    (
        SUM(POWER(duration - (SELECT AVG(duration) FROM data), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(duration) FROM data), 3))
    ) AS duration_skewness,
	(
        SUM(POWER(probability - (SELECT AVG(probability) FROM data), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(probability) FROM data), 3))
    ) AS probability_skewness,
    (
        SUM(POWER(fps - (SELECT AVG(fps) FROM data), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(fps) FROM data), 3))
    ) AS fps_skewness
    from data;
    
    
#Fourth Moment Business Decision - Kurtosis
SELECT
    (
        (SUM(POWER(duration - (SELECT AVG(duration) FROM data), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(duration) FROM data), 4))) - 3
    ) AS duration_kurtosis,
    (
        (SUM(POWER(probability - (SELECT AVG(probability) FROM data), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(probability) FROM data), 4))) - 3
    ) AS probability_kurtosis,
    (
        (SUM(POWER(fps - (SELECT AVG(fps) FROM data), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(fps) FROM data), 4))) - 3
    ) AS fps_kurtosis
FROM data;




