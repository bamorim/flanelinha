#!/bin/sh
SECRET=f9ee085f01ca69106d4fa440330f6c2192084392d180bc16a24c26e499856092333abe6ea2d7bd351a77c66e90612c453e89bee347a34c9ad0c3f9ea0f37591b
if [ "$1" = "deploy" ]; then
    docker build -t 10.20.3.166:5000/flanelinha .
    docker push 10.20.3.166:5000/flanelinha
fi


eval $(docker-machine env deploy)

docker stop flanelinha

if [ "$1" = "reset_db" ]; then
    echo "Reseting db"
    docker run --rm -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 -e RAILS_ENV=production -e SECRET_KEY_BASE=$SECRET -ti localhost:5000/flanelinha rake db:drop db:create db:migrate db:seed
fi
if [ "$1" = "migrate" ]; then
    echo "Migrating db"
    docker run --rm -e RAILS_ENV=production -e SECRET_KEY_BASE=$SECRET -ti localhost:5000/flanelinha rake db:migrate
fi
if [ "$1" = "deploy" ]; then
    docker pull localhost:5000/flanelinha
fi

docker run -p 3000:3000 -e RAILS_ENV=production -e SECRET_KEY_BASE=$SECRET --name flanelinha --rm -d localhost:5000/flanelinha
