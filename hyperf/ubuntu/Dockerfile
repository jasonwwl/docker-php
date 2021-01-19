FROM php:7.4.14-cli-buster

ARG timezone

ENV TIMEZONE=${timezone:-"Asia/Shanghai"} \
    APP_ENV=prod \
    SCAN_CACHEABLE=(true)

RUN set -ex \
    # && echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib" > /etc/apt/sources.list \
    # && echo "deb http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list \
    # && echo "deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list \
    # && echo "deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list \
    # && echo "deb-src http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list \
    # && echo "deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list \
    # && echo "deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list \
    # && echo "deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list \
    # && echo "" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y tzdata curl wget git libcurl4-openssl-dev libxml2-dev libzip-dev zlib1g zlib1g-dev libpng-dev libonig-dev librdkafka-dev \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    gd \
    mysqli \
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
    && curl -fsSL "https://github.com/swoole/swoole-src/archive/v4.6.1.tar.gz" -o swoole.tar.gz \
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
