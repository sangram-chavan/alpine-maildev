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

WORKDIR /opt

RUN apk --update upgrade && \
    apk add ca-certificates curl && \
    cd /tmp && \
    curl -Ls https://github.com/sangram-chavan/maildev/releases/download/1.2.0/alpine.zip | unzip -jno -d /usr/local/bin/ - && \
    chmod a+x /usr/local/bin/maildev

EXPOSE 1080 1025

HEALTHCHECK --interval=10s --timeout=1s \
  CMD curl -k -f -v http://localhost/healthz || exit 1
 