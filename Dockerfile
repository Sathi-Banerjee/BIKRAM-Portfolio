# Use official Ruby slim image
FROM ruby:3.2-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production \
    EXECJS_RUNTIME=Node

# Install system dependencies + Node.js 20.x
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        imagemagick \
        python3-pip \
        zlib1g-dev \
        locales \
        ca-certificates && \
    # Install Node.js from NodeSource quietly
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null && \
    apt-get install -y nodejs > /dev/null && \
    # Install Python nbconvert quietly
    pip3 install --no-cache-dir --break-system-packages nbconvert > /dev/null && \
    # Generate locale
    locale-gen en_US.UTF-8 > /dev/null && \
    # Clean up apt cache
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*

# Set working directory
WORKDIR /srv/jekyll

# Copy Gemfile first to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies quietly
RUN gem install --no-document jekyll bundler > /dev/null && \
    bundle install --no-cache > /dev/null

# Copy site content
COPY . .

# Copy entry point and make it executable
COPY bin/entry_point.sh /tmp/entry_point.sh
RUN chmod +x /tmp/entry_point.sh

# Remove leftover Git metadata if any
RUN rm -rf .git

# Expose Jekyll default port
EXPOSE 4000

# Start Jekyll
CMD ["/tmp/entry_point.sh"]
