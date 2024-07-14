FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# title
ENV TITLE=Chromium

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    chromium \
    chromium-l10n && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# add modification on base-image's vnc client 
COPY /icon/chromium-logo.png /kclient/public/icon.png
COPY /index.html /kclient/public/index.html
COPY /vnc.html /usr/share/kasmvnc/www/index.html

# ports and volumes
EXPOSE 3000

VOLUME /config
