# 📊 E-Commerce Funnel Optimization & Conversion Analytics

## 🔗 Live Dashboard

👉 **[Click here to explore the interactive Power BI dashboard](https://app.powerbi.com/view?r=eyJrIjoiZGM3OTI4M2ItYWJiMS00MDVlLTgyYTQtYzE1NTE0YWU3YjZhIiwidCI6IjVlN2I1ODA0LTEyZmYtNDM0OC1hODFlLWQ5MDAwNjM0MGM5NiJ9)**  
_(Best viewed on desktop)_

![E-Commerce Conversion Dashboard](https://github.com/user-attachments/assets/fd228be3-0757-42b0-b3f5-dbae01079ac7)

---

## 🧠 Overview

This project analyzes the performance of a fictional e-commerce platform using **Python**, **SQL**, and **Power BI**. It explores customer behavior from first visit to confirmed purchase, focusing on:

- Where users drop off in the purchase funnel  
- Which segments convert best and drive the most revenue  
- When users are most likely to buy  
- How to improve the checkout experience and campaign timing  

> 🔧 Tools Used: **Python, SQL (MySQL), Power BI**

---

## 📁 Datasets

| Dataset           | Description                                                     |
|------------------|-----------------------------------------------------------------|
| `users.csv`       | Device type, traffic source, user type, and location per user   |
| `clickstream.csv` | 10K+ clickstream logs of page views, session steps, timestamps |
| `transactions.csv`| 134 confirmed purchases with order values and timestamps        |

---

## 🎯 Objectives

1. **Understand funnel drop-offs** from homepage to confirmed purchase  
2. **Segment performance** by device, traffic source, user type, and location  
3. **Analyze revenue and conversion trends**  
4. **Deliver actionable insights for product and marketing**  

---

## 🔄 End-to-End Pipeline

### 🐍 Python: Data Cleaning & KPI Engineering

- Cleaned and merged all datasets  
- Calculated funnel metrics: conversion rate, repeat rate, revenue  
- Segmented by device type, traffic source, and geography  
- Visualized time-based behavior and funnel duration  

📂 *Coming soon: [View Python Code →](#)*

---

### 🧠 SQL: Structured KPI Queries

- Built schema and tables in `ecommerce_project`  
- Queried conversion, AOV, funnel steps, and segment behavior  
- Used `TIMESTAMPDIFF()` to calculate time-to-convert metrics  

📂 *Coming soon: [View SQL Scripts →](#)*

---

### 📊 Power BI: Dashboard Pages

#### 📄 Page 1: Conversion & Revenue Summary
- KPI Cards, Funnel, Revenue by Country/Device  
- Drop-off Insight Cards  

#### 📄 Page 2: Segment Performance
- AOV & Conversion Rate by Segment  
- Purchase Time Trends (hour/day)  
- Interactive filters by device, traffic, user type  

📷 Preview:

![Segment-Level Insights](https://github.com/user-attachments/assets/3302fe33-f37f-4e65-94b9-aa9ec54f6645)

---

## 📌 Key Results

| Metric               | Value         |
|----------------------|---------------|
| Total Users          | 200           |
| Converted Users      | 101           |
| Conversion Rate      | **50.5%**     |
| Repeat Purchase Rate | **24.8%**     |
| Total Revenue        | **$20,078.97**|
| Avg. Order Value     | **$149.84**   |

---

## 🔍 Business Insights

### 🧭 Funnel Drop-Off  
- 49% of users abandon at the checkout step  
- 198 reached purchase page → only 101 completed purchase  

🎯 *Action:* Simplify mobile/tablet checkout flow

---

### 📱 Device Breakdown

| Device  | Conversion Rate | Revenue  |
|---------|------------------|----------|
| Tablet  | **53.0%**        | $6.2K    |
| Mobile  | 47.1%            | **$7.4K**|
| Desktop | 51.6%            | $6.5K    |

🎯 *Action:* Prioritize UX testing on mobile

---

### 🚦 Traffic Source AOV

| Source       | AOV ($)   |
|--------------|-----------|
| Paid Search  | **167.44**|
| Email        | 133.03    |
| Organic      | 143.85    |

🎯 *Action:* Boost high-performing paid campaigns and improve email conversions

---

### ⏰ Time-Based Behavior

- Peak Purchase Hour: **8–9 PM**  
- Best Days: **Wed–Fri**  
- Avg. Time to Convert: **~29 hours**

🎯 *Action:* Trigger retargeting campaigns 24–36 hrs after first visit

---

## 🚀 Technologies Used

| Area         | Tools                        |
|--------------|------------------------------|
| Data Prep    | Python (Pandas, Seaborn)     |
| SQL          | MySQL                        |
| BI & Viz     | Power BI, DAX, Matplotlib    |
| Dashboarding | Filters, drilldowns, slicers |

---

## ⭐ Support

If you like this project:
- ⭐ Star this repository
- 🔗 Share it on LinkedIn
- 🤝 Let’s connect and collaborate!
