# SQL Practice Portfolio — E-Commerce Dataset

This repository documents my hands-on SQL practice using a relational e-commerce dataset. It's part of my transition into Data Analytics, where I'm building practical, query-level proof of my SQL skills alongside my formal MCA (AI & ML specialization) background.

##  Dataset Overview

A relational dataset simulating a real e-commerce business, with **5 linked tables**:

| Table | Rows | Description |
|---|---|---|
| `customers` | 600 | Customer demographics, signup date, segment, location |
| `products` | 217 | Product catalog across 8 categories with pricing and stock |
| `employees` | 30 | Sales employees with region and monthly targets |
| `orders` | 5,200 | Order-level transactions with status, payment method, shipping |
| `order_items` | 13,156 | Line-item detail per order (quantity, discount, line total) |

**Relationships:**
- `orders.customer_id` → `customers.customer_id`
- `orders.employee_id` → `employees.employee_id`
- `order_items.order_id` → `orders.order_id`
- `order_items.product_id` → `products.product_id`

Data files are in [`/data`](./data) as both `.xlsx` (original) and `.csv` (import-ready) formats.

##  Tools Used

- **MySQL** — database and query execution
- **MySQL Workbench** — schema design, CSV import, and query development

##  Repository Structure

```
sql-practice-portfolio/
├── data/
│   ├── sql_practice_dataset.xlsx
│   ├── customers.csv
│   ├── products.csv
│   ├── employees.csv
│   ├── orders.csv
│   └── order_items.csv
├── SQL_PRACTICE.sql
│  
└── README.md
```




##  Sample Query

```sql
-- Find categories where the average unit price exceeds 5000
SELECT category, ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 5000
ORDER BY avg_price DESC;
```

##  How to Reproduce

1. Clone this repo.
2. Import the CSVs from `/data` into MySQL Workbench (Table Data Import Wizard), in this order to satisfy foreign keys:
   `customers → products → employees → orders → order_items`
3. Run any `.sql` file in `/sql` against the `sql_practice` schema.

##  About This Project

I'm a 2025 MCA graduate (AI & ML specialization) transitioning into Data Analytics. This repo is part of a broader portfolio that includes a Tableau dashboard and other analysis projects — built to demonstrate practical SQL fluency beyond coursework.

**Connect with me:**
- LinkedIn: [linkedin.com/in/imantasha](https://linkedin.com/in/imantasha)
- GitHub: [github.com/imantasha](https://github.com/imantasha)
