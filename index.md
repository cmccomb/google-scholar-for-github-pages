---
layout: default
title: Google Scholar for GitHub Pages
---

# Google Scholar for GitHub Pages

Turn a Google Scholar CSV into a publication list on a Jekyll site. This is a single Liquid include; your site does not need a custom plugin or a browser-side Scholar request.

[Get the include and setup guide](https://github.com/cmccomb/google-scholar-for-github-pages) · [See the Design Research Collective example](https://cmudrc.github.io/)

## Quick start

1. Export all articles from your Google Scholar profile as CSV.
2. Save the export at `_data/citations.csv` in your site.
3. Copy [`_includes/publications`](https://github.com/cmccomb/google-scholar-for-github-pages/blob/main/_includes/publications) into your site's `_includes/` directory.
4. Add the include to a page:

{% raw %}
```liquid
{% include publications link=true %}
```
{% endraw %}

The optional `DOI` column makes linked titles point directly to the paper. Otherwise, linked titles open a Google Scholar title search. The [README](https://github.com/cmccomb/google-scholar-for-github-pages#filter-and-format) documents every filter and citation style.

## Recent publications

This demo uses the Design Research Collective's public publication data, which includes 2026 entries. It is a CSV snapshot, not a live Scholar feed.

{% include publications limit=5 link=true %}

## Filtered example

The same file can show a smaller list. This example includes journal venues with “design” in the name and excludes conference venues.

{% raw %}
```liquid
{% include publications venue_search="design" venue_search_exclude="conference" limit=5 link=true %}

## Compact example

For a homepage or sidebar, show linked titles with year and venue while keeping the full citation format elsewhere.

{% raw %}
```liquid
{% include publications compact=true limit=3 link=true %}
```
{% endraw %}

{% include publications compact=true limit=3 link=true %}
```
{% endraw %}

{% include publications venue_search="design" venue_search_exclude="conference" limit=5 link=true %}
