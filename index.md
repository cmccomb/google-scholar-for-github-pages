---
layout: default
title: Google Scholar for GitHub Pages
---

# Setup
1. Download your Google Scholar publications in a csv. Make sure you get all of them. 
2. Upload that csv file to the `_data/` directory of your site directory and make sure its named `citations.csv`.
3. Download the `publications` include file from this repository ([here](https://github.com/cmccomb/google-scholar-for-github-pages/blob/main/_includes/publications)).
4. Upload that file to the `_includes/` directory of your site.
5. You're ready to go! See below for some different use cases.

# Inputs
You can use this include file to slice and dice your publictions in several different ways by passing different parameters. All parameters are optional. Parameters can be used together - when used together, they implicitly have an AND relationship. Results are always shown with the most recent first. 

| Include Parameter | Type | Default | Description |
| :---------------- | :--- | :------ | :---------- |
| `author` | `String` |  | Return publications based on an author search. This uses substring matching, so providing last name only will work. You can provide multiple terms by separating them with semi-colons in the string (i.e., `searchterm="Einstein;Lovelace"`). Matching is not case sensitive. |
| `limit` | `Number` |  | The maximum number of publications to show. If you don't set this value then all publications that match the criteria will be provided. 
| `link` | `Boolean` | `false` | Indicates whether or not a link should be added to the title. The link directs to a Google Scholar search for the title of the publication. |
| `title_search` | `String` |   | Return publications based on whether or not the title contains a specific term. You can provide multiple terms by separating them with semi-colons in the string (i.e., `title_search="kleenex;tissue"`). Matching is not case sensitive. |
| `style` | `String` | `apa` | Set's the citation style for the include. Valid input are `apa`, `mla`, `chicago`, `vancouver`, and `harvard`. Default value is `apa`. |
| `venue` | `String` |   | Return publications based on the venue (conference, journal, workshop, etc) that they were published in. You can provide multiple venues by separating them with semi-colons in the string (i.e., `venue="Journal of Vogon Poetry;Journal of Underwater Basketweaving"`). Matching is precise. |
| `venue_search` | `String` |   | Return publications based on whether or not the search term appears in the name of the publication venue. You can provide multiple search terms by separating them with semi-colons in the string (i.e., `venue="vogon;basketweaving"`). Matching is not case sensitive. |
| `year` | `String` |   | Return publications based on the year they were published. You can provide multiple years by separating them with semi-colons in the string (i.e., `year="2014;2015"`). |


<br/>

# Examples

## All publications
To include every single publication in your csv file, use:

```liquid
{% raw %}{% include publications %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications %}
</details>
<br/>

## Limit on output
To limit the number of publications provided, add the `limit` variable:

```liquid
{% raw %}{% include publications limit=10 %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications limit=10 %}
</details>
<br/>

  
## Specific publication venues
To include publications in specific venues, pass the `venue` variable to the include. You can pass in multiple venues separated by semi-colons.

```liquid
{% raw %}{% include publications venue="Journal of Mechanical Design;design studies" %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications venue="Journal of Mechanical Design;Design Studies" %}
</details>
<br/>

## Specific years
To include publications from specific years, pass the `year` variable to the include. You can pass in multiple years separated by semi-colons.

```liquid
{% raw %}{% include publications year="2014;2015" %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications year="2014;2015" %}
</details>
<br/>



## Specific term in the title
To include publications with a specific term in the title, pass the `title_search` variable to the include. The search term is not case sensitive.

```liquid
{% raw %}{% include publications title_search="additive;startup" %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications title_search="additive;startup" %}
</details>
<br/>

## Specific term in the venue name
To include publications with a specific term in the name of the publication venue, pass the `venue_search` variable to the include. The search term is not case sensitive.

```liquid
{% raw %}{% include publications venue_search="asme" %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications venue_search="asme" %}
</details>
<br/>


## Specific authors
To include publications by specific authors, pass the `author` variable to the include. The search term is not case sensitive.

```liquid
{% raw %}{% include publications author="prakash;defranco" %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
{% include publications author="prakash;defranco" %}
</details>
<br/>


## Citation Style
To include publications by specific authors, pass the `style` variable to the include.

```liquid
{% raw %}{% include publications style="mla" %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
  <ul>
    <li> MLA
      {% include publications style="mla" limit=1 %}      
    </li>
    <li> APA
      {% include publications style="apa" limit=1 %}
    </li>
    <li> Chicago
      {% include publications style="chicago" limit=1 %}
    </li>
    <li> Harvard
      {% include publications style="harvard" limit=1 %}
    </li>
    <li> Vancouver
      {% include publications style="vancouver" limit=1 %}
    </li>
  </ul>
</details>
<br/>



## Link
To turn on the title link, pass `link=true` to the include.

```liquid
{% raw %}{% include publications link=true %}{% endraw %}
```

<details>
<summary><i>Example output</i></summary>
  <ul>
    <li> With link
      {% include publications limit=1 %}      
    </li>
    <li> Without link
      {% include publications link=true limit=1 %}
    </li>
  </ul>
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
