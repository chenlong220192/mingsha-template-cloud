# 🏜️ 鸣沙微服务项目

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.7.x-green.svg)](https://spring.io/projects/spring-boot)
[![Spring Cloud](https://img.shields.io/badge/Spring%20Cloud-2021.x-green.svg)](https://spring.io/projects/spring-cloud)
[![Docker](https://img.shields.io/badge/Docker-20.x-blue.svg)](https://www.docker.com/)

## 🎯 项目简介

鸣沙是一个基于Spring Cloud全家桶的微服务体系建设项目，提供完整的微服务解决方案。项目涉及服务治理、流量管理、监控、APM、日志、MQ、代码扫描、CI/CD等完整的技术栈。

本项目使用Docker环境进行开发、测试、部署，k8s部署相关内容不在此提及。

### ✨ 主要特性

- 🚀 **完整的微服务架构**: 基于Spring Cloud全家桶
- 🛡️ **服务治理**: Nacos注册中心 + 配置中心
- 🔄 **流量控制**: Sentinel熔断降级 + 流量控制
- 📊 **监控体系**: Prometheus + Grafana + SkyWalking
- 📝 **日志系统**: EFK (Elasticsearch + Filebeat + Kibana)
- 📨 **消息队列**: RocketMQ异步通信
- 🔍 **代码质量**: SonarQube代码质量检查
- 🔧 **CI/CD**: Jenkins持续集成部署
- 🐳 **容器化**: 完整的Docker环境支持

## 🏗️ 技术架构

### 📊 整体架构图

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    🎨 前端应用层 (Port: 8000)                                    │
│                              Vue.js + Element UI + Vue Router + Vuex                            │
└─────────────────────────────────────┬───────────────────────────────────────────────────────────┘
                                      │
┌─────────────────────────────────────▼───────────────────────────────────────────────────────────┐
│                                    🚪 网关服务层 (Port: 8001)                                    │
│                    Spring Cloud Gateway + Sentinel + JWT + 验证码 + XSS防护                      │
└─────────────────────────────────────┬───────────────────────────────────────────────────────────┘
                                      │
┌─────────────────────────────────────▼───────────────────────────────────────────────────────────┐
│                                    ⚙️ 微服务集群                                                │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                │
│  │   🔐 认证服务   │ │   🏢 系统服务   │ │   📁 文件服务   │ │   📨 消息服务   │                │
│  │   (Port: 8002)  │ │   (Port: 8003)  │ │   (Port: 8004)  │ │   (Port: 8005)  │                │
│  │ Spring Security │ │ MyBatis Plus    │ │ MinIO Storage   │ │ RocketMQ        │                │
│  │ JWT + Redis     │ │ MySQL + Redis   │ │ File Upload     │ │ Message Queue   │                │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘                │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                │
│  │ 🔧 代码生成     │ │ 🔄 提供服务     │ │ 📥 消费服务     │ │ 📊 监控服务     │                │
│  │ (Port: 8006)    │ │ (Port: 8007)    │ │ (Port: 8008)    │ │ (Port: 8009)    │                │
│  │ Velocity        │ │ OpenFeign       │ │ RocketMQ        │ │ Spring Boot     │                │
│  │ Code Generator  │ │ Service Provider│ │ Message Consumer│ │ Admin + Actuator│                │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘                │
└─────────────────────────────────────┬───────────────────────────────────────────────────────────┘
                                      │
┌─────────────────────────────────────▼───────────────────────────────────────────────────────────┐
│                                    🌐 服务治理层                                                │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                │
│  │   🌐 Nacos      │ │   🛡️ Sentinel  │ │   🔗 OpenFeign  │ │   ⚖️ LoadBalancer│                │
│  │ 服务注册发现     │ │ 流量控制熔断     │ │ 服务间调用       │ │ 负载均衡         │                │
│  │ 配置中心         │ │ 实时监控         │ │ 降级处理         │ │ 健康检查         │                │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘                │
└─────────────────────────────────────┬───────────────────────────────────────────────────────────┘
                                      │
┌─────────────────────────────────────▼───────────────────────────────────────────────────────────┐
│                                    📊 监控运维层                                                │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                │
│  │ 📊 Prometheus   │ │ 📈 Grafana      │ │ 🌟 SkyWalking   │ │ 📝 EFK Stack    │                │
│  │ 指标收集         │ │ 数据可视化       │ │ APM链路追踪      │ │ 日志收集分析     │                │
│  │ 监控告警         │ │ Dashboard       │ │ 性能监控         │ │ Elasticsearch   │                │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘                │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                │
│  │ 🚀 RocketMQ     │ │ 🔍 SonarQube    │ │ 🔧 Jenkins      │ │ 🐳 Docker       │                │
│  │ 消息队列         │ │ 代码质量检查     │ │ CI/CD流水线      │ │ 容器化部署       │                │
│  │ 异步通信         │ │ 安全扫描         │ │ 自动化构建       │ │ 环境隔离         │                │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘                │
└─────────────────────────────────────┬───────────────────────────────────────────────────────────┘
                                      │
┌─────────────────────────────────────▼───────────────────────────────────────────────────────────┐
│                                    💾 数据存储层                                                │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                │
│  │   🗄️ MySQL     │ │   🔴 Redis      │ │   📊 Elasticsearch│ │   📁 MinIO     │                │
│  │ 关系型数据库     │ │ 缓存数据库       │ │ 搜索引擎         │ │ 对象存储         │                │
│  │ 业务数据存储     │ │ 会话缓存         │ │ 日志存储         │ │ 文件存储         │                │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘                │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### 🔄 服务调用链路图

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   前端应用   │───▶│   网关服务   │───▶│   认证服务   │───▶│   系统服务   │
│  (Vue.js)   │    │  (Gateway)  │    │   (Auth)    │    │  (System)   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │                   │
       │                   ▼                   ▼                   ▼
       │            ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
       │            │   Sentinel  │    │    Redis    │    │    MySQL    │
       │            │ 流量控制     │    │   缓存      │    │   数据库    │
       │            └─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │                   │
       ▼                   ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  文件服务   │    │  消息服务   │    │  代码生成   │    │  提供服务   │
│   (File)    │    │ (Message)   │    │(Generator)  │    │ (Provider)  │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │                   │
       ▼                   ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    MinIO    │    │   RocketMQ  │    │   Velocity  │    │  OpenFeign  │
│  对象存储   │    │  消息队列   │    │  模板引擎   │    │  服务调用   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### 📡 监控链路图

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Prometheus │───▶│   Grafana   │───▶│  SkyWalking │───▶│   EFK Stack │
│   指标收集   │    │  可视化     │    │  APM监控    │    │  日志分析   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       ▲                   ▲                   ▲                   ▲
       │                   │                   │                   │
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   微服务    │───▶│   Actuator  │───▶│   Agent     │───▶│  Filebeat   │
│  集群       │    │  端点       │    │  探针       │    │  日志收集   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### 🔧 核心技术栈

#### 🚀 微服务框架
| 技术 | 版本 | 说明 |
|------|------|------|
| **Spring Boot** | 2.7.x | 微服务基础框架，提供自动配置和快速开发 |
| **Spring Cloud** | 2021.x | 微服务治理框架，提供服务发现、配置管理等 |
| **Spring Cloud Alibaba** | 2021.x | 阿里微服务组件，提供Nacos、Sentinel等 |
| **Spring Cloud Gateway** | 3.1.x | 网关服务，提供路由转发、负载均衡、安全控制 |
| **OpenFeign** | 3.1.x | 声明式HTTP客户端，简化服务间调用 |

#### 🌐 服务治理
| 技术 | 版本 | 说明 |
|------|------|------|
| **Nacos** | 2.3.2 | 服务注册与配置中心，支持动态配置管理 |
| **Sentinel** | 1.8.7 | 流量控制与熔断降级，提供实时监控和规则配置 |
| **Spring Cloud LoadBalancer** | 3.1.x | 负载均衡器，支持多种负载均衡策略 |

#### 🔐 安全认证
| 技术 | 版本 | 说明 |
|------|------|------|
| **Spring Security** | 5.7.x | 安全框架，提供认证和授权功能 |
| **JWT** | 0.11.x | JSON Web Token，无状态身份验证 |
| **Redis** | 7.2.4 | 缓存数据库，存储会话和验证码 |

#### 📊 监控运维
| 技术 | 版本 | 说明 |
|------|------|------|
| **Prometheus** | 2.51.2 | 监控指标收集，支持多维度数据采集 |
| **Grafana** | 10.3.4 | 数据可视化，提供丰富的Dashboard |
| **SkyWalking** | 9.7.0 | 应用性能监控，提供分布式链路追踪 |
| **Spring Boot Actuator** | 2.7.x | 应用监控端点，提供健康检查和指标暴露 |

#### 📝 日志系统
| 技术 | 版本 | 说明 |
|------|------|------|
| **Elasticsearch** | 7.17.20 | 搜索引擎，存储和检索日志数据 |
| **Filebeat** | 7.17.x | 日志收集器，轻量级日志传输 |
| **Kibana** | 7.17.x | 日志可视化，提供日志搜索和分析 |

#### 📨 消息队列
| 技术 | 版本 | 说明 |
|------|------|------|
| **RocketMQ** | 5.2.0 | 分布式消息队列，支持高吞吐量和可靠性 |
| **RocketMQ Spring Boot Starter** | 2.3.0 | Spring Boot集成，简化消息发送和消费 |

#### 💾 数据存储
| 技术 | 版本 | 说明 |
|------|------|------|
| **MySQL** | 8.0.33 | 关系型数据库，存储业务数据 |
| **MyBatis Plus** | 3.5.x | ORM框架，简化数据库操作 |
| **MinIO** | 最新版 | 对象存储，文件上传和下载服务 |

#### 🔍 代码质量
| 技术 | 版本 | 说明 |
|------|------|------|
| **SonarQube** | 9.9.4 | 代码质量检查，提供代码分析和安全扫描 |
| **Maven** | 3.8+ | 项目构建工具，管理依赖和构建流程 |

#### 🔧 CI/CD
| 技术 | 版本 | 说明 |
|------|------|------|
| **Jenkins** | 2.454 | 持续集成部署，自动化构建和部署 |
| **Docker** | 20.10+ | 容器化技术，提供环境隔离和快速部署 |

#### 🎨 前端技术
| 技术 | 版本 | 说明 |
|------|------|------|
| **Vue.js** | 2.6.x | 前端框架，构建用户界面 |
| **Element UI** | 2.15.x | UI组件库，提供丰富的界面组件 |
| **Vue Router** | 3.5.x | 路由管理，单页应用导航 |
| **Vuex** | 3.6.x | 状态管理，集中管理应用状态 |

## 🚀 快速开始

### 📋 环境要求

- **JDK**: 11.0.2+
- **Maven**: 3.8+
- **Docker**: 20.10+
- **Node.js**: 18.20.5+
- **内存**: 8GB+ (推荐16GB)
- **磁盘**: 20GB+ 可用空间

### ⚡ 一键启动

#### 1. 克隆项目
```bash
git clone https://github.com/your-org/mingsha-template-cloud.git
cd mingsha-template-cloud
```

#### 2. 查看帮助信息
```bash
make help
```

#### 3. 一键部署所有服务
```bash
# 标准部署（推荐）
make docker.all

# 带链路追踪部署
make docker.all-skywalking
```

#### 4. 启动前端应用
```bash
cd mingsha-ui
make dev
```

#### 5. 访问服务
- **前端应用**: http://localhost:8000 (admin/123456)
- **网关服务**: http://localhost:8001
- **Nacos控制台**: http://localhost:8848/nacos (nacos/nacos)
- **Sentinel控制台**: http://localhost:8858 (sentinel/sentinel)
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/123456)
- **SkyWalking**: http://localhost:8080

### 🔧 分步部署

#### 1. 环境初始化
```bash
# 创建Docker网络和存储卷
cd docs/01-Init
make init
```

#### 2. 启动基础服务
```bash
# 启动MySQL
cd docs/02-MySQL
make start

# 启动Redis
cd docs/03-Redis
make start

# 启动Nacos
cd docs/04-Nacos
make start

# 启动Sentinel
cd docs/05-Sentinel
make start
```

#### 3. 构建和部署微服务
```bash
# 构建所有服务
make package

# 部署单个服务
make docker.build docker.run APPNAME=gateway VERSION=1.0.0 IP=101.0.0.101 PORT=8001
make docker.build docker.run APPNAME=auth VERSION=1.0.0 IP=101.0.0.102 PORT=8002
make docker.build docker.run APPNAME=system VERSION=1.0.0 IP=101.0.0.103 PORT=8003
make docker.build docker.run APPNAME=file VERSION=1.0.0 IP=101.0.0.104 PORT=8004
make docker.build docker.run APPNAME=generator VERSION=1.0.0 IP=101.0.0.105 PORT=8005
```

#### 4. 启动监控服务
```bash
# 启动Prometheus
cd docs/06-Prometheus
make start

# 启动Grafana
cd docs/07-Grafana
make start

# 启动SkyWalking
cd docs/08-SkyWalking
make start
```

### 🛠️ 常用Make命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `make help` | 显示帮助信息 | `make help` |
| `make clean` | 清理构建文件 | `make clean` |
| `make package` | 构建应用包 | `make package APPNAME=gateway` |
| `make test` | 运行单元测试 | `make test` |
| `make docker.build` | 构建Docker镜像 | `make docker.build APPNAME=auth VERSION=1.0.0` |
| `make docker.run` | 运行Docker容器 | `make docker.run APPNAME=auth VERSION=1.0.0 IP=101.0.0.102 PORT=8002` |
| `make docker.remove` | 移除Docker容器 | `make docker.remove APPNAME=auth` |
| `make docker.all` | 一键部署所有服务 | `make docker.all` |
| `make startup` | 本地部署应用 | `make startup APPNAME=gateway` |
| `make test-sonarqube` | 代码质量检查 | `make test-sonarqube` |

### 🎯 快速验证

部署完成后，可以通过以下方式验证服务状态：

```bash
# 检查服务状态
docker ps

# 查看服务日志
docker logs mingsha-service-gateway
docker logs mingsha-service-auth
docker logs mingsha-service-system

# 测试服务连通性
curl http://localhost:8001/actuator/health
curl http://localhost:8002/actuator/health
curl http://localhost:8003/actuator/health
```

## 📚 文档导航

### 🚀 快速入门
- [📚 文档中心](./docs/README.md) - 完整的项目文档和配置指南
- [🚀 环境配置](./docs/00-Env/README.md) - 开发环境和运行环境镜像构建
- [🚀 环境初始化](./docs/01-Init/README.md) - Docker网络和存储卷创建

### 🗄️ 数据存储
- [🗄️ MySQL数据库配置](./docs/02-MySQL/README.md) - MySQL服务和Adminer管理工具
- [🔴 Redis缓存配置](./docs/03-Redis/README.md) - Redis缓存服务和连接配置

### 🌐 服务治理
- [🌐 Nacos服务注册与配置中心](./docs/04-Nacos/README.md) - 服务注册发现和配置管理
- [🛡️ Sentinel流量控制](./docs/05-Sentinel/README.md) - 流量控制和熔断降级

### 📊 监控体系
- [📊 Prometheus监控](./docs/06-Prometheus/README.md) - 指标收集和监控告警
- [📈 Grafana可视化](./docs/07-Grafana/README.md) - 数据可视化和Dashboard
- [🌟 SkyWalking APM](./docs/08-SkyWalking/README.md) - 应用性能监控和链路追踪

### 📝 运维工具
- [📊 EFK日志系统](./docs/09-EFK/README.md) - 日志收集、存储和分析
- [🚀 RocketMQ消息队列](./docs/10-RocketMQ/README.md) - 消息队列和异步通信
- [🔍 SonarQube代码质量检查](./docs/11-Sonarqube/README.md) - 代码质量分析和安全扫描
- [🔧 Jenkins CI/CD](./docs/12-Jenkins/README.md) - 持续集成和持续部署

### 📋 服务访问地址
| 服务名称 | 访问地址 | 默认账号/密码 |
|----------|----------|---------------|
| 前端应用 | http://localhost:8000 | admin/123456 |
| 网关服务 | http://localhost:8001 | - |
| Nacos控制台 | http://localhost:8848/nacos | nacos/nacos |
| Sentinel控制台 | http://localhost:8858 | sentinel/sentinel |
| Prometheus | http://localhost:9090 | - |
| Grafana | http://localhost:3000 | admin/123456 |
| SkyWalking | http://localhost:8080 | - |
| Kibana | http://localhost:5601 | elastic/changeme |
| RocketMQ Dashboard | http://localhost:8088 | - |
| SonarQube | http://localhost:9000 | admin/admin |
| Jenkins | http://localhost:8090 | admin/123456 |

## 📁 工程结构

```
mingsha-template-cloud/
├── 📚 docs/                           # 项目文档
│   ├── 00-Env/                        # 环境配置与部署
│   ├── 01-Init/                       # 环境初始化
│   ├── 02-MySQL/                      # MySQL数据库配置
│   ├── 03-Redis/                      # Redis缓存配置
│   ├── 04-Nacos/                      # Nacos服务注册与配置中心
│   ├── 05-Sentinel/                   # Sentinel流量控制
│   ├── 06-Prometheus/                 # Prometheus监控
│   ├── 07-Grafana/                    # Grafana可视化
│   ├── 08-SkyWalking/                 # SkyWalking APM
│   ├── 09-EFK/                        # EFK日志系统
│   ├── 10-RocketMQ/                   # RocketMQ消息队列
│   ├── 11-Sonarqube/                  # SonarQube代码质量检查
│   └── 12-Jenkins/                    # Jenkins CI/CD
├── 🚀 deploy/                         # 部署脚本
│   ├── bin/                           # 构建脚本
│   ├── deploy/                        # 部署配置
│   └── docker/                        # Docker镜像
├── 🔧 mingsha-common/                 # 自定义starter
│   ├── mingsha-common-core/           # 核心代码
│   ├── mingsha-common-actuator/       # 监控器
│   ├── mingsha-common-prometheus/     # JVM Exporter
│   ├── mingsha-common-datascope/      # 权限范围
│   ├── mingsha-common-datasource/     # 多数据源
│   ├── mingsha-common-log/            # 操作日志
│   ├── mingsha-common-redis/          # Redis
│   ├── mingsha-common-rocketmq/       # RocketMQ
│   ├── mingsha-common-security/       # 安全模块
│   └── mingsha-common-swagger/        # 接口模块
├── 🎭 mingsha-facade/                 # 门面模式
│   ├── mingsha-facade-file/           # 文件Feign客户端
│   └── mingsha-facade-system/         # 系统Feign客户端
├── ⚙️ mingsha-service/                # 微服务集群
│   ├── mingsha-service-gateway/       # 网关服务 [8001]
│   ├── mingsha-service-auth/          # 认证服务 [8002]
│   ├── mingsha-service-system/        # 系统服务 [8003]
│   ├── mingsha-service-file/          # 文件服务 [8004]
│   ├── mingsha-service-message/       # 消息服务 [8005]
│   ├── mingsha-service-generator/     # 代码生成 [8006]
│   ├── mingsha-service-provider/      # 提供服务 [8007]
│   ├── mingsha-service-consumer/      # 消费服务 [8008]
│   └── mingsha-service-monitor/       # 监控服务 [8009]
├── 🎨 mingsha-ui/                     # 前端工程 [8000]
├── 📊 sql/                            # 数据库脚本
├── 📋 Makefile                        # 构建命令
└── 📄 README.md                       # 项目说明
```

## 🔧 微服务详细说明

### 🚪 网关服务 (Gateway) - Port: 8001
**核心功能**: 统一入口、路由转发、负载均衡、安全控制
**技术栈**: 
- Spring Cloud Gateway - 网关框架
- Sentinel - 流量控制和熔断降级
- JWT - 身份验证
- 验证码 - 防机器人攻击
- XSS防护 - 跨站脚本攻击防护
- 黑名单过滤 - URL黑名单控制

**主要特性**:
- 动态路由配置
- 统一认证鉴权
- 请求限流熔断
- 跨域处理
- 请求日志记录

### 🔐 认证服务 (Auth) - Port: 8002
**核心功能**: 用户认证、权限验证、Token管理、登录日志
**技术栈**:
- Spring Security - 安全框架
- JWT - 无状态身份验证
- Redis - 会话缓存
- OpenFeign - 服务间调用

**主要特性**:
- 用户名密码认证
- JWT Token生成和验证
- 验证码校验
- 登录失败处理
- 会话管理

### 🏢 系统服务 (System) - Port: 8003
**核心功能**: 用户管理、角色管理、菜单管理、部门管理、字典管理
**技术栈**:
- Spring Boot - 应用框架
- MyBatis Plus - ORM框架
- MySQL - 数据存储
- Redis - 缓存
- Sentinel - 流量控制

**主要特性**:
- 用户CRUD操作
- 角色权限管理
- 菜单权限控制
- 数据权限范围
- 操作日志记录

### 📁 文件服务 (File) - Port: 8004
**核心功能**: 文件上传、下载、存储管理、文件预览
**技术栈**:
- Spring Boot - 应用框架
- MinIO - 对象存储
- Sentinel - 流量控制
- OpenFeign - 服务间调用

**主要特性**:
- 多格式文件上传
- 文件存储管理
- 文件下载服务
- 图片预览功能
- 文件权限控制

### 📨 消息服务 (Message) - Port: 8005
**核心功能**: 消息发送、模板管理、推送服务、消息队列
**技术栈**:
- Spring Boot - 应用框架
- RocketMQ - 消息队列
- Sentinel - 流量控制
- OpenFeign - 服务间调用

**主要特性**:
- 消息生产消费
- 消息模板管理
- 异步消息处理
- 消息状态跟踪
- 消息重试机制

### 🔧 代码生成 (Generator) - Port: 8006
**核心功能**: 代码生成、模板管理、数据库表结构分析
**技术栈**:
- Spring Boot - 应用框架
- Velocity - 模板引擎
- MySQL - 数据库连接
- Sentinel - 流量控制

**主要特性**:
- 数据库表分析
- 代码模板生成
- 多模块代码生成
- 模板自定义
- 代码预览下载

### 🔄 提供服务 (Provider) - Port: 8007
**核心功能**: 业务服务提供者、服务接口暴露
**技术栈**:
- Spring Boot - 应用框架
- OpenFeign - 服务接口
- Sentinel - 流量控制
- Actuator - 监控端点

**主要特性**:
- 业务接口提供
- 服务降级处理
- 健康检查
- 性能监控

### 📥 消费服务 (Consumer) - Port: 8008
**核心功能**: 业务服务消费者、消息消费处理
**技术栈**:
- Spring Boot - 应用框架
- RocketMQ - 消息消费
- OpenFeign - 服务调用
- Sentinel - 流量控制

**主要特性**:
- 消息消费处理
- 服务调用集成
- 业务逻辑处理
- 异常处理机制

### 📊 监控服务 (Monitor) - Port: 8009
**核心功能**: 系统监控、性能分析、应用管理
**技术栈**:
- Spring Boot Admin - 应用监控
- Spring Boot Actuator - 监控端点
- Prometheus - 指标收集
- Sentinel - 流量控制

**主要特性**:
- 应用状态监控
- 性能指标收集
- 健康检查
- 告警通知

## 📊 监控体系

### 🔍 监控组件架构

#### 📊 Prometheus 监控系统
- **功能**: 指标收集、存储、查询和告警
- **采集方式**: Pull模式，主动拉取微服务指标
- **数据存储**: 时序数据库，支持高效查询
- **告警规则**: 支持灵活的告警规则配置

#### 📈 Grafana 可视化平台
- **功能**: 数据可视化和Dashboard展示
- **数据源**: 支持Prometheus、Elasticsearch等多种数据源
- **图表类型**: 支持折线图、柱状图、饼图等多种图表
- **告警通知**: 支持邮件、钉钉、企业微信等通知方式

#### 🌟 SkyWalking APM
- **功能**: 分布式链路追踪和应用性能监控
- **链路追踪**: 自动追踪微服务调用链路
- **性能分析**: 提供接口响应时间、吞吐量等性能指标
- **拓扑图**: 自动生成服务依赖关系拓扑图

#### 🛡️ Sentinel 流量控制
- **功能**: 实时监控、流量控制、熔断降级
- **监控面板**: 提供实时QPS、响应时间、异常数等指标
- **规则配置**: 支持动态配置限流、熔断规则
- **集群流控**: 支持集群级别的流量控制

### 📈 监控指标体系

#### 🖥️ 系统层面指标
- **CPU使用率**: 系统CPU负载情况
- **内存使用率**: JVM堆内存和非堆内存使用情况
- **磁盘I/O**: 磁盘读写性能指标
- **网络流量**: 网络带宽使用情况

#### ⚙️ 应用层面指标
- **JVM指标**: 堆内存、非堆内存、GC次数和时间
- **线程池**: 活跃线程数、队列大小、拒绝次数
- **数据库连接池**: 连接数、活跃连接、等待连接
- **缓存指标**: Redis连接数、命中率、响应时间

#### 📊 业务层面指标
- **QPS**: 每秒查询数，反映系统吞吐量
- **响应时间**: 接口平均响应时间、P95、P99响应时间
- **错误率**: 接口调用失败率
- **并发数**: 当前并发用户数

#### 🔗 链路层面指标
- **调用链**: 完整的请求调用链路
- **依赖关系**: 服务间的依赖关系图
- **瓶颈分析**: 识别性能瓶颈点
- **异常定位**: 快速定位异常发生位置

### 🔧 监控配置

#### Prometheus 配置
```yaml
# 监控目标配置
scrape_configs:
  - job_name: 'mingsha-services'
    static_configs:
      - targets: ['101.0.0.101:8001', '101.0.0.102:8002']
    metrics_path: '/actuator/prometheus'
    scrape_interval: 15s
```

#### Grafana Dashboard
- **系统监控面板**: CPU、内存、磁盘等系统指标
- **应用监控面板**: JVM、线程池、数据库等应用指标
- **业务监控面板**: QPS、响应时间、错误率等业务指标
- **链路监控面板**: 调用链、拓扑图等链路指标

#### SkyWalking 配置
```yaml
# 探针配置
agent:
  service_name: mingsha-service-gateway
  collector:
    backend_service: 101.0.0.18:11800
  sample:
    n_per_3_secs: -1
```

#### Sentinel 配置
```yaml
# 流量控制规则
spring:
  cloud:
    sentinel:
      datasource:
        ds1:
          nacos:
            server-addr: 101.0.0.14:8848
            dataId: sentinel-flow-rules
            groupId: DEFAULT_GROUP
            rule-type: flow
```

## 🐛 故障排查

### 🔍 常见问题
1. **服务无法启动**: 检查端口占用和网络配置
2. **数据库连接失败**: 检查MySQL服务状态和连接配置
3. **服务注册失败**: 检查Nacos服务状态
4. **监控数据异常**: 检查Prometheus配置和目标状态

### 📞 获取帮助
- 📚 [详细文档](./docs/README.md)
- 🐛 [提交Issue](https://github.com/your-org/mingsha-template-cloud/issues)
- 💬 [技术交流群](https://github.com/your-org/mingsha-template-cloud/discussions)

## 🤝 贡献指南

### 💡 如何贡献
1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

### 📋 开发规范
- 遵循阿里巴巴Java开发手册
- 使用统一的代码格式化配置
- 编写完整的单元测试
- 提交清晰的Commit信息

## 📄 许可证

本项目采用 [MIT License](LICENSE) 许可证。

## 🙏 致谢

- 感谢 [若依](https://doc.ruoyi.vip/) 项目提供的优秀基础框架
- 感谢所有贡献者的辛勤付出
- 感谢开源社区的支持

---

**🎉 感谢您使用鸣沙微服务项目！**

如果这个项目对您有帮助，请给一个 ⭐️ Star！
