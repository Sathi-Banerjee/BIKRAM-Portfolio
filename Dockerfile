# Use official Ruby slim image
FROM ruby:3.2-slim

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
    pip3 install --no-cache-dir nbconvert --break-system-packages && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*

# Set working directory
WORKDIR /srv/jekyll

# Copy Gemfile first to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN gem install --no-document jekyll bundler && \
    bundle install --no-cache

# Copy the site content
COPY . .

# Copy the entry point script and make it executable
COPY bin/entry_point.sh /tmp/entry_point.sh
RUN chmod +x /tmp/entry_point.sh

# Remove .git to prevent Render exit 128
RUN rm -rf .git

# Expose port (Jekyll default is 4000)
EXPOSE 4000

# Start Jekyll using your entry point
CMD ["/tmp/entry_point.sh"]
