# Google Scholar for GitHub Pages
This is a Jekyll include file that pulls from a Google Scholar CSV file to output and format your references. Using it is pretty simple!

1. Download your Google Scholar publications as a CSV. Make sure you get all of them.
2. Upload that CSV file to the `_data/` directory of your site directory and make sure it's named `citations.csv`.
3. Download the `publications` include file from this repository ([here](https://github.com/cmccomb/google-scholar-for-github-pages/blob/main/_includes/publications)).
4. Upload that file to the `_includes/` directory of your site.
5. That's it! You can see some usage examples and documentation [here](https://cmccomb.com/google-scholar-for-github-pages/).

Optionally filter publications by passing parameters to the `publications` include. For example, set `venue_search_exclude` to a semicolon-separated list of venue terms to omit entries whose venue contains any of those terms.

This is similar to [Jekyll Scholar](https://github.com/inukshuk/jekyll-scholar), but since this is a pure Liquid solution it works seamlessly with Github Pages!

## Development

Run the tests and build the site before publishing changes:

```bash
gem install 'jekyll:4.4.1' 'jekyll-theme-tactile:0.2.0'
ruby tests/test_publications.rb
jekyll build
```

A GitHub Actions workflow runs these commands automatically and only builds the site when the tests succeed.
