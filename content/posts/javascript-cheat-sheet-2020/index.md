---
title: Javascript Cheat Sheet 2020
author: Laszlo Bogacsi
type: post
date: 2020-11-01T00:00:00+00:00
draft: true
coverCaption: Photo by <a href="https://unsplash.com/@candidbcolette?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Brittany Colette</a> on <a href="https://unsplash.com/photos/persons-holding-book-GFLMi4c8XMg?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
categories:
  - Javascript
  - Software Development
tags:
  - advanced
  - Arrays
  - basics
  - concepts
  - dataTypes
  - ES6
  - Functions
  - Javascript
  - Objects
---

Javascript is an interpreted scripting language of the web, that runs directly in your browser.

A web application has 3 main building blocks, HTML, CSS and Javascript.

HTML provides static content, CSS is there for styling while Javascript makes your content dynamic and interactive.

In high level terms, when you request a webpage, the browser loads the HTML, fetches the CSS and images, parses these into the DOM or Document Object Model, and when done, loads and runs the Javascript.

The DOM is a tree-like data structure. Its nodes are the HTML elements and is arranged in a parent-child relationship. The javascript running on the page can interact with the DOM, can create new nodes, and mutate its content.

## Javascript Basics

In the upcoming sections I'll show you examples of the language and the syntax using ES6 aka ECMAScript 2015 with const/let, async/await and arrow functions.

Let's dive in and get more familiar with Javascript.

### Declaring Variables

```js
const myVariable = "you can not reassign me"
let myMutableVariable = "change me as you like"
```

A `const` is a keyword that doesn't let you to reassign the variable, while `let` does.

### Data types

In javascript everything is an object, except for these six primitive types.

```js
const myString = "some text";
const myNumber = 34.5;
const myBoolean = true;
let myNull = null;
let myNothing = undefined;
const myFooSymbol = Symbol("foo");

const myObject = { aProperty:  "value" };
const myArray = [true, "I can hold", ">=", 2, "different types"];
```

### Objects

Javascript objects are a collection of properties. A property can have any value from simple textual data to function – and other object references.

```js
const person = {
    name: "John Doe",
    age: 25,
    saySomething: () => console.log("this blog is cool")
}
```

to access an object property, simply refer to it by the property name:

```js
person.name 
// or
person["name"] // "John Doe"
```

To set a property value just assign a new value to the property, but wait, didn't we say, if it's declared with the `const` keyword, then it's safe and immutable and no one can touch it? Well, to be exact here, we're not reassigning the `person` variable, we're changing a property of the person, which is allowed.

```js
person.name = "Jane Doe"
```

Adding a new property to an object is easy, building on the previous example add an address property like this:

```js
person.address = "some address"
// person => { name: "..", age: 25, saySomething: () => {..}, address: "some address"}
```

Now we can change an existing property value and we can create a new one, we should be able to delete a property too.

Deleting a property is done by the `delete` keyword. Please note that this keyword was designed to work with objects, using it on arrays may lead to unexpected results.

```js
delete person.address;
```

When we'd like to get a collection of (own) properties of an object we can use the keys() method available on the Object object.

```js
Object.keys(person) // ["age", "name", "saySomething"]
```

With this we can iterate through the keys and perform some operation on the corresponding values.

### Arrays

An array is a collection of related "things". An array can hold many different type of things.

To declare one:

```js
const myNumArray = [1, 2, 3, 4];
const myStringArray = ["one", "two", "three", "four"];
```

To access an element of an array:

```js
const myStringArray = ["one", "two", "three", "four"];
myStringArray[2]; // three
```

To add new elements to the end of an array:

```js
const myStringArray = ["one", "two"];

myStringArray.push("three");
myStringArray // ["one", "two", "three"];
```

### Functions

Functions are so-called first class citizens in JavaScript. This means, functions are treated like any other first class objects, they can be:

- stored in a variable
- passed around
- returned from a function
- have their own properties

Because of this, we can leverage concepts like, callbacks, higher-order functions, partial function application aka. currying.

To declare a function, use the `function` keyword, give it a name, declare the parameters in parentheses and write the function body between a pair of curly braces.

```js
function myFunction(name) {
  return "Hello, " + name + "!";
}
```

Now, that we have our first function, to use it, call the function with a string name parameter. Call means, add the () after the function name.

```js
myFunction("World"); // Hello, World!
```

Without the parentheses we can obtain a reference to a function. Save it in a variable and call it elsewhere, this is called a callback function.

```js
const greet = myFunction;
function printWorldGreeting(greeting) {
   const name = "World";
   console.log(greeting(name));
}

printWorldGreeting(greet); // "Hello, World!"
```

The examples for a function above are called `named` functions, well, because they have a name. The ones that don't they are the `anonymous` functions.

Anonymous functions are used when we don't want to reuse a function. In the previous example we could just pass in our greeting function to the other function in the argument like this:

```js
printWorldGreeting(function (name) {
   return "Hello, " + name + "!";
})
```

Or to make this shorter using the rule, if the return statement is a one liner then omitting the curly braces means it's an implicit return so we can leave out the return keyword too.

```js
printWorldGreeting(function (name) "Hello, " + name + "!")
```

At this point we can introduce the ES6 `arrow functions` (the ones with the fat arrow =>) and our function would look like this:

```js
printWorldGreeting(name => "Hello, " + name + "!")
```

Going one step even further, we can make use of the string templates

```js
printWorldGreeting(name => `Hello, ${name}!`)
```

Note the pair of back ticks `` ` `` instead of quotation marks, and to substitute a variable we use the `${var}` syntax.

### Operators

A little bit about operators. JavaScript does not support operator overloading, this means we can't redefine what a `+` or `-` operation do. Some languages like Scala and Clojure and C++ are supporting this.

If we'd like to group the operators we could say there are:

- unary
- binary
- ternary

operators in Javascript.

Some operators have higher precedence than others for example a multiplication will be executed before an addition.

#### Unary operators

A unary operator takes a single operand/argument.

The most common are:

```js
!      // Logical Not (converts to boolean and negates it)
++     // Increment (adds one)
--     // Decrement (subtracts one)
typeof // returns the string type of the operand
```

and there are some more like `unary negation`, `bitwise not`, `delete` and `void`.

#### Binary operators

This type takes two arguments:

```js
+     // add
-     // subtract
*     // multiply
/     // divide
%     // modulo (return the division remainder)
**    // exponentiations
```

#### Ternary operators

This one takes three arguments

```js
// ? :
condition ? true : false

name === 'Laszlo' ? "Hello, Laszlo!" : "Hello, World!";
```

#### Comparison

```js
==             // loose equality
===            // strict equality
>, >=, <, <=   // greater than, less than
```

**Loose equality**, in short checks for value only, if you're comparing a number to a string: 5 == "5" JS will try to coerce the types to a common type and check the value in this case this would return true.

**Strict equality**, checks both type and value, so 5 === "5" would return false but "5" === "5" would return true.

**Falsy or Truthy**

Values in Javascript are either `falsy` or `truthy`.

There are 6 falsy values and everything else is truthy.

- false
- 0 (the number zero)
- "" (empty string)
- null
- undefined
- NaN

### Control Flow Tools

Or Branches and loops.

To introduce different code path in our program, to do something else based on some condition we can use:

- If-Else statement
- Switch statement

The If-Else statement:

```js
if (condition) {
  // do this if condition true
} else {
  // do this if condition is false
}

if (condition) {
  // if first condition is true
} else if (condition) {
  // if second condition is true
} else {
  // if none of the conditions are true
}
```

The Switch statement:

```js
switch (expression) {
  case a:
    // do something
    break;
  case b:
    // do something
    break;
  default:
    // when none of the cases are matching
}
```

To do something many number of times or until a condition is true, we can make use of these looping structures:

- for
- for .. in
- for .. of
- while
- do .. while

**The classic for loop:**

This basically means, declare a loop variable `i` to be `0` and execute the body of the for loop, and when done increment the value of `i` by one (`i++` shorthand for `i = i + 1`) and repeat until the `i < 5` condition is `true`.

```js
for (let i=0; i < 5; i++) {
  console.log(i);
} // 0, 1, 2, 3, 4
```

**The for .. in loop**

This type of loop is for iterating through an object's properties.

Consider the following object:

```js
const myObj = {
  a: 1,
  b: 2,
  c: 3
}
```

So to iterate or loop through its properties one by one, we can use the for in loop like this:

```js
for(let property in myObj) {
  console.log(property)
} // a, b, c
```

Be careful with this construct as it is iterating through all the properties of an object, including own properties and inherited ones. So if the goal is to use the "own" properties of an object we need to perform a `myObj.hasOwnProperty(property)` check.

**The for ... of loop**

This type is the latest kind, mainly used for iterating through iterable objects. An object is iterable when it implements the iterator method.

Such objects are (and not restricted to) Array – like objects, Maps, Sets, and even Strings.

Consider the following array:

```js
const myArray = ["1", "2", "3", "4"];
```

```js
for(const item of myArray) {
  console.log(item);
} // "1" "2" "3" "4"
```

The next looping technique to look at is the `while loop`.

**The while loop**

You can read it like: "do something while a condition is true"

```js
let i = 0;
while(i < 3) {
 // do something
  i++;
}
```

Notice that, in the above example, incrementing the looping variable is important, otherwise we get an infinite loop.

**The do.. while loop**

This do..while statement is similar to the regular while loop, the only difference about it is, while the while loop evaluates the condition first and if true executes the loop body, the do while loop, executes the do block at least once and keeps doing it until the condition is true.

```js
let i = 0;
do {
  // do something
  i++;
} while (i < 3)
```

### Dates

I thought mentioning dates on their own is important, because, surprisingly – to me at least – it requires quite a bit of experience to use them. Unless of course you decide to opt for one of the well known libraries like `momentJs` and just make your life easier.

There are a couple of things that we'd like do with dates and some of them are unexpectedly complicated.

- Compute the difference between two dates
- Subtract a given number of days, months or years from a date
- Format a date (and time)
- Handle timezones
- Handle internationalisation, like different formats, and display conventions between locales

```js
const now = new Date(); 
now.toString();
// Sun Nov 01 2020 10:17:16 GMT+0000 (Greenwich Mean Time)
```

The heart of the Javascript date is the Epoch 1970 jan 01 midnight (UTC). The JS date is the number of milliseconds from this base value (in UTC).

#### Creating a Date object

There are several ways to create a JS Date object. We can use the epoch representation of a date, or we can create one by breaking down it to its year, month, day, (hour, minute, seconds.. etc) components.

```js
const today = new Date();
let aDate = new Date(2020, 10, 1) // <- January is 0!
aDate = new Date(2020, 10, 1, 9, 25, 30) // with time
aDate = new Date("2020-11-01T09:25:30") // from string
aDate = new Date(1604222730000) // from epoch

aDate = Date.parse("2020-11-01T09:25:30") //1604222730000
```

#### Getting part of a date

Sometimes we only need the year, month or day part of the date, this how to get to it:

When using getYear() don't be surprised as it maps to 1900 so for the year 2020 new Date(2020).getYear() will yield `120`.
To get the year 2020 as expected use the `getFullYear()` method.

```js
const today = new Date("2020-11-01");
today.getYear() // 120
today.getFullYear() // 2020

today.getMonth() // 10, it is 0 indexed

today.getDay() // 0, it is the number of day in the week, today is Sunday hence 0.

today.getDate() // 1, because it is the first day of November
```

These methods above have setters to set the desired value.

#### Getting a (formatted) date string

Using one of the built in methods to get the string representation of a date is easy, and we have several of them that help to get, UTC, ISO date strings or just the date or just the time component.

```js
const today = new Date();
today.toUTCString() // "Sun, 01 Nov 2020 11:10:09 GMT"
today.toISOString() // "2020-11-01T11:10:09.227Z"
today.toJSON() // "2020-11-01T11:10:09.227Z"
today.toGMTString() // "Sun, 01 Nov 2020 11:10:09 GMT"

today.toLocaleDateString() // "01/11/2020"
today.toLocaleString() // "01/11/2020, 11:10:09"
today.toLocaleTimeString() // "11:10:09"
```

But very often we need the option to get a date string based on a specific format. In some cases the `Internationalisation API` can help with this, but for not-so-special cases like this: "yyyyMMdd" we need to break the date down to its components and use regular string methods to achieve the required format. There are many date libraries out there to help you with this, but as always it's worth knowing how to do this yourself.

```js
// Using the Intl API

const today = new Date("2020-11-01")
new Intl.DateTimeFormat('en-US').format(today)
// "11/1/2020"

new Intl.DateTimeFormat('en-GB').format(today) 
 // "01/11/2020"

new Intl.DateTimeFormat('en-GB', {year: "numeric", month: "short"}).format(today)
// "Nov 2020"

new Intl.DateTimeFormat('en-GB', {year: "numeric", month: "short", day:"numeric"}).format(today)
// "1 Nov 2020"
```

To achieve that special case above, we could use this:

```js
let [year, month, day] = today.toISOString().slice(0,10).split("-")

`${year}${month}${day}` // 20201101
```

There is much more to dates, we haven't had a look at computing duration and other arithmetics with dates, there are timezones, locales that might be in the scope of an advanced cheat sheet.

### DOM

Interacting with the Document Object Model or DOM. The DOM is a representation of the HTML or XML page with a tree like data structure with objects as nodes. Using Javascript, with the help of the DOM we can update, modify the HTML page.

### Browser


### Events

## Conclusion