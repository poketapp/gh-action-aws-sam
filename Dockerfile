FROM ubuntu:22.04

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update -y
RUN apt-get install -y python3-pip curl unzip build-essential libssl-dev libffi-dev python3-dev sudo
RUN pip3 install setuptools wheel pyyaml==5.3.1 awscliv2 aws-sam-cli

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
