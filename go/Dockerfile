FROM golang:latest AS base

USER root

COPY certs/* /usr/local/share/ca-certificates/
RUN update-ca-certificates -v

FROM base AS updated
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get autoremove
RUN apt-get install -y \
  libxrandr-dev \
  libxcursor-dev \
  libxinerama-dev \
  libxi-dev \
  libglx-dev \
  libglu1-mesa-dev \
  libx11-dev \
  libxxf86vm-dev \
  libgl1-mesa-dev \
  xorg-dev \
  libxkbcommon-dev \
  pkg-config \
  xz-utils

FROM updated AS userver

ARG DUID
ARG DGID

USER root

# Default to Docker using uid 1000, gid 1000
RUN if [ -z "$DGID" ]; then export DGID=1000 ; fi ; \
    if [ -z "$DUID" ]; then export DUID=1000 ; fi ; \
    groupadd --gid ${DGID} gocompiler ; \
    useradd  --uid ${DUID} --gid ${DGID} -m --shell /bin/bash gocompiler

COPY run-go.sh /home/gocompiler/run-go.sh
COPY run-fyne.sh /home/gocompiler/run-fyne.sh
COPY snooze.sh /home/gocompiler/snooze.sh
RUN touch /home/gocompiler/watchdog ; \
    chmod +x /home/gocompiler/*.sh

RUN if [ -z "$DGID" ]; then export DGID=1000 ; fi ; \
    if [ -z "$DUID" ]; then export DUID=1000 ; fi ; \
    chown -R ${DUID}:${DGID} /home/gocompiler


# ------------------------------------------------------------------------------
# Time to start being the final user account

FROM userver AS final

USER gocompiler
WORKDIR /home/gocompiler

RUN mkdir -p /home/gocompiler/fyne-source ; \
    cd /home/gocompiler/fyne-source ; \
    go install fyne.io/tools/cmd/fyne@latest ; \
    git clone --branch main --depth 1 https://github.com/fyne-io/demo.git . ; \
    echo "Building demo so that the image has all dependencies: This is slow - be patient." && fyne build

# This makes sure Fyne is avaliable to the local user
RUN mkdir -p /home/gocompiler/tmp && \
  cd /home/gocompiler/tmp && \
  fyne init && \
  fyne build

# No point in keeping "tmp" around - we don't do anything with it
RUN rm -rf /home/gocompiler/tmp

RUN mkdir -p /home/gocompiler/app

WORKDIR /home/gocompiler/app
ENTRYPOINT ["/home/gocompiler/run-go.sh"]
