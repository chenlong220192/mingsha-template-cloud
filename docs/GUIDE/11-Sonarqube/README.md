# 🔍 SonarQube 代码质量检查

## 📋 目录说明

本目录包含鸣沙微服务项目的SonarQube代码质量检查配置，包括SonarQube服务启动、配置管理等。

## 🚀 SonarQube 服务

### 🚀 启动SonarQube容器

#### 环境配置
- **镜像版本**: `sonarqube:9.9.4-community`
- **端口映射**: `9000:9000`
- **内存限制**: `2048m`
- **配置文件**: `conf/sonar.properties`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.26 \
    -p 0.0.0.0:9000:9000 \
    --restart=no \
    --memory 2048m \
    --name cloud-sonarqube \
    sonarqube:9.9.4-community
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:9000`
- **初始用户名**: `admin`
- **初始密码**: `admin`
- **容器名称**: `cloud-sonarqube`

### 🔍 连接验证

#### 访问控制台
1. 打开浏览器访问: `http://localhost:9000`
2. 使用默认账号登录: `admin/admin`
3. 进入SonarQube Dashboard

#### 检查服务状态
```bash
# 查看容器运行状态
docker ps | grep cloud-sonarqube

# 查看容器日志
docker logs cloud-sonarqube

# 检查服务健康状态
curl http://localhost:9000/api/system/status
```

## 🔧 配置说明

### 📝 主要配置项
- **端口**: `9000` - SonarQube Web界面端口
- **内存**: `2048m` - 容器内存限制
- **配置文件**: `conf/sonar.properties` - 主配置文件

### 🔐 安全配置
- 默认用户名/密码: `admin/admin`
- 建议首次登录后立即修改密码
- 支持LDAP、OAuth等认证方式

### 📊 功能特性
- **代码质量分析**: 静态代码分析
- **安全漏洞检测**: 安全漏洞扫描
- **代码覆盖率**: 测试覆盖率统计
- **技术债务**: 技术债务评估
- **多语言支持**: 支持Java、JavaScript、Python等

## 📊 使用指南

### 🔗 项目集成

#### 1. 生成Token
1. 登录SonarQube
2. 进入 `My Account` → `Security`
3. 生成新的Token
4. 保存Token用于后续使用

#### 2. 配置Maven项目
在项目的 `pom.xml` 中添加插件：

```xml
<plugin>
    <groupId>org.sonarsource.scanner.maven</groupId>
    <artifactId>sonar-maven-plugin</artifactId>
    <version>3.10.0.2594</version>
</plugin>
```

#### 3. 执行代码分析
```bash
# 使用Maven执行分析
mvn clean verify sonar:sonar \
    -Dsonar.host.url=http://localhost:9000 \
    -Dsonar.login=your-token \
    -Dsonar.projectKey=mingsha-cloud \
    -Dsonar.projectName="鸣沙微服务项目"
```

#### 4. 使用SonarQube Scanner
```bash
# 下载并配置SonarQube Scanner
sonar-scanner \
    -Dsonar.host.url=http://localhost:9000 \
    -Dsonar.login=your-token \
    -Dsonar.projectKey=mingsha-cloud \
    -Dsonar.sources=src/main/java \
    -Dsonar.java.binaries=target/classes
```

### 📈 质量门禁

#### 配置质量门禁
1. 进入 `Quality Gates`
2. 创建或编辑质量门禁规则
3. 设置质量指标阈值：
   - **覆盖率**: 最低80%
   - **重复率**: 最高3%
   - **技术债务**: 最多5天
   - **安全热点**: 0个高危

#### 质量指标说明
- **可靠性**: 代码可靠性评级
- **安全性**: 安全漏洞评级
- **可维护性**: 代码可维护性评级
- **覆盖率**: 测试覆盖率
- **重复率**: 代码重复率

## 📁 目录结构

```
11-Sonarqube/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [RocketMQ配置](../10-RocketMQ/README.md)
- [Jenkins配置](../12-Jenkins/README.md)
