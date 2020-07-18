FROM alpine:3.10

RUN apk update && apk add -qU bash aws-cli --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]