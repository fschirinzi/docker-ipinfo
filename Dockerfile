# scratch downloads
FROM scratch as scratch

ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz /app/
ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz /app/
ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz /app/

RUN mkdir /dist/ && \
    cd /app/ && \
    tar -xzvf GeoLite2-ASN.tar.gz && \
    tar -xzvf GeoLite2-City.tar.gz && \
    tar -xzvf GeoLite2-Country.tar.gz && \
    cp */*.mmdb /dist/

# build application
FROM golang:1.13-alpine AS build
ARG BUILDPATH=github.com/jnovack/docker-ipinfo

COPY * /go/src/${BUILDPATH}/

RUN cd /go/src/${BUILDPATH}/ && \
    apk -U add git && \
    go get -v && \
    go build -o /dist/ipinfo

# create a new image
FROM alpine:latest
COPY --from=scratch /dist/*.mmdb /app/
COPY --from=build /dist/ipinfo /app/ipinfo

EXPOSE 80
WORKDIR /app/
ENTRYPOINT [ "/app/ipinfo" ]