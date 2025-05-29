---
title: Create your own CircleCI dashboard
author: Laszlo Bogacsi
type: post
date: 2020-09-05T13:13:54+00:00
url: /2020/09/05/create-your-own-circleci-dashboard/
coverCaption: "Photo by <a href=\"https://unsplash.com/@dawson2406?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash\">Stephen Dawson</a> on <a href=\"https://unsplash.com/photos/turned-on-monitoring-screen-qwtCeJ5cLYs?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash\">Unsplash</a>"

categories:
  - CircleCI
  - Cloud computing
  - Dashboards
tags:
  - AWS
  - CircleCI
  - CSS
  - NodeJS
  - React
---

Have you noticed that [Circle CI][1] is a great hosted CI/CD platform but is lacking a good dashboard? Or as a matter of fact any dashboard. [edit: at the time of writing in 2020]

Have you found yourself in a situation where you have a bunch of projects and a team working on many of these at the same time, and all you wanted is a clean UI which tells you the latest state of the build for each project you’re interested in for a particular branch?

There are many readily available build monitor plugins and dashboard solutions out there like the great [Dashing][2] project or [build monitor plugin][3] for Jenkins, and some other hosted platforms have their own dashboards, but not CircleCI. However, they have a nice [API, and version 2][4] is freshly out so let's build on it and make something nice.

Let's just say I got inspired by [Timo Schwarzer's GitLab dashboard][5], it looks cool and I wanted to make something similar.

## Understanding the data

This project is data heavy, so as always, first let's understand the data we're going to deal with.

{{< figure src="CircleCiDataComponents.png" alt="Abstract purple artwork" caption="Circle CI data components" >}}

For a particular project and branch, we have pipelines, each pipeline has workflows, a workflow has jobs, and jobs have steps.

This data can be easily translated into a UI widget that displays the latest pipeline of a project for a branch.

{{< figure src="DashboardWidget.png" alt="Dashboard Widget" caption="Dashboard Widget" >}}

The widget displays all the workflows for a pipeline, which can be many, when you keep rerunning a workflow. Also on display are the jobs for a workflow. I've left out the steps as with them the UI would be too cluttered and they aren't valuable in this high-level view.

All the information in a widget functions as a link to the underlying resource. The project name, for example, points to the Github repo, the commit message takes you to the commit on Github, while a workflow name points to a CircleCI workflow, and the circled icons are links to the CircleCI jobs.

The background colour of a widget represents the overall state of the latest pipeline’s most recent workflow (in case you keep rerunning the same workflow, it takes the state of the most recent).

Similarly, the icons represent the corresponding jobs’ state.

{{< figure src="Dashboard.png" alt="CircleCI Dashboard" caption="CircleCI Dashboard" >}}

## Architecture

Similar to most of my pet projects, this also started as a Create React App frontend module with TypeScript and functional components and hooks, and a NodeJs with Express backend module organised in a monorepo.

Yeah, I wish, but it didn't.

I had a really lightweight little something in mind, and all it does is just making a couple of API calls to CircleCI. Ahh so the browser can do it, right? Who needs a backend, right? Wrong! Why, it's hardly doing any data processing and the retrieved data is small in size so I'm sure the browser can do it. And the requests are working just fine from Postman. But because of [CORS][6], this gets me every time. So yes, the backend is needed very much.

As the backend progressed, I started to think about deployment and infrastructure and I realised, these request handlers would make perfect AWS Lambda functions behind an APIGateway as they are stateless (more about authentication further down) and they don't serve too much data at a time or at least certainly inside the allowed request and response body payload size of 6 MBs (at the time of writing).

To keep the dashboard as fresh as possible this approach implements a polling approach and the user can set the frequency of how often should the dashboard reload the data.

## Authentication and Application State

I wanted to avoid user management for this project.

To use CircleCI APIs one needs an API token.

The first naive approach would be, just “to get things working”, is to use my own API token, and forget about this until a later stage. There is no point in having a token “for the server” because the projects you follow and the data you are allowed to see is all tied to your CircleCI account.

So the user has to have an opportunity to input his/her API token. In this case the user would need to log in and store the token somewhere. But as I said I wanted to avoid user management for this project as this is more about the dashboard than the user.

Luckily CircleCI allows access to user data through the API, like name, avatar etc so if I have the token then I have some basic user info as well. But what can I do to not store the user's token on the server side?

**Cookies** to the rescue.

During this project I learned a lot about cookies. And an http-only secure cookie with an expiry date seemed like a reasonable solution. I was ok with the secureness as we're not looking at top secret data here, however one can kick off a pipeline build through the API therefore encrypting the token and implementing CSRF measures is important — this bit is yet to be developed. So to get this working I needed a login page with an input for the API token, this sends the token to the server which in turn sets the http-only cookie in the response header. Next time the browser makes a request it sends the cookies, the server parses them and uses the token to make a request to CircleCI.

It turns out it's fairly easy to do:

```js
res.cookie(cookieName, cookieContent, {httpOnly: true, secure: true, maxAge: 900000}).status(200).send();
```

Every now and then the cookie expires, then the server removes the cookie with the token from the header and you'll be redirected to the login page.

What about other application state? In the app you can select projects and branches to display the build state in a widget. This needs to be persisted somewhere. It's not particularly sensitive information as it's basically a list of

```js
[{organisation: "myorg", project: "my-great-project", branch: "master"}, ... ]
```

Let's store it in **browser local storage**.

Storing and retrieving data from local storage:

```js
localStorage.setItem(key, value)
localStorage.getItem(key)
```

The relevant component checks if there is any data in local storage with the given key, loads it into the component or loads an initial state otherwise.

## Learnings

On this handy pet project I've learned a lot about organising neatly a smaller React project like this one, React hooks, CSS and Cookies and browser security in general, CSRF, XSS.

### CSS — 3 rules

Finally I've reached that point in life where aligning something to the centre with CSS is no longer the pain point of the styling process.

Over the countless joyful hours of reading the latest [css-tricks][7] a couple of things stuck.

> 1. Use Grid for large scale page structure and use Flex for smaller scale component structuring  
> 2. Use CSS variables  
> 3. This is your friend:  
>    ```
>    display: flex
>    align-items: center;
>    justify-content: center;
>    ```

### React — Organise!

Organising files into some meaningful structure can often help to think about a project easier, there are many suggestions circling around but each project is different, so there is no one good answer.

These pet projects tend to be smaller and less complex than average production apps but somewhat larger and more elaborate than an average hello world tutorial app. It's not perfection, but this is as close I could get to a satisfying folder structure, here it is, using the example of my CircleCI dashboard app:

{{< figure src="ProjectStructure.png" alt="Project" caption="Project" >}}
{{< figure src="ComponentsStructure.png" alt="Components" caption="Components" >}}
{{< figure src="OneComponentStructure-1.png" alt="One Component" caption="One Component" >}}

The idea was to group the components by routes, so this means that we have a `/dashboard`, a `/login` etc. route and to avoid deep nesting I chose a flat structure so I went with placing each of the components under a route in a component-named folder along with its tests and stylesheet consistently named as `style.module.css` and extracted any commonly used hooks to a `hooks.ts` file.

During this I became a fan of absolute imports, they are neat. Since I'm using TypeScript, to enable this, I placed the following code to my `tsconfig.json`:

```json
{
  "compilerOptions": {
    ...
    "baseUrl": "src"
  },
  "include": ["src"]
}
```

Avoiding the `../../../../SomeComponent.hell.ts`  
We'll have something like this while following the convention where components are PascalCase and everything else is camelCase.

```js
import {useFollowedProjects} from "components/ProjectsManager/hooks";
```

## Conclusion

This was a great way to gain some React mileage and learn a lot about custom React hooks, browser security and CORS and to bag some CSS experience too. For the future I'd like to implement a WebSocket-based approach where only the changing data gets refreshed on a push basis rather than the current “poll and grab all the data”, to give the dashboard a “real-time” feeling.

If you're still reading, thank you, I hope you've found some of this useful.

[1]: https://circleci.com
[2]: http://dashing.io/
[3]: https://plugins.jenkins.io/build-monitor-plugin/
[4]: https://circleci.com/docs/api/v2/#circleci-api
[5]: https://github.com/timoschwarzer/gitlab-monitor
[6]: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
[7]: https://css-tricks.com/