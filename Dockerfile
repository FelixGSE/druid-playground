FROM java:openjdk-8-jdk

ARG DRUID_VERSION=0.17.0
ARG BUILD_TIME="-"
ARG REVISION="-"

ENV DEBIAN_FRONTEND=noninteractive \
    DRUID_HOME=/opt/druid \
    DRUID_RUNTIME_HOME=/var/druid

ENV PATH=${PATH}:${DRUID_HOME}/bin

LABEL org.opencontainers.image.created=$BUILD_TIME \
      org.opencontainers.image.url="https://github.com/FelixGSE/druid-playground" \
      org.opencontainers.image.source="https://github.com/FelixGSE/druid-playground" \
      org.opencontainers.image.version="MAJOR.MINOR.PATCH" \
      org.opencontainers.image.revision="$REVISION" \
      org.opencontainers.image.vendor="-" \
      org.opencontainers.image.title="Apache-Druid" \
      org.opencontainers.image.description="Minimal docker image to run Apache-Druid" \
      org.opencontainers.image.documentation="https://github.com/FelixGSE/druid-playground/README.md" \
      org.opencontainers.image.authors="FelixGSE" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="-"

RUN wget https://archive.apache.org/dist/druid/KEYS \
&&  wget https://www.apache.org/dist/druid/$DRUID_VERSION/apache-druid-$DRUID_VERSION-bin.tar.gz \
&&  wget https://www.apache.org/dist/druid/$DRUID_VERSION/apache-druid-$DRUID_VERSION-bin.tar.gz.asc \
&&  gpg --import KEYS \
&&  gpg --verify apache-druid-$DRUID_VERSION-bin.tar.gz.asc \
&&  tar -xzf apache-druid-$DRUID_VERSION-bin.tar.gz 
&&. mv apache-druid-$DRUID_VERSION $DRUID_HOME \
&&  mkdir -p $DRUID_RUNTIME_HOME \
             var/tmp \
             $DRUID_RUNTIME_HOME/segments \
             $DRUID_RUNTIME_HOME/indexing-logs \
             $DRUID_RUNTIME_HOME/task \ 
             $DRUID_RUNTIME_HOME/hadoop-tmp \
             $DRUID_RUNTIME_HOME/segment-cache \
&&  rm KEYS \
    apache-druid-$DRUID_VERSION-bin.tar.gz \
    apache-druid-$DRUID_VERSION-bin.tar.gz.asc \
&&  adduser --system \
            --group \
            --no-create-home \
            --home $DRUID_RUNTIME_HOME \
            --shell /usr/sbin/nologin \
            --disabled-password \
            druid \
&&  chown -R druid:druid $DRUID_RUNTIME_HOME

USER druid

WORKDIR $DRUID_RUNTIME_HOME

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["invalid"]