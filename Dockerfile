FROM alpine:latest

RUN apk --update --no-cache add jq curl bash gcc musl-dev

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]