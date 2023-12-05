#! /bin/bash

trap 'kill $(jobs -p)' SIGINT

(cd ./services/app && sh/db.sh) &
(cd ./services/app && iex -S mix phx.server) &
(cd ./services/js && yarn dev) &
(cd ./services/site && yarn dev) &
wait

