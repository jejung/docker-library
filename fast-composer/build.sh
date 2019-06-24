#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

export PUSH=`if [ "$2" == "--push" ]; then echo "true"; else echo "false"; fi`
export IMAGE_NAME=fast-composer
export TAG=$1
export REPO=jeanjung/$IMAGE_NAME
export DOCKERFILE=Dockerfile-$TAG

echo travis_fold:start:docker-build-$IMAGE_NAME-$TAG

sed -r -e "s!%%BASE_IMAGE_TAG%%!$TAG!" Dockerfile.template > $DOCKERFILE

docker build -t $REPO:$TAG -f $DOCKERFILE .

if [ "$PUSH" == "true" ]; then 
  docker push $REPO;
fi
