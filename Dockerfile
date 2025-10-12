# Use a lightweight Ruby image
FROM ruby:3.2-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production \
    EXECJS_RUNTIME=Node

LABEL maintainer="Sathi Banerjee" \
      description="Docker image for al-folio Jekyll portfolio site"

# Install system dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        imagemagick \
        python3-pip \
        python3-venv \
        zlib1g-dev \
        locales \
        gnupg \
        ca-certificates \
        apt-transport-https \
        lsb-release && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*

# Install Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Upgrade nbconvert safely in a virtual environment
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip nbconvert

# Create a directory for the Jekyll site
RUN mkdir /srv/jekyll
WORKDIR /srv/jekyll

# Copy Gemfile and lock
COPY Gemfile Gemfile.lock /srv/jekyll/

# Install Jekyll and Bundler
RUN gem install --no-document bundler jekyll && \
    bundle install --no-cache

# Copy entry point and make it executable
COPY bin/entry_point.sh /tmp/entry_point.sh
RUN chmod +x /tmp/entry_point.sh

# Expose the Jekyll port
EXPOSE 10000

# Set entry point
CMD ["/tmp/entry_point.sh"]
