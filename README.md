# SQL Course — Beginner to Expert

A structured, hands-on SQL course with exercises and corrections.

## How it works

Each topic folder contains:
- `exercises.md` — theory, concepts, and exercises to solve
- `correction.sql` — full corrections with comments

All exercises share the same sample database. Set it up first before starting.

## Getting started

1. Read [setup/README.md](setup/README.md) and run the sample database script
2. Follow the modules in order
3. Attempt exercises on your own before looking at the corrections

## Course structure

| Level | Module | Topic |
|---|---|---|
| 🟢 Beginner | 01 | What is SQL? |
| 🟢 Beginner | 02 | SELECT and FROM |
| 🟢 Beginner | 03 | WHERE clause |
| 🟢 Beginner | 04 | ORDER BY |
| 🟢 Beginner | 05 | LIMIT and DISTINCT |
| 🟡 Intermediate | 01 | JOINs |
| 🟡 Intermediate | 02 | Aggregations and GROUP BY |
| 🟡 Intermediate | 03 | HAVING |
| 🟡 Intermediate | 04 | Subqueries |
| 🔴 Advanced | 01 | Window Functions |
| 🔴 Advanced | 02 | CTEs |
| 🔴 Advanced | 03 | Indexes |
| 🔴 Advanced | 04 | Transactions |
| ⚫ Expert | 01 | Query Optimization |
| ⚫ Expert | 02 | Stored Procedures and Functions |
| ⚫ Expert | 03 | Partitioning |
| ⚫ Expert | 04 | Database Design |

## Sample database

The course uses a fictional e-commerce store with these tables:
`customers`, `categories`, `products`, `employees`, `orders`, `order_items`

See [setup/sample-data.sql](setup/sample-data.sql) for the full schema and seed data.