USE kyruus;

-- Change the table name to providers_visit
ALTER TABLE visit_type
RENAME TO providers_visit;

-- Removing blank values
DELETE FROM providers_visit 
WHERE source_system = '' 
OR provider_id = '' 
OR provider_name = '' 
OR provider_npi = '' 
OR visit_type_id = '' 
OR duration = '' 
OR dept_id = '' 
OR dept_name = '' 
OR appt_date = '' 
OR appt_time = ''; 

-- Preview data
SELECT * FROM providers_visit
LIMIT 10;

-- Sorted for provider_id
SELECT DISTINCT
	provider_id,
	visit_type,
    duration
FROM 
	providers_visit
ORDER BY provider_id;

-- Unique visit type and duration combinations for each provider
SELECT DISTINCT
	provider_id,
	provider_name,
	visit_type_id,
	visit_type,
    duration
FROM 
	providers_visit
WHERE provider_id = 1234;

-- Most frequetnly used durations for each visit type
SELECT 
    visit_type,
    duration
FROM 
(
SELECT visit_type, 
           duration,
           row_number() OVER (PARTITION BY visit_type ORDER BY duration_frequency DESC) AS row_num
FROM (SELECT visit_type,
		duration, 
		count(duration) AS duration_frequency
	FROM providers_visit
	GROUP BY 1, 2
	) AS frequency
) AS a
WHERE a.row_num = 1

