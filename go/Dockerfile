FROM golang:latest

USER root
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
RUN chmod 775 /home/gocompiler/app
RUN chown gocompiler:gocompiler /home/gocompiler/app

WORKDIR /home/gocompiler/app

USER gocompiler
ENTRYPOINT ["/home/gocompiler/run-go.sh"]
