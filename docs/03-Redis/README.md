# 🔴 Redis 缓存配置

## 📋 目录说明

本目录包含鸣沙微服务项目的Redis缓存配置，包括Redis服务启动、连接配置等。

## 🚀 Redis 服务

### 🚀 启动Redis容器

#### 环境配置
- **镜像版本**: `redis:7.2.4-alpine`
- **端口映射**: `6379:6379`
- **内存限制**: `128m`
- **认证密码**: `123456`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.13 \
    -p 0.0.0.0:6379:6379 \
    --restart=no \
    --memory 128m \
    --name cloud-redis \
    redis:7.2.4-alpine --requirepass 123456
```

#### ⚠️ 重要信息
- **访问地址**: `localhost:6379`
- **认证密码**: `123456`
- **容器名称**: `cloud-redis`

### 🔍 连接验证

#### 使用命令行连接
```bash
# 进入容器
docker exec -it cloud-redis redis-cli

# 认证
AUTH 123456

# 测试连接
PING
```

#### 使用客户端连接
```bash
# 直接连接并认证
docker exec -it cloud-redis redis-cli -a 123456

# 测试连接
PING
```

#### 使用redis-cli工具连接
```bash
redis-cli -h localhost -p 6379 -a 123456
```

### 📊 性能监控

#### 查看Redis信息
```bash
# 进入Redis容器
docker exec -it cloud-redis redis-cli -a 123456

# 查看服务器信息
INFO

# 查看内存使用情况
INFO memory

# 查看连接数
INFO clients
```

#### 查看容器状态
```bash
# 查看容器运行状态
docker ps | grep cloud-redis

# 查看容器资源使用情况
docker stats cloud-redis

# 查看容器日志
docker logs cloud-redis
```

## 🔧 配置说明

### 📝 主要配置项
- **端口**: `6379` - Redis默认端口
- **密码**: `123456` - 访问认证密码
- **内存**: `128m` - 容器内存限制
- **网络**: `network4cloud` - 自定义网络

### 🛡️ 安全配置
- 启用了密码认证
- 使用自定义网络隔离
- 限制了容器内存使用

## 📁 目录结构

```
03-Redis/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [MySQL配置](../02-MySQL/README.md)
- [Nacos配置](../04-Nacos/README.md)
