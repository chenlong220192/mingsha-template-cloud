# 🚀 RocketMQ 消息队列

## 📋 目录说明

本目录包含鸣沙微服务项目的RocketMQ消息队列配置，包括NameServer、Broker、Dashboard等组件的启动和配置。

## 🚀 RocketMQ 服务

### 🚀 启动NameServer

#### 环境配置
- **镜像版本**: `apache/rocketmq:5.2.0`
- **内存限制**: `1024m`
- **功能**: 服务注册与发现

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.23 \
    --restart=no \
    --memory 1024m \
    --name cloud-rocketmq-namesrv-0 \
    apache/rocketmq:5.2.0 ./mqnamesrv
```

#### ⚠️ 重要信息
- **服务地址**: `101.0.0.23:9876`
- **容器名称**: `cloud-rocketmq-namesrv-0`
- **功能**: 管理Broker注册、路由信息

### 🚀 启动Broker

#### 环境配置
- **镜像版本**: `apache/rocketmq:5.2.0`
- **内存限制**: `2048m`
- **NameServer地址**: `101.0.0.23:9876`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.24 \
    --restart=no \
    --memory 2048m \
    --name cloud-rocketmq-broker-n0 \
    apache/rocketmq:5.2.0 sh mqbroker -n 101.0.0.23:9876 -c ../conf/broker.conf
```

#### ⚠️ 重要信息
- **服务地址**: `101.0.0.24:10911`
- **容器名称**: `cloud-rocketmq-broker-n0`
- **功能**: 消息存储、转发

### 🚀 启动Dashboard

#### 环境配置
- **镜像版本**: `apacherocketmq/rocketmq-dashboard:1.0.0`
- **端口映射**: `8088:8080`
- **内存限制**: `512m`
- **NameServer地址**: `101.0.0.23:9876`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.25 \
    -p 0.0.0.0:8088:8080 \
    -e "JAVA_OPTS=-Drocketmq.namesrv.addr=101.0.0.23:9876" \
    --restart=no \
    --memory 512m \
    --name cloud-rocketmq-dashboard \
    apacherocketmq/rocketmq-dashboard:1.0.0
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:8088`
- **容器名称**: `cloud-rocketmq-dashboard`
- **功能**: Web管理界面

## 🔍 连接验证

### 检查服务状态
```bash
# 查看NameServer状态
docker ps | grep cloud-rocketmq-namesrv-0

# 查看Broker状态
docker ps | grep cloud-rocketmq-broker-n0

# 查看Dashboard状态
docker ps | grep cloud-rocketmq-dashboard
```

### 访问Dashboard
1. 打开浏览器访问: `http://localhost:8088`
2. 进入RocketMQ Dashboard
3. 查看集群状态、Topic、Consumer等信息

### 查看服务日志
```bash
# 查看NameServer日志
docker logs cloud-rocketmq-namesrv-0

# 查看Broker日志
docker logs cloud-rocketmq-broker-n0

# 查看Dashboard日志
docker logs cloud-rocketmq-dashboard
```

## 🔧 配置说明

### 📝 端口说明
- **9876**: NameServer端口，用于服务注册发现
- **10911**: Broker端口，用于消息传输
- **8088**: Dashboard端口，用于Web管理

### 🌐 网络配置
- **NameServer**: 仅内部网络访问
- **Broker**: 仅内部网络访问
- **Dashboard**: 对外暴露8088端口

### 💾 存储配置
- Broker使用容器内存储
- 生产环境建议挂载外部存储卷

## 📊 使用指南

### 🔗 微服务集成

在Spring Boot微服务中集成RocketMQ：

#### 1. 添加依赖
```xml
<dependency>
    <groupId>org.apache.rocketmq</groupId>
    <artifactId>rocketmq-spring-boot-starter</artifactId>
    <version>2.2.3</version>
</dependency>
```

#### 2. 配置RocketMQ
```yaml
rocketmq:
  name-server: 101.0.0.23:9876
  producer:
    group: mingsha-producer-group
  consumer:
    group: mingsha-consumer-group
```

#### 3. 发送消息示例
```java
@Autowired
private RocketMQTemplate rocketMQTemplate;

public void sendMessage() {
    rocketMQTemplate.convertAndSend("test-topic", "Hello RocketMQ");
}
```

#### 4. 消费消息示例
```java
@Component
@RocketMQMessageListener(
    topic = "test-topic",
    consumerGroup = "mingsha-consumer-group"
)
public class MessageConsumer implements RocketMQListener<String> {
    
    @Override
    public void onMessage(String message) {
        System.out.println("收到消息: " + message);
    }
}
```

## 📁 目录结构

```
10-RocketMQ/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [EFK配置](../09-EFK/README.md)
- [SonarQube配置](../11-Sonarqube/README.md)
