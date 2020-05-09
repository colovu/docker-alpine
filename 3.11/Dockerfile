FROM alpine:3.11

LABEL \
        "Version"="v3.11" \
        "Description"="Alpine Image based on Alpine 3.11." \
        "Dockerfile"="https://github.com/colovu/docker-alpine" \
        "Vendor"="Endial Fang (endial@126.com)"

ENV GOSU_VERSION=1.12 \
	GPG_KEYS="0xB42F6819007F00F88E364FD4036A9C25BF357DD4"

RUN set -eux; \
	\
# 修改默认软件源为阿里云软件源
	echo "http://mirrors.aliyun.com/alpine/v3.11/main" > /etc/apk/repositories; \
	echo "http://mirrors.aliyun.com/alpine/v3.11/community" >> /etc/apk/repositories; \
	\
# 安装依赖软件包
	apk add --no-cache --virtual .gosu-deps \
		dpkg \
		gnupg \
	; \
	\
# 安装应用软件
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# 安装软件包需要使用的GPG证书
	export GNUPGHOME="$(mktemp -d)"; \
	for key in ${GPG_KEYS}; do \
		gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "${key}"|| \
		gpg --batch --keyserver pgp.mit.edu --recv-keys "${key}" || \
		gpg --batch --keyserver keys.gnupg.net --recv-keys "${key}" || \
		gpg --batch --keyserver keyserver.pgp.com --recv-keys "${key}"; \
	done; \
	gpg --batch --verify "/usr/local/bin/gosu.asc" "/usr/local/bin/gosu"; \
	command -v gpgconf > /dev/null && gpgconf --kill all; \
	rm -rf "$GNUPGHOME"; \
	\
# 删除安装的依赖软件包
	apk del --no-network .gosu-deps; \
	\
	chmod +x /usr/local/bin/gosu; \
# 验证安装的应用软件是否正常
	gosu nobody true

# RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/main" >> /etc/apk/repositories \
#   && echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/community" >> /etc/apk/repositories

CMD []
