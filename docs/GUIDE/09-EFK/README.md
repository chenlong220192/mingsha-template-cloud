# 📊 EFK 日志系统

## 📋 目录说明

本目录包含鸣沙微服务项目的EFK（Elasticsearch + Filebeat + Kibana）日志系统配置，包括日志收集、存储、可视化等。

## 🚀 Elasticsearch 服务

### 🚀 启动Elasticsearch容器

#### 环境配置
- **镜像版本**: `elastic/elasticsearch:7.17.20`
- **端口映射**: 
  - `9200:9200` (HTTP端口)
  - `9300:9300` (集群通信端口)
- **内存限制**: `2048m`
- **运行模式**: `single-node`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.20 \
    -p 0.0.0.0:9200:9200 \
    -p 0.0.0.0:9300:9300 \
    -e "discovery.type=single-node" \
    --restart=no \
    --memory 2048m \
    --name cloud-elasticsearch \
    elastic/elasticsearch:7.17.20
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:9200`
- **初始用户名**: `elastic`
- **初始密码**: `changeme`
- **容器名称**: `cloud-elasticsearch`

### 🔐 密码管理

#### 修改Elasticsearch密码
```bash
curl -XPUT -H 'Content-Type: application/json' \
    -u elastic \
    'http://101.0.0.20:9200/_xpack/security/user/elastic/_password' \
    -d '{ "password" : "123456" }'
```

## 🚀 Kibana 服务

### 🚀 启动Kibana容器

#### 环境配置
- **镜像版本**: `elastic/kibana:7.17.20`
- **端口映射**: `5601:5601`
- **内存限制**: `1024m`
- **配置文件**: `/usr/share/kibana/config/kibana.yml`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.21 \
    -p 0.0.0.0:5601:5601 \
    --restart=no \
    --memory 1024m \
    --name cloud-kibana \
    elastic/kibana:7.17.20
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:5601`
- **容器名称**: `cloud-kibana`

### 🔧 Kibana配置

#### 创建kibana.yml配置文件
```bash
touch kibana.yml
```

#### 配置kibana.yml内容
```yaml
server.name: kibana
server.host: "0"
server.port: "5601"
elasticsearch.hosts: [ "http://101.0.0.20:9200" ]
elasticsearch.username: 'elastic'
elasticsearch.password: 'changeme'
```

#### 复制配置文件到容器
```bash
docker cp kibana.yml cloud-kibana:/usr/share/kibana/config
```

## 🚀 Filebeat 服务

### 🚀 启动Filebeat容器

#### 环境配置
- **镜像版本**: `elastic/filebeat:7.17.20`
- **内存限制**: `256m`
- **配置文件**: `/usr/share/filebeat/filebeat.yml`
- **数据卷**: `volume4cloud:/data`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.22 \
    -v volume4cloud:/data \
    --restart=no \
    --memory 256m \
    --name cloud-filebeat \
    elastic/filebeat:7.17.20
```

#### ⚠️ 重要信息
- **容器名称**: `cloud-filebeat`
- **日志路径**: `/data/logs/*/*.log`

### 🔧 Filebeat配置

#### 创建filebeat.yml配置文件
```bash
touch filebeat.yml
```

#### 配置filebeat.yml内容
```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /data/logs/*/*.log

processors:
  - add_cloud_metadata: ~
  - add_docker_metadata: ~

output.elasticsearch:
  hosts: '101.0.0.20:9200'
  username: 'elastic'
  password: 'changeme'
  indices:
    - index: "filebeat-%{+yyyy.MM.dd}"

setup.dashboards.enabled: true
setup.kibana:
    host: "http://101.0.0.21:5601"
```

#### 复制配置文件到容器
```bash
docker cp filebeat.yml cloud-filebeat:/usr/share/filebeat
```

#### ⚠️ 重要注意事项
- 启动Filebeat前，需要设置配置文件权限：
```bash
chmod go-w ./filebeat.yml
```

## 🔍 连接验证

### 检查Elasticsearch
```bash
# 查看容器状态
docker ps | grep cloud-elasticsearch

# 检查服务健康状态
curl http://localhost:9200/_cluster/health
```

### 检查Kibana
```bash
# 查看容器状态
docker ps | grep cloud-kibana

# 检查服务健康状态
curl http://localhost:5601/api/status
```

### 检查Filebeat
```bash
# 查看容器状态
docker ps | grep cloud-filebeat

# 查看容器日志
docker logs cloud-filebeat
```

## 📊 使用指南

### 🔍 访问Kibana
1. 打开浏览器访问: `http://localhost:5601`
2. 使用Elasticsearch账号登录
3. 进入Discover页面查看日志

### 📈 创建可视化
1. 进入 `Visualize Library`
2. 选择可视化类型（柱状图、折线图等）
3. 选择索引模式: `filebeat-*`
4. 配置查询条件和聚合方式

### 📋 创建Dashboard
1. 进入 `Dashboard`
2. 点击 `Create dashboard`
3. 添加已创建的可视化组件
4. 保存Dashboard

## 📁 目录结构

```
09-EFK/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [SkyWalking配置](../08-SkyWalking/README.md)
- [RocketMQ配置](../10-RocketMQ/README.md)
