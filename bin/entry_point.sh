#!/bin/bash
set -euo pipefail

echo "Entry point script running"

CONFIG_FILE="_config.yml"

# Function to manage Gemfile.lock
manage_gemfile_lock() {
    git config --global --add safe.directory '*'
    if command -v git &> /dev/null && [ -f Gemfile.lock ]; then
        if git ls-files --error-unmatch Gemfile.lock &> /dev/null; then
            echo "Gemfile.lock is tracked by git, keeping it intact"
            git restore Gemfile.lock 2>/dev/null || true
        else
            echo "Gemfile.lock is not tracked by git, removing it"
            rm -f Gemfile.lock
        fi
    fi
}

# Function to start Jekyll
start_jekyll() {
    manage_gemfile_lock
    echo "Starting Jekyll server..."
    bundle exec jekyll serve \
        --watch \
        --port="${PORT:-8080}" \
        --host=0.0.0.0 \
        --livereload \
        --verbose \
        --trace \
        --force_polling &
    JEKYLL_PID=$!
}

# Function to stop Jekyll safely
stop_jekyll() {
    if [ -n "${JEKYLL_PID:-}" ] && kill -0 "$JEKYLL_PID" 2>/dev/null; then
        echo "Stopping Jekyll (PID $JEKYLL_PID)..."
        kill -TERM "$JEKYLL_PID"
        wait "$JEKYLL_PID" 2>/dev/null || true
    fi
}

# Start Jekyll for the first time
start_jekyll

# Watch for changes in _config.yml and restart Jekyll
while true; do
    inotifywait -q -e modify,move,create,delete "$CONFIG_FILE"
    echo "Change detected in $CONFIG_FILE, restarting Jekyll..."
    stop_jekyll
    start_jekyll
done
