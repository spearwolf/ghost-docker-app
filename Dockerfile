FROM ubuntu:15.04
MAINTAINER Wolfger Schramm <wolfger@spearwolf.de>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y git-core curl

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN groupadd -g 666 node && useradd -g node -u 666 node && mkdir -p /home/node

ADD ghost-0.7.0 /home/node/ghost-0.7.0

RUN chown -R node /home/node && chgrp -R node /home/node

USER node

ENV HOME         /home/node
ENV NVM_DIR      /home/node/nvm
ENV NODE_VERSION v0.12.7

COPY creationix-nvm-install-v0.26.1.sh /home/node/creationix-nvm-install-v0.26.1.sh
RUN cat /home/node/creationix-nvm-install-v0.26.1.sh | bash \
      && source $NVM_DIR/nvm.sh \
      && nvm install $NODE_VERSION \
      && nvm alias default $NODE_VERSION \
      && nvm use $NODE_VERSION \
      && rm /home/node/creationix-nvm-install-v0.26.1.sh

ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH
ENV NODE_ENV  production

WORKDIR /home/node/ghost-0.7.0
RUN npm install --production

COPY config.js /home/node/ghost-0.7.0/config.js

EXPOSE 2368

CMD npm start
