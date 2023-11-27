#! /bin/bash

npx @openapitools/openapi-generator-cli generate -i ./ipfs-pinning-service.yaml -g elixir -o .
