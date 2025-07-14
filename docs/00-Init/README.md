# 🚀 环境初始化

## 📋 目录说明

本目录包含鸣沙微服务项目的环境初始化配置，包括Docker网络创建、存储卷创建等基础环境配置。

## 🌐 Docker基础环境配置

### 🔗 创建网络

创建一个专用的Docker网络，用于容器间通信。

#### 网络配置
- **网段**: `101.0.0.0`
- **子网掩码**: `255.255.255.0`
- **IP范围**: `101.0.0.0 - 101.0.0.255`

#### 创建命令
```bash
docker network create \
    --subnet 101.0.0.0/24 \
    --ip-range 101.0.0.0/24 \
    network4cloud
```

### 💾 创建存储卷

创建一个持久化存储卷，用于数据共享。

#### 创建命令
```bash
docker volume create volume4cloud
```

## 📋 初始化检查清单

### ✅ 环境检查
- [ ] Docker 服务已启动
- [ ] Docker 网络 `network4cloud` 已创建
- [ ] Docker 存储卷 `volume4cloud` 已创建

### 🔍 验证命令

#### 检查网络
```bash
docker network ls | grep network4cloud
```

#### 检查存储卷
```bash
docker volume ls | grep volume4cloud
```

#### 查看网络详情
```bash
docker network inspect network4cloud
```

## 📁 目录结构

```
00-Init/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [环境配置](../01-Env/README.md)
- [MySQL配置](../02-MySQL/README.md)
