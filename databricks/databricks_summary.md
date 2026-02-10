
## Databricks Platform
### What is the Databricks platform and why use it?
<details>
<summary>Answer</summary>

```text
Databricks = Managed Spark + Delta Lake + collaborative notebooks + job scheduling.
````

> Note: Managed runtime versions control available Spark/Delta features.

</details>

---

## Datasource API

### How do you read/write data from common sources (S3 / ADLS / DBFS)?

<details>
<summary>Answer A — PySpark read/write</summary>

```python
# Read CSV / Parquet
df = spark.read.option("header", True).csv("/mnt/data/my.csv")
df.write.mode("overwrite").parquet("/mnt/data/out/")
```

> One-line note: use `spark.read.format("delta")` for Delta.

</details>

<details>
<summary>Answer B — Unified data source API</summary>

```python
# Use format to switch sources
df = spark.read.format("jdbc") \
    .option("url", jdbc_url) \
    .option("dbtable", "schema.table") \
    .load()
```

> ⚠️ Trap: forgetting credentials or network ACLs causes silent failures.

</details>

---

## DataFrame API

### How do you perform common DataFrame transformations?

<details>
<summary>Answer</summary>

```python
from pyspark.sql.functions import col, when

df2 = (
    df.filter(col("age") > 18)
      .withColumn("adult", when(col("age") >= 18, True).otherwise(False))
)
```

> Note: transformations are lazy until an action (e.g. `count()`) is called.

</details>

---

## Drawbacks of Cloud Storage

### What are common pitfalls using object storage for analytics?

<details>
<summary>Answer</summary>

```text
- Eventual consistency and listing costs
- Small-file problem hurting read performance
```

> One-line note: use Delta + compaction to mitigate small files.

</details>

---

## Understanding Delta and the Transaction Log

### What is a Delta transaction log and how does it guarantee ACID?

<details>
<summary>Answer</summary>

```text
Delta stores a JSON/Parquet transaction log under _delta_log/
with atomic commits; readers always see a consistent snapshot.
```

> Note: the log enables time travel and schema enforcement.

</details>

---

## Delta Table Creation and Transactions

### How do you create and write to a Delta table?

<details>
<summary>Answer A — SQL table creation</summary>

```sql
CREATE TABLE IF NOT EXISTS db.table (
  id   LONG,
  name STRING
) USING DELTA;

INSERT INTO db.table VALUES (1, 'alice');
```

</details>

<details>
<summary>Answer B — PySpark write</summary>

```python
(
    df.write
      .format("delta")
      .mode("overwrite")
      .save("/mnt/delta/mytable")
)
```

> ⚠️ Trap: mixing direct file writes and metastore-managed tables can cause inconsistencies.

</details>

---

## Schema Enforcement and Evolution

### How do you enforce and evolve schema on write?

<details>
<summary>Answer A — Enforcement</summary>

```python
# Fails if schema mismatches
df.write.format("delta").mode("append").save("/mnt/delta/table")
```

> One-line note: schema enforcement is default behavior in Delta.

</details>

<details>
<summary>Answer B — Evolution</summary>

```python
(
    df.write
      .format("delta")
      .option("mergeSchema", "true")
      .mode("append")
      .save("/mnt/delta/table")
)
```

> ⚠️ Trap: `mergeSchema=true` can silently change schema—use controlled migrations.

</details>

---

## UDFs

### When and how should you use UDFs vs built-in functions?

<details>
<summary>Answer A — PySpark UDF</summary>

```python
from pyspark.sql.functions import udf
import pyspark.sql.types as T

@udf(T.IntegerType())
def add_one(x):
    return x + 1

df.withColumn("x1", add_one(df.x))
```

> One-line note: UDFs are slower and can break predicate pushdown.

</details>

<details>
<summary>Answer B — Pandas / Vectorized UDF</summary>

```python
from pyspark.sql.functions import pandas_udf

@pandas_udf("long")
def add_one_series(s):
    return s + 1
```

> Use vectorized UDFs for better performance; prefer built-ins when possible.

</details>

---

## Complex Data Types

### How do you work with arrays, maps, and structs?

<details>
<summary>Answer</summary>

```python
from pyspark.sql.functions import explode

exploded = df.select(
    df.id,
    explode(df.items).alias("item")
)
```

> One-line note: use `from_json` / `to_json` for nested JSON columns.

</details>

---

## Correlations & Analogies

* Delta transaction log ≈ Git commit history for table files (snapshots & rollbacks)
* DataFrame transformations are recipes: they build a plan; actions execute it
