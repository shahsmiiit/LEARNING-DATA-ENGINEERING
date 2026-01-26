# Day 1 & 2: Python Fundamentals - Quick Revision

> **Focus**: Core Python concepts, safe practices, and functional programming patterns

---

## 📋 Table of Contents

### Day 1
1. [Input Handling & Type Safety](#1-input-handling--type-safety)
2. [Control Flow & Logic Ordering](#2-control-flow--logic-ordering)
3. [Ternary Operators](#3-ternary-operators)
4. [Functions: Arguments & Styles](#4-functions-arguments--styles)
5. [String Slicing](#5-string-slicing)
6. [Functional Programming Patterns](#6-functional-programming-patterns)
7. [Match-Case & Enumerate](#7-match-case--enumerate)

### Day 2
8. [Lists: Operations & Type Checking](#8-lists-operations--type-checking)
9. [Dictionary Safe Access](#9-dictionary-safe-access)
10. [Exception Handling](#10-exception-handling)
11. [File Operations](#11-file-operations)
12. [Testing Concepts](#12-testing-concepts)

---

# DAY 1: Core Fundamentals

## 1. Input Handling & Type Safety

### 🎯 Core Concept
**NEVER use `eval()`** in production - it executes arbitrary code and is a major security risk.

### Best Practice

```python
# ❌ DANGEROUS: Can execute malicious code
x = eval(input("Enter x: "))  # User could input: __import__('os').system('rm -rf /')

# ✅ SAFE: Always use explicit type casting
x = int(input("Enter x: "))
price = float(input("Enter price: "))
name = input("Enter name: ")  # Already returns string
```

**✅ Key Takeaway**: Use specific type conversion (`int()`, `float()`, `str()`) instead of `eval()`.

---

## 2. Control Flow & Logic Ordering

### 🎯 Core Concept
Order conditions from **most specific to most general** to avoid logical errors.

<details>
<summary>📝 Best Practice: FizzBuzz Implementation</summary>

```python
def get_fizzbuzz(n):
    """Clean, concise FizzBuzz logic"""
    if n % 15 == 0: return "fizz-buzz"  # Most specific (divisible by both)
    if n % 5 == 0: return "Fizz"
    if n % 3 == 0: return "Buzz"
    return str(n)

# Usage
for i in range(1, 16):
    print(get_fizzbuzz(i))
```

**Why This Order Matters:**
- Check `% 15` BEFORE `% 3` or `% 5`
- If you check `% 3` first, numbers like 15 would return "Buzz" instead of "fizz-buzz"
</details>

**✅ Key Takeaway**: Most specific conditions first, general conditions last.

---

## 3. Ternary Operators

### 🎯 Core Concept
One-line conditional assignment for simple logic only.

```python
# ✅ GOOD: Simple, readable
status = "greater" if x >= 100 else "not-greater"
max_val = a if a > b else b

# ❌ AVOID: Nested ternaries (hard to read)
result = "A" if x > 10 else "B" if x > 5 else "C"  # Use if-elif-else instead
```

**✅ Key Takeaway**: Use ternary only for simple assignments. Complex logic should use standard `if-else`.

---

## 4. Functions: Arguments & Styles

### Argument Types

| Type | Description | Example |
|------|-------------|---------|
| **Positional** | Order matters | `add(5, 3)` |
| **Named/Keyword** | Order doesn't matter | `add(b=3, a=5)` |
| **Default** | Pre-assigned value | `def func(x=10)` |
| **Variable Length** | Accept any number | `*args`, `**kwargs` |

<details>
<summary>📝 Example: Flexible Function Arguments</summary>

```python
def calculate_percentage(obtained, total=100):
    """
    obtained: required positional
    total: optional with default value
    """
    return (obtained / total) * 100

# Different ways to call:
print(calculate_percentage(245, 300))        # Positional: 81.67
print(calculate_percentage(obtained=33.4))   # Named + Default: 33.4
print(calculate_percentage(50))              # Positional + Default: 50.0
```
</details>

### Function vs Method

- **Function**: Standalone block of code → `add(x, y)`
- **Method**: Function inside a class (OOP) → `obj.add(x, y)`

**✅ Key Takeaway**: Use default arguments for optional parameters; named arguments improve readability.

---

## 5. String Slicing

### 🎯 Core Concept
Strings support slicing with `[start:stop:step]` syntax.

```python
s = "ABCDEFG"

# Common patterns
s[-1]        # 'G' (last character)
s[::-1]      # 'GFEDCBA' (reverse - BEST PRACTICE)
s[::2]       # 'ACEG' (every 2nd character)
s[1:5]       # 'BCDE' (substring)
s[-6:-1:2]   # 'BDF' (complex slicing)
```

### String Types

| Quote Style | Use Case | Example |
|------------|----------|---------|
| Single `'` | Simple strings | `'hello'` |
| Double `"` | Strings with single quotes | `"it's working"` |
| Triple `'''` or `"""` | Multiline strings | `"""Line 1\nLine 2"""` |

**✅ Key Takeaway**: Use `[::-1]` for string reversal; triple quotes for multiline strings.

---

## 6. Functional Programming Patterns

### Imperative vs Declarative

| Style | Focus | Characteristics |
|-------|-------|----------------|
| **Imperative** | What + How | Step-by-step, explicit state changes |
| **Declarative/Functional** | What only | Pure functions, immutable data |

### Pure Functions
Functions where **same input → same output**, with no side effects. Easier to test and debug.

<details>
<summary>📝 Example: Transforming Data</summary>

```python
l1 = [1, 2, 3, 4, 5]

# ✅ BEST PRACTICE: List Comprehension (Pythonic)
doubled = [e * 2 for e in l1]

# ✅ ALTERNATIVE: Map with Lambda (functional style)
doubled_map = list(map(lambda e: e * 2, l1))

# ❌ VERBOSE: Imperative style (avoid for simple transformations)
a = []
for e in l1:
    a.append(e * 2)
```
</details>

### Filter & Map (Predicates)

**Predicate**: Function that returns `True` or `False`

<details>
<summary>📝 Example: Filtering Data</summary>

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# ✅ BEST PRACTICE: List Comprehension
evens = [n for n in numbers if n % 2 == 0]

# ✅ ALTERNATIVE: Filter with Lambda
evens_filter = list(filter(lambda n: n % 2 == 0, numbers))

# Both output: [2, 4, 6, 8, 10]
```
</details>

### Common Functional Patterns

```python
# Map: Transform each element
squares = list(map(lambda x: x**2, [1, 2, 3]))  # [1, 4, 9]

# Filter: Select elements matching condition
adults = list(filter(lambda age: age >= 18, [15, 20, 17, 25]))  # [20, 25]

# Combined: Filter then transform
result = [x**2 for x in range(10) if x % 2 == 0]  # [0, 4, 16, 36, 64]
```

**✅ Key Takeaway**: Prefer **list comprehensions** over `map`/`filter` for readability in modern Python.

---

## 7. Match-Case & Enumerate

### Match-Case (Python 3.10+)

Modern alternative to multiple `if-elif` statements.

<details>
<summary>📝 Example: Match with Guards</summary>

```python
def check_number(y):
    match y:
        case z if z > 0:
            print("Positive")
        case z if z < 0:
            print("Negative")
        case _:  # Default case
            print("Zero")

check_number(5)   # Positive
check_number(-3)  # Negative
check_number(0)   # Zero
```
</details>

### Enumerate

Use when you need **both index and value** during iteration.

<details>
<summary>📝 Example: Enumerate Pattern</summary>

```python
items = ["apple", "banana", "cherry"]

# ✅ BEST PRACTICE: Enumerate
for i, fruit in enumerate(items):
    print(f"{i}: {fruit}")
# Output:
# 0: apple
# 1: banana
# 2: cherry

# ✅ With custom start index
for i, fruit in enumerate(items, start=1):
    print(f"#{i}: {fruit}")
# Output:
# #1: apple
# #2: banana
# #3: cherry

# ❌ AVOID: Manual counter
i = 0
for fruit in items:
    print(f"{i}: {fruit}")
    i += 1  # Error-prone
```
</details>

**✅ Key Takeaway**: Use `enumerate()` instead of manual index tracking; use `match-case` for complex pattern matching.

---

# DAY 2: Data Structures & I/O

## 8. Lists: Operations & Type Checking

### 🎯 Core Concept
Lists are **heterogeneous** (mixed types), **ordered**, and allow **duplicates**.

### Append vs Extend

```python
l1 = [1, 2, 3]
l2 = [4, 5, 6]

# append: Adds entire object as single element
l1.append(l2)      # [1, 2, 3, [4, 5, 6]]

# extend: Merges elements
l1 = [1, 2, 3]
l1.extend(l2)      # [1, 2, 3, 4, 5, 6]

# insert: Adds at specific index (slower - O(n))
l1.insert(0, 99)   # [99, 1, 2, 3, 4, 5, 6]
```

### Type Checking: `isinstance()` vs `type()`

<details>
<summary>📝 Example: Counting Lists Within Lists</summary>

```python
data = [1, "text", [2, 3], True, [4, 5], {"key": "val"}]

# ✅ BEST PRACTICE: isinstance (handles inheritance)
list_elements = [e for e in data if isinstance(e, list)]
count = len(list_elements)  # 2

# ❌ AVOID: type() comparison (doesn't handle subclasses)
bad_check = [e for e in data if type(e) == list]
```

**Why `isinstance()` is Better:**
- Respects inheritance (custom list classes still count as lists)
- More Pythonic and flexible
</details>

**✅ Key Takeaway**: 
- Use `extend()` to merge lists, `append()` to add single elements
- Always use `isinstance()` instead of `type() ==` for type checking

---

## 9. Dictionary Safe Access

### 🎯 Core Concept
Accessing non-existent keys with `[]` raises `KeyError` and crashes your program.

```python
user = {"name": "Alice", "age": 25}

# ❌ RISKY: Crashes if key doesn't exist
city = user["city"]  # KeyError!

# ✅ SAFE: Returns None or default value
city = user.get("city", "Unknown")  # "Unknown"
age = user.get("age", 0)            # 25 (key exists)

# ✅ Check before access
if "city" in user:
    city = user["city"]
```

### Dictionary Operations

```python
# Safe access with default
value = d.get("key", "default")

# Set default if key doesn't exist
d.setdefault("key", "default_value")

# Get all keys/values/items
d.keys()    # dict_keys(['name', 'age'])
d.values()  # dict_values(['Alice', 25])
d.items()   # dict_items([('name', 'Alice'), ('age', 25)])
```

**✅ Key Takeaway**: Always use `.get()` method for safe dictionary access with defaults.

---

## 10. Exception Handling

### 🎯 Core Concept
Proper error handling prevents one failure from crashing your entire application.

### Try-Except-Else-Finally Structure

<details>
<summary>📝 Best Practice: Specific Exception Handling</summary>

```python
try:
    a = float(input("Enter a: "))
    b = float(input("Enter b: "))
    result = a / b
    
except ValueError:
    # Handles non-numeric input
    print("Error: Please enter numbers only.")
    
except ZeroDivisionError:
    # Handles division by zero
    print("Error: Cannot divide by zero.")
    
except Exception as e:
    # Catch-all for unexpected errors
    print(f"Unexpected error: {e}")
    
else:
    # Runs ONLY if no exception occurred
    print(f"Success! Result: {result}")
    
finally:
    # ALWAYS runs (cleanup code)
    print("Operation completed.")
```

**Execution Flow:**
```
try → Exception? → No → else → finally
  ↓                 ↓
  └─→ Yes → except → finally
```
</details>

### Custom Exceptions

<details>
<summary>📝 Example: Domain-Specific Errors</summary>

```python
class ColorValidationError(Exception):
    """Raised when color is not in allowed list"""
    pass

def set_color(color):
    allowed = ["yellow", "red", "green"]
    if color not in allowed:
        raise ColorValidationError(f"'{color}' is not valid. Choose: {allowed}")
    return color

# Usage
try:
    set_color("blue")
except ColorValidationError as e:
    print(f"Validation failed: {e}")
# Output: Validation failed: 'blue' is not valid. Choose: ['yellow', 'red', 'green']
```
</details>

**✅ Key Takeaway**: 
- Use **specific exceptions** before general ones
- `else` block for success-only code
- `finally` for cleanup (files, connections)
- Create **custom exceptions** for better error messages

---

## 11. File Operations

### 🎯 Core Concept
**ALWAYS use `with` statement** (context manager) - guarantees file closure even if errors occur.

### Reading Text Files

```python
# ✅ BEST PRACTICE: Context manager
with open("data.txt", "r") as f:
    content = f.read()        # Read entire file
    # OR
    lines = f.readlines()     # List of lines
    # OR
    for line in f:            # Memory-efficient for large files
        print(line.strip())

# File automatically closes after 'with' block
```

### Writing CSV Files

<details>
<summary>📝 Example: CSV Operations</summary>

```python
import csv

# Writing CSV
data = [
    [1, "Alice", "alice@email.com"],
    [2, "Bob", "bob@email.com"]
]

with open("users.csv", "w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["id", "name", "email"])  # Header
    writer.writerows(data)                    # All rows at once

# Reading CSV
with open("users.csv", "r", newline="") as file:
    reader = csv.reader(file)
    header = next(reader)  # Skip header
    for row in reader:
        print(f"User {row[0]}: {row[1]}")
```

**Why `newline=""`?**
- Prevents extra blank lines on Windows
- Ensures cross-platform compatibility
</details>

### File Modes

| Mode | Description | Creates if Missing? |
|------|-------------|---------------------|
| `"r"` | Read only | ❌ No (raises error) |
| `"w"` | Write (overwrites) | ✅ Yes |
| `"a"` | Append | ✅ Yes |
| `"r+"` | Read + Write | ❌ No |

**✅ Key Takeaway**: 
- Use `with open()` for automatic resource management
- Use `csv` module for CSV files (handles edge cases)
- Always specify `newline=""` when writing CSV

---

## 12. Testing Concepts

### Testing Levels

| Type | Scope | Purpose | Framework |
|------|-------|---------|-----------|
| **Unit Testing** | Individual functions | Verify correct output for all inputs | `pytest`, `unittest` |
| **Integration Testing** | Multiple components | Test how parts work together | `pytest`, `Cucumber` |
| **End-to-End Testing** | Entire system | Test complete user workflows | `Selenium`, `Cucumber` |

### Key Concepts

**Unit Testing:**
- Test individual functions in isolation
- Ensure correct output for edge cases
- Fast and easy to debug

**Pytest:**
- Modern Python testing framework
- Measures code coverage
- Auto-discovers tests (files starting with `test_`)

**BDD/TDD:**
- **TDD (Test-Driven Development)**: Write tests before code
- **BDD (Behavior-Driven Development)**: Write tests in natural language (Given-When-Then)

```python
# Example unit test structure (pytest)
def add(a, b):
    return a + b

def test_add_positive():
    assert add(2, 3) == 5

def test_add_negative():
    assert add(-1, -1) == -2

def test_add_zero():
    assert add(0, 5) == 5
```

**✅ Key Takeaway**: 
- Unit tests verify individual functions
- Pytest is the standard Python testing framework
- Good tests cover normal cases, edge cases, and error cases

---

## 🎓 Quick Revision Checklist

**Day 1:**
- [ ] Never use `eval()` - always use explicit type casting
- [ ] Order conditions from specific to general
- [ ] Use ternary operators only for simple assignments
- [ ] Understand positional, named, and default arguments
- [ ] Use `[::-1]` for string reversal
- [ ] Prefer list comprehensions over `map`/`filter`
- [ ] Use `enumerate()` for index + value iteration

**Day 2:**
- [ ] Know difference between `append()` and `extend()`
- [ ] Always use `isinstance()` instead of `type() ==`
- [ ] Use `.get()` for safe dictionary access
- [ ] Handle exceptions with specific except blocks
- [ ] Always use `with` statement for file operations
- [ ] Use `csv` module for CSV files
- [ ] Understand unit vs integration testing concepts

---

## 💡 Common Pitfalls

**Day 1:**
- Using `eval()` for input (security risk)
- Wrong condition order in FizzBuzz-style problems
- Nested ternary operators (unreadable)
- Forgetting default argument values are evaluated once

**Day 2:**
- Using `append()` instead of `extend()` for merging lists
- Accessing dictionary keys with `[]` instead of `.get()`
- Forgetting `newline=""` in CSV writing
- Not closing files (use `with` statement!)
- Using `type()` instead of `isinstance()`

---

## 📊 Quick Reference: Best Practices Summary

| Task | Best Practice | Avoid |
|------|--------------|-------|
| Input | `int(input())` | `eval(input())` |
| List transform | `[x*2 for x in lst]` | Manual loop |
| Type check | `isinstance(x, list)` | `type(x) == list` |
| Dict access | `d.get("key", default)` | `d["key"]` |
| File handling | `with open() as f:` | `f = open(); f.close()` |
| String reverse | `s[::-1]` | Manual loop |

---

**Last Updated**: Day 1 & 2 - Python Fundamentals
**Next**: Day 3 - OOP Concepts & Advanced Patterns
