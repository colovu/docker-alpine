# 简介

简单、高性能、小体积的基础系统镜像，本镜像基于[Alpine系统](http://www.alpinelinux.org)。



**版本信息：**

- 3.12、latest
- 3.11

**镜像信息：**

* 镜像地址：colovu/alpine:latest
  * 依赖镜像：alpine:TAG

**与官方镜像差异：**

- 增加 `default、tencent、ustc、aliyun、huawei` 源配置文件，可在编译时通过 `ARG` 变量`apt_source`进行选择

- 更新已安装的软件包
- 增加bash
- 增加gosu



## 使用说明

**下载镜像：**

```shell
docker pull colovu/alpine:latest
```

- latest：为镜像的TAG，可针对性选择不同的TAG进行下载

**查看镜像：**

```shell
docker images
```

**命令行方式运行容器：**

```shell
docker run -it --rm colovu/alpine:latest /bin/sh
```

- `-it`：使用交互式终端启动容器
- `--rm`：退出时删除容器
- `colovu/alpine:latest`：包含版本信息的镜像名称
- `/bin/sh`：在容器中执行`/bin/sh`命令；如果不执行命令，容器会在启动后立即结束并退出。

以该方式启动后，直接进入容器的命令行操作界面。如果需要退出，直接使用命令`exit`退出。

**后台方式运行容器：**

```shell
docker run -d --name test colovu/alpine:latest tail /dev/stderr
```

- `--name test`：命名容器为`test`
- `-d`：以后台进程方式启动容器
- `colovu/alpine:latest`：包含TAG信息的镜像名称
- `tail /dev/stderr`：在容器中执行`tail /dev/stderr`命令，以防止容器直接退出



以该方式启动后，如果想进入容器，可以使用以下命令：

```shell
docker exec -it test /bin/sh
```

- `-it`：使用交互式执行
- `test`：之前启动的容器名
- `/bin/sh`：执行的命令



----

本文原始来源 [Endial Fang](https://github.com/colovu) @ [Github.com](https://github.com)

