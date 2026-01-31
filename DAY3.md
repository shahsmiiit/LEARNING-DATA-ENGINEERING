# Day 3 Learning Summary: Object-Oriented Programming & Modularity

---

## 🏗️ Command-Line Arguments

---

### How do you access command-line arguments in Python?

<details>
<summary>Answer A — Raw sys.argv</summary>

```python
import sys

if __name__ == '__main__':
    arguments = sys.argv
    print(arguments[0])  # script name
    print(arguments[1])  # first arg
    # arguments[0] = 'command_line_args.py'
    # arguments[1:] = remaining args
```

> `sys.argv` is a list; index 0 is the script filename, index 1+ are user-provided arguments.

</details>

<details>
<summary>Answer B — Parse named flags manually</summary>

```python
import sys

if __name__ == '__main__':
    name = "anonymous"
    age = -1
    args = sys.argv[1:]

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
```

> Loop through args, check for flag keys, grab next element as value; validate types.

</details>

<details>
<summary>Answer C — argparse (recommended)</summary>

```python
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="A smarter ArgParser Demo")
    
    parser.add_argument("--name", default="SS", help="Your full name")
    parser.add_argument("--age", type=int, default="43", help="Your age as a number")
    
    args = parser.parse_args()
    print(f"Hello {args.name} ({args.age} years old).")
```

> `argparse` handles validation, type conversion, and auto-generates help menus. Access args as attributes: `args.name`, `args.age`.

</details>

---

## 🎯 Module & Execution Context

---

### How do you control when code runs in a module?

<details>
<summary>Answer</summary>

```python
# m0.py
import sys

def f01():
    print("do something")

def main():
    f01()

if __name__ == '__main__':
    main()
```

```python
# m1.py
from m0 import f01

def d2():
    print("d2")

if __name__ == '__main__':
    d2()
```

> `if __name__ == '__main__'` only executes when the file is run directly, not when imported. Allows reusable functions without side effects.

</details>

---

## 🏛️ Object-Oriented Programming Fundamentals

---

### How do you define a class with a constructor?

<details>
<summary>Answer</summary>

```python
class A:
    def __init__(self):
        print("constructor invoked")

if __name__ == '__main__':
    obj = A()  # __init__() automatically called
```

> `__init__()` is a dunder method (magic method); Python calls it automatically during object instantiation.

</details>

---

### How do you implement getters and setters?

<details>
<summary>Answer A — Manual methods (POJO/BEAN pattern)</summary>

```python
class Student:
    def __init__(self, name, marks):
        self.name = name
        self.marks = marks

    def set_name(self, name):
        self.name = name

    def get_name(self):
        return self.name

    def set_marks(self, marks):
        self.marks = marks

    def get_marks(self):
        return self.marks

if __name__ == '__main__':
    obj = Student("ss", 1)
    print(obj.get_name(), obj.get_marks())
```

> Class with get/set methods is called POJO (Plain Old Java Object) or BEAN.

</details>

<details>
<summary>Answer B — @property decorator</summary>

```python
class A:
    def __init__(self, name):
        self._name = name

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, value):
        self._name = value

if __name__ == '__main__':
    s1 = A("smit")
    print(s1.name)  # get (uses property)
    
    s1.name = "Alice"  # set (uses setter)
    print(s1.name)
```

> `@property` makes method act like attribute; `@name.setter` allows assignment syntax. Cleaner API than explicit get/set.

</details>

---

### What are class variables vs instance variables?

<details>
<summary>Answer</summary>

```python
class A:
    x = 10  # class variable (shared across instances)

    def m02(self):
        return A.x  # access via class name

    @staticmethod
    def m01():
        return A.x  # static method, no self needed

if __name__ == '__main__':
    obj = A()
    print(obj.m02())  # 10 (instance can access class var)
    print(A.m01())    # 10 (static method, no instance needed)
```

> Class variables are shared; instance variables (set in `__init__` via `self.x = ...`) are unique per object.

</details>

---

## 🔗 Inheritance

---

### How do you inherit from one or more parent classes?

<details>
<summary>Answer — Single and multiple inheritance</summary>

```python
class A:
    def a1work(self):
        print("A-works")

class A2:
    def a1work(self):
        print("A2-work")

class B(A, A2):  # inherits from A and A2
    def work(self):
        print("B-works")

    def manage(self):
        print("B-manage")

if __name__ == '__main__':
    child = B()
    child.work()      # B-works
    child.manage()    # B-manage
    child.a1work()    # A-works (MRO: B -> A -> A2)
```

> Multiple inheritance: `class B(A, A2)`. Method Resolution Order (MRO) determines which parent method is called if duplicates exist (left-to-right).

</details>

---

## 🎨 Decorators

---

### How do you create and use function decorators?

<details>
<summary>Answer A — Basic decorator</summary>

```python
def my_decorator(func):
    def wrapper():
        print("before fun")
        func()
        print("after fun")
    return wrapper

@my_decorator
def say_hello():
    print("hello")

say_hello()  # Output: before fun -> hello -> after fun
```

> Decorator wraps a function; `@my_decorator` is syntactic sugar for `say_hello = my_decorator(say_hello)`.

</details>

<details>
<summary>Answer B — Decorator with arguments and kwargs</summary>

```python
def log(func):
    def wrapper(*args, **kwargs):
        print(f"called-fun: {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

@log
def pay(amount):
    print(f"processed the amount of {amount}")

pay(500)  # Output: called-fun: pay -> processed the amount of 500
```

> `*args` captures positional args, `**kwargs` captures keyword args; pass them through to original function.

</details>

---

## 🛡️ Abstract Classes & Interfaces

---

### How do you enforce method implementation in child classes?

<details>
<summary>Answer</summary>

```python
from abc import ABC, abstractmethod

class Parent(ABC):
    @abstractmethod
    def pay(self, amount):
        pass  # no implementation required

class Child1(Parent):
    def pay(self, amount):
        print(f"Pay this amount : {amount}")

if __name__ == '__main__':
    c_ptr = Child1()
    c_ptr.pay(500)
    
    # p = Parent()  # TypeError: Cannot instantiate abstract class
```

> Abstract class: inherit from `ABC`, use `@abstractmethod`. Child must override or cannot be instantiated.
> 
> **Abstract Class vs Interface**: Abstract class can have concrete methods + abstract methods. Interface (all `@abstractmethod`) is pure contract.

</details>

---

## 🔄 Object References & Aliasing

---

### How do object references behave in Python?

<details>
<summary>Answer</summary>

```python
class A:
    def __init__(self, num):
        self.num = num

    def set_num(self, num):
        self.num = num

    def get_num(self):
        return self.num

if __name__ == '__main__':
    obj1 = A(110)
    obj2 = obj1          # obj2 points to same object as obj1
    obj3 = A(120)        # new separate object
    
    obj1.set_num(130)
    print(obj1.get_num())  # 130
    print(obj2.get_num())  # 130 (same object as obj1)
    print(obj3.get_num())  # 120 (different object)
```

> Assignment `obj2 = obj1` creates alias (both reference same object in memory), not a copy. Changes to one affect both.

</details>

---

## 🎯 Key Takeaways

- **Command-line args**: Use `argparse` for robust parsing with automatic validation and help generation.
- **`if __name__ == '__main__'`**: Prevents code execution on import; essential for reusable modules.
- **Instance vs class variables**: Instance (set in `__init__`) unique per object; class variables shared across all instances.
- **Properties**: Use `@property` + `@name.setter` for cleaner API than explicit get/set methods.
- **Inheritance**: Multiple inheritance follows MRO (left-to-right); duplicate method names resolve by parent order.
- **Decorators**: Wrap functions to add behavior; `@decorator` syntax = `func = decorator(func)`.
- **Abstract classes**: Enforce contract; child must override `@abstractmethod` or cannot instantiate.
- **References**: Assignment creates alias (same object), not copy. Modifications affect all references to that object.
