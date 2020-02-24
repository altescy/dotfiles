FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y build-essential curl file git locales locales-all \
    && locale-gen ja_JP.UTF-8 \
    && update-locale

WORKDIR /work

CMD ["/bin/bash"]
