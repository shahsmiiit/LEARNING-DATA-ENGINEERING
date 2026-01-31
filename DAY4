# Day 4 Learning Summary: Python Libraries & Advanced Concepts

---

## 📚 Logging & Debugging

---

### How do you set up logging in Python?

<details>
<summary>Answer A — Basic logging configuration</summary>

```python
import logging

logging.basicConfig(
    filename="app.log",
    level=logging.INFO,
    format="%(asctime)s - %(filename)s - %(levelname)s - %(message)s"
)

logging.info("app started")
logging.error("something went wrong")
```

> `basicConfig()` sets up root logger with file output, timestamp, source file, and log level in format string.

</details>

<details>
<summary>Answer B — Logger object with handlers</summary>

```python
import logging

# 3 parts: logger, handler, formatter
logger = logging.getLogger("my_app")
logger.setLevel(logging.DEBUG)

console_handler = logging.StreamHandler()
file_handler = logging.FileHandler("app.log")

logger.addHandler(console_handler)
logger.addHandler(file_handler)

logger.info("info-obj")
logger.debug("debug-obj")
logger.warning("warn-obj")
logger.error("error-obj")
```

> More control: create logger object, attach multiple handlers (console + file), each handler can have different levels.

</details>

---

## ⏱️ Time & Performance

---

### How do you measure execution time in Python?

<details>
<summary>Answer</summary>

```python
import time

a = time.time()
# ... code to measure ...
b = time.time()

print("diff : ", b - a)
```

> `time.time()` returns seconds since epoch; subtract for elapsed duration.

</details>

---

### How do you display timestamps in human-readable format?

<details>
<summary>Answer</summary>

```python
from datetime import datetime

timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print(f"[{timestamp}] event_data")
```

> `strftime()` formats datetime object; useful for logging or time-stamped output.

</details>

---

## 🧵 Multithreading

---

### How do you run code concurrently using threads?

<details>
<summary>Answer</summary>

```python
import time
import threading

def print_num():
    for i in range(5):
        print(i)
        time.sleep(1)

a = time.time()

t1 = threading.Thread(target=print_num)
t2 = threading.Thread(target=print_num)

t1.start()
t2.start()

t1.join()  # wait for t1 to finish
t2.join()  # wait for t2 to finish

b = time.time()
print("diff : ", b - a)
```

> Create `Thread` objects with target function, `.start()` to launch, `.join()` to block until done. Execution time ~5s (concurrent) vs 10s (sequential).

</details>

---

## 🔢 NumPy

---

### How do you convert lists and matrices to NumPy arrays?

<details>
<summary>Answer</summary>

```python
import numpy as np

# 1D array from list
my_list = [1, 2, 3, 4, 5]
v_arr = np.array(my_list)

# 2D array (matrix)
my_matrix = [[1, 2, 3], [4, 5, 6]]
m_arr = np.array(my_matrix)

# Check dimensions
print(m_arr.ndim)  # 2
```

> `np.array()` accepts nested lists; `.ndim` returns number of dimensions.

</details>

---

## 📊 Pandas

---

### How do you read different file formats into Pandas?

<details>
<summary>Answer A — CSV and TSV</summary>

```python
import pandas as pd

csv_data = pd.read_csv("test.csv")
tsv_data = pd.read_table("test.tsv")
```

</details>

<details>
<summary>Answer B — Excel with multiple sheets</summary>

```python
import pandas as pd

# Single sheet
df_01 = pd.read_excel("movies.xls", sheet_name="1900s")

# Get all sheet names
xlsx = pd.ExcelFile("movies.xls")
sheet_names = xlsx.sheet_names

# Read and combine multiple sheets
total_movies_df_list = []
for sheet_name in sheet_names:
    movies = pd.read_excel("movies.xls", sheet_name=sheet_name)
    total_movies_df_list.append(movies)

combined_df = pd.concat(total_movies_df_list, ignore_index=True)
```

</details>

<details>
<summary>Answer C — JSON</summary>

```python
import pandas as pd

df = pd.read_json("user_001.json", lines=True)
```

> `lines=True` when JSON is newline-delimited.

</details>

<details>
<summary>Answer D — XML parsing</summary>

```python
from xml.dom import minidom
import pandas as pd

data = []
document = minidom.parse('company_002.xml')
staffs = document.getElementsByTagName("staff")

for staff in staffs:
    id = staff.getAttribute("id")
    name_nodes = staff.getElementsByTagName("name")
    name = name_nodes[0].firstChild.data.strip() if name_nodes and name_nodes[0].firstChild else "Anonymous"
    expense = staff.getElementsByTagName("expense")[0].firstChild.data
    
    data.append({"id": int(id), "name": name, "expenses": int(expense)})

df = pd.DataFrame(data)
```

> Use `minidom` for XML; parse, get elements by tag, extract attributes/data, then convert to DataFrame.

</details>

---

### How do you transform and aggregate Pandas DataFrames?

<details>
<summary>Answer A — Create computed columns and filter</summary>

```python
import pandas as pd

data = {
    "order_id": [101, 102, 103, 104],
    "product": ["Laptop", "Mouse", "Laptop", "Keyboard"],
    "price": [800, 20, 800, 50],
    "quantity": [1, 2, 1, 3]
}

df = pd.DataFrame(data)

# Add computed column
df["total_amount"] = df["price"] * df["quantity"]

# Filter rows
high_value = df[df["total_amount"] > 100]
```

</details>

<details>
<summary>Answer B — Rename columns</summary>

```python
df = df.rename(columns={"product": "item"})
```

</details>

<details>
<summary>Answer C — GroupBy aggregation</summary>

```python
# Single aggregation
df.groupby("item")["total_amount"].sum()

# Multiple aggregations
df.groupby("item").agg({
    "total_amount": "sum",
    "quantity": "mean"
})
```

</details>

---

## 💾 Caching

---

### How do you cache function results to avoid redundant computation?

<details>
<summary>Answer</summary>

```python
from functools import lru_cache
import time

@lru_cache(maxsize=3)
def get_user(user_id):
    print("Fetching from database...")
    time.sleep(2)
    return {"id": user_id, "name": f"User{user_id}"}

print(get_user(1))  # Fetching... (2 sec)
print(get_user(1))  # Instant (cached)
print(get_user(2))  # Fetching... (2 sec)
print(get_user(3))  # Fetching... (2 sec)
print(get_user(4))  # Fetching... (2 sec, evicts key 1)
print(get_user(1))  # Fetching... (2 sec, no longer cached)
```

> `@lru_cache(maxsize=N)` stores up to N results; older entries evicted when capacity exceeded. `maxsize=3` keeps 3 items; add a 4th evicts the least-recently-used.

</details>

---

## 🌐 REST APIs

---

### How do you make HTTP requests with Python?

<details>
<summary>Answer A — GET request</summary>

```python
import requests

response = requests.get("https://api.restful-api.dev/objects")
print(response.status_code)  # e.g., 200
print(response.text)  # raw string response
print(response.json())  # parsed JSON
```

</details>

<details>
<summary>Answer B — GET with query parameters</summary>

```python
import requests

params = {"id": ["1", "ff8081819782e69e019bea806fea4563"]}
response = requests.get("https://api.restful-api.dev/objects", params=params)
print(response.json())
```

</details>

<details>
<summary>Answer C — POST request with JSON data</summary>

```python
import requests

data = {
    "id": "ff8081819782e69e019bea806fea4563",
    "name": "nymmyn",
    "data": {
        "year": 2019,
        "price": 1849.99,
        "CPU model": "Intel Core i9",
        "Hard disk size": "1 TB"
    }
}

response = requests.post("https://api.restful-api.dev/objects/ff8081819782e69e019bea806fea4563", json=data)
print(response.json())
```

> Pass dict to `json=` parameter; `requests` auto-serializes to JSON.

</details>

---

## 🎯 Key Takeaways

- **Logging** is 3-part: logger (who), handler (where), formatter (how). Use `basicConfig()` for quick setup.
- **Threading** via `threading.Thread(target=fn)` runs functions concurrently; `join()` waits for completion.
- **NumPy** converts Python lists/matrices to efficient arrays; check `.ndim` for shape.
- **Pandas** reads CSV/TSV/Excel/JSON/XML; chain `.groupby().agg()` for aggregations.
- **Caching** with `@lru_cache()` auto-stores results; respects `maxsize` limit.
- **Requests** library simplifies HTTP calls; use `params=` for query strings, `json=` for body data.
