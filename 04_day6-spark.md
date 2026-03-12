# Day 6 Learning Summary: Apache Spark & PySpark

## 🚀 Spark Session & DataFrame Basics

### How do you create a Spark session and read CSV files?

<details>
<summary><strong>Answer</strong></summary>

<br>

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Demo App").master("local").getOrCreate()

df = spark.read.csv(
    path="employee.csv",
    sep="|",
    inferSchema=True,
    header=True,
    quote="'"
)
````

> `SparkSession.builder` creates session; `master("local")` uses single machine.
> `read.csv()` with `sep`, `inferSchema`, `header`, and `quote` parameters handles custom CSV parsing.

</details>

---

### How do you display and inspect DataFrame rows and schema?

<details>
<summary><strong>Answer A — Display rows with formatting</strong></summary>

<br>

```python
df.show(n=5, truncate=False)
```

> `n` limits output rows; `truncate=False` shows full cell content.

</details>

<details>
<summary><strong>Answer B — Display schema</strong></summary>

<br>

```python
df.printSchema()
```

> Prints column names and inferred data types.

</details>

---

## 🔍 Selecting & Filtering

### How do you select and rename specific columns from a DataFrame?

<details>
<summary><strong>Answer A — Select with string names</strong></summary>

<br>

```python
df.select("id", "name").show()
```

</details>

<details>
<summary><strong>Answer B — Using col() for transformations</strong></summary>

<br>

```python
from pyspark.sql.functions import col

df.select(col("id"), col("name").alias("Full-Name")).show()
```

> `col()` returns column object with methods like `.alias()`, `.cast()`, etc.

</details>

---

### How do you filter rows using equality, comparisons, and text matching?

<details>
<summary><strong>Answer A — Filter by single column value</strong></summary>

<br>

```python
from pyspark.sql.functions import col

df.filter(col("gen") == "F") \
  .select(col("name").alias("Female Names")) \
  .show()
```

</details>

<details>
<summary><strong>Answer B — Case-insensitive text matching</strong></summary>

<br>

```python
from pyspark.sql.functions import col, lower

df.filter(lower(col("company")) == "cisco") \
  .select(col("name").alias("Cisco Employees")) \
  .show()
```

</details>

<details>
<summary><strong>Answer C — Multiple conditions (AND)</strong></summary>

<br>

```python
from pyspark.sql.functions import col, lower

df.filter(
    (lower(col("company")) == "cisco") & (col("exp") >= 5)
).select("name").show()
```

</details>

---

## 🏗️ Adding & Transforming Columns

### How do you add a new column with a constant value?

<details>
<summary><strong>Answer</strong></summary>

<br>

```python
from pyspark.sql.functions import lit

df.withColumn("is_employed", lit(True)).show()
```

</details>

---

### How do you add a conditional column (if-then-else)?

<details>
<summary><strong>Answer A — Simple when/otherwise</strong></summary>

<br>

```python
from pyspark.sql.functions import col, when

df.withColumn(
    "exp_level",
    when(col("exp") >= 10, "Senior")
    .when(col("exp") >= 5, "Mid Level")
    .when(col("exp") >= 0, "Junior")
    .otherwise("Invalid Experience")
).select("name", "exp", "exp_level").show()
```

</details>

<details>
<summary><strong>Answer B — Multi-column conditions</strong></summary>

<br>

```python
from pyspark.sql.functions import col, when

df.withColumn(
    "exp_level_gen",
    when((col("exp") >= 10) & (col("gen") == "M"), "Senior(M)")
    .when((col("exp") >= 8) & (col("gen") == "F"), "Senior(F)")
    .when((col("exp") >= 5) & (col("gen") == "M"), "Mid Level(M)")
    .when((col("exp") >= 4) & (col("gen") == "F"), "Mid Level(F)")
    .when((col("exp") >= 0) & (col("gen") == "M"), "Junior(M)")
    .when((col("exp") >= 0) & (col("gen") == "F"), "Junior(F)")
    .otherwise("Invalid Experience")
).select("name", "exp", "exp_level_gen").show()
```

</details>

---

### How do you extract parts of a string column and convert data types?

<details>
<summary><strong>Answer</strong></summary>

<br>

```python
from pyspark.sql.functions import col, split

df.withColumn(
    "current_salary",
    split(col("col_current_expected_salary"), ",")[0].cast("double")
).show()
```

</details>

---

### How do you chain column operations and calculate derived values row-by-row?

<details>
<summary><strong>Answer</strong></summary>

<br>

```python
from pyspark.sql.functions import col, when, split

df.withColumn(
    "current_salary",
    split(col("col_current_expected_salary"), ",")[0].cast("double")
).withColumn(
    "bonus",
    when(col("gen") == "M", col("current_salary") * 0.10)
    .when(col("gen") == "F", col("current_salary") * 0.20)
    .otherwise(0)
).show()
```

</details>

---

## 📊 Aggregation

### How do you group rows by a column and perform aggregations?

<details>
<summary><strong>Answer</strong></summary>

<br>

```python
from pyspark.sql.functions import col

df.groupBy(col("gen")).count().show()
```

</details>

---

## ⚠️ Common Traps & Gotchas

### Data Quality Issues in This Dataset

<details>
<summary><strong>Common problems to watch for</strong></summary>

<br>

```text
⚠️ Missing values in id column
⚠️ Missing values in name column
⚠️ Missing values in exp column
⚠️ Mixed case in company names
⚠️ Inconsistent gender codes
⚠️ Empty rows
⚠️ Quoted strings in CSV
⚠️ Composite salary column
```

</details>

---

## 🎯 Key Takeaways

* SparkSession is the entry point for Spark
* Use col() for transformations
* Always normalize strings before filtering
* Order matters in when/otherwise chains
* Inspect and clean data early
