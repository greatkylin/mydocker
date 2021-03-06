FROM php:7.3-fpm

LABEL maintainer="linyb <yb_lin@163.com>"

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean

# install modules : GD iconv
RUN apt-get update && apt-get install -y \
        procps \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        openssl \
        libssh-dev \
        libpcre3 \
        libpcre3-dev \
        libnghttp2-dev \
        libhiredis-dev \
        libmcrypt-dev \
        curl \
        wget \
        libzip-dev \
        zip \
        unzip \
        libgmp-dev \
        git && \
        apt autoremove && apt clean
        

# install php pdo_mysql opcache
# WARNING: Disable opcache-cli if you run you php
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install \
    iconv \
    gd \
    pdo_mysql \
    mysqli \
    iconv \
    mbstring \
    json \
    opcache \
    sockets \
    bcmath \
    gmp \
    pcntl && \
    echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

#install redis
RUN pecl install redis && docker-php-ext-enable redis

# install composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update --clean-backups

# Install the zip extension
RUN docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install zip && \
    php -m | grep -q 'zip'

# install swoole
#TIP: it always get last stable version of swoole coroutine.
RUN cd /root && \
    curl -o /tmp/swoole-releases https://github.com/swoole/swoole-src/releases -L && \
    cat /tmp/swoole-releases | grep 'href=".*archive.v4.4.17.tar.gz"' | head -1 | \
    awk -F '"' ' {print "curl -o /tmp/swoole.tar.gz https://github.com"$2" -L" > "/tmp/swoole.download"}' && \
    sh /tmp/swoole.download && \
    tar zxvf /tmp/swoole.tar.gz && cd swoole-src* && \
    phpize && \
    ./configure \
    --enable-coroutine \
    --enable-openssl  \
    --enable-http2  \
    --enable-async-redis \
    --enable-mysqlnd && \
    make && make install && \
    docker-php-ext-enable swoole && \ 
    echo "swoole.fast_serialize=On" >> /usr/local/etc/php/conf.d/docker-php-ext-swoole-serialize.ini && \
    rm -rf /tmp/*

COPY ./php.ini /usr/local/etc/php/php.ini

EXPOSE 1215 9000

# set China timezone
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone && \
    echo "[Date]\ndate.timezone=Asia/Shanghai" > /usr/local/etc/php/conf.d/timezone.ini
