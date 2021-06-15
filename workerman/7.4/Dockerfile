FROM php:7.4-fpm

ENV TIMEZONE=${timezone:-"Asia/Shanghai"}

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    libcurl4-openssl-dev \
    libxml2-dev \
    libzip-dev \
    zlib1g \
    zlib1g-dev \
    libssl-dev

RUN apt-get update && apt-get install -y tzdata \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    gd \
    mysqli \
    pdo_mysql \
    zip \
    sockets \
    opcache \
    posix \
    pcntl

RUN pecl channel-update pecl.php.net \
    && pecl install redis \
    && docker-php-ext-enable redis

RUN pecl channel-update pecl.php.net \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

RUN set -ex \
    && curl -fsSL "https://pecl.php.net/get/xlswriter-1.3.7.tgz" -o xlswriter.tar.gz \
    && mkdir -p /tmp/xlswriter \
    && tar -xf xlswriter.tar.gz -C /tmp/xlswriter --strip-components=1 \
    && rm xlswriter.tar.gz \
    && docker-php-ext-configure /tmp/xlswriter --enable-reader \
    && docker-php-ext-install -j$(nproc) /tmp/xlswriter \
    && rm -r /tmp/xlswriter \
    && php --ri xlswriter

RUN apt-get update && apt-get install -y \
    libevent-dev \
    && pecl channel-update pecl.php.net \
    && pecl install event \
    && docker-php-ext-enable event

RUN set -ex \
    # install composer
    && cd /tmp \
    && wget https://mirrors.aliyun.com/composer/composer.phar \
    && chmod u+x composer.phar \
    && mv composer.phar /usr/local/bin/composer \ 
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

RUN php -m && php -v
