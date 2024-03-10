# 🏦 BTPN Syariah Credit Card Customer Churn Analysis
BTPN Syariah, a 70% owned subsidiary of BTPN, is the 12th Syariah bank in Indonesia, prioritizing financial inclusion by providing services to remote and low-income communities. Through its Daya program, the bank not only offers financial services but also provides essential financial education, promoting sustainable livelihoods and healthier communities.<br>

Source: [BTPN Syariah](https://www.btpnsyariah.com/)

## ⭐ **Introduction**
As a Data Engineer Intern at BTPN Syariah, facilitated by Rakamin Academy, i learned about the role of a Data Engineer at Bank BTPN Syariah, mastering skills and tools such T-SQL, Tableau, and others utilized by the bank in developing IT services to meet user needs. the primary objective of this project was to analyze customer profiles and characteristics related to churn. This analysis allowed for an examination of customer behavior based on demographic information, their relationship with the bank, and transaction history.

### Tools
![MicrosoftSQLServer](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)![Tableau](https://img.shields.io/badge/Tableau-E97627.svg?style=for-the-badge&logo=Tableau&logoColor=white)![Google Slides](https://img.shields.io/badge/Google%20Slides-FBBC04.svg?style=for-the-badge&logo=Google-Slides&logoColor=black)
- Query: Microsoft SQL Server ➡️ [Script](https://github.com/sergiolhx/credit-card-customer-churn-analysis/blob/main/btpn_syariah_scipt.sql) <br>
- Visualization: Tableau ➡️ [Dashboard](https://public.tableau.com/views/BTPNSyariah_17099906528150/Dashboard2?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link) <br>
- Report : Google Slides ➡️ [Slides](https://docs.google.com/presentation/d/1YCw3hoYsnySL7Tm59vRzfMVKu7C7_AsDB7WGpSSV7dI/edit?usp=sharing)<br>
- Dataset: BTPN Syariah x Rakamin ➡️ [Link](https://www.rakamin.com/virtual-internship-experience/data-engineer-btpn-syariah)

### Objectives
- Identify key drivers of credit card customer churn through analysis of historical data.
- Develop predictive models to forecast churn probability and enable proactive intervention strategies.
- Segment credit card customers based on churn propensity for targeted retention efforts.
- Optimize retention strategies by evaluating effectiveness and refining customer engagement tactics.

### Dataset
- status_db <br>
Dataset: <br>

| id | status            |
| -- | ----------------- |
| 1  | Existing Customer |
| 2  | Attrited Customer |

- marital_db <br>
Dataset: <br>

| id | Marital_Status |
| -- | -------------- |
| 1  | Married        |
| 2  | Single         |
| 3  | Unknown        |
| 0  | Divorced       |

- education_db <br>
Dataset: <br>

| id | Education_Level |
| -- | --------------- |
| 1  | High School     |
| 2  | Graduate        |
| 3  | Uneducated      |
| 4  | Unknown         |
| 5  | College         |
| 6  | Post-Graduate   |
| 7  | Doctorate       |

- category_db <br>
Dataset: <br>

| id | Card_Category |
| -- | ------------- |
| 1  | Blue          |
| 2  | Gold          |
| 3  | Silver        |
| 4  | Platinum      |

- customer_data_history <br>
Sample Dataset: <br>

| clientnum | status            | age | gender | dependent_count | education   | marital | income_category | card_category | months_on_book | total_relationship_count | months_inactive_12_mon | contacts_count_12_mon | credit_limit | total_revolving_bal | avg_open_to_buy | total_trans_amt | total_trans_ct | avg_utilization_ratio |
| --------- | ----------------- | --- | ------ | --------------- | ----------- | ------- | --------------- | ------------- | -------------- | ------------------------ | ---------------------- | --------------------- | ------------ | ------------------- | --------------- | --------------- | -------------- | --------------------- |
| 768805383 | Existing Customer | 45  | M      | 3               | High School | Married | $60K - $80K     | Blue          | 39             | 5                        | 1                      | 3                     | 12691        | 777                 | 11914           | 1144            | 42             | 0,06                  |
| 818770008 | Existing Customer | 49  | F      | 5               | Graduate    | Single  | Less than $40K  | Blue          | 44             | 6                        | 1                      | 2                     | 8256         | 864                 | 7392            | 1291            | 33             | 0,1                   |
| 713982108 | Existing Customer | 51  | M      | 3               | Graduate    | Married | $80K - $120K    | Blue          | 36             | 4                        | 1                      | 0                     | 3418         | 0                   | 3418            | 1887            | 20             | 0                     |


## ⭐ **Create Datamart**
### Base table
Base table is a table that contains raw or original data collected from its source and contains the information needed to answer questions or solve specific problems.
<details>
  <summary> Click to view Query </summary>
    <br>
  
```sql
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
```
<br>
</details>

### Aggregate table 
Aggregate table is a table created by collecting and calculating data from base table. This aggregate table contains more concise information and is used to analyze data more quickly and efficiently. The results from this table will be used as a source for creating data visualization
<br>
Result: [Click here](https://github.com/sergiolhx/credit-card-customer-churn-analysis/blob/main/aggregate_table_btpn_syariah.csv)

<details>
  <summary> Click to view Query </summary>
    <br>
  
```sql
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
```
<br>
</details>

## ⭐ **Visualization**
Export the aggregate table to CSV. Then, build a dashboard using the data from the aggregate table in Tableau. <br>
Result: [Click here](https://public.tableau.com/views/BTPNSyariah_17099906528150/Dashboard2?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link) <br>
<p align="center"> <img alt="dashboard" src="https://github.com/sergiolhx/credit-card-customer-churn-analysis/assets/149363611/41ecc6bf-f965-4f9c-8a0a-7ab0d6d79e41"><br>
</p>

Presentation Slides: [Google Slides](https://docs.google.com/presentation/d/1YCw3hoYsnySL7Tm59vRzfMVKu7C7_AsDB7WGpSSV7dI/edit?usp=sharing)
