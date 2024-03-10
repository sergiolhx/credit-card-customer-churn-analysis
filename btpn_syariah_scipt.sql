-- Import data
-- Create base table

CREATE TABLE base_table (
		clientnum VARCHAR(50),
		status VARCHAR(50),
		age INT,
		gender VARCHAR(50),
		dependent_count INT,
		education VARCHAR(50),
		marital VARCHAR(50),
		income_category VARCHAR(50),
		card_category VARCHAR(50),
		months_on_book INT,
		total_relationship_count INT,
		months_inactive_12_mon INT,
		contacts_count_12_mon INT,
		credit_limit INT,
		total_revolving_bal INT,
		avg_open_to_buy INT,
		total_trans_amt INT,
		total_trans_ct INT,
		avg_utilization_ratio DECIMAL(10,2)
);


INSERT INTO base_table
SELECT
		h.CLIENTNUM,
		s.status,
		h.Customer_Age,
		h.Gender,
		h.Dependent_count,
		e.Education_Level,
		m.Marital_Status,
		h.Income_Category,
		c.Card_Category,
		h.Months_on_book,
		h.Total_Relationship_Count,
		h.Months_Inactive_12_mon,
		h.Contacts_Count_12_mon,
		ROUND(h.Credit_Limit, 0),
		ROUND(h.Total_Revolving_Bal, 0),
		ROUND(h.Avg_Open_To_Buy, 0),
		ROUND(h.Total_Trans_Amt, 0),
		ROUND(h.Total_Trans_Ct, 0),
		ROUND(h.Avg_Utilization_Ratio, 2)
	FROM customer_data_history AS h
	LEFT JOIN status_db AS s
		ON h.idstatus = s.id
	LEFT JOIN education_db AS e
		ON h.Educationid = e.id
	LEFT JOIN category_db AS c
		ON h.card_categoryid = c.id
	LEFT JOIN marital_db AS m
		ON h.Maritalid = m.id;

--Churn Customer Percentage
SELECT 
	status, 
	COUNT(status) as total,
	ROUND(COUNT(status) * 100 / (SELECT COUNT (*) FROM base_table), 2) AS percentage
FROM base_table
GROUP BY status;

--Create Churn Customer Table
CREATE TABLE churn_table (
		age_category VARCHAR(50),
		gender VARCHAR(50),
		dependent_count INT,
		education VARCHAR(50),
		marital VARCHAR(50),
		income_category VARCHAR(50),
		card_category VARCHAR(50),
		years_on_book VARCHAR(50),
		total_relationship_count INT,
		months_inactive_12_mon INT,
		contacts_count_12_mon INT,
		credit_limit INT,
		total_revolving_bal INT,
		avg_open_to_buy INT,
		total_trans_amt INT,
		total_trans_ct INT,
		avg_utilization_ratio DECIMAL(10,2)
);

INSERT INTO churn_table
SELECT
		CASE
			WHEN age <= 29 THEN '20s'
			WHEN age <= 39 THEN '30s'
			WHEN age <= 49 THEN '40s'
			WHEN age <= 59 THEN '50s'
			WHEN age <= 69 THEN '60s'
			WHEN age >= 70 THEN '70+'
		END age_category,
		gender,
		dependent_count,
		education,
		marital,
		income_category,
		card_category,
		CASE
			WHEN months_on_book <= 24 THEN '1 - 2'
			WHEN months_on_book <= 36 THEN '2 - 3'
			WHEN months_on_book <= 48 THEN '3 - 4'
			WHEN months_on_book <= 60 THEN '4 - 5'
			WHEN months_on_book <= 72 THEN '6 - 7'
		END years_on_book,	
		total_relationship_count,
		months_inactive_12_mon,
		contacts_count_12_mon,
		credit_limit,
		total_revolving_bal,
		avg_open_to_buy,
		total_trans_amt,
		total_trans_ct,
		avg_utilization_ratio
FROM base_table
WHERE status = 'Attrited Customer'

-- --------------------
-- Customer Demographic
-- --------------------

-- Age
SELECT age_category, COUNT(*) AS total
FROM churn_table
GROUP BY age_category
ORDER BY 1 

-- Gender 
SELECT gender, COUNT(*) AS total
FROM churn_table
GROUP BY gender
ORDER BY 2 DESC

-- Education
SELECT education, COUNT(*) AS total
FROM churn_table
GROUP BY education
ORDER BY 2 DESC

-- Marital Status
SELECT marital, COUNT(*) AS total
FROM churn_table
GROUP BY marital
ORDER BY 2 DESC

-- Income
SELECT income_category, COUNT(*) AS total
FROM churn_table
GROUP BY income_category
ORDER BY 2 DESC

-- Dependent Count
SELECT dependent_count, COUNT(*) AS total
FROM churn_table
GROUP BY dependent_count
ORDER BY 2 DESC

-- --------------------
-- Customer Credit Card
-- --------------------

-- Card Category
SELECT card_category, COUNT(*) AS total
FROM churn_table
GROUP BY card_category
ORDER BY 2 DESC

--  Years on Book
SELECT years_on_book, COUNT(*) AS total
FROM churn_table
GROUP BY years_on_book
ORDER BY 1 