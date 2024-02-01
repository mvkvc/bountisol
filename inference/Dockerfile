FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    git \
    wget \
    build-essential

WORKDIR /home
RUN git clone https://github.com/ggerganov/llama.cpp.git

WORKDIR /home/llama.cpp
RUN make
RUN cp ./server /home/server

WORKDIR /home
COPY ./sh/ /home/sh/
RUN chmod +x /home/sh/*.sh
RUN sh/download.sh

CMD ["/home/sh/start.sh"]
