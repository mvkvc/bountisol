FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    git \
    build-essential

WORKDIR /home

RUN git clone https://github.com/ggerganov/llama.cpp.git
WORKDIR /home/llama.cpp
RUN make
RUN cp ./server /home/server

WORKDIR /home

COPY ./start.sh /home/start.sh
RUN chmod +x /home/start.sh

CMD ["/home/start.sh"]
