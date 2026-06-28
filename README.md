# 🏥 Akwaaba Health Insurance Company PLC

## Insurance Risk Analytics & Business Intelligence Platform

![Python](https://img.shields.io/badge/Python-Data%20Science-blue?style=for-the-badge&logo=python)
![Jupyter](https://img.shields.io/badge/Jupyter-Analysis-orange?style=for-the-badge&logo=jupyter)
![BigQuery](https://img.shields.io/badge/Google%20BigQuery-Data%20Warehouse-blue?style=for-the-badge&logo=googlebigquery)
![PowerBI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?style=for-the-badge&logo=powerbi)
![Streamlit](https://img.shields.io/badge/Streamlit-Application-red?style=for-the-badge&logo=streamlit)
![Status](https://img.shields.io/badge/Project-In%20Progress-green?style=for-the-badge)

---

## 📌 Project Overview

Akwaaba Health Insurance Company PLC (AHICP) is a fictional healthcare insurance company inspired by the structure and operations of Ghanaian corporate health insurance providers.

This end-to-end Data Analytics and Data Science project simulates the work of an internal analytics team responsible for transforming raw insurance data into strategic business intelligence — built independently and personalized with original analytical decisions, distinct from any reference implementation.

The company is experiencing increasing healthcare claim expenses and requires a data-driven system to identify high-risk customers and corporate organizations before excessive financial exposure occurs.

---

# 🎯 Business Problem

The company currently lacks a standardized risk assessment framework for evaluating:

- Individual employees
- Corporate organizations
- Insurance products
- Claims behavior

This limitation affects:

- Premium pricing decisions
- Underwriting effectiveness
- Fraud detection capabilities
- Claims management
- Long-term financial sustainability

---

# 🧠 Project Goals

The project aims to develop a custom **Insurance Risk Score Engine** capable of:

✅ Identifying high-risk employees
✅ Evaluating high-cost corporate clients
✅ Measuring claim-to-premium profitability
✅ Detecting suspicious claim patterns
✅ Forecasting future claims and financial exposure
✅ Supporting strategic insurance decision-making

### Additional Objectives Identified During Cleaning

Beyond the original business problem, the following objectives emerged directly from patterns found during data profiling and cleaning — and are unique to this implementation:

- **Renewal risk** — identifying corporate clients in "Pending Renewal" status likely to churn
- **Premium collection risk** — flagging clients with a history of late or pending payments
- **Pricing accuracy gap** — quantifying the mismatch between declared staff estimates at application and actual enrolled headcount, and its effect on pricing risk
- **Claims workflow efficiency** — measuring approval-to-payout duration for the subset of claims with full workflow records
- **Beneficiary designation risk** — flagging the structural gap where every employee record assumes exactly one beneficiary at 100% allocation, with no support for multiple beneficiaries or none at all
- **Industry-level risk patterns** — comparing claims behavior across client industries (Telecom, Banking, Mining, Manufacturing, Education)

---

# 🏗️ Analytics Architecture

```text
                Raw Insurance Data (Excel)
                        │
                        ▼
             Python + Jupyter Notebook
          (Data Profiling & Data Cleaning)
                        │
                        ▼
         ETL: Clean, Normalize, Split Entities
                        │
                        ▼
             Google BigQuery Data Warehouse
                        │
                        ▼
              Power BI Business Dashboards
                        │
                        ▼
        Machine Learning Risk Prediction Model
                        │
                        ▼
          Streamlit Insurance Analytics App
```

---

# 🗂️ Dataset Overview

## Raw Source Sheets

| Sheet             | Records | Notes                                                                                                       |
| ----------------- | ------: | ----------------------------------------------------------------------------------------------------------- |
| Corporate Clients |      70 | Mixed company + branch + policy data (split during cleaning)                                                |
| Covered Employees |   1,974 | Individual employee demographics and risk factors                                                           |
| Claims            |   2,500 | Healthcare claim history and financial exposure                                                             |
| Policy Table      |      70 | Policy lifecycle (start/end dates, status) — **retained**, unlike reference implementations that dropped it |
| Premium Payments  |     420 | Actual billed/paid transaction history                                                                      |
| Branch Table      |      70 | Branch-to-company mapping (rebuilt with proper foreign keys)                                                |
| Claim Workflow    |     165 | Claims processing operational data (partial coverage only)                                                  |
| Beneficiaries     |   1,974 | Beneficiary designations — flagged data limitations                                                         |
| Risk Scores       |   1,974 | Placeholder table — to be populated in feature engineering                                                  |

## Cleaned, Normalized Tables

| Table                | Records | Primary Key      | Links To                          |
| -------------------- | ------: | ---------------- | --------------------------------- |
| `companies`          |       7 | `Company_ID`     | —                                 |
| `branches`           |      70 | `Branch_ID`      | `companies`                       |
| `corporate_policies` |      70 | `Corporate_ID`   | `companies`, `branches`           |
| `covered_employees`  |   1,974 | `Employee_ID`    | `corporate_policies`              |
| `claims`             |   2,500 | `Claim_ID`       | `covered_employees`               |
| `policy_table`       |      70 | `Policy_ID`      | `corporate_policies`              |
| `premium_payments`   |     420 | `Payment_ID`     | `corporate_policies`              |
| `claim_workflow`     |     165 | `Workflow_ID`    | `claims`                          |
| `beneficiaries`      |   1,974 | `Beneficiary_ID` | `covered_employees`               |
| `risk_scores`        |   1,974 | `Risk_ID`        | `covered_employees` (placeholder) |

---

# 🔎 Data Profiling Findings

### ✅ Strengths

- No missing values across any of the nine source sheets
- No duplicate records anywhere
- Strong relational ID structure underlying all tables
- Clear separation between customers, claims, premiums, and operations achievable through normalization

### ⚠️ Data Issues Identified

- Date columns stored as text, requiring conversion to proper `datetime`
- Corporate Clients table mixed company identity, branch location, and policy/pricing data in a single table
- Branch Table fully duplicated information already present in Corporate Clients
- Employee names contained embedded titles (`Mr.`, `Mrs.`, `Ms.`, `Dr.`, `Miss`) and suffixes (`MD`, `DVM`, `DDS`, `PhD`, `Jr.`), verified by full-column scan rather than assumption
- `Number_of_Staff` did not reflect actual enrolled headcount (verified against Covered Employees) — renamed to `Estimated_Headcount` to accurately reflect that it is a declared, pricing-stage estimate, not a verified count
- `Gender` column showed only a ~50.5% match rate against name-implied gender — statistically consistent with random assignment, indicating no reliable derivation is possible; retained unchanged and documented, with an exploratory `Gender_Guess` column added separately
- `Claims.Corporate_ID` was fully redundant (100% derivable via `Employee_ID`) and was dropped
- `Policy Table.Insurance_Product` fully duplicated `corporate_policies` and was dropped
- `Claim Workflow` covers only 165 of 2,500 claims (6.6%), with no identifiable pattern explaining the gap — documented as a genuine data limitation
- `Beneficiaries.Allocation_Percentage` is constant at 100% across all 1,974 records, and `Beneficiary_Name` appears to be templated rather than genuine — both documented as structural limitations with real business risk implications (no support for multiple beneficiaries or zero-beneficiary cases)
- `Risk Scores` contains only identifiers, with no actual score data — confirmed as an intentional placeholder for the feature engineering phase

---

# 🧹 Data Cleaning & Transformation Pipeline (Completed)

### Entity Splitting & Normalization

- Split Corporate Clients into `companies` (client identity) and `corporate_policies` (policy/pricing terms)
- Rebuilt `branches` as a proper entity linked to `companies` via `Company_ID`, rather than repeating company name text
- Retained `Policy Table` for policy lifecycle tracking (start date, end date, status) — a deliberate divergence from reference implementations that dropped it, justified by its necessity for renewal and retention analysis

### Standardization

- Converted all date fields across every table to proper `datetime` types
- Extracted employee titles and suffixes into dedicated `Employee_Title` and `Employee_Suffix` columns, verified against the full dataset rather than assumed patterns
- Cleaned `Employee_Name` to a consistent `First Last` format

### Data Quality Documentation

Rather than silently dropping or "fixing" values with no reliable ground truth, the following were retained and explicitly documented in-notebook:

- `Gender` vs. `Gender_Guess` distinction and limitation
- `Number_of_Staff` → `Estimated_Headcount` rename rationale
- `Claim Workflow` partial coverage
- `Beneficiaries` allocation and naming limitations
- `Risk Scores` placeholder status

### Entity Relationship Diagram

A full ERD was produced (via dbdiagram.io / DBML) reflecting the final ten-table structure and all primary/foreign key relationships.

---

# 📊 Planned Power BI Dashboards

## Executive Dashboard

- Total revenue, total claims, profitability trends
- High-risk corporate clients
- Renewal risk by policy status

## Customer Risk Dashboard

- Employee risk categories, claims behavior, demographic analysis
- Industry-level risk comparison

## Operations Dashboard

- Claim processing performance (for claims with workflow data)
- Approval and payout delays
- Premium payment timeliness by client

---

# 🤖 Machine Learning Objectives

Predictive models will be developed to estimate:

- Customer risk scores
- Future claim costs
- Probability of high-cost claims
- Corporate profitability risk
- Renewal/churn likelihood

Potential models include regression models, classification algorithms, and ensemble methods.

---

# 📁 Project Structure

```text
AHICP/
│
├── data/
│   ├── raw/
│   │   └── Akwaaba_Insurance_Dataset.xlsx
│   │
│   └── processed/
│       └── (cleaned tables exported here, e.g. .csv / .parquet)
│
├── notebooks/
│   ├── 01_Data_Profiling.ipynb
│   └── 02_Data_Cleaning.ipynb
│
├── scripts/
│
├── powerbi/
│
├── streamlit_app/
│
├── requirements.txt
│
├── .gitignore
│
└── README.md
```

> **Note:** A dedicated feature engineering notebook was intentionally not created as a separate step before warehousing. Following standard modern data practice, cleaned tables are loaded directly into BigQuery, with feature engineering performed downstream in SQL/BigQuery and Power BI — closer to a real-world ELT pattern once data reaches the warehouse layer.

---

# 🚀 Project Status

| Phase                             | Status         |
| --------------------------------- | -------------- |
| Data Profiling                    | ✅ Completed   |
| Data Cleaning & Standardization   | ✅ Completed   |
| Entity Relationship Diagram       | ✅ Completed   |
| ETL & Load into BigQuery          | 🔄 In Progress |
| Feature Engineering (in BigQuery) | ⏳ Pending     |
| Power BI Dashboard                | ⏳ Pending     |
| Machine Learning Risk Model       | ⏳ Pending     |
| Streamlit Deployment              | ⏳ Pending     |

---

## 👨‍💻 Author

**Data Analyst & Data Scientist Portfolio Project**

Designed as an end-to-end simulation of a healthcare insurance analytics team building a modern data platform for risk management, profitability analysis, and strategic decision-making — personalized with independent analytical and design decisions, including Ghanaian business context.
