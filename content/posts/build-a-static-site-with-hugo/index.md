---
title: Build your personal site with Hugo on Github
author: Laszlo Bogacsi
type: post
coverCaption: Photo by <a href="https://unsplash.com/@snowshade?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Oleg Laptev</a> on <a href="https://unsplash.com/photos/orange-megaphone-on-orange-wall-QRKJwE6yfJo?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
      
date: 2025-06-10T21:00:00+00:00 
url: /2025/06/10/personal-site-with-hugo-ssg-on-github/
categories:
  - Web Development
  - Personal brand
tags:
  - SSG
  - Markdown
  - Hugo

---


# Do you still need a personal site in 2025?
It's part of your brand, it's an outlet to your thoughts if you want, a place to showcase your projects, or just have fun with things you don't get to do in the 9-5.
The usefulness I feel, based on no data whatsoever, is probably questionable. 
It'll likely have incredibly low traffic and hardly useful engagement. But you know, maybe it'll help the one developer whos in the same situation, looking for the same thing you're writing about, if this happens I'd say it's worth it.

In the age of AI, what is an original thought anyway ;) 

# Why [Hugo](https://gohugo.io/)?
{{< figure src="hugo-logo.png" alt="Hugo Logo" class="ma0 w-24" >}}

I love the simplicity of it, uses markdown as your canvas which you're probably more familiar with than you'd like, you write your daily notes in obsidian using markdown, this how you detail your PRs on Github, and the adventurer in you uses it to create wiki pages noone will ever read, and frankly it is enough for most things, or it should be enough. If it isn't ask yourself: "what do you want to achieve that can't be done with some nicely structured plain markdown and a few images". Do you want shiny stuff that moves sparkles and smells nice? Oh so you need Javascript to enrich your experience and ruin your site that can be just as simple as a handful of .md files? You can but, ..really?

Hugo was written in go, this somehow provides a false sense of comfort, since I use go in the day to day.
It's an SSG or Static Site Generator, so it renders the site at build time and serves the pre cooked pages with lighning speed.

It's free, every piece of it is. 

# Why not something else?

## Worpress
I tried selfhosted wordpress, on aws, with free tier, and all the faff around having an rds mysql db instance and a single ec2 t2.nano (or micro, whichever is in the free tier) and the only thing that kept me going was the idea of "free". But it came at a cost, the cost of complexity. Which in my case felt large, for what I was trying to accomplish.

### Complexity Catch
At first I enjoyed figuring out the cloudformation template that could build the whole infrastructure and could tear it down, and this was repeatable.
But complex. When setting up something like this from scratch, the adventure and fun lies within the details and the process to discover it. Once it was done and working, it became a chore. Year on year, creating a new aws account with a new email, just to make use of the free tier and the 750 hours of monthly gifted compute time. Then run the template that creates vpc with public and private subnets, security groups, iam roles, spins up rds mysql instance and an ec2 all with the right networking, restricted ssh port access and installed https certs. Then scripts to setup nginx and wordpress and then resurrect the blog from a backup, year on year. Then sort out route 53, hosted zones and the dns setup. And voila it was alive. 

This was tedious. 

## Others
Were there any other solutions?
Surely, but there was always a catch, a paywall, or a marketplace wordpress image that would need paying for.

But then use something else to deploy it.. yeh, been there, show me the free one as soon as it has the word "managed" it'll have a cost attached. Fair enough, I'm paying for hard work of others, nothing wrong with that. But somehow I feel joy when I can avoid it give what I want is dad simple and need not to be complicated.

Looked at other technologies, strapi, ghost, and other CMS systems, which are great, if I want the job of developing my site instead of writing content for it.

At this point I was happy to trade in the custom react ui, or the convenience of the article publishing pipeline and the ability of having a more responsive interactive site with comments and discussions.

Simplicity won!

# How to deploy a Hugo static site on Github?
When your case is simple, and you're not using your github pages for anything else, than carry on reading.

Ingredients:

Setup:
- create a repo with your-github-username.github.io
- install hugo locally
- create a project with hugo
- install a theme
- setup a few things like site Title, author details etc...
- connect your own custom domain
- install a cert to have `https://`

Deployment pipeline:
- create github actions

Local Development:
- make a change, write a post
- run the hugo server
- observe the changes with live reload

Workflow and publish
- publish it (commit, push, PR, merge (if you want))
- watch it being deployed
- visit your custom domain
- Done!


# How to.. or how not to

Bazinga![^1] I won't go into the actuall "how-to", both Github and Hugo got comprehensive documentation on that.

However there are a couple of quirks I wanted to hightight that weren't immediatelly obvious.

1. Themes as go modules
2. Adding styling to things
3. Post hero images and crediting.
4. Draft


### 1. Themes as go modules

Most tutorials or quick start guides will tell you to set up a git submodule.

If you haven't worked with git or git submodules much it'll be confusing. Sure I realise the site is deployed on Github, so some level of git will be involved, but when I ask about "what's your favourite git workflow".. as you normally would on a human conversation.. and the response is blank stares then it's a good challenge.

So while you figured out how to clone a remote repo to local, and you learned to commit and push, or you might have an actual answer to the question above, good on you, otherwise, grabbing the theme as a go module might seem a little less complex.

To set that up, just

```shell
go mod init
```

this will create a file named `go.mod`

Hop in there, fix your module name if it's not already done, it should read:
```go
module github.com/your_github_username/your_github_username.github.io
```
(yes.. twice)

for me it's: `module github.com/laszlobogacsi/laszlobogacsi.github.io`

and then just
```shell
go get [theme_package]
```

for eg in this site it's: `go get github.com/jpanther/congo/v2@latest`

`@latest` just refers to the whatever the latest available version is.

and when there is an update, or you want to switch themes, just `go get` it.


### 2. Adding style to things

The theme I'm using uses Tailwind, so to add something extra like let's say you'd want to control the width of an element, just add a tailwing class to the element like this:
```
class="w-24"
```
.. why 24? because! Tailwind figured w-4 is your base line, meaning `1 rem`, so 24 is `4 rem` what is rem? Well, look it up in another article please.

In markdown you can also use html tags it'll be understood by most of the markdown engines. But you see you're a programmer now, and for some reason not being idiomatic is frowned upon, because.. well, because you can it doesn't always mean you should.

So you know adding an image in markkdown is `![](path/to/image.jpg)` but nowhere to put your class if you want a different size image.

Of course you could just add `<img src="path/to/image.jpg" class="some-class-name" width=50% alt="always add alt.. please" />` but now we know this is only for the dark side.

If you want to stay on the right side of the force and not risk being ostracised by people you don't know, be idiomatic and use Hugo shorthands for images, a `figure` block

```md
{{< figure src="path/to/image.png" alt="Description of the image" class="w-24" >}}
```

### 3. Post hero images and crediting

Perhaps it wasn'tobvious onbly for me. I blame old age and worsened eyesight :) 
This will likely be different from theme to theme. The theme I'm using likes some naming convention, so if you kindly prefix your chosen featured image with `feature-` it'll just automagically pop to the top of your post, and it'll use it in list view too.

We all know that you did not take that photo, and did not create that image.. probably.. likely.. so go ahead and credit the lovely person who made it available for you problably for free on unsplash.. or just thank chatgpt, midjourney or whatever you used to mush some pixels together.

To do this you can add some metadata to your `Front Matter`. This is the section at the top of each `.md` file you create between the `---` markers

My theme supports some extra meta tags, to add an image caption you can add `coverCaption` and add your credit there.

### 4. Draft

If you've used any CMS systmes before, the idea of the "draft" state should be familiar. This indicates, your creation is not ready for eyes of the public just yet, but you've made some progress you'd like to save it, and after necking down some matcha latte you wishing to continue. 

For this you can just add `draft: true` to your Front Matter section, and the article won't be available for public viewing (Hugo will skip building it and copying it over to the public folder.)

But you very much would like to see this page locally, to do so start the local hugo server with an option:

```shell
hugo server --buildDrafts
```

This option will include the articles marked as "draft" as well and your theme will likely add a nicely styled "draft" tag to the articles.


# Conclusion

For some reason this section is a must, so if you're still reading along, thanks!

Keep creating simple sites. For static sites, Hugo is a great choice.

___
[^1]: Great show, if you don't know where is the reference from.. and you're reading this.. look  it up you'll probably enjoy it :) 