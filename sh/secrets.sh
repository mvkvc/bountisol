#! /bin/bash

(cd ./app &&
doppler secrets download \
    --project app \
    --config dev \
    --format env \
    --no-file \
    > .secret.dev
)

(cd ./app &&
doppler secrets download \
    --project app \
    --config prd \
    --format env \
    --no-file \
    > .secret.prd
)

(cd ./contracts &&
doppler secrets download \
    --project contracts \
    --config dev \
    --format env \
    --no-file \
    > .secret.dev
)

(cd ./contracts &&
doppler secrets download \
    --project contracts \
    --config prd \
    --format env \
    --no-file \
    > .secret.prd
)

(cd ./site &&
doppler secrets download \
    --project site \
    --config dev \
    --format env \
    --no-file \
    > .secret.dev
)

(cd ./site &&
doppler secrets download \
    --project site \
    --config prd \
    --format env \
    --no-file \
    > .secret.prd
)
