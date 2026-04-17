# 🗄️ MySQL 数据库配置

## 📋 目录说明

本目录包含鸣沙微服务项目的MySQL数据库配置，包括MySQL服务启动、Adminer管理工具配置等。

## 🐬 MySQL 服务

### 🚀 启动MySQL容器

#### 环境配置
- **镜像版本**: `mysql:8.0.33`
- **端口映射**: `3306:3306`
- **内存限制**: `2048m`
- **字符集**: `utf8mb4`
- **认证插件**: `mysql_native_password`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.11 \
    -p 0.0.0.0:3306:3306 \
    --restart=no \
    --memory 2048m \
    --name cloud-mysql \
    -e MYSQL_ROOT_PASSWORD="123456" \
    mysql:8.0.33 \
    --character-set-server=utf8mb4 \
    --collation-server=utf8mb4_bin \
    --default-authentication-plugin=mysql_native_password
```

#### ⚠️ 重要信息
- **账号**: `root`
- **密码**: `123456`
- **访问地址**: `localhost:3306`

### 🔍 连接验证

#### 使用命令行连接
```bash
docker exec -it cloud-mysql mysql -uroot -p123456
```

#### 使用客户端连接
```bash
mysql -h localhost -P 3306 -u root -p
```

## 🛠️ Adminer 管理工具

### 🚀 启动Adminer容器

#### 环境配置
- **镜像版本**: `adminer:4.8.1`
- **端口映射**: `8085:8080`
- **内存限制**: `128m`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.12 \
    -p 0.0.0.0:9090:8080 \
    --restart=no \
    --memory 128m \
    --name cloud-adminer \
    adminer:4.8.1
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:8085`
- **服务器**: `101.0.0.11`
- **用户名**: `root`
- **密码**: `123456`
- **数据库**: `mingsha_template_cloud`

### 🔗 连接配置

在Adminer登录页面填写以下信息：
- **系统**: `MySQL`
- **服务器**: `101.0.0.11`
- **用户名**: `root`
- **密码**: `123456`
- **数据库**: `mingsha_template_cloud`

## 📋 数据库初始化

### 📝 导入数据库

- 建议使用adminer页面操作。

#### 导入主数据库
```bash
# 连接MySQL并创建数据库
docker exec -it cloud-mysql mysql -uroot -p123456 -e "CREATE DATABASE IF NOT EXISTS mingsha_template_cloud CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"

# 导入数据
docker exec -i cloud-mysql mysql -uroot -p123456 mingsha_template_cloud < ../../sql/mingsha_template_cloud.sql
```

#### 导入配置数据库
```bash
# 连接MySQL并创建数据库
docker exec -it cloud-mysql mysql -uroot -p123456 -e "CREATE DATABASE IF NOT EXISTS mingsha_template_config CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"

# 导入数据
docker exec -i cloud-mysql mysql -uroot -p123456 mingsha_template_config < ../../sql/mingsha_template_config.sql
```

## 📁 目录结构

```
02-MySQL/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [环境初始化](../00-Init/README.md)
- [Redis配置](../03-Redis/README.md)
