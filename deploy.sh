#!/bin/sh
cd src
zip -r ../deploy.zip .
cd ..

bx fn action delete webmonitor
bx fn action create webmonitor deploy.zip --kind python:3.7
