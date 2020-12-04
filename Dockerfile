FROM ubuntu:18.04

RUN apt-get update && apt install -y ruby

WORKDIR /root

COPY . .

RUN ./install
