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
    BUILD ./services/js+build
    BUILD ./services/site+docker

deploy:
    BUILD ./services/app+docker
    BUILD ./services/js+build
    BUILD ./services/site+docker

libs:
    BUILD ./services/app+libs
