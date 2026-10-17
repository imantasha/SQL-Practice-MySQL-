# SQL Practice Portfolio: E-Commerce Sales Analysis

Hands-on SQL analysis of a relational e-commerce dataset (5 linked tables, 5,200 orders, 2022–2025). I wrote 60 queries covering joins, subqueries, window functions, date/string functions and CASE logic, then used them to answer business questions about revenue, shipping, returns and customers.

This is part of my transition into Data Analytics, alongside my MCA (AI & ML specialization) background.

## Business Questions

- Which categories, products and regions generate the most revenue?
- How healthy is order fulfilment: how many orders are cancelled, returned or shipped late?
- How do customer segments differ in spending, and how loyal are customers?
- Do discounts actually increase quantity sold?

## Dataset

A practice dataset simulating an e-commerce business (not real company data), with **5 linked tables**:

| Table | Rows | Description |
|---|---|---|
| `customers` | 600 | Customer demographics, signup date, segment, location |
| `products` | 217 | Product catalog across 8 categories with pricing and stock |
| `employees` | 30 | Sales employees with region and monthly targets |
| `orders` | 5,200 | Order-level transactions with status, payment method, shipping |
| `order_items` | 13,156 | Line-item detail per order (quantity, discount, line total) |

**Relationships (logical, joined on ID columns):**
- `orders.customer_id` → `customers.customer_id`
- `orders.employee_id` → `employees.employee_id`
- `order_items.order_id` → `orders.order_id`
- `order_items.product_id` → `products.product_id`

Data files are in the repository root as both `.xlsx` (original) and `.csv` (import-ready).

## Tools Used

- **MySQL**: database and query execution
- **MySQL Workbench**: CSV import and query development

## Skills Demonstrated

`SELECT / WHERE / GROUP BY / HAVING` · `INNER and LEFT JOINs (up to 4 tables)` · `Self-joins` · `Subqueries (correlated, EXISTS)` · `CTEs` · `Window functions (RANK, DENSE_RANK, ROW_NUMBER, LAG/LEAD, NTILE, running totals, moving averages)` · `Date and string functions` · `CASE logic` · `RFM and Pareto analysis`

## Key Findings

*Net revenue below means orders that were not Cancelled or Returned.*

**Revenue and products**
1. **Electronics drives the business.** Electronics generates about 250.5M in net revenue (57% of the total) and Furniture adds 113.6M (26%). Together they bring in 83% of revenue, while Books and Office Supplies contribute under 1.5% each.
2. **Revenue is flat, not growing.** Net revenue was 113.4M in 2022, 106.3M in 2023, 110.2M in 2024 and 108.6M in 2025.

**Orders, shipping and returns**
3. **About 1 in 4 orders is lost.** Of 5,200 orders, 12.7% were cancelled and 13.3% returned (26.0% combined). Only 49.8% were delivered.
4. **Cancel/return rates are similar across shipping modes.** Economy is highest at 28.1% and Express lowest at 24.4%. The gap is under 4 points, so I treat it as something to monitor, not a proven driver.
5. **Shipping speed is the same for every mode.** Orders take about 5.4–5.5 days to ship whether Economy, Standard, Express or Same Day, and 49.8% of shipped orders exceed a 5-day delay threshold. Same Day averaging over 5 days suggests the modes are not delivering what they promise.

**Customers and sales team**
6. **Enterprise customers spend the most per order.** Average order value is about 122K for Enterprise, against 106K for Corporate and 111K–113K for the other segments.
7. **Customers are loyal.** 598 of the 599 customers who ordered did so in more than one calendar year, averaging 8.7 orders each.
8. **Revenue is spread widely.** The top 5% of customers account for only 10.8% of revenue and the top 20% for 35.2%, so it does not follow a classic 80/20 pattern.
9. **Regional differences mostly reflect headcount.** Central leads with 144.6M but has 10 employees, versus 2 in South (27.5M). Revenue per employee is similar across regions (roughly 13.8M–15.6M).

**Discounts**
10. **Discounts do not increase quantity sold.** Average quantity per line item is about 3.5 at every discount level (0–20%), and the correlation between discount and quantity is about 0 (-0.002).

## Recommendations

- Investigate why a quarter of orders end up cancelled or returned, starting with Economy shipping.
- Review the shipping modes, since faster options are not shipping faster.
- Reconsider blanket discounting, as it shows no effect on quantity.
- Protect Electronics and Furniture first, as they carry most of the revenue.

## Limitations

- This is a practice dataset, so findings illustrate analysis technique and are not real business conclusions.
- Differences of a few percentage points (finding 4) were not tested for statistical significance.
- 84% of orders exceed the 10,000 "High Value" threshold in the CASE query, so those labels do not separate orders meaningfully.

## Screenshots

*(Add result-grid screenshots here, for example category revenue, cancel/return rate by ship mode, and the Pareto query. Upload each image to the repo and embed it with `![Category revenue](category_revenue.png)`.)*

## Repository Structure

```
sql-practice-portfolio/
├── README.md
├── SQL_PRACTICE.sql                  (queries 1–20)
├── sql_practice_queries_20_60.sql    (queries 20–60, includes setup)
├── SQL_Practice_Queries.md           (query write-up)
├── sql_practice_dataset.xlsx         (original dataset)
├── customers.csv
├── products.csv
├── employees.csv
├── orders.csv
└── order_items.csv
```

## Sample Query

```sql
-- Share of revenue from the top 5% and top 20% of customers (Pareto check)
WITH spend AS (
    SELECT customer_id, SUM(order_total) AS total_spend
    FROM orders
    GROUP BY customer_id
),
ranked AS (
    SELECT customer_id, total_spend,
           NTILE(20) OVER (ORDER BY total_spend DESC) AS bucket
    FROM spend
)
SELECT ROUND(100 * SUM(CASE WHEN bucket = 1 THEN total_spend END) / SUM(total_spend), 2) AS top_5pct_share,
       ROUND(100 * SUM(CASE WHEN bucket <= 4 THEN total_spend END) / SUM(total_spend), 2) AS top_20pct_share
FROM ranked;
```

## How to Reproduce

1. Clone this repo.
2. In MySQL Workbench, create a schema named `sql_practice` and import the five CSV files with the Table Data Import Wizard (any order).
3. Run the setup block at the top of `sql_practice_queries_20_60.sql` once. It converts text dates to `DATE` and adds indexes so multi-table joins run quickly.
4. Run `SQL_PRACTICE.sql` and `sql_practice_queries_20_60.sql` against the `sql_practice` schema.

## About Me

I'm a 2025 MCA graduate (AI & ML specialization) moving into Data Analytics. This repo is part of a broader portfolio that includes a Tableau dashboard and other analysis projects.

**Connect with me:**
- LinkedIn: [linkedin.com/in/imantasha](https://linkedin.com/in/imantasha)
- GitHub: [github.com/imantasha](https://github.com/imantasha)
