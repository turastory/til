# Building Abstraction with Procedures.

#### Keywords

##### Computational Process

A computational process, simply called **process** - is an abstract thing that *manipulates another abstract thing* called **data**.

##### Data

Data are some stuff that is *manipulated by a process*.

##### Program

A program is **a pattern of rules**, that *directs* a process.

##### Programming Languages

A **programming language** prescribes *the tasks our process to perform*. A programming language is made up of **symbolic expressions**.

### Questions

- What does it mean that something is abstract?
  I think it doesn't have any technical, serious meaning of it, but 
- In the sentences above, it seems that *data* is defined only using the relation with process. But as a common sense we recognize *data* as something useful, or something that stores a value in it.



## 1.1 The Elements of Programming

A programming laugage provides three mechanism for **combining simple ideas to form complex ideas**.

- **Primitive expressions**
  The *simplest entities* the language provides.
- **Means of combination**
  The ways to *build compound elements from the simpler ones*.
- **Means of abstraction**
  The ways to **name**, and **manipulate** compound elements *as units*.



Usually there are two kinds of elements:

- Procedures - descriptions of **rules** for *manipulating data*.
- Data - data is **stuff** that we want to manipulate.



Hence, any programming language should be able to...

- describe **primitive data** and **primitive procedures**
- have methods for **combining and abstracting procedures and data**.



### 1.1.1 Expressions

> You type an *expression*, and the interpreter responds by displaying the result of its *evaluating* that expression.

##### Expressions

An **expression** is a *computational object*, which *has a value*, and we can obtain the value of it, by *evaluating* it.

##### Types of expressions

Here are some common types of expressions

- Numbers
- Strings
- Procedures
- ...

##### Combinations

A combination and it denotes **procedure application**

##### Procedure Application

Procedure application means the application of the procedure - **operator**, to the other elements - **operands**.

The value of a combination is obtained by *applying* the procedure to the arguments.

-> Then how to apply the procedure? What's the method for applying the procedure? We will discuss it later.

##### Side Note: prefix notation

In **prefix notation**, the operator is placed to the left of the operands. What's the advantages of such notation?

- Can handle procedures that takes *more than one arguments*.

  ```scheme
  (+ 1 2 3 4 5)
  ```

- Provides a straightforward way to representing *nested combinations*.

  ```scheme
  (+ (* 1 2) (- 4 3))
  ```



### 1.1.2 Naming and the Environment

##### Variable & Naming

A programming language usuall provides the means for **using names to refer computational objects**.

> The name identifies a **variable** whose *value* is the object.

```scheme
(define x 1234)
```

Naming the value, is the simplest *means of abstraction*.

##### Environment

The fact that we can associate values with symbols, and later retrieving them, implies **some sort of memory that keeps track of the name-object pairs**.

Such memory is called the **environment**.



### 1.1.3 Evaluating Combinations

##### General evaluation rule

In this section we're gonna figure out **how to evaluate a combination**.

1. Evaluate the subexpressions of the combination.
2. Apply the procedure that is the value of the leftmost subexpressions to the argumenets that are the values of the other subexpressions. (Apply the procedure to the arguments)

We can observe few things here...

##### Recursion

The rule is **recursive** in nature - to accomplish the evaluation process, we must first perform evaluation process on the subexpressions.

The idea of recursion makes it possible to express complicated process easily.

In general, using recursion, we can deal hierarchical, treelike objects easily.

##### Evaluation rules for primitive expressions

Repeated applications of the first step (recursive step), leads us to the point where there're no subexpressions left to evaluate - where we need to evaluate primitive expressions.

Here are some rules for evaluating primitives

- the values of **numerals** are the numbers that they name.
- the values of **built-in operators** are the machine instruction sequences that carry out the corresponding operations
- the values of **other names** are the objects associated with those names in the environment.

We can regard the second rule as a special case of the third rule.

-> This kind of abstraction - which elliminates concrete cases based on the common properties - happens in various areas of computer science.

##### Special Forms

**Special forms** are special expressions that *does not follow general evaluation rule*. They have their own rules.

```scheme
(define x 3)
```

Here, `define` is a special form and therefore `(define x 3)` does not form a combination. These kinds of exception is needed in order to do stuff outside of the program logic - `define` is one of them, and it associates name with a value in the environment.



### 1.1.4 Compound Procedures

##### Procedure Definitions

An abstraction technique by which a compound operation can be given a name and then referred to as a unit. Procedure definition provides another means of abstraction, in addition to `define`.

```scheme
(define (square x) (* x x))
; General form
(define (<name> <formal parameters>) <body>)
```

We can get a **compound procedure** as a result of *procedure definition*.

Here're few things that constitutes the above compound procedure:

- `<name>` - the name of the compound procedure to define.
- `<formal paramters>` - the names used within the *body* of the procedure to reter to the arguments, when the procedure application is occured.
- `<body>` - an expression that will yield the value of the procedure application when the formal parameters are replaced by the actual arguments, in which the procedure is applied.

Another intersting thing to note hWere is the fact that *evaluating procedure definitions* actually consist of two distinct operations: **1) creating the procedure** and **2) giving a name to it**.



### Questions

- What is an **expression**?

  From the text above...

  - We type an expression.
  - The interpreter evaluates the result.
  - An expression has a value.

  "An **expression** is a *computational object*, which *has a value*, and we can obtain the value of it, by *evaluating* it."

