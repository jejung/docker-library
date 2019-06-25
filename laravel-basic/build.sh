#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

export PUSH=`if [ "$2" == "--push" ]; then echo "true"; else echo "false"; fi`
export IMAGE_NAME=laravel-basic
export TAG=$1
export REPO=jeanjung/$IMAGE_NAME
export DOCKERFILE=Dockerfile-$TAG

set -o allexport
source .env
source .env-$TAG
set +o allexport

sed -r \
	-e "s!%%BASE_IMAGE_TAG%%!$BASE_IMAGE_TAG!" \
	-e "s!%%NODE_VERSION%%!$NODE_VERSION!" \
	-e "s!%%INSTALL_PACKAGES%%!$INSTALL_PACKAGES!" \
	-e "s!%%PHP_PACKAGES%%!$PHP_PACKAGES!" \
       	Dockerfile.template > $DOCKERFILE

docker build -t $REPO:$TAG -f $DOCKERFILE .

if [ "$PUSH" == "true" ]; then
  docker push $REPO;
fi

