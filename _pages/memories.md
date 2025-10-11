---
layout: page
title: Memories
permalink: /memories/
nav: true
nav_order: 5
---



<div class="album-gallery">

  <div class="album">
    <a href="{{ '/memories/bsc-trip/' | relative_url }}">
      <img src="{{ '/assets/img/memories/bsc/photo1.jpg' | relative_url }}" alt="BSc Trip">
      <div class="album-title">BSc Days</div>
    </a>
  </div>

  <div class="album">
    <a href="{{ '/memories/rkmvcc-trip/' | relative_url }}">
      <img src="{{ '/assets/img/memories/rkmvcc/photo1.jpg' | relative_url }}" alt="RKMVCC Trip">
      <div class="album-title">RKMVCC</div>
    </a>
  </div>

  <div class="album">
    <a href="{{ '/memories/brainware-trip/' | relative_url }}">
      <img src="{{ '/assets/img/memories/brainware/photo1.jpg' | relative_url }}" alt="Brainware Trip">
      <div class="album-title">Brainware</div>
    </a>
  </div>

  <div class="album">
    <a href="{{ '/memories/manali-trip/' | relative_url }}">
      <img src="{{ '/assets/img/memories/manali/photo1.jpg' | relative_url }}" alt="Manali Trip">
      <div class="album-title">Manali Trip</div>
    </a>
  </div>

</div>

<style>
.album-gallery {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 25px;
  justify-items: center;
}

.album {
  text-align: center;
  background: #1e1e1e;
  border-radius: 15px;
  padding: 12px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.25);
  transition: transform 0.25s ease-in-out;
  width: 100%;
  max-width: 280px;
}

.album:hover {
  transform: translateY(-7px);
}

.album img {
  width: 100%;
  height: 180px;
  object-fit: cover;
  border-radius: 12px;
}

.album-title {
  margin-top: 10px;
  font-weight: bold;
  font-size: 1rem;
  color: #fff;
}
</style>
