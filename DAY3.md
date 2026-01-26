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

## 🎓 Quick Revision Checklist

- [ ] Understand when `__main__` guard executes
- [ ] Know the difference between instance and static variables
- [ ] Recognize that assignment creates references, not copies
- [ ] Understand object mutation vs creating new objects
- [ ] Know when to use `@property` decorator
- [ ] Can parse command-line args with both `sys.argv` and `argparse`
- [ ] Understand that methods can modify objects passed as parameters

---

## 💡 Common Pitfalls

1. **Forgetting `self`**: Instance variables MUST use `self.variable_name`
2. **Shallow copies**: `b = a` doesn't create a new object
3. **Mutable defaults**: Never use `def __init__(self, items=[])` - list is shared!
4. **Type validation**: `sys.argv` returns strings - convert manually
5. **Property naming**: Don't name a property the same as its backing variable

---

---

## 7. Abstract Classes & Interfaces

### 🎯 Core Concept
Abstract classes enforce a **contract** - they define methods that subclasses MUST implement. You cannot instantiate an abstract class directly.

### Abstract Class vs Interface

| Concept | Abstract Class | Interface (Python style) |
|---------|---------------|--------------------------|
| **Abstract Methods** | ✅ Can have | ✅ Only has |
| **Concrete Methods** | ✅ Can have | ❌ None |
| **Implementation** | Partial | None |
| **Purpose** | Shared behavior + contract | Pure contract |

<details>
<summary>📝 Example: Payment System with Abstracts</summary>

```python
from abc import ABC, abstractmethod

class PaymentGateway(ABC):
    """Abstract class - defines contract for all payment methods"""
    
    @abstractmethod
    def pay(self, amount):
        """All subclasses MUST implement this"""
        pass
    
    @abstractmethod
    def refund(self, transaction_id):
        """All subclasses MUST implement this"""
        pass
    
    # Concrete method - shared behavior
    def log_transaction(self, amount):
        print(f"Transaction logged: ${amount}")

class CreditCardPayment(PaymentGateway):
    def pay(self, amount):
        self.log_transaction(amount)  # Using inherited method
        print(f"💳 Charged ${amount} to credit card")
    
    def refund(self, transaction_id):
        print(f"♻️ Refunded transaction {transaction_id}")

class CryptoPayment(PaymentGateway):
    def pay(self, amount):
        self.log_transaction(amount)
        print(f"₿ Transferred ${amount} in Bitcoin")
    
    def refund(self, transaction_id):
        print(f"⛔ Crypto transactions are non-refundable")

# Usage
# gateway = PaymentGateway()  # ❌ ERROR: Can't instantiate abstract class

card = CreditCardPayment()
card.pay(500)
# Output:
# Transaction logged: $500
# 💳 Charged $500 to credit card

crypto = CryptoPayment()
crypto.refund("TX123")
# Output: ⛔ Crypto transactions are non-refundable
```
</details>

### Why Use Abstract Classes?

**Benefits:**
- **Enforce consistency** across different implementations
- **Prevent incomplete implementations** - compile-time safety
- **Document contracts** - clear expectations for subclasses
- **Enable polymorphism** - treat different objects uniformly

**✅ Key Takeaway**: Use abstract classes when you want to provide a **template** with some shared behavior, but require subclasses to implement specific methods.

---

## 8. Decorators

### 🎯 Core Concept
Decorators **wrap a function** to extend or modify its behavior without changing its source code. Think of it as "gift wrapping" - the gift stays the same, but you add layers around it.

### How Decorators Work

```
Original Function → Decorator → Enhanced Function
     pay()      →   @log    →   pay() with logging
```

<details>
<summary>📝 Evolution: Manual Wrapping → Decorator Syntax</summary>

```python
# STEP 1: Manual wrapping (verbose way)
def my_decorator(func):
    def wrapper():
        print("🔵 Before function")
        func()
        print("🔴 After function")
    return wrapper

def say_hello():
    print("Hello!")

# Manual wrapping
enhanced_hello = my_decorator(say_hello)
enhanced_hello()
# Output:
# 🔵 Before function
# Hello!
# 🔴 After function

# STEP 2: Using @ syntax (clean way)
@my_decorator
def say_goodbye():
    print("Goodbye!")

say_goodbye()  # Automatically wrapped!
# Output:
# 🔵 Before function
# Goodbye!
# 🔴 After function
```
</details>

### Practical Decorator with Arguments

<details>
<summary>📝 Example: Real-World Logging Decorator</summary>

```python
def log(func):
    """Decorator that logs function calls with their arguments"""
    def wrapper(*args, **kwargs):
        # *args captures positional arguments (500, "test")
        # **kwargs captures keyword arguments (amount=500, user="Alice")
        
        print(f"📞 Called: {func.__name__}")
        print(f"   Args: {args}")
        print(f"   Kwargs: {kwargs}")
        
        # Execute the original function
        result = func(*args, **kwargs)
        
        print(f"✅ Completed: {func.__name__}")
        return result
    
    return wrapper

@log
def pay(amount, currency="USD"):
    print(f"💰 Processing payment: {amount} {currency}")
    return f"Receipt-{amount}"

@log
def transfer(from_account, to_account, amount):
    print(f"🔄 {from_account} → {to_account}: ${amount}")

# Usage
receipt = pay(500)
print(f"Got: {receipt}")
# Output:
# 📞 Called: pay
#    Args: (500,)
#    Kwargs: {}
# 💰 Processing payment: 500 USD
# ✅ Completed: pay
# Got: Receipt-500

transfer("ACC001", "ACC002", 1000)
# Output:
# 📞 Called: transfer
#    Args: ('ACC001', 'ACC002', 1000)
#    Kwargs: {}
# 🔄 ACC001 → ACC002: $1000
# ✅ Completed: transfer
```
</details>

### Common Use Cases

| Decorator Purpose | Example |
|------------------|---------|
| **Logging** | Track function calls |
| **Authentication** | Check user permissions |
| **Caching** | Store expensive results |
| **Timing** | Measure execution time |
| **Validation** | Check input parameters |

<details>
<summary>📝 Bonus: Timing Decorator</summary>

```python
import time

def timer(func):
    """Measures how long a function takes to execute"""
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"⏱️ {func.__name__} took {end - start:.4f} seconds")
        return result
    return wrapper

@timer
def slow_operation():
    time.sleep(2)
    print("Operation complete!")

slow_operation()
# Output:
# Operation complete!
# ⏱️ slow_operation took 2.0001 seconds
```
</details>

**✅ Key Takeaway**: Decorators let you add functionality to functions **without modifying their code**. They're essential for clean, reusable code patterns.

---

## 9. Generators

### 🎯 Core Concept
Generators produce values **one at a time** using `yield` instead of returning everything at once. They're **memory-efficient** and perfect for large datasets or infinite sequences.

### Regular Function vs Generator

| Feature | Regular Function | Generator |
|---------|-----------------|-----------|
| **Keyword** | `return` | `yield` |
| **Memory** | Stores all values | Stores one value at a time |
| **Execution** | Runs to completion | Pauses and resumes |
| **Use Case** | Small datasets | Large/infinite datasets |

<details>
<summary>📝 Example: Why Generators Matter</summary>

```python
# ❌ BAD: Regular function - loads everything into memory
def get_numbers_regular(n):
    """Returns a list of n numbers - uses lots of memory!"""
    numbers = []
    for i in range(n):
        numbers.append(i * i)
    return numbers

# This loads 1 million numbers into memory at once!
large_list = get_numbers_regular(1000000)  # 💾 ~8MB of memory

# ✅ GOOD: Generator - produces values on-demand
def get_numbers_generator(n):
    """Yields numbers one at a time - memory efficient!"""
    for i in range(n):
        yield i * i  # Produces one value, pauses, resumes

# This only stores ONE number at a time!
large_gen = get_numbers_generator(1000000)  # 💾 ~100 bytes

# Use it in a loop
for num in large_gen:
    print(num)
    if num > 100:
        break  # Can stop early, saving computation
```
</details>

### How Generators Work (Step-by-Step)

<details>
<summary>📝 Example: Generator Execution Flow</summary>

```python
def countdown(n):
    print("🚀 Generator started")
    while n > 0:
        print(f"  → About to yield {n}")
        yield n
        print(f"  ← Resumed after yielding {n}")
        n -= 1
    print("✅ Generator exhausted")

# Create generator (doesn't run yet!)
gen = countdown(3)
print("Generator created but not started")

# First call to next() - runs until first yield
print("\n--- Calling next() #1 ---")
value1 = next(gen)
print(f"Got: {value1}")

# Second call - resumes from where it left off
print("\n--- Calling next() #2 ---")
value2 = next(gen)
print(f"Got: {value2}")

# Third call
print("\n--- Calling next() #3 ---")
value3 = next(gen)
print(f"Got: {value3}")

# Fourth call - generator exhausted
print("\n--- Calling next() #4 ---")
try:
    next(gen)
except StopIteration:
    print("❌ No more values!")

# Output:
# Generator created but not started
#
# --- Calling next() #1 ---
# 🚀 Generator started
#   → About to yield 3
# Got: 3
#
# --- Calling next() #2 ---
#   ← Resumed after yielding 3
#   → About to yield 2
# Got: 2
#
# --- Calling next() #3 ---
#   ← Resumed after yielding 2
#   → About to yield 1
# Got: 1
#
# --- Calling next() #4 ---
#   ← Resumed after yielding 1
# ✅ Generator exhausted
# ❌ No more values!
```
</details>

### Practical Use Cases

<details>
<summary>📝 Example: Reading Large Files Line-by-Line</summary>

```python
def read_large_file(filename):
    """Memory-efficient file reading - yields one line at a time"""
    with open(filename, 'r') as file:
        for line in file:
            yield line.strip()

# Process 10GB file without loading it all into memory!
for line in read_large_file('huge_log.txt'):
    if 'ERROR' in line:
        print(line)
        # Can process millions of lines efficiently
```
</details>

<details>
<summary>📝 Example: Infinite Sequence Generator</summary>

```python
def fibonacci():
    """Generates infinite Fibonacci sequence"""
    a, b = 0, 1
    while True:  # Infinite loop!
        yield a
        a, b = b, a + b

# Generate Fibonacci numbers on demand
fib = fibonacci()
for _ in range(10):
    print(next(fib), end=' ')
# Output: 0 1 1 2 3 5 8 13 21 34

# Can stop anytime - doesn't compute unnecessary values!
```
</details>

### Generator Expressions (Shorthand)

```python
# List comprehension - creates entire list
squares_list = [x**2 for x in range(1000000)]  # 💾 Uses lots of memory

# Generator expression - creates generator
squares_gen = (x**2 for x in range(1000000))   # 💾 Uses minimal memory

# Use it
for square in squares_gen:
    if square > 100:
        break
```

**✅ Key Takeaway**: 
- Use generators when working with **large datasets** or **infinite sequences**
- `yield` pauses the function and resumes later
- Much more **memory-efficient** than lists
- Perfect for **streaming data** or **pipeline processing**

---

## 10. Inheritance

### 🎯 Theory
Inheritance allows a class (child/subclass) to **acquire properties and methods** from another class (parent/superclass). It promotes **code reuse** and establishes **"is-a" relationships**.

### Types of Inheritance

```
Single         Multiple        Multilevel       Hierarchical
  A              A   B           A                  A
  ↓              ↓   ↓           ↓                ↙   ↘
  B              C               B              B       C
                                 ↓
                                 C
```

### Pros and Cons

| ✅ Advantages | ❌ Disadvantages |
|--------------|------------------|
| **Code reuse** - Don't repeat yourself | **Tight coupling** - Changes in parent affect children |
| **Logical hierarchy** - Models real-world relationships | **Fragile base class** - Parent changes can break children |
| **Polymorphism** - Treat related objects uniformly | **Deep hierarchies** - Hard to understand and maintain |
| **Override behavior** - Customize inherited methods | **Multiple inheritance** - Diamond problem complexity |
| **Extend functionality** - Add new features to existing code | **Wrong abstraction** - Inheritance used when composition is better |

### When to Use Inheritance

**Use Inheritance When:**
- ✅ There's a clear **"is-a"** relationship (Dog **is a** Animal)
- ✅ You need to **extend** existing behavior
- ✅ Multiple classes share **common behavior**

**Use Composition Instead When:**
- ✅ There's a **"has-a"** relationship (Car **has an** Engine)
- ✅ You need **flexibility** to swap implementations
- ✅ Relationship is **not strictly hierarchical**

<details>
<summary>📝 Quick Example: Inheritance in Action</summary>

```python
class Animal:
    def __init__(self, name):
        self.name = name
    
    def speak(self):
        pass  # Will be overridden by subclasses

class Dog(Animal):  # Dog inherits from Animal
    def speak(self):
        return f"{self.name} says Woof!"

class Cat(Animal):
    def speak(self):
        return f"{self.name} says Meow!"

# Polymorphism - treat different objects uniformly
animals = [Dog("Buddy"), Cat("Whiskers")]
for animal in animals:
    print(animal.speak())
# Output:
# Buddy says Woof!
# Whiskers says Meow!
```
</details>

### Key Inheritance Concepts

- **`super()`**: Call parent class methods
- **Method overriding**: Replace parent method in child
- **Method overloading**: Python doesn't support (use default args instead)
- **MRO (Method Resolution Order)**: Order Python searches for methods in inheritance chain

**✅ Key Takeaway**: Inheritance is powerful for modeling hierarchies, but use it judiciously. Favor **composition over inheritance** when the relationship isn't strictly hierarchical.

---

## 🎓 Extended Quick Revision Checklist

**Day 3 Part 2:**
- [ ] Understand abstract classes enforce contracts for subclasses
- [ ] Know the difference between abstract classes and interfaces
- [ ] Can write decorators to extend function behavior
- [ ] Understand `*args` and `**kwargs` in decorator wrappers
- [ ] Know when to use generators vs regular functions
- [ ] Understand `yield` pauses and resumes execution
- [ ] Recognize inheritance pros (reuse) and cons (coupling)
- [ ] Know when to use inheritance vs composition

---

## 💡 Additional Common Pitfalls

**Abstract Classes:**
- Forgetting `ABC` import and inheritance
- Not implementing all abstract methods in subclass

**Decorators:**
- Forgetting `return wrapper` in decorator
- Not using `*args, **kwargs` for flexible argument handling
- Losing function metadata (use `@functools.wraps`)

**Generators:**
- Trying to reuse an exhausted generator (create a new one)
- Confusing `yield` with `return` (yield pauses, return exits)

**Inheritance:**
- Creating deep inheritance hierarchies (max 2-3 levels recommended)
- Not calling `super().__init__()` in child constructors
- Using inheritance when composition would be clearer

---

**Last Updated**: Day 3 of Python Training (Extended)
**Topics Covered**: OOP Fundamentals, CLI Arguments, Abstract Classes, Decorators, Generators, Inheritance
