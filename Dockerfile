# Ver: 1.4 by Endial Fang (endial@126.com)
#

# 预处理 =========================================================================
ARG registry_url="registry.cn-shenzhen.aliyuncs.com"
FROM ${registry_url}/colovu/abuilder as builder

# sources.list 可使用版本：default / tencent / ustc / aliyun / huawei
ARG apt_source=aliyun

# 编译镜像时指定用于加速的本地服务器地址
ARG local_url=""

WORKDIR /usr/local

# 选择软件包源(Optional)，以加速后续软件包安装
RUN select_source ${apt_source};

# 下载并解压软件包
RUN set -eux; \
	appVersion=1.12; \
	appName=gosu-"$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	appKeys="0xB42F6819007F00F88E364FD4036A9C25BF357DD4"; \
	[ ! -z ${local_url} ] && localURL=${local_url}/gosu; \
	appUrls="${localURL:-} \
		https://github.com/tianon/gosu/releases/download/${appVersion} \
		"; \
	download_pkg install ${appName} "${appUrls}" -g "${appKeys}"; \
	chmod +x /usr/local/bin/${appName};

# 增加 NSS_WRAPPER 支持
RUN set -ex; \
	mkdir -p /usr/local/include; \
	echo -e "#ifndef NSS__H\n#define NSS__H\n\nenum nss_status\n{\n\tNSS_STATUS_TRYAGAIN = -2,\n\tNSS_STATUS_UNAVAIL,\n\tNSS_STATUS_NOTFOUND,\n\tNSS_STATUS_SUCCESS,\n\tNSS_STATUS_RETURN\n};\n\n#endif\n" > /usr/local/include/nss.h; \
 	appVersion=1.1.11; \
	appName=nss_wrapper-${appVersion}.tar.gz; \
	[ ! -z ${local_url} ] && localURL=${local_url}/cwrap; \
	appUrls="${localURL} \
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

# sources.list 可使用版本：default / tencent / ustc / aliyun / huawei
ARG apt_source=aliyun

ENV APP_NAME=alpine-os

LABEL \
	"Version"="v3.12" \
	"Description"="Docker image for Alpine OS v3.12." \
	"Dockerfile"="https://github.com/colovu/docker-alpine" \
	"Vendor"="Endial Fang (endial@126.com)"

# 拷贝默认的通用脚本文件
COPY prebuilds /

# 从预处理过程中拷贝软件包
COPY --from=builder /usr/local/bin/gosu-amd64 /usr/local/bin/gosu
COPY --from=builder /usr/local/lib64/libnss_wrapper.so /usr/lib/

# 选择软件包源(Optional)，以加速后续软件包安装
RUN select_source ${apt_source}

# 配置时区默认为 Shanghai
RUN install_pkg bash tini tzdata curl; \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime;

# 增加musl版本的locales支持，并设置默认为 UTF-8
RUN apk add --no-cache libintl; \
	apk add --no-cache --virtual .locale_build git cmake make musl-dev gcc gettext-dev; \
	git clone https://gitlab.com/rilian-la-te/musl-locales; \
	cd musl-locales && cmake -DLOCALE_PROFILE=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install; \
	cd .. && rm -r musl-locales; \
	apk del .locale_build; \
	rm -rf /var/cache/apk/*;
ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8

# 执行预处理脚本，并验证安装的软件包
RUN set -eux; \
	gosu nobody true; \
	gosu --version; \
	tini --version;

WORKDIR /

# 应用程序的服务命令，必须使用非守护进程方式运行。如果使用变量，则该变量必须在运行环境中存在（ENV可以获取）
CMD []

