#!/bin/bash
set -euo pipefail

echo "Starting Jekyll server..."

# Function to start Jekyll
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

# Trap signals to stop Jekyll gracefully
trap "echo 'Stopping Jekyll...'; kill $JEKYLL_PID || true; exit 0" SIGINT SIGTERM

start_jekyll

# Watch _config.yml for changes
while true; do
    inotifywait -q -e modify,move,create,delete _config.yml
    echo "Detected change in _config.yml, restarting Jekyll..."
    kill $JEKYLL_PID || true
    start_jekyll
    sleep 1
done
