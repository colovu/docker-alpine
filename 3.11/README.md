# Alpine

简单、高性能、小体积的基础系统镜像，本镜像基于Alpine系统。



## 基本信息

* 镜像地址：endial/alpine:v3.11
  * 依赖镜像：alpine:3.11



与官方镜像差异：

- 修改默认源为阿里云镜像

  ```shell
  http://mirrors.aliyun.com/alpine/v3.11/main
  http://mirrors.aliyun.com/alpine/v3.11/community
  ```

- 增加gosu




## 数据卷

该容器没有定义默认的数据卷。该容器仅用作创建其他业务容器的基础容器。



## 使用说明

### 镜像管理

下载镜像：

```shell
docker pull endial/alpine:v3.11
```

查看镜像：

```shell
docker images
```



### 服务方式启动

启动命令：

```
docker run -d --name test -d endial/alpine:v3.11 tail /dev/stderr
```

- `--name test`：命名容器为`test`
- `-d`：以后台进程方式启动容器
- `endial/alpine:v3.11`：包含版本信息的镜像名称
- `tail /dev/stderr`：在容器中执行`tail /dev/stderr`命令，以防止容器直接退出



以该方式启动后，如果想进入容器，可以使用以下命令：

```
docker exec -it test /bin/sh
```



### 命令行方式启动

启动命令：

```
docker run --rm -it endial/alpine:v3.11 /bin/sh
```

- `-it`：使用交互式终端启动容器
- `--rm`：退出时删除容器
- `endial/alpine:v3.11`：包含版本信息的镜像名称
- `/bin/sh`：在容器中执行`/bin/sh`命令

以该方式启动后，直接进入容器的命令行操作界面。如果需要退出，直接使用命令`exit`退出。



----

本文原始来源 [Endial Fang](https://github.com/endial) @ [Github.com](https://github.com)

