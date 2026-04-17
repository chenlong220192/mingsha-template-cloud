# 📊 Prometheus 监控

## 📋 目录说明

本目录包含鸣沙微服务项目的Prometheus监控配置，包括Prometheus服务启动、配置管理等。

## 🚀 Prometheus 服务

### 🚀 启动Prometheus容器

#### 环境配置
- **镜像版本**: `prom/prometheus:v2.51.2`
- **端口映射**: `9090:9090`
- **内存限制**: `1024m`
- **配置文件**: `/etc/prometheus/prometheus.yml`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.16 \
    -p 0.0.0.0:9090:9090 \
    --restart=no \
    --memory 1024m \
    --name cloud-prometheus \
    prom/prometheus:v2.51.2 --config.file=/etc/prometheus/prometheus.yml --web.enable-lifecycle
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:9090`
- **配置文件路径**: `--config.file`
- **热加载配置**: `--web.enable-lifecycle`
- **容器名称**: `cloud-prometheus`

### 🔍 连接验证

#### 访问控制台
1. 打开浏览器访问: `http://localhost:9090`
2. 进入Prometheus Web界面
3. 查看监控目标和指标

#### 检查服务状态
```bash
# 查看容器运行状态
docker ps | grep cloud-prometheus

# 查看容器日志
docker logs cloud-prometheus

# 检查服务健康状态
curl http://localhost:9090/-/healthy
```

#### 热加载配置
```bash
# 重新加载配置文件
curl -X POST http://localhost:9090/-/reload
```

## 📝 配置文件

### prometheus.yml

```yaml
# 全局配置
global:
  scrape_interval: 15s      # 抓取间隔，默认1分钟
  evaluation_interval: 15s  # 规则评估间隔，默认1分钟
  # scrape_timeout: 10s     # 抓取超时时间，默认10秒

# 告警管理器配置
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# 规则文件配置
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# 抓取配置
scrape_configs:
  # Prometheus自身监控
  - job_name: "cloud-prometheus"
    metrics_path: /metrics
    scrape_interval: 30s
    scrape_timeout: 15s
    static_configs:
      - targets:
        - localhost:9090

  # 鸣沙微服务监控
  - job_name: cloud-mingsha-service
    metrics_path: /actuator/prometheus
    scrape_interval: 30s
    scrape_timeout: 15s
    static_configs:
      - targets:
        - 101.0.0.101:8001  # 网关服务
        - 101.0.0.102:8002  # 认证服务
        - 101.0.0.103:8003  # 系统服务
        - 101.0.0.104:8004  # 文件服务
        - 101.0.0.105:8005  # 消息服务
```

## 🔧 配置说明

### 📝 主要配置项
- **scrape_interval**: 抓取间隔时间
- **evaluation_interval**: 规则评估间隔
- **metrics_path**: 指标暴露路径
- **targets**: 监控目标列表

### 🔄 热加载功能
- 支持配置文件热加载
- 无需重启服务即可应用新配置
- 使用 `curl -X POST http://localhost:9090/-/reload` 重新加载

### 📊 监控目标
- **Prometheus自身**: `localhost:9090`
- **微服务集群**: 各个微服务的 `/actuator/prometheus` 端点

## 📊 使用指南

### 🔍 查询指标

在Prometheus Web界面中，可以使用PromQL查询语言查询指标：

#### 常用查询示例
```promql
# 查询HTTP请求总数
http_requests_total

# 查询JVM内存使用情况
jvm_memory_used_bytes

# 查询系统CPU使用率
system_cpu_usage

# 查询应用响应时间
http_server_requests_seconds_sum
```

### 📈 可视化

Prometheus可以与Grafana集成，提供更丰富的可视化功能：

1. 在Grafana中添加Prometheus数据源
2. 导入预配置的Dashboard
3. 创建自定义图表和告警

## 📁 目录结构

```
06-Prometheus/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [Sentinel配置](../05-Sentinel/README.md)
- [Grafana配置](../07-Grafana/README.md)
