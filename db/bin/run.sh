#!/bin/bash

docker run --privileged -di -p 27017:27017 --name mongodb mongodb-base-7/mongodb:1.1
