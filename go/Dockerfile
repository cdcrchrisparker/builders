FROM golang:latest

USER root

RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get autoremove

ARG DUID
ARG DGID

# Default to Docker using uid 1000, gid 1000
RUN if [ -z "$DGID" ]; then export DGID=1000 ; fi ;\
    if [ -z "$DUID" ]; then export DUID=1000 ; fi ;\
    groupadd --gid ${DGID} gocompiler ;\
    useradd  --uid ${DUID} --gid ${DGID} -m --shell /bin/bash gocompiler

WORKDIR /home/gocompiler

COPY run-go.sh /home/gocompiler/run-go.sh
RUN chown gocompiler:gocompiler /home/gocompiler/run-go.sh
RUN chmod 775 /home/gocompiler/run-go.sh

COPY snooze.sh /home/gocompiler/snooze.sh
RUN chown gocompiler:gocompiler /home/gocompiler/snooze.sh
RUN chmod 775 /home/gocompiler/snooze.sh

RUN touch /home/gocompiler/watchdog
RUN chown gocompiler:gocompiler /home/gocompiler/watchdog
RUN chmod 644  /home/gocompiler/watchdog

RUN mkdir /home/gocompiler/app
RUN chown gocompiler:gocompiler /home/gocompiler/app
RUN chmod 775 /home/gocompiler/app


# ------------------------------------------------------------------------------
# Everything in this section is used for GUI programming

RUN mkdir /home/gocompiler/fyne-source
RUN chown gocompiler:gocompiler /home/gocompiler/fyne-source
RUN chmod 775 /home/gocompiler/fyne-source

RUN apt-get install -y \
  libxrandr-dev \
  libxcursor-dev \
  libxinerama-dev \
  libxi-dev \
  libglx-dev \
  libglu1-mesa-dev \
  libx11-dev \
  libxxf86vm-dev \
  pkg-config

USER gocompiler

WORKDIR /home/gocompiler/fyne-source
RUN cd /home/gocompiler/fyne-source ; \
  go mod init fyne-source ; \
  go get fyne.io/fyne/v2/app@v2.6.1 ; \
  go get fyne.io/fyne/v2/internal/driver/glfw@v2.6.1 ; \
  go get fyne.io/fyne/v2/internal/metadata@v2.6.1 ; \
  go get fyne.io/fyne/v2/internal/painter/gl@v2.6.1 ; \
  go get fyne.io/fyne/v2/internal/painter@v2.6.1 ; \
  go get fyne.io/fyne/v2/internal/svg@v2.6.1 ; \
  go get fyne.io/fyne/v2/lang@v2.6.1 ; \
  go get fyne.io/fyne/v2/storage/repository@v2.6.1 ; \
  go get fyne.io/fyne/v2/widget@v2.6.1 ; \
  go install fyne.io/fyne/v2/cmd/fyne_demo@latest

# Delete everything in this section if you do not want GUI
# ------------------------------------------------------------------------------


USER gocompiler

WORKDIR /home/gocompiler/app

ENTRYPOINT ["/home/gocompiler/run-go.sh"]
