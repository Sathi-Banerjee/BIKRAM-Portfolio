# generate_memories.rb
# Auto-generate memory album pages + album index data for Jekyll

require 'fileutils'

# Paths
memories_dir = File.join(Dir.pwd, "_pages", "memories")
FileUtils.mkdir_p(memories_dir)

assets_memories_dir = File.join(Dir.pwd, "assets", "img", "memories")

# Prepare albums.yml for index page
albums_data = File.join(Dir.pwd, "_data", "albums.yml")
FileUtils.mkdir_p(File.dirname(albums_data))
File.write(albums_data, "") # clear old content

Dir.each_child(assets_memories_dir) do |folder|
  folder_path = File.join(assets_memories_dir, folder)
  next unless File.directory?(folder_path)

  # Collect images
  images = Dir.glob(File.join(folder_path, "*.{jpg,png,jpeg,gif}")).map { |f| File.basename(f) }
  next if images.empty?

  # Format title (split on "-" or "_" and capitalize each part)
  title_name = folder.split(/[-_]/).map(&:capitalize).join(" ")
  title = "#{title_name} Trip"

  # Permalink
  permalink = "/memories/#{folder}-trip/"

  # Generate page content
  page_content = <<~HEREDOC
  ---
  layout: page
  title: "#{title}"
  permalink: #{permalink}
  ---

  <h2>#{title} Memories</h2>

  <div class="gallery">
    #{images.map { |img| "<img src='{{ '/assets/img/memories/#{folder}/#{img}' | relative_url }}' alt='#{title} Photo'>" }.join("\n    ")}
  </div>

  <p>These are some beautiful memories from my #{title_name.downcase} trip.</p>

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
  HEREDOC

  # Write the markdown page
  File.write(File.join(memories_dir, "#{folder}-trip.md"), page_content)

  # Write album info to albums.yml (for index page)
  cover = images.first
  File.open(albums_data, "a") do |f|
    f.puts "- title: \"#{title}\""
    f.puts "  permalink: #{permalink}"
    f.puts "  cover: /assets/img/memories/#{folder}/#{cover}"
  end

  puts "✅ #{title} page created at _pages/memories/#{folder}-trip.md"
end

puts "🎉 All memory pages + albums.yml generated successfully!"
