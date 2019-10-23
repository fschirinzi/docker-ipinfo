# scratch downloads
FROM scratch as scratch

COPY GeoLite2-*.mmdb /dist/

# ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz /app/
# ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz /app/
# ADD https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz /app/

# RUN mkdir /dist/ && \
#     cd /app/ && \
#     tar -xzvf GeoLite2-ASN.tar.gz && \
#     tar -xzvf GeoLite2-City.tar.gz && \
#     tar -xzvf GeoLite2-Country.tar.gz && \
#     cp */*.mmdb /dist/

# build application
FROM golang:1.13-alpine AS build
ARG BUILDPATH=github.com/jnovack/docker-ipinfo

COPY * /go/src/${BUILDPATH}/

RUN mkdir /dist/ && \
    apk -U add git && \
    cd /go/src/${BUILDPATH}/ && \
    go get -v && \
    go build -o /dist/ipinfo

# create a new image
FROM alpine:latest
COPY --from=scratch /dist/*.mmdb /app/
COPY --from=build /dist/ipinfo /app/ipinfo

WORKDIR /app/
ENTRYPOINT [ "/app/ipinfo" ]