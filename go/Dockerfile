FROM golang:latest

USER root

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
  libxkbcommon-dev \
  pkg-config \
  xz-utils


ARG DUID
ARG DGID

# Default to Docker using uid 1000, gid 1000
RUN if [ -z "$DGID" ]; then export DGID=1000 ; fi ;\
    if [ -z "$DUID" ]; then export DUID=1000 ; fi ;\
    groupadd --gid ${DGID} gocompiler ;\
    useradd  --uid ${DUID} --gid ${DGID} -m --shell /bin/bash gocompiler

WORKDIR /home/gocompiler

RUN mkdir /home/gocompiler/fyne-source
RUN chown gocompiler:gocompiler /home/gocompiler/fyne-source
RUN chmod 775 /home/gocompiler/fyne-source

USER gocompiler

# This does the work of getting Fyne
WORKDIR /home/gocompiler/fyne-source
RUN cd /home/gocompiler/fyne-source ; \
  go install fyne.io/tools/cmd/fyne@latest ; \
  git clone https://github.com/fyne-io/demo.git . ; \
  fyne build

USER root

COPY run-go.sh /home/gocompiler/run-go.sh
RUN chown gocompiler:gocompiler /home/gocompiler/run-go.sh
RUN chmod 775 /home/gocompiler/run-go.sh

COPY run-fyne.sh /home/gocompiler/run-fyne.sh
RUN chown gocompiler:gocompiler /home/gocompiler/run-fyne.sh
RUN chmod 775 /home/gocompiler/run-fyne.sh

COPY snooze.sh /home/gocompiler/snooze.sh
RUN chown gocompiler:gocompiler /home/gocompiler/snooze.sh
RUN chmod 775 /home/gocompiler/snooze.sh

RUN touch /home/gocompiler/watchdog
RUN chown gocompiler:gocompiler /home/gocompiler/watchdog
RUN chmod 644  /home/gocompiler/watchdog

RUN mkdir /home/gocompiler/app
RUN chown gocompiler:gocompiler /home/gocompiler/app
RUN chmod 775 /home/gocompiler/app

USER gocompiler

# This makes sure Fyne is avaliable to the local user
RUN mkdir /home/gocompiler/tmp ; \
  cd /home/gocompiler/tmp ; \
  fyne init ; \
  fyne build

# No point in keeping the temp project around
USER root
RUN rm -rf /home/gocompiler/tmp
USER gocompiler

WORKDIR /home/gocompiler/app

ENTRYPOINT ["/home/gocompiler/run-go.sh"]
