# Ver: 1.0 by Endial Fang (endial@126.com)
#
FROM alpine:3.12

# ARG参数使用"--build-arg"指定，如 "--build-arg apt_source=tencent"
# sources.list 可使用版本：default / tencent / ustc / aliyun / huawei
ARG apt_source=default

# 编译镜像时指定本地服务器地址，如 "--build-arg local_url=http://172.29.14.108/dist-files/"
ARG local_url=""

ARG gosu_ver=1.12

LABEL \
        "Version"="v3.12" \
        "Description"="Alpine image for Alpine 3.12." \
        "Dockerfile"="https://github.com/colovu/docker-alpine" \
        "Vendor"="Endial Fang (endial@126.com)"

COPY sources/* /etc/apk/

RUN set -eux; \
	\
# 更改源为当次编译指定的源
	cp /etc/apk/repositories.${apt_source} /etc/apk/repositories; \
	\
	apk update; \
	apk upgrade --no-cache;\
	apk add --no-cache bash; \
	\
# 安装依赖软件包
	apk add --no-cache --virtual .fetch-deps \
		dpkg \
		gnupg \
	; \
	\
# 安装应用软件
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	if [ -n "${local_url}" ]; then \
		wget -O /usr/local/bin/gosu "${local_url}/gosu-${dpkgArch}"; \
		wget -O /usr/local/bin/gosu.asc "${local_url}/gosu-${dpkgArch}.asc"; \
	else \
		wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${gosu_ver}/gosu-$dpkgArch"; \
		wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/${gosu_ver}/gosu-$dpkgArch.asc"; \
	fi; \
	\
# 安装软件包需要使用的GPG证书
	export GPG_KEYS="0xB42F6819007F00F88E364FD4036A9C25BF357DD4"; \
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
	chmod +x /usr/local/bin/gosu; \
	rm -rf /usr/local/bin/gosu.asc; \
	\
# 删除安装的依赖软件包
	apk del --no-network .fetch-deps; \
	\
# 验证安装的应用软件是否正常
	gosu nobody true;

CMD []
