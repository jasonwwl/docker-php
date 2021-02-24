#!/bin/bash

TAG=$1-$2

docker build -t docker-php ./hyperf/$1
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD shiyuehehu-registry.cn-beijing.cr.aliyuncs.com
echo php-hyperf:$TAG
docker tag docker-php:latest shiyuehehu-registry.cn-beijing.cr.aliyuncs.com/common/php-hyperf:$TAG
docker push shiyuehehu-registry.cn-beijing.cr.aliyuncs.com/common/php-hyperf:$TAG
