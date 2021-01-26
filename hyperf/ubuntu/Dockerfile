FROM php:7.4.14-cli-buster

ARG timezone

ENV TIMEZONE=${timezone:-"Asia/Shanghai"} \
    APP_ENV=prod \
    SCAN_CACHEABLE=(true)

RUN set -ex \
    && apt-get update \
    && apt-get install -y tzdata curl wget git libcurl4-openssl-dev libxml2-dev libzip-dev zlib1g zlib1g-dev libpng-dev libonig-dev librdkafka-dev zlib1g-dev \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    gd \
    mysqli \
    pdo_mysql \
    zip \
    sockets \
    opcache

RUN set -ex \
    && pecl channel-update pecl.php.net \
    && pecl install rdkafka \
    && docker-php-ext-enable rdkafka \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

RUN set -ex \
    && curl -fsSL "https://github.com/swoole/swoole-src/archive/v4.6.0.tar.gz" -o swoole.tar.gz \
    && mkdir -p /tmp/swoole \
    && tar -xf swoole.tar.gz -C /tmp/swoole --strip-components=1 \
    && rm swoole.tar.gz \
    && apt-get update \
    && apt-get install libssl-dev \
    && docker-php-ext-configure /tmp/swoole --enable-openssl --with-openssl-dir=/usr/include/openssl --enable-mysqlnd --enable-http2 --enable-swoole-json --enable-swoole-curl --enable-sockets \
    && docker-php-ext-install -j$(nproc) /tmp/swoole \
    && rm -r /tmp/swoole \
    && echo "memory_limit=2G" > /usr/local/etc/php/conf.d/99_overrides.ini \
    && echo "swoole.use_shortname='Off'" >> /usr/local/etc/php/conf.d/99_overrides.ini \
    && echo "upload_max_filesize=128M" >> /usr/local/etc/php/conf.d/99_overrides.ini \
    && echo "post_max_size=128M" >> /usr/local/etc/php/conf.d/99_overrides.ini \
    && echo "date.timezone=Asia/Shanghai" >> /usr/local/etc/php/conf.d/99_overrides.ini \
    && php --ri swoole

RUN set -ex \
    && curl -fsSL "https://pecl.php.net/get/xlswriter-1.3.7.tgz" -o xlswriter.tar.gz \
    && mkdir -p /tmp/xlswriter \
    && tar -xf xlswriter.tar.gz -C /tmp/xlswriter --strip-components=1 \
    && rm xlswriter.tar.gz \
    && docker-php-ext-configure /tmp/xlswriter --enable-reader \
    && docker-php-ext-install -j$(nproc) /tmp/xlswriter \
    && rm -r /tmp/xlswriter \
    && php --ri xlswriter

RUN php -m
