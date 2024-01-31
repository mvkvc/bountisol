#! /bin/bash

trap 'kill $(jobs -p)' SIGINT

(cd ./app && sh/db.sh) &
(cd ./app && iex -S mix phx.server) &
wait
