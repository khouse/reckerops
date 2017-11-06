FROM alpine:latest
MAINTAINER Alex Recker <alex@reckerfamily.com>

RUN apk -Uuv add groff less python py-pip && \
    pip install awscli && \
    apk --purge -v del py-pip && \
    rm /var/cache/apk/*

RUN mkdir -p /data
ADD backup.sh /
ENTRYPOINT ["/backup.sh"]
