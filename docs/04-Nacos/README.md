# 🌐 Nacos 服务注册与配置中心

## 📋 目录说明

本目录包含鸣沙微服务项目的Nacos服务注册与配置中心配置，包括Nacos服务启动、配置管理等。

## 🚀 Nacos 服务

### 🚀 启动Nacos容器

#### 环境配置
- **镜像版本**: `nacos/nacos-server:v2.3.2`
- **运行模式**: `standalone` (单机模式)
- **端口映射**: 
  - `7848:7848` (集群端口)
  - `8848:8848` (控制台端口)
  - `9848:9848` (客户端端口)
  - `9849:9849` (客户端端口)
- **内存限制**: `2048m`
- **存储类型**: `mysql`

#### 数据库配置
- **MySQL主机**: `101.0.0.11`
- **数据库名**: `mingsha_template_config`
- **用户名**: `root`
- **密码**: `123456`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.14 \
    -p 0.0.0.0:7848:7848 \
    -p 0.0.0.0:8848:8848 \
    -p 0.0.0.0:9848:9848 \
    -p 0.0.0.0:9849:9849 \
    -e SPRING_DATASOURCE_PLATFORM='mysql' \
    -e MYSQL_SERVICE_HOST='101.0.0.11' \
    -e MYSQL_SERVICE_DB_NAME='mingsha_template_config' \
    -e MYSQL_SERVICE_USER='root' \
    -e MYSQL_SERVICE_PASSWORD='123456' \
    --env MODE=standalone \
    --restart=no \
    --memory 2048m \
    --name cloud-nacos \
    nacos/nacos-server:v2.3.2
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:8848/nacos/#/login`
- **默认用户名**: `nacos`
- **默认密码**: `nacos`
- **容器名称**: `cloud-nacos`

### 🔍 连接验证

#### 访问控制台
1. 打开浏览器访问: `http://localhost:8848/nacos`
2. 使用默认账号登录: `nacos/nacos`
3. 进入服务管理或配置管理页面

#### 检查服务状态
```bash
# 查看容器运行状态
docker ps | grep cloud-nacos

# 查看容器日志
docker logs cloud-nacos

# 检查服务健康状态
curl http://localhost:8848/nacos/v1/console/health/readiness
```

## 📋 前置准备

### 📝 数据库初始化

在启动Nacos之前，需要先导入配置数据库：

```bash
# 连接MySQL并创建数据库
docker exec -it mysql-8.0.33 mysql -uroot -p123456 -e "CREATE DATABASE IF NOT EXISTS mingsha_template_config CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"

# 导入Nacos配置数据
docker exec -i mysql-8.0.33 mysql -uroot -p123456 mingsha_template_config < ../../sql/mingsha_template_config.sql
```

## 🔧 配置说明

### 📝 端口说明
- **7848**: 集群通信端口
- **8848**: Web控制台端口
- **9848/9849**: 客户端通信端口

### 🗄️ 存储配置
- **存储类型**: MySQL
- **数据库**: mingsha_template_config
- **表结构**: 自动创建

### 🔐 安全配置
- 默认用户名/密码: `nacos/nacos`
- 建议在生产环境中修改默认密码

## 📁 目录结构

```
04-Nacos/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [Redis配置](../03-Redis/README.md)
- [Sentinel配置](../05-Sentinel/README.md)
