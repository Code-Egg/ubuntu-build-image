FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install  \
        build-essential \
        ccache \
        clang \
        curl \
        git \
        sudo \
        wget \
        unzip \
        pigz

RUN apt-get -y install \
        debootstrap \
        devscripts \
        pbuilder \
        debhelper \
        debsigs\
        ubuntu-dev-tools

ADD .pbuilderrc /root/.pbuilderrc
COPY base_img/ /var/cache/pbuilder/
RUN ls -lh /var/cache/pbuilder/