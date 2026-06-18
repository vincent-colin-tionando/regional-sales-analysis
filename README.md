# Regional Sales Performance Analysis

## Overview

This project analyzes sales performance across multiple regions, states, and cities of a large U.S. supermarket chain using transaction data. The objective is to identify underperforming branches and prioritize locations that require operational improvements.

The analysis follows a structured drill-down approach:

**Region → State → City**

This method helps narrow down performance issues from a national level to specific locations where corrective actions can have the greatest impact.

---

## Business Problem

Management wants to determine which branches have the weakest sales performance and should be prioritized for investigation.

Instead of reviewing thousands of transactions individually, this project develops a KPI-driven framework to identify:

* Underperforming regions
* High-risk states
* Priority cities requiring immediate attention
* Potential causes of low sales performance

---

## Dataset

### Source

Supermarket Sales Dataset

### Dataset Summary

| Metric                 | Value           |
| ---------------------- | --------------- |
| Raw Records            | 9,800           |
| Cleaned Records        | 9,799           |
| Columns                | 18              |
| Missing Values         | 11 Postal Codes |
| Duplicate Rows Removed | 1               |

### Main Features

#### Order Information

* Order ID
* Order Date
* Ship Date
* Ship Mode

#### Customer Information

* Customer ID
* Customer Name
* Segment
* Region
* State
* City

#### Product Information

* Product ID
* Category
* Sub-Category
* Product Name
* Sales

---

## Tools & Technologies

| Tool             | Purpose                               |
| ---------------- | ------------------------------------- |
| Python           | Data Cleaning & EDA                   |
| Pandas           | Data Manipulation                     |
| PostgreSQL       | Data Storage & SQL Analysis           |
| SQL              | KPI Calculation & Drill-Down Analysis |
| Power BI         | Dashboard Development                 |
| Gamma            | Executive Presentation                |
| Jupyter Notebook | Analysis Environment                  |

---

## Project Workflow

### 1. Data Preparation in Python

Performed initial data quality assessment and cleaning:

* Loaded dataset using Pandas
* Reviewed structure using `info()` and `describe()`
* Identified missing values
* Removed duplicate records
* Standardized column names to snake_case
* Prepared data for database integration

### 2. Data Cleaning

#### Missing Values

* Detected 11 missing Postal Code records
* Imputed values using Vermont Postal Code reference

#### Duplicate Records

* Identified duplicated transactions
* Retained one valid record
* Removed duplicate entries

### 3. Database Integration

* Connected Python to PostgreSQL
* Loaded cleaned dataset into database tables
* Prepared environment for SQL analysis

### 4. SQL-Based Business Analysis

Developed KPI calculations and drill-down analysis using SQL.

#### Key Performance Indicators (KPIs)

**AOV (Average Order Value)**

```text
AOV = Total Sales / Number of Orders
```

**SPC (Sales Per Customer)**

```text
SPC = Total Sales / Number of Customers
```

**OPC (Orders Per Customer)**

```text
OPC = Number of Orders / Number of Customers
```

#### Drill-Down Framework

##### Layer 1: Region Analysis

Compared:

* Total Sales
* AOV
* SPC
* OPC

Result:

* South Region identified as the lowest sales contributor
* Selected for deeper investigation

##### Layer 2: State Analysis

Analyzed states within the South Region.

Key findings:

* Tennessee: Largest AOV gap
* North Carolina: High order volume but low AOV
* Florida: Largest revenue contributor but still classified as Critical

##### Layer 3: City Analysis

Investigated priority states at city level.

Identified high-priority locations:

1. Miami, Florida
2. Jacksonville, North Carolina
3. Tennessee (state-wide structural issue)

---

## Power BI Dashboard

The Power BI dashboard provides an interactive view of sales performance.

### Dashboard Features

#### Executive KPIs

* Total Sales
* Number of Orders
* Number of Customers
* Average Order Value
* Sales Per Customer
* Orders Per Customer

#### Regional Analysis

* Sales by Region
* KPI Status Comparison
* Benchmark Analysis

#### State Drill-Down

* State Performance Ranking
* Critical vs Warning States
* KPI Gap Analysis

#### City Analysis

* Priority Cities
* Sales Performance Distribution
* AOV Benchmark Comparison

---

## Key Findings

### Region Level

* South Region generated the lowest sales revenue.
* East Region was the only region classified as Healthy.
* Central Region showed the weakest KPI performance overall.

### State Level

* Six states were classified as Critical.
* Tennessee had the largest AOV gap.
* Florida contributed 22.7% of South Region sales but remained Critical.
* North Carolina showed strong order volume but weak transaction value.

### City Level

#### Highest Priority Locations

**Miami, Florida**

* High order volume
* Low AOV
* Large revenue improvement opportunity

**Jacksonville, North Carolina**

* Highest order volume among critical NC cities
* Significant AOV gap

**Tennessee**

* Structural issue across the entire state
* Low AOV observed in all cities

---

## Business Recommendations

### 1. Review Product Mix in Tennessee

Investigate whether low-value products or aggressive discounting are driving poor AOV performance.

### 2. Audit Miami and Jacksonville (NC)

Focus on increasing transaction value in high-volume branches.

### 3. Improve Customer Retention

Evaluate loyalty programs in Louisiana and Arkansas where repeat purchases are extremely low.

### 4. Replicate Best Practices

Use Jacksonville (Florida) and the East Region as internal benchmarks for successful branch operations.

---

## Results

### Priority Locations for Immediate Action

| Priority | Location                     | Reason                      |
| -------- | ---------------------------- | --------------------------- |
| 1        | Miami, Florida               | High volume, low AOV        |
| 2        | Jacksonville, North Carolina | High volume, low AOV        |
| 3        | Tennessee                    | State-wide structural issue |
| 4        | Hialeah & Hollywood, Florida | Large AOV gap               |
| 5        | Wilmington, North Carolina   | Largest AOV gap in NC       |

---

## Project Structure

```text
project/
│
├── data/
│   ├── raw_data.csv
│   └── cleaned_data.csv
│
├── notebooks/
│   ├── data_cleaning.ipynb
│   ├── exploratory_data_analysis.ipynb
│   └── database_integration.ipynb
│
├── sql/
│   ├── region_analysis.sql
│   ├── state_analysis.sql
│   └── city_analysis.sql
│
├── dashboard/
│   └── regional_sales_dashboard.pbix
│
├── reports/
│   └── regional_sales_performance_analysis.pdf
│
├── presentation/
│   └── executive_presentation.pdf
│
└── README.md
```

---

## How to Run

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/regional-sales-performance-analysis.git
```

### 2. Install Dependencies

```bash
pip install pandas numpy sqlalchemy psycopg2 matplotlib seaborn
```

### 3. Execute Analysis

Run notebooks in sequence:

1. Data Cleaning
2. EDA
3. Database Integration

### 4. Execute SQL Scripts

Run SQL files in PostgreSQL:

* region_analysis.sql
* state_analysis.sql
* city_analysis.sql

### 5. Open Power BI Dashboard

Open:

```text
dashboard/regional_sales_dashboard.pbix
```

Refresh data connections if required.

---

## Skills Demonstrated

* Data Cleaning
* Exploratory Data Analysis (EDA)
* SQL Analytics
* KPI Development
* Drill-Down Analysis
* PostgreSQL
* Power BI Dashboarding
* Business Intelligence
* Data Storytelling
* Executive Reporting
