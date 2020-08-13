FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install -y python3-pip curl unzip
RUN apt-get install build-essential libssl-dev libffi-dev python3-dev

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
