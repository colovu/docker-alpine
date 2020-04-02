# Base Alpine

简单、高性能、小体积的基础系统镜像，本镜像基于Alpine系统（v3.6）。



## 历史版本

* v3.11, latest: 基于Alpine 3.11
* v3.6: 基于Alpine 3.6
* v3.5: 基于Alpine 3.5




## 基本信息

* 镜像地址：endial/base-alpine:v3.11
* 依赖镜像：alpine




## 数据卷

该容器没有定义默认的数据卷。该容器仅用作创建其他业务容器的基础容器。



## 使用说明

### 服务方式启动

启动命令

```
docker run --rm --name test -d endial/base-alpine:v3.11 tail /dev/stderr
```



以该方式启动后，如果想进入容器，可以使用以下命令：

```
docker exec -it test /bin/sh
```



### 命令行方式启动

启动命令

```
docker run --rm --name test -it endial/base-alpine:v3.11 /bin/sh
```



以该方式启动后，直接进入容器的命令行操作界面。如果需要退出，直接使用命令`exit`退出。

