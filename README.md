# Gym Membership Retention & Churn Intelligence

## Project Overview

A data analytics project focused on understanding gym member retention churn risk engagement and membership behavior.

The project combines SQL analysis with Power BI to transform raw membership data into actionable insights for identifying high risk members and supporting retention strategies.

## Business Problem

Gym businesses need to understand why members leave and identify members who may be at risk of churning.

This project analyzes member profiles membership history payments and attendance data to identify churn patterns and highlight members requiring attention.

## Objectives

- Analyze member retention and churn behavior
- Identify members with high and medium churn risk
- Analyze membership and payment patterns
- Understand member attendance and engagement
- Analyze churn probability by fitness goal and city
- Build an interactive Power BI dashboard
- Use SQL for structured data analysis

## Dataset

The project uses four CSV datasets:

- `members.csv` — Member demographic and profile information
- `memberships.csv` — Membership plans duration pricing and discounts
- `payments.csv` — Payment transactions and payment status
- `attendance.csv` — Member visits workout types and check-in information

## Tools & Technologies

- SQL
- Power BI
- Microsoft Excel
- Data Cleaning
- Data Analysis
- Data Visualization
- DAX

## Analysis Performed

### Member Analysis

Analyzed member demographics fitness goals cities lead sources and membership status.

### Membership Analysis

Analyzed membership plans duration pricing discounts and final membership prices.

### Payment Analysis

Analyzed payment amounts payment methods payment dates and payment status.

### Attendance Analysis

Analyzed gym visits check-in times workout types and member engagement patterns.

### Churn Risk Analysis

Analyzed member churn probability and categorized members into different risk levels.

The dashboard highlights high risk members who may require immediate attention and trainer follow-up.

## Power BI Dashboard

The interactive dashboard provides:

- Total Active Members
- High Risk Members
- Medium Risk Members
- Average Churn Probability
- Member Risk Distribution
- Churn Probability by Fitness Goal
- Churn Risk by City
- Members Requiring Immediate Attention
- Recommended Actions
- Risk Level filters
- City filters
- Fitness Goal filters

## Dashboard Preview

![Gym Churn Dashboard](dashboard/gym_churn_dashboard.png)

## Key Insights

The dashboard provides visibility into:

- Overall active membership
- Distribution of members across risk levels
- Churn probability across different fitness goals
- Differences in churn risk across cities
- Members requiring immediate retention attention
- Recommended follow-up actions for high risk members

## Project Structure

```text
GYM_MEMBERSHIP_CHURN_RETENTION_ANALYSIS
│
├── attendance.csv
├── members.csv
├── memberships.csv
├── payments.csv
│
├── sql
│   └── gym_analysis.sql
│
├── dashboard
│   └── gym_churn_dashboard.png
│
└── README.md
