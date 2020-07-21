
current_branch := $(shell git rev-parse --abbrev-ref HEAD)

# Sources List: default / tencent / ustc / aliyun / huawei
build-arg := --build-arg apt_source=tencent
build-arg += --build-arg local_url=http://192.168.48.132/dist-files/

build:
	docker build --force-rm $(build-arg) -t alpine:$(current_branch) .
