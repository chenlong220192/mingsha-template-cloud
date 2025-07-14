# 🔧 Jenkins CI/CD

## 📋 目录说明

本目录包含鸣沙微服务项目的Jenkins CI/CD配置，包括Jenkins服务启动、构建服务器配置、Pipeline管理等。

## 🚀 Jenkins 服务

### 🚀 启动Jenkins容器

#### 环境配置
- **镜像版本**: `jenkins/jenkins:2.454-alpine`
- **端口映射**: `8090:8080`
- **内存限制**: `2048m`
- **数据卷**: `/data/containers/jenkins:/var/jenkins_home`

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.27 \
    -p 0.0.0.0:8090:8080 \
    -v /data/containers/jenkins:/var/jenkins_home \
    --memory 2048m \
    --restart=no \
    --name cloud-jenkins \
    jenkins/jenkins:2.454-alpine
```

#### ⚠️ 重要信息
- **访问地址**: `http://localhost:8090`
- **默认用户名**: `admin`
- **默认密码**: `123456`
- **容器名称**: `cloud-jenkins`
- **数据存储**: `/data/containers/jenkins`

### 🔍 连接验证

#### 访问控制台
1. 打开浏览器访问: `http://localhost:8090`
2. 使用默认账号登录: `admin/123456`
3. 进入Jenkins Dashboard

#### 初始化Token获取
如果是全新安装，需要在容器日志中查看初始化Token：
```bash
# 查看容器日志获取初始化Token
docker logs cloud-jenkins
```

#### 权限配置
```bash
# 进入Jenkins容器（指定root权限）
docker exec -it -u root cloud-jenkins /bin/bash

# 设置Jenkins工作目录权限
chown -R 1000:1000 /var/jenkins_home

# 在宿主机执行重启命令
docker restart cloud-jenkins
```

## 🚀 构建服务器

### 🚀 创建Docker构建服务器

#### 环境配置
- **SSH端口**: `22`
- **SSH账号**: `root`
- **SSH密码**: `123456`
- **功能**: 构建应用

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.28 \
    -v volume4cloud:/data \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --restart=no \
    --memory 2048m \
    --name cloud-jenkins-agent-docker \
    site.mingsha/mingsha-server:openjdk-11-rocky9
```

### 🚀 创建OpenJDK11构建服务器

#### 环境配置
- **SSH端口**: `22`
- **SSH账号**: `root`
- **SSH密码**: `123456`
- **功能**: 构建Java应用

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.29 \
    -v volume4cloud:/data \
    --restart=no \
    --memory 2048m \
    --name cloud-jenkins-agent-openjdk11 \
    site.mingsha/mingsha-server:openjdk-11-rocky9
```

### 🚀 创建Node.js构建服务器

#### 环境配置
- **SSH端口**: `22`
- **SSH账号**: `root`
- **SSH密码**: `123456`
- **功能**: 构建前端应用

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.30 \
    -v volume4cloud:/data \
    --restart=no \
    --memory 2048m \
    --name cloud-jenkins-agent-node \
    site.mingsha/mingsha-server:openjdk-11-rocky9
```

### 🚀 创建Linux部署服务器

#### 环境配置
- **SSH端口**: `22`
- **SSH账号**: `root`
- **SSH密码**: `123456`
- **前端端口**: `7999:8000`
- **功能**: 部署发布

#### 启动命令
```bash
docker run -d \
    --network=network4cloud \
    --ip=101.0.0.31 \
    -v volume4cloud:/data \
    -p 0.0.0.0:7999:8000 \
    --restart=no \
    --memory 6144m \
    --name cloud-server-linux \
    site.mingsha/mingsha-server:openjdk-11-rocky9
```

## 🔧 配置说明

### 📝 服务器说明
- **101.0.0.28**: Docker构建服务器，支持Docker操作
- **101.0.0.29**: OpenJDK11构建服务器，用于Java应用构建
- **101.0.0.30**: Node.js构建服务器，用于前端应用构建
- **101.0.0.31**: Linux部署服务器，用于应用部署

### 🔐 SSH连接配置
所有构建服务器都支持SSH连接：
- **用户名**: `root`
- **密码**: `123456`
- **端口**: `22`

### 💾 数据共享
- 所有服务器都挂载了 `volume4cloud` 数据卷
- 支持构建产物和配置文件共享

## 📊 使用指南

### 🔗 Jenkins节点配置

#### 1. 添加SSH节点
1. 进入Jenkins → `Manage Jenkins` → `Manage Nodes and Clouds`
2. 点击 `New Node`
3. 配置节点信息：
   - **Name**: `docker-agent`
   - **Type**: `Permanent Agent`
   - **Remote root directory**: `/data/jenkins`
   - **Labels**: `docker`

#### 2. 配置SSH连接
- **Host**: `101.0.0.28`
- **Credentials**: 添加SSH凭据
- **Port**: `22`
- **Launch method**: `Launch agents via SSH`

#### 3. 配置凭据
1. 进入 `Manage Jenkins` → `Manage Credentials`
2. 添加SSH凭据：
   - **Kind**: `SSH Username with private key`
   - **Username**: `root`
   - **Private Key**: 选择或上传私钥

### 📋 Pipeline示例

#### Java应用构建Pipeline
```groovy
pipeline {
    agent { label 'openjdk11' }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('SonarQube') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                sh 'docker build -t mingsha-app .'
                sh 'docker push registry/mingsha-app'
            }
        }
    }
}
```

## 📁 目录结构

```
12-Jenkins/
└── README.md                    # 本文档
```

## 🔗 相关链接

- [项目主页](../../README.md)
- [SonarQube配置](../11-Sonarqube/README.md)
- [环境配置](../01-Env/README.md)
