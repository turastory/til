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

- What is an **expression**?

  From the text above...

  - We type an expression.
  - The interpreter evaluates the result.
  - An expression has a value.


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



### 1.1.5 The Substitution Model for Procedure Application

##### Substitution Model

> To apply a compound procedure to arguments, evaluate the
> body of the procedure with **each formal parameter replaced**
> **by the corresponding argument**.

Substitution model succinctly describes the meaning of procedure application. Basically this model substitue formal parameters with the actual arguments to evaluate a compound procedure.

There're are few things to note, however:

- It doesn't give a description of how the interpreter works. This approach (manipulating the text of the procedure) is not so efficient and typical interpreters use local environments to achieve it.

- This is not a complete model of how the interpreter works. We'll examine more elaborate models later.

##### Applicative order vs Normal order

- **Applicative order**
  **"Evaluate and then apply"** - First evaluates the operator and the operands and then applis the resulting procedure to the resulting arguments.

- **Normal order**
  **"Fully expand and then reduce"** - First substitution operands until it obtained an expression involving only primitive operators, and then perform the evaluation.

For procedure applications *that can be modeled using substitution* and that
*yield legitimate values*, **normal-order and applicative-order evaluation**
**produce the same value**.

- What does it mean to be modeled using substitution? Are there procedures that cannot be modeled using substitution?

  I can't answer this question now.. Maybe we can figure it out in the chapter 3.



### 1.1.6 Conditional Expressions and Predicates

##### Predicate

The word `predicate` denotes...

- An expression whose value is interpreted as either ture or false.
- A procedure that returns true or false.

##### `cond`

`cond` is a special form to describe *case analysis*.

```scheme
(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        (else) (- x))))

; General form
(cond (⟨p1⟩ ⟨e1⟩) ; Clauses (predicate - expression)
      (⟨p2⟩ ⟨e2⟩)
      ...
      (⟨pn⟩ ⟨en⟩))
```

The evaluation rule for this conditional expression is pretty straightforward, so I'm not gonna mention it here.

**`if`**

`if` is another special form - a restricted type of conditional that can be used when there're *only two cases*.

```scheme
(define (abs x)
  (if (< x 0) (- x) x))

; General form
(if <predicate> <consequent>  <alternative>)
```

##### Logical operations

```scheme
(and <e1> ... <en>)
(or <e1> ... <en>)
(not <e>)
```

Again, the evaluation rules for these logical compound predicates are pretty straightforward so omitted.



##### Side Note: Why conditional expressions are speical forms?

Above compound predicates - except `not` - are all special forms. This is because when you can determine the resulting value from the former conditions, then you don't have to look at the latter conditions.

So in the following example, if `x` is positive, then you don't have to evaluate the second predicate `(= x 0)` at all.

```scheme
(cond ((> x 0) x)
      ((= x 0) 0)
      else (- x))
```

> In compiler theory, an optimization technique like dead code elimination uses this kind of code analysis to get rid of unused/dead code.



### 1.1.7 Example: Square Roots by Newton's Method

##### Difference between mathematical function and procedure.

Mathematical functions and procedures are very similar, but **procedures must be effective**.

> The contrast between function and procedure is a reflection of the general distinction between **describing properties of things** and **describing how to do things**.

For example, here's the definition of the square-root function:
$$
\sqrt{x} = \text{the } y \text{ such that } y \ge 0 \text{ and } y^2 = x.
$$
This definition succinctly describes the concept of the square-roots, but it doesn't explain how to actually find the square root of a given number.



### 1.1.8 Procedures as Black-Box Abstractions

##### Procedure abstraction

We can observe the fact that calculating square roots or cube roots can **break up into number of subproblems**.

Each of these tasks is accomplished by a **separate procedure**. We can take any large problem and divide it into several parts, but the important thing is **how** we divide it. By 10 lines each? By statements?

It is crucial that **each procedure accomplishes an identifiable task** that can be used as a module in defining other procedures.

By doing this, other programs or procedures can use those procedures (the ones we defined) **without knowing how they're implemented**.

> Indeed, as far as the `good-enough?` procedure is concerned, `square` is not quite a procedure but rather an abstraction of a procedure, a so-called **procedural abstraction**.

In the following example, we cannot distinguish these two `square` procedure, in terms of the user of these procedures.

```scheme
(define (square x) (* x x))
(define (square x) (exp (double (log x))))
(define (double x) (+ x x))
```

> So a procedure definition should be able to **suppress detail**.



##### Local names

One of the details of procedure's implementation is the names of the formar parameters. So the following procedures are not distinguishable.

> The meaning of a procedure should be independent of the parameter names used by its author.

```scheme
(define (square x) (* x x))
(define (square y) (* y y))
```

It seems pretty obvious, but we can observe an important fact: **the parameter names of a procedure must be local to the body of the procedure**.

```scheme
(define x 3)
(define (square x) (* x x))
(define (good-enough? guess x)
  (< (abs (- (square guess) x))
     0.001))
```

In the following example, the first `x` should not affect the other two procedures, `square` and `good-enough?`.
On the other hand, the parameter `x` of the procedure `square` is different from the parameter `x` of the procedure `good-enough?`.

> If the parameters were not local to the bodies of their respective procedures, then the parameter `x` in square could be confused with the parameter `x` in `good-enough?`, and the behavior of `good-enough?` would depend upon which version of `square` we used. Thus `square` would not be the black box we desired.



##### Bound variable

Bound variable is **a name that doesn't matter what name it has**. One example of such variable is **formal parameter**.

> The procedure definition *binds* its formal parameters.

In contrast, a variable that is not bound is called **free variable**.

> The set of expressions for which a binding defines a name is called the *scope* of that name. In a procedure definition, the bound variables declared as the formal parameters of the procedure have the body of the procedure as their scope.

-> The scope of the formal parameters, which is bound to the procedure is the body of the procedure.



##### Internal definitions and block structure

We have another kind of "name isolation": **internal definitions**. In the following example, the procedure `sqrt-iter` is local to the procedure `sqrt`.

```scheme
(define (sqrt x)
  (define (sqrt-iter guess)
    x ; Here we can access *outer* variable x
    ...)
  ...)
```

This kind of *nesting of definitions* is called **block structure**.



##### Lexical scoping

Since the **internal procedures are in the body of the outer procedure** (the scope of formal parameters), we allow the formal parameters of the outer procedure *to be free variables* in the internal definitions.

This discipline is called **lexical scoping**.

- What is lexical scoping?

  From stackoverflow...

  > **Lexical Scoping** defines how variable names are resolved in nested functions: **inner functions contain the scope of parent functions even if the parent function has returned**.
  >
  > When a variable is **lexically scoped**, the system looks to where the function is **defined** to find the value for a free variable.
  >
  > When a variable is **dynamically scoped**, the system looks to where the function is **called** to find the value for the free variable.

  In short, lexical scoping means that free variables in a procedure are taken from where the procedure is defined.



### Exercises

##### Exercise 1.5

```scheme
(define (p) (p))
(define (test x y)
  (if (= x 0) 0 y))

(test 0 (p))
```

In applicative-order, the expressions are evaluated first. But since the value of `(p)` is also `(p)`, we'll fall into an **infinite loop**.

In normal-order, the oprands are replaced first. And you can see that the value of the predicate `(= x 0)` is true - hence the interpreter will not evaluate the argument `y` (which is replaced with `(p)`). So the is **0**.

##### Exercise 1.6

Using `sqrt-iter` with new version of if, yields an infinite loop. This is because of the evaluation rule.

LISP interpreter uses applicative order for evaluating procedures, so recursive call always yields an infinite loop. To avoid this, `if` should be a special form rather an ordinary procedure.

##### Exercise 1.8

Using the following formula to implement a cube-root procedure:
$$
\frac{x/y^2 + 2y}{3}
$$

```scheme
(define (cube-root x)
  (cube-root-iter 1.0 x))

(define (cube-root-iter guess x)
  (if (good-enough? guess x)
      guess
      (cube-root-iter (improve guess x) x)))

(define (good-enough? guess x)
  (< (abs (- (* guess guess guess) x)) 0.001))

(define (improve y x)
  (define improved (/ (+ (/ x (* y y)) (* 2 y)) 3))
  (average y improved))

(define (average x y)
  (/ (+ x y) 2))
```
