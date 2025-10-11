---
layout: page
title: Memories 📸
permalink: /memories/
---
<h1>{{ page.title }}</h1>

<div class="memory-grid">
  {% assign base_path = '/assets/img/memories/' %}
  {% assign all_files = site.static_files | where_exp: "file", "file.path contains base_path" %}
  
  {% assign grouped = all_files | group_by_exp: "file", "file.path | split: '/' | slice: 4, 1 | first | downcase" %}

  {% for folder in grouped %}
    {% assign folder_name = folder.name | downcase %}
    {% assign first_image = folder.items | first %}
    {% if first_image %}
      <div class="memory-card">
        <a href="{{ '/memories/' | append: folder_name | append: '-trip/' | relative_url }}">
          <img src="{{ first_image.path | relative_url }}" alt="{{ folder_name }}">
          <h2>{{ folder_name | capitalize }} Trip</h2>
        </a>
      </div>
    {% endif %}
  {% endfor %}
</div>

<style>
.memory-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

.memory-card {
  text-align: center;
}

.memory-card img {
  width: 100%;
  height: 180px;
  border-radius: 8px;
  object-fit: cover;
  box-shadow: 0 4px 10px rgba(0,0,0,0.2);
  transition: transform 0.2s ease-in-out;
}

.memory-card:hover {
  transform: scale(1.05);
}

.memory-card h2 {
  margin-top: 0.5rem;
  font-size: 1.1rem;
  color: #333;
}
</style>
