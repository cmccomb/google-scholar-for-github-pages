---
layout: default
title: Google Scholar for GitHub Pages
---

# How to use
This is a Jekyll include file that pulls from a Google Scholar csv file to output and format your references. Using it is pretty simple!
1. Download your Google Scholar publications in a csv. Make sure you get all of them.
2. Upload that csv file to the `_data/` directory of your site directory and make sure its named `citations.csv`.
3. Download the `publications` include file from this repository ([here](https://github.com/cmccomb/google-scholar-for-github-pages/blob/main/_includes/publications)).
4. Upload that file to the `_includes/` directory of your site.
5. You're ready to go! See below for some different use cases. 

# Examples
You can use this include file to slice and dice your publications in several different ways by passing different parameters. All parameters are optional. Parameters can also be used together - when used together, they implicitly have an AND relationship. All parameters should be specified as strings.

| Include Parameter | Description |
| :----------------- | :----------- |
| `venue` | Return publications based on the venue (conference, journal, workshop, etc) that they were published in. You can provide multiple venues by separating them with semi-colons in the string (i.e., `venue="Journal of Vogon Poetry;Journal of Underwater Basketweaving"`) |
| `year` | Return publications based on the year they were published. You can provide multiple years by separating them with semi-colons in the string (i.e., `year="2014;2015"`) |
| `searchterm` | Return publications based on whether or not the title contains a specific term. |

<br/>

## Include all publications
To include every single publication in your csv file, use:

```liquid
{% raw %}{% include publications %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications %}
</details>
<br/>

  
## Include publications from specific venues
To include publications in specific venues, pass the `venue` variable to the include. You can pass in multiple venues separated by semi-colons.

```liquid
{% raw %}{% include publications venue="Journal of Mechanical Design;Design Studies" %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications venue="Journal of Mechanical Design;Design Studies" %}
</details>
<br/>

## Include publications from specific years
To include publications from specific years, pass the `year` variable to the include. You can pass in multiple years separated by semi-colons.

```liquid
{% raw %}{% include publications year="2014;2015" %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications year="2014;2015" %}
</details>
<br/>



## Include publications with a specific term in the title
To include publications with a specific term in the title, pass the `searchterm` variable to the include. The search term is not case sensitive.

```liquid
{% raw %}{% include publications searchterm="additive" %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications searchterm="additive" %}
</details>
<br/>

## Throwing it all together
The best part is that all of these options play nicely together! For instance, to get all publications from years 2015 OR 2016 in the venues Journal of Mechanical Design OR Design Studies, use this command:

```liquid
{% raw %}{% include publications year="2015;2016" venue="Journal of Mechanical Design;Design Studies"%}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications year="2015;2016" venue="Journal of Mechanical Design;Design Studies"%}
</details>
