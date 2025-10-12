# Use a small Ruby base image
FROM ruby:3.3-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    EXECJS_RUNTIME=Node \
    JEKYLL_ENV=production \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Install system dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        nodejs \
        imagemagick \
        python3-pip \
        zlib1g-dev \
        locales && \
    pip install --no-cache-dir --upgrade nbconvert && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*

# Create working directory
WORKDIR /srv/jekyll

# Copy Gemfiles first for caching
COPY Gemfile Gemfile.lock ./

# Install Jekyll and Ruby dependencies
RUN gem install bundler jekyll --no-document && \
    bundle install --no-cache

# Copy the rest of the site
COPY . .

# Expose port
EXPOSE 10000

# Start Jekyll server
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "${PORT:-10000}"]
