# Power BI – Executive Sales & Finance Dashboard

## Overview
End-to-end BI project demonstrating data modeling, DAX, RLS, and executive reporting
using a Superstore dataset. Designed as a production-style Power BI solution.

## Tech Stack
- Power BI Desktop
- Azure SQL (simulated warehouse layer)
- SQL (views, staging, semantic layer)
- DAX (time intelligence)
- Power Query
- Row-Level Security (RLS)
- Figma

## Key Features
- Star schema (FactSales + dimensions)
- Incremental-ready date model
- Advanced DAX (YoY, % of total, benchmarks)
- RLS based on user-to-region mapping
- Drillthrough pages with filter context summary
- Custom design created in Figma

## Pages
1. Executive Overview – KPIs, trends, drivers
2. Drillthrough Detail Page
3. Security-aware views

## Security
Row-Level Security implemented on dimension level using USERPRINCIPALNAME().

## How to use
1. Open PBIX in Power BI Desktop
2. Review data model
3. Explore DAX measures
