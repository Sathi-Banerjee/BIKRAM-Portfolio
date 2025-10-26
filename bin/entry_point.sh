#!/bin/bash
set -euo pipefail

# Default port
PORT=${PORT:-4000}

# Initialize JEKYLL_PID safely
JEKYLL_PID=0

echo "Starting Jekyll server on port $PORT..."

# Function to start Jekyll
start_jekyll() {
    echo "Launching Jekyll..."
    bundle exec jekyll serve \
        --host 0.0.0.0 \
        --port "$PORT" \
        --livereload \
        --watch \
        --verbose \
        --trace &
    JEKYLL_PID=$!
}

# Trap signals to stop Jekyll gracefully
trap 'echo "Stopping Jekyll..."; kill $JEKYLL_PID 2>/dev/null || true; exit 0' SIGINT SIGTERM

# Start Jekyll for the first time
start_jekyll

# Directories/files to watch
WATCH_ITEMS="_config.yml _posts _layouts _includes assets"

# Watch for changes and restart Jekyll
while true; do
    inotifywait -q -r -e modify,move,create,delete $WATCH_ITEMS
    echo "Detected changes, restarting Jekyll..."
    if ps -p $JEKYLL_PID > /dev/null 2>&1; then
        kill $JEKYLL_PID || true
    fi
    start_jekyll
    sleep 1
done
