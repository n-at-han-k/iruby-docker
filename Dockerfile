ARG BASE_IMAGE=quay.io/jupyter/minimal-notebook:latest
FROM $BASE_IMAGE

LABEL maintainer="Nathan"
LABEL org.opencontainers.image.source="https://github.com/OWNER/REPO"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        autoconf \
        bison \
        build-essential \
        ca-certificates \
        curl \
        libczmq-dev \
        libffi-dev \
        libgdbm-dev \
        libgmp-dev \
        libncurses5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        libyaml-dev \
        libzmq3-dev \
        pkg-config \
        sqlite3 \
        tzdata \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

ARG RUBY_VERSION=3.3.7
ENV RUBY_VERSION=$RUBY_VERSION

RUN curl -fsSL "https://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-${RUBY_VERSION}.tar.gz" \
        | tar -xz -C /tmp \
    && cd /tmp/ruby-${RUBY_VERSION} \
    && ./configure \
        --prefix=/usr/local \
        --enable-shared \
        --disable-install-doc \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf /tmp/ruby-${RUBY_VERSION}

RUN echo "gem: --no-document" >> /etc/gemrc

USER $NB_UID

ENV GEM_HOME=$HOME/.gem
ENV PATH=$GEM_HOME/bin:$PATH

RUN gem install \
        iruby \
        ffi-rzmq \
    && iruby register --force

RUN gem install \
        activerecord \
        awesome_print \
        benchmark-ips \
        numo-narray \
        pry \
        sqlite3

WORKDIR /home/$NB_USER
