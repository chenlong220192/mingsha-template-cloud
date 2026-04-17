# 🚀 环境配置与部署

## 📋 目录说明

本目录包含鸣沙微服务项目的环境配置和部署相关文档，包括开发环境镜像构建、运行环境镜像构建等。

## 🏗️ 镜像构建

### 🔨 开发环境镜像

#### 环境描述
- **基础镜像**: `rockylinux:9`
- **Java版本**: `11.0.2-open`
- **Node.js版本**: `v18.20.5`
- **Docker客户端**: 已安装
- **SSH服务**: 已配置

#### 构建命令
```bash
# 在 01-Env 目录下执行
docker build -f ./docker/Dockerfile-server-for-develop \
    --rm \
    --no-cache \
    --progress=plain \
    -t site.mingsha/mingsha-server:openjdk-11-rocky9 .
```

### 🏃 运行环境镜像

#### 环境描述
- **基础镜像**: `rockylinux:9`
- **Java版本**: `11.0.2-open`
- **SkyWalking Agent**: `9.2.0`

#### 构建命令
```bash
# 在 01-Env 目录下执行
docker build -f ./docker/Dockerfile-runtime-for-service \
    --rm \
    --no-cache \
    --progress=plain \
    -t site.mingsha/mingsha-runtime:openjdk-11 .
```

## 🖥️ 开发环境初始化

### 🚀 创建开发环境容器

```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.10 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/local/bin/docker \
    -v volume4cloud:/data \
    --restart=no \
    --memory 2048m \
    --name cloud-server-dev \
    site.mingsha/mingsha-server:openjdk-11-rocky9
```

### ⚠️ 注意事项

#### Windows 环境
- 需要配置 Docker 服务器远程访问

#### macOS/Linux 环境
- `-v /var/run/docker.sock:/var/run/docker.sock`: 将宿主机 docker.sock 映射到容器内
- `-v $(which docker):/usr/bin/docker`: 将宿主机 docker 程序映射至容器内

### 🔧 进入开发环境

```bash
docker exec -it -u root cloud-server-dev /bin/bash
```

## 📁 目录结构

```
01-Env/
├── README.md                             # 本文档
├── docker/                               # Docker相关文件
│   ├── Dockerfile-server-for-develop     # 开发环境Dockerfile
│   └── Dockerfile-runtime-for-service    # 运行环境Dockerfile
└── agent/                                # 代理相关文件
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [环境初始化](../00-Init/README.md)
- [MySQL配置](../02-MySQL/README.md)
