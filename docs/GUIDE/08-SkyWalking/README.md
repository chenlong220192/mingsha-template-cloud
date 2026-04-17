# 🌟 SkyWalking APM

## 📋 目录说明

本目录包含鸣沙微服务项目的SkyWalking APM配置，包括SkyWalking OAP服务端、UI界面启动等。

## 🚀 SkyWalking 服务

### 🚀 启动SkyWalking OAP服务端

#### 环境配置
- **镜像版本**: `apache/skywalking-oap-server:9.7.0`
- **内存限制**: `2048m`
- **网络模式**: 自定义网络

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.18 \
    --restart=no \
    --memory 2048m \
    --name cloud-skywalking-oap \
    apache/skywalking-oap-server:9.7.0
```

#### ⚠️ 重要信息
- **服务地址**: `101.0.0.18:12800`
- **容器名称**: `cloud-skywalking-oap`
- **功能**: 数据收集、存储、分析

### 🚀 启动SkyWalking UI

#### 环境配置
- **镜像版本**: `apache/skywalking-ui:9.7.0`
- **端口映射**: `8080:8080`
- **内存限制**: `512m`
- **时区设置**: `Asia/Shanghai`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.19 \
    -p 0.0.0.0:8080:8080 \
    -e TZ=Asia/Shanghai \
    -e SW_OAP_ADDRESS=http://101.0.0.18:12800 \
    --restart=no \
    --memory 512m \
    --name cloud-skywalking-ui \
    apache/skywalking-ui:9.7.0
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:8080`
- **容器名称**: `cloud-skywalking-ui`
- **OAP地址**: `http://101.0.0.18:12800`

### 🔍 连接验证

#### 访问控制台
1. 打开浏览器访问: `http://localhost:8080`
2. 进入SkyWalking Web界面
3. 查看服务拓扑、性能指标等

#### 检查服务状态
```bash
# 查看OAP容器运行状态
docker ps | grep cloud-skywalking-oap

# 查看UI容器运行状态
docker ps | grep cloud-skywalking-ui

# 查看OAP容器日志
docker logs cloud-skywalking-oap

# 查看UI容器日志
docker logs cloud-skywalking-ui
```

## 🔧 配置说明

### 📝 端口说明
- **12800**: OAP服务端口，用于接收Agent数据
- **8080**: UI界面端口，用于Web访问

### 🌐 网络配置
- **OAP服务**: 仅内部网络访问
- **UI界面**: 对外暴露8080端口
- **通信**: UI通过内部网络访问OAP服务

### ⏰ 时区设置
- 设置时区为 `Asia/Shanghai`
- 确保时间显示正确

## 📊 使用指南

### 🔗 微服务集成

在Spring Boot微服务中集成SkyWalking Agent：

#### 1. 添加Agent参数
```bash
-javaagent:/path/to/skywalking-agent.jar
-Dskywalking.agent.service_name=your-service-name
-Dskywalking.collector.backend_service=101.0.0.18:11800
```

#### 2. Docker容器启动示例
```bash
docker run -d \
    --network=network4cloud \
    -p 8001:8001 \
    -e JAVA_OPTS="-javaagent:/skywalking/agent/skywalking-agent.jar \
                  -Dskywalking.agent.service_name=mingsha-gateway \
                  -Dskywalking.collector.backend_service=101.0.0.18:11800" \
    --name mingsha-gateway \
    your-service-image
```

### 📈 监控功能

#### 服务监控
- **服务拓扑**: 查看微服务调用关系
- **服务性能**: 监控服务响应时间、吞吐量
- **服务依赖**: 分析服务间依赖关系

#### 链路追踪
- **分布式追踪**: 追踪请求在微服务间的传播
- **链路分析**: 分析请求链路中的性能瓶颈
- **异常定位**: 快速定位异常发生的位置

#### 性能分析
- **JVM监控**: 监控JVM内存、GC等指标
- **数据库监控**: 监控SQL执行性能
- **缓存监控**: 监控Redis等缓存性能

## 📁 目录结构

```
08-SkyWalking/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [Grafana配置](../07-Grafana/README.md)
- [EFK配置](../09-EFK/README.md)
