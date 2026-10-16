# Google Scholar for GitHub Pages

[![CI status](https://img.shields.io/github/actions/workflow/status/cmccomb/google-scholar-for-github-pages/ci.yml?branch=main&label=CI)](https://github.com/cmccomb/google-scholar-for-github-pages/actions/workflows/ci.yml)
[![Latest release](https://img.shields.io/github/v/release/cmccomb/google-scholar-for-github-pages?label=release)](https://github.com/cmccomb/google-scholar-for-github-pages/releases/latest)
[![Liquid test coverage](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fcmccomb%2Fgoogle-scholar-for-github-pages%2Fmain%2Fcoverage%2Fliquid-branches-badge.json&label=Liquid%20test%20coverage)](coverage/liquid-branches.json)
[![MIT license](https://img.shields.io/github/license/cmccomb/google-scholar-for-github-pages)](LICENSE)

Publish a Google Scholar CSV as a formatted, filterable publication list on a Jekyll site. The renderer is a single Liquid include, with no custom Jekyll plugin or browser-side API request. Your CSV remains in your repository, so updates happen when you replace that file and rebuild the site.

**[Live demo](https://cmccomb.com/google-scholar-for-github-pages/)** · **[Lab example](https://cmudrc.github.io/)**

## Quick start

1. In [your Google Scholar profile](https://scholar.google.com/), select all articles using the checkbox beside **Title**, choose **Export**, then **CSV**. [Google Scholar's help](https://scholar.google.com/intl/en/scholar/citations.html) describes the export steps. Review the export for duplicates or missing works before publishing it.
2. Save the file as `_data/citations.csv` in your Jekyll repository. The required columns are `Authors`, `Title`, `Publication`, and `Year`. An optional `DOI` column may contain a `https://doi.org/` URL or a bare DOI beginning with `10.`. See [the small sample CSV](examples/citations.csv).
3. Copy [`_includes/publications`](https://github.com/cmccomb/google-scholar-for-github-pages/blob/main/_includes/publications) into your site's `_includes/` directory.
4. Add this to a page:

   ```liquid
   {% include publications link=true %}
   ```

The list is newest first. With `link=true`, titles link to their DOI when one is provided, or to a Google Scholar title search. Leave `link` out for plain text titles.

## Filter and format

```liquid
{% include publications limit=5 link=true %}
{% include publications author="Lovelace" year="2025;2026" link=true %}
{% include publications venue_search="design" venue_search_exclude="conference" %}
{% include publications style="mla" %}
{% include publications compact=true limit=3 link=true %}
```

| Parameter | Effect |
| --- | --- |
| `author` | Case-insensitive substring in the `Authors` field. |
| `year` | Exact year. |
| `venue` | Exact, case-insensitive publication venue. |
| `venue_exclude` | Exclude exact venues. |
| `title_search` | Case-insensitive substring in the title. |
| `venue_search` | Case-insensitive substring in the venue. |
| `venue_search_exclude` | Exclude venues containing a term. |
| `limit` | Maximum number of matching publications. |
| `link` | Set to `true` to link titles. Default: `false`. |
| `style` | `apa` (default), `mla`, `chicago`, `harvard`, or `vancouver`. |
| `compact` | Set to `true` for title, year, and venue only. Overrides `style`. |

Separate multiple values in a filter with semicolons. Values within one filter use **OR**; different filters use **AND**. For example, `year="2025;2026" venue_search="design"` includes design venues from either year.

The citation styles are lightweight formats for website lists, not a substitute for a full citation processor. Check the rendered output if your data contains unusual author names or publication types.

## Demo data and updates

The [demo CSV](_data/citations.csv) mirrors the Design Research Collective's public publication data, including entries from 2026. It demonstrates a full-size list; use [the sample CSV](examples/citations.csv) for a small installation test. The demo is a snapshot, not a live Google Scholar sync. To refresh your own site, export a new CSV, review it, replace `_data/citations.csv`, and rebuild.

## Development

```bash
gem install 'jekyll:4.4.1' 'jekyll-theme-tactile:0.2.0'
ruby tests/test_publications.rb
jekyll build
```

[GitHub Actions](.github/workflows/ci.yml) tests and builds with Jekyll 3.10, 4.3, and 4.4 on pushes and pull requests. The renderer itself uses only Liquid and Jekyll filters, which keeps it compatible with GitHub Pages' Jekyll builds.

The coverage badge counts exercised paths through the Liquid include's `if`, `unless`, and `for` tags, including implicit `else` and empty-loop paths. It does not measure Ruby lines. Running the tests regenerates the [branch report](coverage/liquid-branches.json); CI checks that the committed report matches.

## License

[MIT](LICENSE)
