#! /bin/bash

docker build --tag antarcticite-be .

docker image ls

docker run -d -p 8080:8080 antarcticite-be antarcticite

http localhost:8080
