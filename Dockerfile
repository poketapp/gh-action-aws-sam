FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install -y python3-pip curl unzip build-essential libssl-dev libffi-dev python3-dev

ENV LC_ALL C.utf-8
ENV LANG C.utf-8

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
