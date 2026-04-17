# 📈 Grafana 可视化

## 📋 目录说明

本目录包含鸣沙微服务项目的Grafana可视化配置，包括Grafana服务启动、数据源配置、Dashboard导入等。

## 🚀 Grafana 服务

### 🚀 启动Grafana容器

#### 环境配置
- **镜像版本**: `grafana/grafana:10.3.4`
- **端口映射**: `3000:3000`
- **内存限制**: `512m`
- **管理员密码**: `123456`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.17 \
    -p 0.0.0.0:3000:3000 \
    -e GF_SECURITY_ADMIN_PASSWORD=123456 \
    --restart=no \
    --memory 512m \
    --name cloud-grafana \
    grafana/grafana:10.3.4
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:3000`
- **默认用户名**: `admin`
- **默认密码**: `123456`
- **容器名称**: `cloud-grafana`

### 🔍 连接验证

#### 访问控制台
1. 打开浏览器访问: `http://localhost:3000`
2. 使用默认账号登录: `admin/123456`
3. 进入Grafana Dashboard

#### 检查服务状态
```bash
# 查看容器运行状态
docker ps | grep cloud-grafana

# 查看容器日志
docker logs cloud-grafana

# 检查服务健康状态
curl http://localhost:3000/api/health
```

## 🔧 配置说明

### 🔐 密码管理

#### 修改管理员密码
```bash
# 进入grafana容器
docker exec -it cloud-grafana /bin/bash

# 重置管理员密码
grafana-cli admin reset-admin-password 123456
```

### 📊 数据源配置

#### 配置Prometheus数据源
1. 登录Grafana控制台
2. 进入 `Configuration` → `Data Sources`
3. 点击 `Add data source`
4. 选择 `Prometheus`
5. 配置连接信息：
   - **URL**: `http://101.0.0.16:9090`
   - **Access**: `Server (default)`
6. 点击 `Save & Test` 测试连接

### 📋 Dashboard配置

#### 导入预配置Dashboard
1. 进入 `Dashboards` → `Import`
2. 上传配置文件: `config/grafana_dashboard_spring_boot_apm.json`
3. 选择数据源: `Prometheus`
4. 点击 `Import` 完成导入

## 📊 使用指南

### 🔍 创建Dashboard

#### 1. 创建新的Dashboard
1. 点击 `+` → `Dashboard`
2. 选择 `Add new panel`
3. 配置数据源和查询

#### 2. 配置Panel
- **数据源**: 选择Prometheus
- **查询**: 使用PromQL查询语言
- **可视化**: 选择图表类型（折线图、柱状图等）

#### 3. 常用查询示例
```promql
# JVM内存使用率
jvm_memory_used_bytes / jvm_memory_max_bytes * 100

# HTTP请求响应时间
rate(http_server_requests_seconds_sum[5m])

# 系统CPU使用率
system_cpu_usage * 100
```

### 📈 告警配置

#### 创建告警规则
1. 在Panel中点击 `Alert` 标签
2. 配置告警条件
3. 设置告警通知方式
4. 保存告警规则

## 📁 目录结构

```
07-Grafana/
├── README.md                    # 本文档
└── config/                      # 配置文件目录
    └── grafana_dashboard_spring_boot_apm.json  # Dashboard配置
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [Prometheus配置](../06-Prometheus/README.md)
- [SkyWalking配置](../08-SkyWalking/README.md)
