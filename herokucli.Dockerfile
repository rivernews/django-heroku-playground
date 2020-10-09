# the herokucli requires nodejs
# nodejs docker image: https://github.com/nodejs/docker-node
FROM node

USER root

# RUN apk --no-cache add curl bash bash-completion

WORKDIR /temp

RUN curl https://cli-assets.heroku.com/install.sh | sh

ENTRYPOINT ["heroku"]