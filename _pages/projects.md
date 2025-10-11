---
layout: page
title: Projects
permalink: /projects/
nav: true
nav_order: 3
horizontal: false
---

<style>
  /* Background for the projects page */
  .projects {
    position: relative;
    background-image: url('{{ "/assets/img/Morse2.gif" | relative_url }}'); /* your GIF */
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    padding: 3rem 1rem;
    border-radius: 12px;
    overflow: hidden;
    margin-bottom: 2rem;
  }

  /* Overlay for readability */
  .projects::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0, 0, 0, 0.3);
    z-index: 0;
  }

  /* Ensure all project cards appear above the overlay */
  .projects > * {
    position: relative;
    z-index: 1;
  }

  /* Category headings styling */
  .category {
    color: #004d40;
    border-bottom: 2px solid #00695c;
    padding-bottom: 6px;
    margin-top: 1.5rem;
    margin-bottom: 1rem;
  }
</style>

<div class="projects">

{% if site.enable_project_categories and page.display_categories %}
  <!-- Display categorized projects -->
  {% for category in page.display_categories %}
    <a id="{{ category }}" href="#{{ category }}">
      <h2 class="category">{{ category | capitalize }}</h2>
    </a>

    {% assign categorized_projects = site.projects | where: "category", category %}
    {% assign sorted_projects = categorized_projects | sort: "importance" %}

    {% if page.horizontal %}
      <div class="container">
        <div class="row row-cols-1 row-cols-md-2">
          {% for project in sorted_projects %}
            {% include projects_horizontal.liquid %}
          {% endfor %}
        </div>
      </div>
    {% else %}
      <div class="row row-cols-1 row-cols-md-3">
        {% for project in sorted_projects %}
          {% include projects.liquid %}
        {% endfor %}
      </div>
    {% endif %}
  {% endfor %}
{% else %}
  <!-- Display all projects without categories -->
  {% assign sorted_projects = site.projects | sort: "importance" %}

  {% if page.horizontal %}
    <div class="container">
      <div class="row row-cols-1 row-cols-md-2">
        {% for project in sorted_projects %}
          {% include projects_horizontal.liquid %}
        {% endfor %}
      </div>
    </div>
  {% else %}
    <div class="row row-cols-1 row-cols-md-3">
      {% for project in sorted_projects %}
        {% include projects.liquid %}
      {% endfor %}
    </div>
  {% endif %}
{% endif %}
</div>
