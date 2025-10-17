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
        ca-certificates \
        nodejs \
        npm && \
    pip3 install --no-cache-dir nbconvert && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/cache/apt/*
