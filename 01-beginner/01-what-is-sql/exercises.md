# What is SQL?

## What you will learn

SQL (Structured Query Language) is the standard language for interacting with relational databases.
It lets you:
- **Query** data (retrieve information)
- **Insert** new data
- **Update** existing data
- **Delete** data
- **Define** tables and relationships

## Key concepts

### Relational databases
Data is organized in **tables** (also called relations), made up of **rows** (records) and **columns** (fields).

```
customers table:
┌────┬───────────┬──────────┬────────────────────────────┐
│ id │ first_name│ last_name│ email                      │
├────┼───────────┼──────────┼────────────────────────────┤
│  1 │ Alice     │ Martin   │ alice.martin@email.com     │
│  2 │ Bob       │ Smith    │ bob.smith@email.com        │
└────┴───────────┴──────────┴────────────────────────────┘
```

### SQL statement categories
| Category | Purpose | Examples |
|---|---|---|
| DQL | Query data | `SELECT` |
| DML | Modify data | `INSERT`, `UPDATE`, `DELETE` |
| DDL | Define structure | `CREATE`, `ALTER`, `DROP` |
| DCL | Control access | `GRANT`, `REVOKE` |
| TCL | Manage transactions | `COMMIT`, `ROLLBACK` |

## Our database: ShopDB

Before starting, make sure you have loaded the sample database.
See [../../setup/README.md](../../setup/README.md).

The database represents a small e-commerce shop with these tables:

| Table | Description |
|---|---|
| `customers` | People who place orders |
| `categories` | Product categories |
| `products` | Items available in the store |
| `employees` | Staff who manage orders |
| `orders` | Purchase orders |
| `order_items` | Lines within each order |

---

## Exercises

### Exercise 1
List all the tables available in the database and write a short description of what each one contains (without running any SQL yet — just read the setup documentation).

### Exercise 2
For each table below, identify what the **primary key** is and what it represents:
- `customers`
- `products`
- `orders`
- `order_items`

### Exercise 3
Identify the **foreign keys** in the `orders` table. What tables do they reference and what is the business meaning of each link?

### Exercise 4
Looking at the table list, write in plain English the SQL questions you think would be most useful to answer for a shop owner (e.g., "Which customers placed the most orders?"). You will answer these with SQL in later modules.
