FROM sangram/alpine-node:13.8.0 
LABEL   maintainer="Sangram Chavan <schavan@outlook.com>" \
        architecture="amd64/x86_64" 

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL   org.label-schema.schema-version="1.0" \
        org.label-schema.build-date=${BUILD_DATE} \
        org.label-schema.name="MailDev " \
        org.label-schema.description="MailDEv Docker image running on Alpine Linux" \
        org.label-schema.url="https://hub.docker.com/r/sangram/alpine-maildev" \
        org.label-schema.vcs-url="https://github.com/sangram-chavan/maildev.git" \
        org.label-schema.vcs-ref=${VCS_REF} \
        org.label-schema.vendor="Open Source" \
        org.label-schema.version=${VERSION} \
        org.label-schema.image.authors="Sangram Chavan <schavan@outlook.com>" \
        org.label-schema.image.vendor="Open Source" 

COPY root/. /

WORKDIR /opt

RUN chmod a+x /etc/service/maildev/run && \
    apk --update add bash wget && rm -rf /var/cache/apk/* && \
    wget -qO - https://github.com/sangram-chavan/maildev/archive/master.zip | unzip -q - && \
    mv maildev-master maildev && cd maildev && chmod 777 bin/maildev && yarn install -s

HEALTHCHECK --interval=10s --timeout=1s \
  CMD curl -k -f -v http://localhost/healthz || exit 1
