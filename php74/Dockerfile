ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm

#--------------------------------------------------------------------------
# 必需安装项
#--------------------------------------------------------------------------

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    && rm -rf /var/lib/apt/lists/*

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql \
    # Install the PHP pdo_pgsql extention
    && docker-php-ext-install pdo_pgsql \
    # Install the PHP gd library
    && docker-php-ext-configure gd \
    --with-jpeg \
    --with-freetype && \
    docker-php-ext-install gd \
    bcmath

# always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    apt-get update -yqq && \
    pecl channel-update pecl.php.net && \
    apt-get install -yqq \
    apt-utils \
    #
    #--------------------------------------------------------------------------
    # Mandatory Software's Installation
    #--------------------------------------------------------------------------
    #
    # Mandatory Software's such as ("mcrypt", "pdo_mysql", "libssl-dev", ....)
    # are installed on the base image 'laradock/php-fpm' image. If you want
    # to add more Software's or remove existing one, you need to edit the
    # base image (https://github.com/Laradock/php-fpm).
    #
    # next lines are here becase there is no auto build on dockerhub see https://github.com/laradock/laradock/pull/1903#issuecomment-463142846
    libzip-dev zip unzip && \
    docker-php-ext-configure zip  && \
    # Install the zip extension
    docker-php-ext-install zip && \
    php -m | grep -q 'zip'

ENV DEBIAN_FRONTEND noninteractive

#--------------------------------------------------------------------------
# 可选安装项
#--------------------------------------------------------------------------

#####################################
# SOAP:
#####################################

ARG INSTALL_SOAP=false
RUN if [ ${INSTALL_SOAP} = true ]; then \
    # Install the soap extension
    rm /etc/apt/preferences.d/no-debian-php && \
    apt-get -y install libxml2-dev php-soap && \
    docker-php-ext-install soap \
    ;fi


###########################################################################
# PHP REDIS EXTENSION
###########################################################################

ARG INSTALL_PHPREDIS=false

RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    # Install Php Redis Extension
    printf "\n" | pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
    ;fi

###########################################################################
# Swoole EXTENSION
###########################################################################

ARG INSTALL_SWOOLE=false

RUN if [ ${INSTALL_SWOOLE} = true ]; then \
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
    pecl install swoole-2.0.10; \
    else \
    if [ $(php -r "echo PHP_MINOR_VERSION;") = "0" ]; then \
    pecl install swoole-2.2.0; \
    else \
    pecl install swoole; \
    fi \
    fi && \
    docker-php-ext-enable swoole \
    && php -m | grep -q 'swoole' \
    ;fi

#####################################
# ZipArchive:
#####################################

ARG INSTALL_ZIP_ARCHIVE=false
RUN if [ ${INSTALL_ZIP_ARCHIVE} = true ]; then \
    docker-php-ext-install zip && \
    docker-php-ext-install zip \
    ;fi


###########################################################################
# Opcache:
###########################################################################

ARG INSTALL_OPCACHE=false

RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    docker-php-ext-install opcache \
    ;fi

COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

###########################################################################
# Check PHP version:
###########################################################################

RUN set -xe; php -v | head -n 1 | grep -q "PHP ${PHP_VERSION}."

ADD ./site.ini /usr/local/etc/php/conf.d
ADD ./site.pool.conf /usr/local/etc/php-fpm.d/

USER root

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
