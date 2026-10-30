# Credit Card Fraud Analysis Using MySQL

## Project Overview

This project focuses on analyzing credit card transactions to identify fraudulent activities and understand transaction patterns using **MySQL**.

The dataset was collected from Kaggle, initially converted into Excel format for data inspection and preparation, and then imported into MySQL for data exploration and analysis.

The primary goal is to identify fraud patterns, measure the fraud rate, explore transaction behavior, and extract meaningful insights through SQL queries.

## Project Objectives

- Analyze credit card transaction data using SQL.
- Identify fraudulent and non-fraudulent transactions.
- Calculate the overall fraud rate.
- Explore transaction patterns across different categories.
- Identify high-risk transaction behaviors.
- Generate meaningful business insights from the dataset.

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Kaggle | Dataset collection |
| Microsoft Excel | Data inspection and preparation |
| MySQL | Data storage, querying, and analysis |
| MySQL Workbench | SQL development environment |

## Dataset

**Source:** Kaggle

The dataset contains credit card transaction records with information about transaction amounts, timestamps, merchant categories, customer details, and fraud labels.

### Key Attributes

- `trans_date_trans_time` – Transaction date and time
- `cc_num` – Credit card number
- `merchant` – Merchant information
- `category` – Transaction category
- `amt` – Transaction amount
- `gender` – Customer gender
- `city` – Customer city
- `state` – Customer state
- `job` – Customer occupation
- `dob` – Date of birth
- `is_fraud` – Fraud indicator (0 = Non-Fraud, 1 = Fraud)

## Data Preparation Workflow

1. Collected the credit card transaction dataset from Kaggle.
2. Converted the dataset into Excel format.
3. Inspected the dataset and its column structure.
4. Prepared the data for database import.
5. Imported the dataset into MySQL.
6. Created the `fraud_case` database and `fraud_raw` table.
7. Performed SQL-based data exploration and analysis.

## SQL Analysis

The project includes the following analytical operations:

- **Data Exploration:** Examining dataset structure and transaction records.
- **Fraud Detection Analysis:** Identifying fraudulent transactions.
- **Fraud Rate Calculation:** Measuring the percentage of fraudulent transactions.
- **Transaction Analysis:** Exploring transaction amounts and patterns.
- **Category Analysis:** Analyzing fraud distribution across merchant categories.
- **Time-Based Analysis:** Exploring transaction trends over time.
- **Comparative Analysis:** Comparing fraudulent and non-fraudulent transactions.

### Key SQL Concepts Used

- SELECT, WHERE, ORDER BY
- GROUP BY and HAVING
- Aggregate Functions (COUNT, SUM, AVG)
- CASE Statements
- Subqueries
- Common Table Expressions (CTEs)
- Date and Time Functions
- Window Functions

## Key Findings

The analysis identified the following transaction distribution:

| Metric | Result |
|---|---:|
| Total Transactions | 140,182 |
| Non-Fraud Transactions | 139,569 |
| Fraudulent Transactions | 613 |
| Fraud Rate | 0.44% |

The results show that fraudulent transactions represent a small proportion of the overall transaction dataset, highlighting the importance of analyzing transaction patterns rather than relying only on total transaction volume.

## Project Structure

```text
Credit-Card-Fraud-Analysis/
│
├── Dataset/
│   └── fraud_dataset.xlsx
│
├── SQL/
│   └── fraud_analysis.sql
│
├── Screenshots/
│   └── analysis_results/
│
└── README.md
```


## Learning Outcomes

Through this project, I gained practical experience in:

- Working with real-world datasets from Kaggle.
- Preparing and handling data using Excel.
- Importing datasets into MySQL.
- Writing SQL queries for analytical purposes.
- Performing fraud-related exploratory data analysis.
- Extracting insights from large transaction datasets.

## Future Improvements

- Build an interactive fraud analysis dashboard.
- Perform advanced fraud detection using Python.
- Apply Machine Learning classification algorithms.
- Develop predictive models to identify potentially fraudulent transactions.

---

**Project Type:** SQL Data Analysis  
**Domain:** Financial Data / Fraud Detection  
**Database:** MySQL  
**Dataset Source:** Kaggle
