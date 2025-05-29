---
title: HomeHub 5 – Backend Service and UI
author: Laszlo Bogacsi
type: post
date: 2020-09-21T00:00:00+00:00
coverCaption: Photo by <a href="https://unsplash.com/@jouwdan?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Jordan Harrison</a> on <a href="https://unsplash.com/photos/blue-utp-cord-40XgDxBfYXM?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
draft: true
categories:
  - Uncategorized
---

> I’ve built a home automation system from scratch. This is the 5th part of a series of posts discussing the backend service and the UI

The project's main purpose was to build something inexpensive while learning a lot and having as much fun as possible. Besides getting hands on with the electronics part—soldering and wiring and trying to fit the components into project boxes—I really looked forward to learning Python. I'm familiar with some JVM languages, like Java and Kotlin, and Python seemed like a good choice to extend my tool belt. There is/was a huge hype around the language, and it is the most recommended one for data science projects.

My little creation also needed a User Interface, so when I typed python + web + ui one of the top results was Flask. So I chose it for no particular reason other than it’s also something new.

I was excited to start learning this new stack.

## Python

{{< figure src="pngegg.png" alt="Python" caption="Python" class="w-24">}}

> Python is an interpreted, dynamically typed…, garbage collected, high level, general purpose programming language. It supports multiple programming paradigms: …procedural, object oriented and functional programming… .
>
> — [Wikipedia](https://en.wikipedia.org/wiki/Python_(programming_language))

It comes with a comprehensive standard library, and it is notable for its use of significant whitespace.

I chose to go with the future proof version 3 of Python. And this is where all the fun starts.

## Package and Python Version management

To grab packages I used [PyPi][1]. And to manage my python environments I learnt a lot about Pipenv and Pyenv.

[1]: https://pypi.org/