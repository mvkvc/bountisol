#! /bin/bash

doppler secrets download \
    --project app \
    --config dev \
    --format env \
    --no-file \
    > .env.app

doppler secrets download \
    --project inference \
    --config dev \
    --format env \
    --no-file \
    > .env.inf
