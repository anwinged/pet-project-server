#!/usr/bin/env sh

# See https://cloud.yandex.ru/docs/container-registry/tutorials/run-docker-on-vm#run

set -eu

curl --silent --show-error -H Metadata-Flavor:Google 169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token | \
    cut -f1 -d',' | \
    cut -f2 -d':' | \
    tr -d '"' | \
    docker login --username iam --password-stdin cr.yandex
