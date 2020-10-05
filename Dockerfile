FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install -y python3-pip curl unzip build-essential libssl-dev libffi-dev python3-dev sudo
RUN pip3 uninstall wheel
RUN pip3 install wheel==0.21.0

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
