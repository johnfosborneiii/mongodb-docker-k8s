#!/bin/bash

docker run --privileged -di -p 8080:8080 --name mongodb-mma mongodb-base-7/mma:1.1
