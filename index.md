---
layout: default
title: Google Scholar for GitHub Pages
---

# How to use
1. Go to your google scholar page and select all of your publications. Then select the option to export a CSV. ![](/assets/images/export-csv.png)
2. Next, make sure that you download all of your publications. ![](/assets/images/export-all.png)
3. Upload this file to `_data/` directory in your Github Pages repository. It must be named `citations.csv`. Sometimes there is an extra character at the beginning of the first line of the CSV. You should remove this.
4. Download the [publications](https://github.com/cmccomb/google-scholar-for-github-pages/blob/main/_includes/publications) include file and upload it to the `_includes/` directory in your in your Github Pages repository.
5. You're ready to go! See below for some different use cases. 

# Examples
You can use this include file to slice and dice your publications in several different ways. 

## Include all publications
To include every single publication in your csv file, use:
{% raw %}
{% include publications %}
{% endraw %}

<details>
<summary><i>Example output</i></summary>
{% include publications %}
</details>
<br/>

  
## Include publications from specific venues
To include publications in specific venues, pass the `venue` variable to the include. You can pass in multiple venues separated by semi-colons.
{% raw %}
{% include publications venue="Journal of Mechanical Design;Design Studies" %}
{% endraw %}

<details>
<summary><i>Example output</i></summary>
{% include publications venue="Journal of Mechanical Design;Design Studies" %}
</details>
<br/>

## Include publications from specific years
To include publications from specific years, pass the `year` variable to the include. You can pass in multiple years separated by semi-colons.
{% raw %}
{% include publications year="2014;2015" %}
{% endraw %}

<details>
<summary><i>Example output</i></summary>
{% include publications year="2014;2015" %}
</details>
<br/>

## Throwing it all together
The best part is that all of these options play nicely together! For instance, to get all publications from years 2015 OR 2016 in the venues Journal of Mechanical Design OR Design Studies, use this command:
{% raw %}
{% include publications year="2015;2016" venue="Journal of Mechanical Design;Design Studies"%}
{% endraw %}

<details>
<summary><i>Example output</i></summary>
{% include publications year="2015;2016" venue="Journal of Mechanical Design;Design Studies"%}
</details>
