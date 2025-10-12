# Use official Ruby slim image
FROM ruby:3.2-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production \
    EXECJS_RUNTIME=Node

# Install system dependencies including inotify-tools
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        imagemagick \
        python3-pip \
        zlib1g-dev \
        locales \
        gnupg \
        ca-certificates \
        apt-transport-https \
        lsb-release \
        nodejs \
        npm \
        inotify-tools && \
    pip3 install --no-cache-dir nbconvert --break-system-packages && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*

# Set work directory
WORKDIR /srv/jekyll

# Copy Gemfile first to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN gem install --no-document jekyll bundler && \
    bundle install --no-cache

# Copy entry point script
COPY bin/entry_point.sh /tmp/entry_point.sh
RUN chmod +x /tmp/entry_point.sh

# Copy the site content
COPY . .

# Remove .git to prevent Render exit 128
RUN rm -rf .git

# Expose port 4000 (for Jekyll) or 10000 if you prefer
EXPOSE 4000

# Start Jekyll
CMD ["/tmp/entry_point.sh"]
