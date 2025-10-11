---
layout: page
permalink: /memories/brainware-trip/
---

<h2>BWU-Memories</h2>

<div class="gallery">
  {% assign base_path = '/assets/img/memories/brainware/' %}
  {% assign images = site.static_files | where_exp: "file", "file.path contains base_path" %}
  {% for img in images %}
    <img src="{{ img.path | relative_url }}" alt="Brainware Trip Photo" style="max-width:100%; margin-bottom:10px;">
  {% endfor %}
</div>

<p>Some awesome days in my life during the Brainware Days.</p>

<style>
.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}
.gallery img {
  width: 100%;
  border-radius: 8px;
  object-fit: cover;
  box-shadow: 0 4px 10px rgba(0,0,0,0.2);
  transition: transform 0.2s ease-in-out;
}
.gallery img:hover {
  transform: scale(1.05);
}
</style>
