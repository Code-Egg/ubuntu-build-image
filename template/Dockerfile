FROM ubuntu:24.04

RUN apt-get update && apt-get install vim wget curl cron tzdata unzip -y
RUN apt install pbuilder ubuntu-dev-tools debootstrap devscripts pigz -y
RUN apt install ipxe-qemu qemubuilder qemu-utils qemu-user-static -y

pbuilder-dist noble create --mirror https://mirrors.dc.clear.net.ar/ubuntu/

Add .pbuilderrc /root/.pbuilderrc
Add base_img/* /var/cache/pbuilder/