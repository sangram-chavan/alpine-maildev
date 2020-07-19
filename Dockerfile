ARG VERSION
FROM sangram/alpine-mini:${VERSION}
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

WORKDIR /etc/maildev

RUN apk --update upgrade && \
    apk add ca-certificates curl && \
    cd /tmp && \
    curl -L "$(curl -Ls https://api.github.com/repos/sangram-chavan/maildev/releases | \
    awk '/browser_download_url/ {print $2}' | \
    sort -ru | \
    awk '/alpine.zip/ {print; exit}' | \
    sed -r 's/"(.*)"/\1/')" | \
    unzip -jno -d /usr/local/bin/ -  && \
    chmod a+x /etc/service/maildev/run && \
    chmod a+x /usr/local/bin/maildev 

EXPOSE 1080 1025

HEALTHCHECK --interval=10s --timeout=1s \
  CMD curl -k -f -v http://127.0.0.1:1080/healthz || exit 1
 
