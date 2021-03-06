FROM kdautrey/rpi-mono
MAINTAINER keltakmaster

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y apt-transport-https --force-yes &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC &&\
    echo "deb https://apt.sonarr.tv/ master main" | tee -a /etc/apt/sources.list.d/sonarr.list &&\
    apt-get update &&\
    apt-get install nzbdrone -y && \
    adduser --system -shell "/bin/bash" --uid 1000 --disabled-password --group --home /var/lib/sonarr sonarr && \
    groupadd media && \
    usermod -a -G media sonarr && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN mkdir -p /config && chown sonarr:sonarr /config
RUN mkdir -p /logs && chown sonarr:sonarr /logs
RUN mkdir -p /downloads && chown sonarr:media /downloads
RUN mkdir -p /tv && chown sonarr:media /tv

VOLUME ["/config", "/downloads", "/logs", "/tv", "/opt/NzbDrone"]

USER sonarr

CMD mono /opt/NzbDrone/NzbDrone.exe -nobrowswer -data=/config
