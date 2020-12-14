# Alpine

简单、高性能、小体积的基础 [Alpine](http://www.alpinelinux.org) 系统镜像，用于为其他应用提供基础镜像。

使用说明可参照：[官方说明](https://wiki.alpinelinux.org)


**版本信息：**

- 3.12、latest

**镜像信息：**

* 镜像地址：registry.cn-shenzhen.aliyuncs.com/colovu/alpine:latest
  * 依赖镜像：alpine:3.12

**与官方镜像差异：**

- 增加 `default、tencent、ustc、aliyun、huawei` 源配置文件，可在编译时通过 `ARG` 变量`apt_source`进行选择
- 增加常用 Shell 脚本文件
- 更新已安装的软件包
- 增加`locales`，并设置默认编码格式为`en_US.utf8`
- 增加`bash`
- 增加`gosu`
- 设置默认时区信息为 `Asia/Shanghai`
- 默认增加 nss_wrapper 支持
- 默认增加 curl 软件，用作镜像健康检查


## **TL;DR**

Docker 快速启动命令：

```shell
$ docker run -it registry.cn-shenzhen.aliyuncs.com/colovu/alpine /bin/bash
```



---



## 使用说明

**下载镜像：**

```shell
$ docker pull registry.cn-shenzhen.aliyuncs.com/colovu/alpine:latest
```

- latest：为镜像的 TAG，可针对性选择不同的 TAG 进行下载
- 不指定 TAG 时，默认下载 latest 镜像

**查看镜像：**

```shell
$ docker images
```

**命令行方式运行容器：**

```shell
$ docker run -it --rm registry.cn-shenzhen.aliyuncs.com/colovu/alpine:latest /bin/bash
```

- `-it`：使用交互式终端启动容器
- `--rm`：退出时删除容器
- `registry.cn-shenzhen.aliyuncs.com/colovu/alpine:latest`：包含版本信息的镜像地址及名称
- `/bin/bash`：在容器中执行`/bin/bash`命令；如果不执行命令，容器会在启动后立即结束并退出。

以该方式启动后，直接进入容器的命令行操作界面。如果需要退出，直接使用命令`exit`退出。

**后台方式运行容器：**

```shell
$ docker run -d --name test registry.cn-shenzhen.aliyuncs.com/colovu/alpine:latest tail /dev/stderr
```

- `--name test`：命名容器为`test`
- `-d`：以后台进程方式启动容器
- `registry.cn-shenzhen.aliyuncs.com/colovu/alpine:latest`：包含TAG信息的镜像地址及名称
- `tail /dev/stderr`：在容器中执行`tail /dev/stderr`命令，以防止容器直接退出



以该方式启动后，如果想进入容器，可以使用以下命令：

```shell
$ docker exec -it test /bin/bash
```

- `-it`：使用交互式执行
- `test`：之前启动的容器名
- `/bin/bash`：执行的命令



## 更新记录

- 3.12、latest


----

本文原始来源 [Endial Fang](https://github.com/colovu) @ [Github.com](https://github.com)

