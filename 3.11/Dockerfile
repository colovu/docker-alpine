FROM alpine:3.11

LABEL \
        "Version"="v3.11" \
        "Description"="Alpine Image based on Alpine 3.11." \
        "Dockerfile"="https://github.com/endial/docker-alpine" \
        "Vendor"="Endial Fang (endial@126.com)"

ENV GOSU_VERSION 1.11

RUN set -eux; \
	\
	echo "http://mirrors.aliyun.com/alpine/v3.11/main" > /etc/apk/repositories; \
	echo "http://mirrors.aliyun.com/alpine/v3.11/community" >> /etc/apk/repositories; \
	\
	apk add --no-cache --virtual .gosu-deps \
		dpkg \
		gnupg \
	; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
# for flaky keyservers, consider https://github.com/tianon/pgp-happy-eyeballs, ala https://github.com/docker-library/php/pull/666
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	command -v gpgconf && gpgconf --kill all || :; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
# clean up fetch dependencies
	apk del --no-network .gosu-deps; \
	\
	chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu nobody true

# RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/main" >> /etc/apk/repositories \
#   && echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/community" >> /etc/apk/repositories

CMD []
