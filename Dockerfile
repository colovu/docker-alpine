# Ver: 1.2 by Endial Fang (endial@126.com)
#
FROM colovu/abuilder as builder

# sources.list 可使用版本：default / tencent / ustc / aliyun / huawei
ARG apt_source=tencent

# 编译镜像时指定用于加速的本地服务器地址
ARG local_url=""

WORKDIR /usr/local

RUN set -eux; \
	appVersion=1.12; \
	appName=gosu-"$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	appKeys="0xB42F6819007F00F88E364FD4036A9C25BF357DD4"; \
	appUrls=" \
		${local_url}/gosu \
		https://github.com/tianon/gosu/releases/download/${appVersion} \
		"; \
	download_pkg install ${appName} "${appUrls}" -g "${appKeys}"; \
	chmod +x /usr/local/bin/${appName}; \
# 验证安装的应用软件是否正常
	${appName} nobody true;

# 增加 NSS_WRAPPER 支持
RUN set -ex; \
	mkdir -p /usr/local/include; \
	echo -e "#ifndef NSS__H\n#define NSS__H\n\nenum nss_status\n{\n\tNSS_STATUS_TRYAGAIN = -2,\n\tNSS_STATUS_UNAVAIL,\n\tNSS_STATUS_NOTFOUND,\n\tNSS_STATUS_SUCCESS,\n\tNSS_STATUS_RETURN\n};\n\n#endif\n" > /usr/local/include/nss.h; \
 	appVersion=1.1.11; \
	appName=nss_wrapper-${appVersion}.tar.gz; \
	appUrls=" \
		${local_url}/cwrap \
		https://ftp.samba.org/pub/cwrap \
		"; \
	download_pkg unpack ${appName} "${appUrls}"; \
 	mkdir nss_wrapper-${appVersion}/build; \
 		(cd nss_wrapper-${appVersion}/build; \
 		cmake .. -DUNIT_TESTING:BOOL=ON; \
 		make -j "$(nproc)"; \
 		find . -name nss.h -print; \
# 		make -j "$(nproc)" CTEST_OUTPUT_ON_FAILURE=TRUE test; \
 		make install);

# 镜像生成 ========================================================================
FROM alpine:3.12
ARG apt_source=default


LABEL   "Version"="v3.12" \
	"Description"="Alpine image for Alpine 3.12." \
	"Dockerfile"="https://github.com/colovu/docker-alpine" \
	"Vendor"="Endial Fang (endial@126.com)"

COPY prebuilds /
RUN select_source ${apt_source}
RUN install_pkg bash tini tzdata; \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
	apk del tzdata; 
RUN apk add --no-cache libintl; \
	apk add --no-cache --virtual .locale_build git cmake make musl-dev gcc gettext-dev; \
	git clone https://gitlab.com/rilian-la-te/musl-locales; \
	cd musl-locales && cmake -DLOCALE_PROFILE=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install; \
	cd .. && rm -r musl-locales; \
	apk del .locale_build; \
	rm -rf /var/cache/apk/*;

COPY --from=builder /usr/local/lib64/libnss_wrapper.so /usr/lib/
COPY --from=builder /usr/local/bin/gosu-amd64 /usr/local/bin/gosu

WORKDIR /

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8

CMD []
