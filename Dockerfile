# Use slim Ruby image
FROM ruby:slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    JEKYLL_ENV=production \
    EXECJS_RUNTIME=Node

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
        python3-venv \
        zlib1g-dev \
        locales \
        gnupg \
        ca-certificates \
        apt-transport-https \
        lsb-release && \
    # Set locale
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    # Install Node.js LTS
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    # Upgrade nbconvert with break-system-packages to bypass PEP 668
    pip install --no-cache-dir --upgrade --break-system-packages nbconvert && \
    # Clean up to reduce image size
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*

# Create working directory
RUN mkdir /srv/jekyll
WORKDIR /srv/jekyll

# Copy Gemfile and Gemfile.lock
COPY Gemfile* /srv/jekyll/

# Install Jekyll and dependencies
RUN gem install --no-document jekyll bundler && \
    bundle install --no-cache

# Copy entrypoint script
COPY bin/entry_point.sh /tmp/entry_point.sh

# Expose default Render port
EXPOSE 10000

# Run Jekyll serve
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "${PORT:-10000}"]
