# build application
FROM golang:1.13-alpine AS build
ARG BUILDPATH=github.com/fschirinzi/docker-ipinfo

COPY * /go/src/${BUILDPATH}/

RUN cd /go/src/${BUILDPATH}/ && \
    apk -U add git && \
    go get -v && \
    go build -o /dist/ipinfo

# create a new image
FROM alpine:latest
COPY --from=build /dist/ipinfo /app/ipinfo
ADD databases /app/databases

EXPOSE 80
WORKDIR /app/
ENTRYPOINT [ "/app/ipinfo" ]