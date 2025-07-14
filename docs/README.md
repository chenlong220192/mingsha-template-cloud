# 📚 鸣沙微服务项目文档中心

## 🎯 项目简介

鸣沙是一个基于Spring Cloud全家桶的微服务体系建设项目，涉及服务治理、流量管理、监控、APM、日志、MQ、代码扫描、CI/CD等完整的技术栈。

本项目使用Docker环境进行开发、测试、部署，提供完整的微服务解决方案。

## 📁 文档目录结构

本项目的文档目录采用统一的命名规范：`xx-Name` 格式，其中 `xx` 为两位数字序号，`Name` 为功能模块名称。

### 📋 完整目录列表

| 序号 | 目录名称 | 功能描述 | 访问地址 |
|------|----------|----------|----------|
| 00 | [🚀 环境初始化](./00-Init/) | Docker网络创建、存储卷创建 | - |
| 01 | [🚀 环境配置与部署](./01-Env/) | 开发环境镜像构建、运行环境镜像构建 | - |
| 02 | [🗄️ MySQL数据库配置](./02-MySQL/) | MySQL服务、Adminer管理工具 | `http://localhost:3306` |
| 03 | [🔴 Redis缓存配置](./03-Redis/) | Redis缓存服务、连接配置 | `http://localhost:6379` |
| 04 | [🌐 Nacos服务注册与配置中心](./04-Nacos/) | 服务注册发现、配置管理 | `http://localhost:8848/nacos` |
| 05 | [🛡️ Sentinel流量控制](./05-Sentinel/) | 流量控制、熔断降级 | `http://localhost:8858` |
| 06 | [📊 Prometheus监控](./06-Prometheus/) | 指标收集、监控告警 | `http://localhost:9090` |
| 07 | [📈 Grafana可视化](./07-Grafana/) | 数据可视化、Dashboard | `http://localhost:3000` |
| 08 | [🌟 SkyWalking APM](./08-SkyWalking/) | 应用性能监控、链路追踪 | `http://localhost:8080` |
| 09 | [📊 EFK日志系统](./09-EFK/) | 日志收集、存储、分析 | `http://localhost:5601` |
| 10 | [🚀 RocketMQ消息队列](./10-RocketMQ/) | 消息队列、异步通信 | `http://localhost:8088` |
| 11 | [🔍 SonarQube代码质量检查](./11-Sonarqube/) | 代码质量分析、安全扫描 | `http://localhost:9000` |
| 12 | [🔧 Jenkins CI/CD](./12-Jenkins/) | 持续集成、持续部署 | `http://localhost:8090` |

## 🔄 命名规范

### 📝 目录命名规则
- **格式**: `xx-Name`
- **xx**: 两位数字序号（00-99）
- **Name**: 功能模块名称（首字母大写）
- **示例**: `01-Env`、`00-Init`、`02-MySQL`

### 📄 文件命名规则
- **配置文件**: `Module.md`（如：`MySQL.md`、`Redis.md`）
- **脚本文件**: `action-module.sh`（如：`build-dev-env.sh`）
- **验证文件**: `validate-module.sh`（如：`validate-dockerfile.sh`）

## 🚀 快速开始

### 📋 环境准备
1. **Docker环境**: 确保Docker已安装并运行
2. **网络配置**: 创建专用Docker网络
3. **存储配置**: 创建持久化存储卷

### 🔧 初始化步骤
```bash
# 1. 查看环境配置
cd docs/01-Env
cat README.md

# 2. 初始化开发环境
cd docs/00-Init
cat README.md

# 3. 配置数据库
cd docs/02-MySQL
cat MySQL.md
```

### 📊 服务启动顺序
建议按照以下顺序启动服务：

1. **基础环境** (00-Init, 01-Env)
2. **数据存储** (02-MySQL, 03-Redis)
3. **服务治理** (04-Nacos, 05-Sentinel)
4. **监控体系** (06-Prometheus, 07-Grafana, 08-SkyWalking)
5. **日志系统** (09-EFK)
6. **消息队列** (10-RocketMQ)
7. **质量保证** (11-Sonarqube)
8. **CI/CD** (12-Jenkins)

## 📊 技术架构

### 🏗️ 整体架构
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   前端应用      │    │   网关服务      │    │   微服务集群    │
│   (Vue.js)      │◄──►│   (Gateway)     │◄──►│   (Spring Boot) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   服务注册      │    │   配置中心      │    │   流量控制      │
│   (Nacos)       │    │   (Nacos)       │    │   (Sentinel)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   监控系统      │    │   日志系统      │    │   消息队列      │
│   (Prometheus)  │    │   (EFK)         │    │   (RocketMQ)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 🔧 核心组件
- **服务治理**: Nacos (注册中心 + 配置中心)
- **流量控制**: Sentinel (熔断降级 + 流量控制)
- **监控体系**: Prometheus + Grafana + SkyWalking
- **日志系统**: Elasticsearch + Filebeat + Kibana
- **消息队列**: RocketMQ
- **代码质量**: SonarQube
- **CI/CD**: Jenkins

## 📝 使用说明

### 🎯 开发环境
1. **环境准备**: 参考 `01-Env` 目录配置开发环境
2. **项目初始化**: 参考 `00-Init` 目录进行基础配置
3. **服务配置**: 按照序号顺序配置各个服务模块
4. **监控部署**: 配置监控、日志、CI/CD等运维工具

### 🔍 故障排查
- **服务状态检查**: 每个目录都提供了服务状态检查命令
- **日志查看**: 使用 `docker logs` 查看容器日志
- **网络连通性**: 检查Docker网络配置和端口映射

### 📈 性能优化
- **资源配置**: 根据实际需求调整容器内存限制
- **存储优化**: 使用SSD存储提升I/O性能
- **网络优化**: 配置合适的网络参数

## 🔗 相关资源

### 📚 官方文档
- [Spring Cloud 官方文档](https://spring.io/projects/spring-cloud)
- [Nacos 官方文档](https://nacos.io/zh-cn/docs/what-is-nacos.html)
- [Sentinel 官方文档](https://sentinelguard.io/zh-cn/docs/introduction.html)
- [Prometheus 官方文档](https://prometheus.io/docs/)
- [Grafana 官方文档](https://grafana.com/docs/)

### 🛠️ 工具链接
- [Docker Hub](https://hub.docker.com/)
- [GitHub 项目地址](https://github.com/your-org/mingsha-template-cloud)

## 📞 技术支持

### 🐛 问题反馈
如果您在使用过程中遇到问题，请通过以下方式反馈：
- 提交 GitHub Issue
- 发送邮件至技术支持团队

### 💡 贡献指南
欢迎提交 Pull Request 来改进项目：
1. Fork 本仓库
2. 创建特性分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request
