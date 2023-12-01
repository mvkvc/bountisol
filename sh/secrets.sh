#! /bin/bash

doppler secrets download \
    --project app \
    --config dev \
    --format env \
    --no-file \
    > .secret.app.dev

doppler secrets download \
    --project js \
    --config dev \
    --format env \
    --no-file \
    > .secret.js.dev

doppler secrets download \
    --project site \
    --config dev \
    --format env \
    --no-file \
    > .secret.site.dev
