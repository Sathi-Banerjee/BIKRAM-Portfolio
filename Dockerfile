# Base image
FROM ruby:3.2-slim

ENV DEBIAN_FRONTEND=noninteractive

LABEL authors="Amir Pourmand, George Araújo" \
      description="Docker image for al-folio academic template" \
      maintainer="Amir Pourmand"

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
        lsb-release && \
    # Install Node.js LTS (20.x)
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    # Upgrade nbconvert for Jupyter support (allow system package override)
    pip install --no-cache-dir --break-system-packages --upgrade nbconvert && \
    # Set locale
    locale-gen en_US.UTF-8 && \
    # Cleanup
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*

# Set environment variables
ENV EXECJS_RUNTIME=Node \
    JEKYLL_ENV=production \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Create Jekyll site directory
RUN mkdir /srv/jekyll

# Copy Gemfile for dependencies
ADD Gemfile /srv/jekyll/
ADD Gemfile.lock /srv/jekyll/

WORKDIR /srv/jekyll

# Install Jekyll and bundle dependencies
RUN gem install --no-document jekyll bundler && \
    bundle install --no-cache

# Expose the default port
EXPOSE 10000

# Copy entrypoint script
COPY bin/entry_point.sh /tmp/entry_point.sh
RUN chmod +x /tmp/entry_point.sh

# Start the Jekyll server
CMD /tmp/entry_point.sh
