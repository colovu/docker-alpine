FROM alpine:3.11

MAINTAINER Endial Fang ( endial@126.com )

RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.11/main" > /etc/apk/repositories \
  && echo "http://mirrors.ustc.edu.cn/alpine/v3.11/community" >> /etc/apk/repositories

# RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/main" >> /etc/apk/repositories \
#   && echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/community" >> /etc/apk/repositories

CMD []
