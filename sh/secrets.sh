#! /bin/bash

(cd ./services/app &&
doppler secrets download \
    --project app \
    --config dev \
    --format env \
    --no-file \
    > .secret.dev
)

(cd ./services/app &&
doppler secrets download \
    --project app \
    --config prd \
    --format env \
    --no-file \
    > .secret.prd
)

(cd ./services/js &&
doppler secrets download \
    --project js \
    --config dev \
    --format env \
    --no-file \
    > .secret.dev
)

(cd ./services/js &&
doppler secrets download \
    --project js \
    --config prd \
    --format env \
    --no-file \
    > .secret.prd
)

(cd ./services/site &&
doppler secrets download \
    --project site \
    --config dev \
    --format env \
    --no-file \
    > .secret.dev
)

(cd ./services/site &&
doppler secrets download \
    --project app \
    --config prd \
    --format env \
    --no-file \
    > .secret.prd
)
