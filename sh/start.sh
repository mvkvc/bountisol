#! /bin/bash

trap 'kill $(jobs -p)' SIGINT

(cd ./services/app && iex -S mix phx.server) &
(cd ./services/js && yarn start) &
(cd ./services/site && yarn start) &
wait

