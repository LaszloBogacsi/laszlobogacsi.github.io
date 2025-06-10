[![GitHub Pages](https://github.com/LaszloBogacsi/laszlobogacsi.github.io/actions/workflows/gh-pages.yml/badge.svg?branch=master)](https://github.com/LaszloBogacsi/laszlobogacsi.github.io/actions/workflows/gh-pages.yml)

# Welcome to laszlobogacsi.com

This is my personal site, where I write some blog articles mainly aroud tech.

## Techstack

- Hugo SSG hugo `v0.145`
- Theme: Congo
- markdown

## Local Development

Build and serve, including draft posts
```shell
hugo server --buildDrafts
```
then visit:
```
http://localhost:1313/
```

## Deployment

- GitHub Actions


Workflow:
```mermaid
flowchart TD
    A[Write Article] --> B[Push]
    B --> C[PR & Review]
    C --> D[Merge]
    D --> E[Build]
    E --> F[Deploy]
```

The output of the build phase is happening on `gh-pages` branch
