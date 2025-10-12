FROM ruby:slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    EXECJS_RUNTIME=Node \
    JEKYLL_ENV=production

LABEL authors="Amir Pourmand,George Araújo" \
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
    # Install Node.js (long-term support)
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    # Upgrade nbconvert for Jupyter support
    pip install --no-cache-dir --upgrade nbconvert && \
    # Set locale
    locale-gen en_US.UTF-8 && \
    # Cleanup to reduce image size
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*

# Create Jekyll site directory
RUN mkdir /srv/jekyll

WORKDIR /srv/jekyll

# Copy only Gemfile first to leverage Docker cache for gems
COPY Gemfile Gemfile.lock /srv/jekyll/

# Install Jekyll and bundle gems (cached if Gemfile doesn't change)
RUN gem install --no-document jekyll bundler && \
    bundle install --no-cache

# Copy the rest of the site (content changes won't reinstall gems)
COPY . /srv/jekyll

# Expose Jekyll port
EXPOSE 10000

# Copy entry point script
COPY bin/entry_point.sh /tmp/entry_point.sh

# Default command to serve Jekyll
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "${PORT:-10000}"]
