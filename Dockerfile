# Inspired by https://github.com/mumoshu/dcind
FROM alpine:3.7 
MAINTAINER Francisco Miguel Cejudo <fmcejudo@gmail.com>

ENV DOCKER_VERSION=1.12.1 \
    DOCKER_COMPOSE_VERSION=1.8.1


# Install Docker, Docker Compose
RUN apk --update --no-cache \
        add curl device-mapper mkinitfs zsh e2fsprogs e2fsprogs-extra iptables ca-certificates && \
        curl https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz | tar zx && \
        mv /docker/* /bin/ && chmod +x /bin/docker* \
    && \
        apk add py-pip && \
        pip install docker-compose==${DOCKER_COMPOSE_VERSION}
#install aws-cli
RUN apk -Uuv add groff less python py-pip && \
    pip install awscli 

COPY ./entrykit /bin/entrykit

RUN chmod +x /bin/entrykit && entrykit --symlink


# Include useful functions to start/stop docker daemon in garden-runc containers on Concourse CI
# Its usage would be something like: source /docker.lib.sh && start_docker "" "" "-g=$(pwd)/graph"
COPY docker-lib.sh /docker-lib.sh

ENTRYPOINT ["entrykit", "-e"]
