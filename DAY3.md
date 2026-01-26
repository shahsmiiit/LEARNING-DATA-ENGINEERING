# Day 3: Python OOP & Command-Line Arguments

> **Focus Areas**: Object-Oriented Programming fundamentals, Python execution model, and CLI argument handling

---

## 📋 Table of Contents
1. [The `__main__` Guard](#the-main-guard)
2. [Constructors & Magic Methods](#constructors--magic-methods)
3. [Variable Scopes in Python](#variable-scopes-in-python)
4. [Object References & Mutation](#object-references--mutation)
5. [Properties & Encapsulation](#properties--encapsulation)
6. [Command-Line Arguments](#command-line-arguments)

---

## 1. The `__main__` Guard

### 🎯 Core Concept
The `if __name__ == '__main__':` pattern ensures code only runs when the file is executed directly, NOT when imported as a module.

### Why It Matters
- **Modularity**: Write reusable code that can be safely imported
- **Testing**: Import functions without triggering side effects
- **Security**: Prevent accidental execution of setup/initialization code

```python
# my_module.py
def greet(name):
    return f"Hello, {name}!"

if __name__ == '__main__':
    # Only runs when: python my_module.py
    # Does NOT run when: import my_module
    print(greet("World"))
```

**✅ Key Takeaway**: Always use `__main__` guard for executable scripts that can also be imported.

---

## 2. Constructors & Magic Methods

### What Are Constructors?
Special methods that **initialize instance variables** when an object is created.

### Dunder (Magic) Methods
Methods with double underscores (`__method__`) that tell Python how to behave with standard operations.

<details>
<summary>📝 Example: Basic Constructor</summary>

```python
class Student:
    def __init__(self, name, age):
        """Constructor - automatically called when object is created"""
        self.name = name  # Instance variable
        self.age = age
        print(f"Student object created for {name}")

# Object creation triggers __init__
student1 = Student("Alice", 20)  # Output: Student object created for Alice
```
</details>

**✅ Key Takeaway**: `__init__` is NOT the object creator (that's `__new__`), it's the initializer that sets up the object's state.

---

## 3. Variable Scopes in Python

| Variable Type | Scope | Shared Across Objects? | Example |
|--------------|-------|------------------------|---------|
| **Instance** | Object-level | ❌ No | `self.name` |
| **Static/Class** | Class-level | ✅ Yes | `Student.count` |
| **Local** | Method-level | ❌ No | Variables inside methods |
| **Constants** | Module-level | ✅ Yes (by convention) | `MAX_SIZE = 100` |

<details>
<summary>📝 Example: Instance vs Static Variables</summary>

```python
class BankAccount:
    # Static/Class variable - shared across ALL instances
    total_accounts = 0
    bank_name = "Python Bank"
    
    def __init__(self, owner, balance):
        # Instance variables - unique to each object
        self.owner = owner
        self.balance = balance
        BankAccount.total_accounts += 1

# Demonstration
acc1 = BankAccount("Alice", 1000)
acc2 = BankAccount("Bob", 2000)

print(acc1.owner)              # Alice (instance variable)
print(acc2.owner)              # Bob (instance variable)
print(BankAccount.total_accounts)  # 2 (static variable - shared)
print(acc1.total_accounts)     # 2 (accessible via instance too)
```
</details>

**✅ Key Takeaway**: Instance variables use `self.`, static variables use `ClassName.`

---

## 4. Object References & Mutation

### 🎯 Critical Concept
In Python, **variables hold references to objects**, not the objects themselves. Assignment creates a new reference, not a copy.

<details>
<summary>📝 Unified Example: Understanding Object Behavior</summary>

```python
class Counter:
    def __init__(self, value):
        self.value = value
    
    def get_value(self):
        return self.value
    
    def set_value(self, new_value):
        self.value = new_value
    
    def create_new(self, value):
        """Returns a NEW Counter object"""
        return Counter(value)
    
    def mutate_other(self, other_counter):
        """Modifies another Counter object"""
        other_counter.set_value(999)
    
    def mutate_self_and_other(self, other_counter):
        """Modifies both self and another object"""
        self.value = 5000
        other_counter.set_value(self.get_value())
        return self  # Returns reference to self

# Let's trace what happens
c1 = Counter(100)           # c1 → Counter(100)
c2 = c1                     # c2 → same object as c1
c3 = c2.create_new(200)     # c3 → NEW Counter(200)
c1.mutate_other(c3)         # c3's value changes to 999
c4 = c1.mutate_self_and_other(c2)  # c1 and c2 both → 5000, c4 → same as c1

# Results:
print(c1.get_value())  # 5000 (mutated by mutate_self_and_other)
print(c2.get_value())  # 5000 (c2 is same object as c1)
print(c3.get_value())  # 5000 (mutated by mutate_other, then by mutate_self_and_other)
print(c4.get_value())  # 5000 (c4 is same object as c1)
```

**Trace Diagram:**
```
c1 = Counter(100)          →  c1 ──→ [Counter: value=100]
c2 = c1                    →  c2 ──→ [same object]
c3 = c2.create_new(200)    →  c3 ──→ [Counter: value=200] (NEW object)
c1.mutate_other(c3)        →  c3.value becomes 999
c4 = c1.mutate_self...(c2) →  c1.value=5000, c2.value=5000 (same object)
                               c4 ──→ [same as c1]
```
</details>

### Reference Rules

| Operation | Creates New Object? | Example |
|-----------|---------------------|---------|
| Assignment (`=`) | ❌ No | `b = a` |
| Method returning `self` | ❌ No | `return self` |
| Constructor call | ✅ Yes | `Counter(10)` |
| Method parameter passing | ❌ No (passes reference) | `func(obj)` |

**✅ Key Takeaway**: 
- Assignment and parameter passing share references
- Only constructors create new objects
- Methods can mutate objects via their references

---

## 5. Properties & Encapsulation

### POJO/Bean Pattern
A class with getters and setters for controlled access to private data.

### The `@property` Decorator
Allows method calls to look like attribute access (syntactic sugar for getters).

<details>
<summary>📝 Example: Properties vs Manual Getters/Setters</summary>

```python
class Temperature:
    def __init__(self, celsius):
        self._celsius = celsius  # "Private" by convention
    
    # Traditional getter/setter
    def get_celsius(self):
        return self._celsius
    
    def set_celsius(self, value):
        if value < -273.15:
            raise ValueError("Temperature below absolute zero!")
        self._celsius = value
    
    # Property decorator (Pythonic way)
    @property
    def fahrenheit(self):
        """Get temperature in Fahrenheit"""
        return (self._celsius * 9/5) + 32
    
    @fahrenheit.setter
    def fahrenheit(self, value):
        """Set temperature using Fahrenheit"""
        self._celsius = (value - 32) * 5/9

# Usage
temp = Temperature(25)
print(temp.get_celsius())        # 25 (traditional getter)
temp.set_celsius(30)             # Traditional setter

print(temp.fahrenheit)           # 86.0 (looks like attribute access!)
temp.fahrenheit = 100            # Setter via assignment
print(temp.get_celsius())        # 37.77... (updated via fahrenheit setter)
```
</details>

**✅ Key Takeaway**: Use `@property` for computed attributes or when you need validation logic with clean syntax.

---

## 6. Command-Line Arguments

### Two Approaches

| Feature | `sys.argv` | `argparse` |
|---------|-----------|------------|
| **Complexity** | Manual parsing | Automatic parsing |
| **Type Conversion** | Manual (try/except) | Built-in (`type=int`) |
| **Validation** | Custom logic needed | Built-in validators |
| **Help Menu** | Manual | Auto-generated (`-h`) |
| **Best For** | Simple scripts | Production code |

### Approach 1: `sys.argv` (Manual)

<details>
<summary>📝 Example: Manual Argument Parsing</summary>

```python
import sys

if __name__ == '__main__':
    name = "Anonymous"
    age = -1
    
    args = sys.argv[1:]  # Skip script name (index 0)
    
    # Parse --name and --age flags
    for i in range(len(args)):
        if args[i] == "--name" and i + 1 < len(args):
            name = args[i + 1]
        elif args[i] == "--age" and i + 1 < len(args):
            try:
                age = int(args[i + 1])
            except ValueError:
                print("Error: Age must be an integer.")
                sys.exit(1)
    
    print(f"Hello {name} ({age} years old).")

# Run: python script.py --name Alice --age 25
# Output: Hello Alice (25 years old).
```

**Key Points:**
- `sys.argv[0]` is always the script filename
- `sys.argv[1:]` contains actual arguments
- Manual validation with try/except
</details>

### Approach 2: `argparse` (Recommended)

<details>
<summary>📝 Example: Professional Argument Parsing</summary>

```python
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="User Info CLI")
    
    # Define arguments with types and defaults
    parser.add_argument("--name", default="Anonymous", help="Your full name")
    parser.add_argument("--age", type=int, default=18, help="Your age")
    parser.add_argument("--verbose", action="store_true", help="Enable verbose output")
    
    args = parser.parse_args()
    
    if args.verbose:
        print(f"Received: name={args.name}, age={args.age}")
    
    print(f"Hello {args.name} ({args.age} years old).")

# Run: python script.py --name Bob --age 30 --verbose
# Output: 
# Received: name=Bob, age=30
# Hello Bob (30 years old).

# Run: python script.py -h
# Shows auto-generated help menu!
```

**Key Benefits:**
- Automatic type conversion (`type=int`)
- Default values
- Auto-generated help with `-h` flag
- Boolean flags with `action="store_true"`
</details>

### Common Patterns

```python
# Reading multiple files from command line
import sys

if __name__ == '__main__':
    for filename in sys.argv[1:]:
        with open(filename, "r") as file:
            content = file.read()
            print(f"--- {filename} ---")
            print(content)

# Run: python script.py file1.txt file2.txt
```

**✅ Key Takeaway**: Use `sys.argv` for quick scripts, `argparse` for anything production-ready.

---

## 💡 Common Pitfalls

1. **Forgetting `self`**: Instance variables MUST use `self.variable_name`
2. **Shallow copies**: `b = a` doesn't create a new object
3. **Mutable defaults**: Never use `def __init__(self, items=[])` - list is shared!
4. **Type validation**: `sys.argv` returns strings - convert manually
5. **Property naming**: Don't name a property the same as its backing variable
