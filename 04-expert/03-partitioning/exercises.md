# Partitioning

## What is partitioning?

Partitioning splits a large table into smaller, physically separate pieces called **partitions**, while appearing as a single table to queries. This improves query performance, maintenance operations, and data lifecycle management.

## Types of partitioning

### Range partitioning
Split by a continuous range of values (e.g., date ranges):

```sql
CREATE TABLE orders_partitioned (
    id          SERIAL,
    customer_id INT,
    status      VARCHAR(50),
    ordered_at  TIMESTAMP NOT NULL
) PARTITION BY RANGE (ordered_at);

CREATE TABLE orders_2024_q1 PARTITION OF orders_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE orders_2024_q2 PARTITION OF orders_partitioned
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');
```

### List partitioning
Split by discrete values (e.g., country, status):

```sql
CREATE TABLE orders_by_status (
    id     SERIAL,
    status VARCHAR(50) NOT NULL,
    ...
) PARTITION BY LIST (status);

CREATE TABLE orders_delivered PARTITION OF orders_by_status
    FOR VALUES IN ('delivered');

CREATE TABLE orders_pending   PARTITION OF orders_by_status
    FOR VALUES IN ('pending', 'shipped');
```

### Hash partitioning
Distribute rows evenly across N partitions by hashing a column:

```sql
CREATE TABLE products_hashed (
    id   SERIAL,
    name VARCHAR(200)
) PARTITION BY HASH (id);

CREATE TABLE products_h0 PARTITION OF products_hashed
    FOR VALUES WITH (MODULUS 4, REMAINDER 0);
-- ... (h1, h2, h3)
```

## Partition pruning

When querying with a `WHERE` clause on the partition key, PostgreSQL automatically skips irrelevant partitions:

```sql
EXPLAIN SELECT * FROM orders_partitioned
WHERE ordered_at >= '2024-04-01' AND ordered_at < '2024-07-01';
-- Only scans orders_2024_q2, skips Q1
```

---

## Exercises

### Exercise 1
Create a partitioned version of `orders` called `orders_part`, partitioned by **range on `ordered_at`**, with one partition per quarter of 2024.

### Exercise 2
Insert a few rows into `orders_part` and verify using `EXPLAIN` that the correct partition is scanned when filtering by date.

### Exercise 3
Create a partitioned table `orders_by_status_part` split by **list on `status`** (one partition per status value).

### Exercise 4
Add a new partition to `orders_part` for Q1 2025. Then drop the Q1 2024 partition (simulating data archival).

### Exercise 5 — Challenge
Create a partitioned table `products_part` using **hash partitioning** on `id` with 3 partitions. Populate it from the existing `products` table using `INSERT INTO ... SELECT`. Verify the row distribution across partitions.
