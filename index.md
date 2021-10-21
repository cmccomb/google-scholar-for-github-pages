---
layout: default
title: Google Scholar for GitHub Pages
---
# How to use

# Examples

## Include all publications
To include every single publication in your csv file, use:
{% raw %}
{% include publications %}
{% endraw %}

<details>
<summary><h3>Example output</h3></summary>
{% include publications %}
<details>
  
## Include publications from specific venues
To include publications in specific venues, pass the `venue` variable to the include. You can pass in multiple venues separated by semi-colons.
{% raw %}
{% include publications venue="Journal of Mechanical Design;Design Studies" %}
{% endraw %}

<details>
<summary><h3>Example output</h3></summary>
{% include publications venue="Journal of Mechanical Design;Design Studies" %}
</details>

## Include publications from specific years
To include publications from specific years, pass the `year` variable to the include. You can pass in multiple years separated by semi-colons.
{% raw %}
{% include publications year="2017;2021" %}
{% endraw %}

<details>
<summary><h3>Example output</h3></summary>
{% include publications year="2014" %}
</details>

## Include publications by specific authors
### Example output

## Throwing it all together
The best part is that all of these options play nicely together! For instance, to get all publications with authors Ayush Raina OR Glen Williams that were published in years 2021 OR 2020 OR 2019 in the venue Design Studies, use this command:
{% raw %}
{% include publications author="Raina,Ayush;Williams,Glen" year="2021;2020;2019" venue="Design Studies"%}
{% endraw %}
### Example output
