# Setup — Sample Database

## Prerequisites

You need a running SQL database. The scripts are written in standard SQL and are compatible with:
- **PostgreSQL** (recommended)
- MySQL / MariaDB (minor adjustments may be needed for data types)
- SQLite (for quick local testing)

## Running the script

### PostgreSQL

```bash
# Create the database
createdb sql_course

# Load schema and seed data
psql -d sql_course -f sample-data.sql
```

### SQLite

```bash
sqlite3 sql_course.db < sample-data.sql
```

## Database overview

The course uses a fictional e-commerce store called **ShopDB**.

```
customers        → people who place orders
categories       → product categories
products         → items available in the store
employees        → staff who manage orders
orders           → purchase orders placed by customers
order_items      → individual lines inside each order
```

### Entity relationship

```
customers ──< orders ──< order_items >── products >── categories
                │
            employees
```
