VERSION 0.7

test:
    BUILD ./programs+test
    BUILD ./services/app+test
    BUILD ./services/js+test

build:
    BUILD ./contracts+build
    BUILD ./services/app+build
    BUILD ./services/js+build
    BUILD ./services/site+build

docker:
    BUILD ./services/app+docker
    BUILD ./services/js+docker
    BUILD ./services/site+docker

deploy:
    BUILD ./services/app+deploy
    BUILD ./services/js+deploy
    BUILD ./services/site+deploy

libs:
    BUILD ./services/app+libs
