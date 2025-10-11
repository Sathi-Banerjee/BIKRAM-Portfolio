---
layout: page
permalink: /memories/rkmvcc-trip/
---

<h2>Msc-Days</h2>

<div class="gallery">
  {% assign base_path = '/assets/img/memories/rkmvcc/' %}
  {% assign images = site.static_files | where_exp: "file", "file.path contains base_path" %}
  {% for img in images %}
    <img src="{{ img.path | relative_url }}" alt="RKMVCC Trip Photo" style="max-width:100%; margin-bottom:10px;">
  {% endfor %}
</div>

<p>Wo din bhi kya din the!!.</p>

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
