---
layout: page
permalink: /memories/manali-trip/
---
<h2>Manali Trip</h2>

<div class="gallery">
  {% assign base_path = '/assets/img/memories/manali/' %}
  {% assign media_files = site.static_files | where_exp: "file", "file.path contains base_path" | sort: "name" %}
  
  {% for file in media_files %}
    {% assign ext = file.extname | downcase %}
    
    {% if ext == ".jpg" or ext == ".jpeg" or ext == ".png" or ext == ".gif" %}
      <img src="{{ file.path | relative_url }}" alt="Manali Trip Photo">
    {% elsif ext == ".mp4" or ext == ".webm" %}
      <video controls>
        <source src="{{ file.path | relative_url }}" type="video/{{ ext | remove: '.' }}">
        Your browser does not support the video tag.
      </video>
    {% endif %}
  {% endfor %}
</div>

<style>
.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

.gallery img, .gallery video {
  width: 100%;
  border-radius: 8px;
  object-fit: cover;
  box-shadow: 0 4px 10px rgba(0,0,0,0.2);
  transition: transform 0.2s ease-in-out;
}

.gallery img:hover, .gallery video:hover {
  transform: scale(1.05);
}

.gallery video {
  max-height: 300px;
}
</style>
