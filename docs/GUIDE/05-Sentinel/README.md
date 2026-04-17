# 🛡️ Sentinel 流量控制

## 📋 目录说明

本目录包含鸣沙微服务项目的Sentinel流量控制配置，包括Sentinel Dashboard启动、配置管理等。

## 🚀 Sentinel Dashboard

### 🚀 启动Sentinel容器

#### 环境配置
- **镜像版本**: `bladex/sentinel-dashboard:1.8.7`
- **端口映射**:
  - `8858:8858` (Web控制台端口)
  - `8719:8719` (客户端通信端口)
- **内存限制**: `2048m`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.15 \
    -p 0.0.0.0:8858:8858 \
    -p 0.0.0.0:8719:8719 \
    --restart=no \
    --memory 2048m \
    --name cloud-sentinel \
    bladex/sentinel-dashboard:1.8.8
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:8858`
- **默认用户名**: `sentinel`
- **默认密码**: `sentinel`
- **容器名称**: `cloud-sentinel`

### 🔍 连接验证

#### 访问控制台
1. 打开浏览器访问: `http://localhost:8858`
2. 使用默认账号登录: `sentinel/sentinel`
3. 进入流量控制管理页面

#### 检查服务状态
```bash
# 查看容器运行状态
docker ps | grep cloud-sentinel

# 查看容器日志
docker logs cloud-sentinel

# 检查服务健康状态
curl http://localhost:8858/actuator/health
```

## 🔧 配置说明

### 📝 端口说明
- **8858**: Web控制台端口，用于访问Sentinel Dashboard
- **8719**: 客户端通信端口，用于接收微服务的监控数据

### 🛡️ 功能特性
- **实时监控**: 实时监控微服务的QPS、响应时间、异常数等指标
- **流量控制**: 支持QPS限流、线程数限流、关联限流等
- **熔断降级**: 支持慢调用比例、异常比例、异常数熔断
- **系统保护**: 支持系统负载、CPU使用率、线程池等系统指标保护

### 🔐 安全配置
- 默认用户名/密码: `sentinel/sentinel`
- 建议在生产环境中修改默认密码

## 📊 使用指南

### 🔗 微服务集成

在Spring Cloud微服务中集成Sentinel：

#### 1. 添加依赖
```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
</dependency>
```

#### 2. 配置Sentinel Dashboard地址
```yaml
spring:
  cloud:
    sentinel:
      transport:
        dashboard: 101.0.0.15:8858
        port: 8719
```

#### 3. 使用注解进行流量控制
```java
@SentinelResource(value = "test", blockHandler = "blockHandler")
public String test() {
    return "Hello Sentinel";
}

public String blockHandler(BlockException ex) {
    return "被限流了";
}
```

## 📁 目录结构

```
05-Sentinel/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [Nacos配置](../04-Nacos/README.md)
- [Prometheus配置](../06-Prometheus/README.md)
