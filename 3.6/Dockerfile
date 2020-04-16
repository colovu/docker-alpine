FROM alpine:3.6

LABEL \
        "Version"="v3.6" \
        "Description"="Alpine Image based on Alpine 3.6." \
        "Dockerfile"="https://github.com/endial/docker-libs" \
        "Vendor"="Endial Fang (endial@126.com)"

RUN set -eux \
	\
	&& echo "http://mirrors.aliyun.com/alpine/v3.6/main" > /etc/apk/repositories \
	&& echo "http://mirrors.aliyun.com/alpine/v3.6/community" >> /etc/apk/repositories

# RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/main" >> /etc/apk/repositories \
#   && echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/community" >> /etc/apk/repositories

CMD []
