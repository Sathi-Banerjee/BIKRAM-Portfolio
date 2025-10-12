#!/bin/bash
set -euo pipefail

echo "Starting Jekyll server..."

# Function to restart Jekyll if _config.yml changes
start_jekyll() {
    bundle exec jekyll serve \
        --host 0.0.0.0 \
        --port "${PORT:-10000}" \
        --livereload \
        --watch \
        --verbose \
        --trace &
    JEKYLL_PID=$!
}

start_jekyll

# Watch _config.yml for changes
while true; do
    inotifywait -q -e modify,move,create,delete _config.yml
    echo "Detected change in _config.yml, restarting Jekyll..."
    kill -9 $JEKYLL_PID || true
    start_jekyll
done
