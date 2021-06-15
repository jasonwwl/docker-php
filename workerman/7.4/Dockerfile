FROM php:7.4-cli

RUN uname -a && \
    apt update
# Change ubuntu source.
# Reference: https://github.com/laradock/laradock
# ARG UBUNTU_SOURCE=aliyun
# ARG CHANGE_UBUNTU_SOURCE=true
# COPY ./sources.sh /tmp/sources.sh
# RUN if [ ${CHANGE_UBUNTU_SOURCE} = true ]; then \
#     apt-get install -y gnupg2 && \
#     apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32 && \
#     chmod +x /tmp/sources.sh && \
#     /bin/bash -c /tmp/sources.sh && \
#     rm -rf /tmp/sources.sh && \
#     apt update \
# ;fi

# Install php ext.
RUN apt update && \
    apt-get remove -y libssl1.1 && \
    apt-get install libssl1.1 krb5-locales libkrb5support0 libkrb5-3 libgssapi-krb5-2 libcurl4 curl zlib1g zlib1g-dev libonig-dev libpng-dev libzip-dev --allow-downgrades -y && \
    docker-php-ext-install bcmath gd zip sockets pcntl pdo_mysql -j$(nproc) && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    pecl install mongodb && \
    docker-php-ext-enable mongodb && \
    apt-get install libssl-dev -y

ARG INSTALL_LIB_EVENT=true
RUN if [ ${INSTALL_LIB_EVENT} = true ]; then \
    apt-get install libevent-dev -y && \
    pecl install event && \
    echo extension=event.so > /usr/local/etc/php/conf.d/event.ini \
;fi

# Install composer and set mirror.
# Reference: https://pkg.phpcomposer.com/#how-to-install-composer
# Referencr: https://developer.aliyun.com/composer
ARG INSTALL_COMPOSER=true
ARG COMPOSER_INSTALLER=https://install.phpcomposer.com/installer
ARG COMPOSER_MIRROR=https://mirrors.aliyun.com/composer/
RUN if [ ${INSTALL_COMPOSER} = true ]; then \
    php -r "copy('${COMPOSER_INSTALLER}', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    composer config -g repo.packagist composer ${COMPOSER_MIRROR} \
;fi


RUN apt-get install git zip vim -y

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