#!/bin/sh

docker build . -t runctl:latest && docker run --mount type=bind,source=$(realpath ~/.kube),target=/home/app/.kube -it --rm -p 9292:9292 runctl:latest bundle exec rackup -o 0.0.0.0 -p 9292 config.ru
