# Use official Ruby slim image
FROM ruby:3.2-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production \
    EXECJS_RUNTIME=Node

# Install system dependencies
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
    pip3 install --no-cache-dir nbconvert && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*

# Set working directory
WORKDIR /srv/jekyll

# Copy Gemfile first (improves build cache)
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies (Jekyll + Bundler)
RUN gem install --no-document jekyll bundler && \
    bundle install --no-cache

# Copy the site content (after dependencies)
COPY . .

# Copy and set entry point script permissions
COPY bin/entry_point.sh /tmp/entry_point.sh
RUN chmod +x /tmp/entry_point.sh

# Ensure no leftover Git metadata (prevents Render status 128)
RUN rm -rf .git

# Expose Jekyll default port
EXPOSE 4000

# Start Jekyll
CMD ["/tmp/entry_point.sh"]
