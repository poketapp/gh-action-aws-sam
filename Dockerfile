FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install -y python-pip

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]