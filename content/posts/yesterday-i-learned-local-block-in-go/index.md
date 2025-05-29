---
title: Yesterday I learned… local block in Go
author: Laszlo Bogacsi
type: post
date: 2021-07-17T20:11:09+00:00
url: /2021/07/17/yesterday-i-learned-local-block-in-go/
categories:
  - Go
  - Software Development
  - YesterdayILearned
tags:
  - beginner
  - Go
  - Yesterday I learned
---
What are local blocks, how are they influencing scope and visibility?

I’m new to Go. Coming from a Java, Kotlin, Javascript background when I first saw a pair of `{ ... }` with some code in it, but without any variable assignment or method name, I looked kinda baffled.

I felt like I understand what this is but I don’t know what this is. It’s like that familiar stranger on the streets.

Just like in other C like languages, `{ }` signifies a block of code.

_Ok, so what?_

This is good for grouping lines of code together and for scoping.

This has a name, it’s called a local block, or more precisely explicit local block and it comes with its own variable scope. So a variable defined in the local block is only visible in the block or in a child scope of the block, where a child scope can be an if condition or a for loop block, a function or even another local block.

A block that doesn’t have an enclosing “parent” block is called the top-level block. And each block implicitly belongs to the Universe block.