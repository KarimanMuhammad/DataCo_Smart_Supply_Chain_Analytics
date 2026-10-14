# 📦 DataCo Smart Supply Chain Analytics

An end-to-end data analytics project focused on analyzing supply chain operations, sales performance, profitability, customer behavior, product performance, and delivery risk using **Python, SQL, and Power BI**.

The project transforms a large supply chain dataset into meaningful business insights through data cleaning, exploratory analysis, analytical queries, interactive dashboards, and data-driven recommendations.

## 🎯 Project Objectives

-  Evaluate overall sales and profitability performance.
-  Analyze customer activity and market-level business performance.
-  Identify top-performing products and investigate product profitability.
-  Examine shipping performance and delivery risk patterns.
-  Translate analytical findings into actionable business recommendations.

## 🛠️ Tools & Technologies

- 🐍 **Python:** Pandas, NumPy, data cleaning, feature engineering, and exploratory data analysis.
- 🗄️ **SQL:** Structured queries and business-focused data analysis.
- 📊 **Power BI:** DAX measures, KPI cards, interactive visualizations, and dashboard development.

## 📂 Dataset

**Dataset:** DataCo SMART SUPPLY CHAIN FOR BIG DATA ANALYSIS

**Source:** [Kaggle Dataset](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)

The dataset contains order, customer, product, sales, profit, and shipping information for supply chain analysis.

- 📏 **Original dataset size:** 180,519 records and 53 columns.
- 🧹 **Prepared analytical dataset:** 180,519 records and 44 columns.
- 🔍 **Data quality checks:** Missing values and duplicate records were examined during cleaning and preparation.

The dataset is not included in this repository because of its size. Download it from the original source and review its license before using or redistributing it.

## 🔄 Project Workflow

### 1. 🧹 Data Cleaning & Preparation — Python

- Inspected the dataset structure, dimensions, data types, and data quality.
- Examined missing values and duplicate records.
- Cleaned and transformed the data for downstream analysis.
- Prepared an analytical dataset with 44 columns.
- Created additional analytical features related to shipping delays and customer ordering behavior.

### 2. 🔎 Exploratory Data Analysis — Python

Analyzed the prepared data to understand:

- 💰 Overall sales, profit, and order volume.
- 🏆 Product and category performance.
- 👥 Customer activity and repeat-order behavior.
- 🌍 Market-level performance.
- 🚚 Shipping duration and delivery risk patterns.

### 3. 🗄️ SQL Analysis

Organized SQL-based analysis around business questions, including sales and profitability, product performance, customer behavior, and shipping operations.

### 4. 📊 Power BI Dashboard Development

Developed a five-page interactive dashboard to present the analysis through KPIs, charts, comparisons, and business insights.

### 5. 💡 Business Insights & Recommendations

Interpreted analytical results to highlight performance gaps, investigate potential operational issues, and support data-driven decision-making.

## 📈 Key Business Metrics

| Metric | Project Result |
|---|---:|
|  Total Sales | 36.78M |
|  Recorded Profit | 3.97M |
|  Total Orders | 65,752 |
|  Total Customers | 20,652 |
|  Products | 118 |
|  Order Items / Records | 180,519 |
|  Recorded Profit Margin | 10.78% |

*Values are based on the project's prepared dataset and calculations. Profitability and delivery metrics should be interpreted according to their underlying measure definitions.*

## 📊 Power BI Dashboard

The dashboard consists of five pages, each focusing on a different business area.

### 1. 📍 Overview

Provides a high-level summary of supply chain performance through key KPIs and overview visualizations.

![Overview Dashboard](<screenshots/Overview.png>)


### 2. 🏆 Product Performance

Analyzes product and category performance to identify major sales contributors and investigate profitability differences.

![Product Performance Dashboard](<screenshots/Product Performance.png>)

### 3. 👥 Customer & Market Analysis

Explores customer activity and compares business performance across markets to identify differences in sales and profitability.

![Customer and Market Analysis](<screenshots/Customer & Market Analysis.png>)

### 4. 🚚 Shipping & Delivery Performance

Examines shipping modes, delivery indicators, and shipping duration to identify delivery risks and operational improvement opportunities.

![Shipping and Delivery Performance](<screenshots/Shipping & Delivery Performance.png>)

### 5. 💡 Business Insights & Recommendations

Presents key findings and business recommendations to connect analytical results with potential actions for improving business performance.

![Business Insights and Recommendations](<screenshots/Business Insights & Recommendations.png>)


## 🗂️ Repository Structure

```text
DataCo_Smart_Supply_Chain_Analytics/
├── notebooks/
├── sql/
├── powerbi/
├── screenshots/
├── data/
└── README.md 
```

-  `notebooks/` — Python notebooks for data cleaning, preparation, and analysis.
-  `sql/` — SQL queries used for the project.
-  `powerbi/` — Power BI dashboard file.
-  `screenshots/` — Dashboard page screenshots displayed in this README.
-  `data/` — Dataset source information and download instructions.


## 💡 Key Takeaways

This project demonstrates an end-to-end analytical workflow, from preparing a large dataset and exploring business performance to building an interactive Power BI dashboard and communicating actionable findings.

It combines technical data analysis with business-focused interpretation to investigate supply chain performance across sales, products, customers, markets, and delivery operations.

## 👩‍💻 Author
**Kariman Abdelmajed**
<a href="https://www.linkedin.com/in/kariman-muhammad/" target="_blank">
  <img src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="Kariman Muhammad LinkedIn" height="30" width="40" />
</a> 


