#!/bin/sh

docker build -t 10.20.3.166:5000/flanelinha .
docker push 10.20.3.166:5000/flanelinha
eval $(docker-machine env deploy)
docker pull localhost:5000/flanelinha 
docker stop flanelinha
docker run -p 3000:3000 -e RAILS_ENV=production -e SECRET_KEY_BASE=f9ee085f01ca69106d4fa440330f6c2192084392d180bc16a24c26e499856092333abe6ea2d7bd351a77c66e90612c453e89bee347a34c9ad0c3f9ea0f37591b --name flanelinha --rm -d localhost:5000/flanelinha
