FROM phusion/baseimage:0.9.18

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

## Set TERM so that nano and vi won't be weird
ENV TERM xterm

## Fix UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen; \
        echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale; \
        locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8

## Add docker scripts
ADD data/docker /docker

## Set WORKDIR
WORKDIR /root
RUN apt-get update && apt-get install -y curl augeas-tools augeas-lenses python
RUN curl -L $(/docker/plex_getlink.py) > plexmediaserver.deb
RUN dpkg -i plexmediaserver.deb
RUN rm plexmediaserver.deb

## Configure runit
ADD runit /etc/service/plexmediaserver

## Add augtool for ENV configuration
ADD augtool /docker/augtool

## Expose port
EXPOSE 32400
