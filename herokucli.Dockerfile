# build the docker image if you haven't
# `docker build -f herokucli.Dockerfile -t shaungc/herokucli:latest .`

# the herokucli requires nodejs
# nodejs docker image: https://github.com/nodejs/docker-node
FROM node

USER root

WORKDIR /temp

RUN curl https://cli-assets.heroku.com/install.sh | sh

ENTRYPOINT ["heroku"]