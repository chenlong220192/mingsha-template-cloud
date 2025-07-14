#======================================================================
#
# example 'make help'
# example 'make package SKIP_TEST=true'
# example 'make docker.all'
#
# author: mingsha
# date: 2024-12-19
#======================================================================

SHELL := /bin/bash -o pipefail

export BASE_PATH := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# ----------------------------- colors <-----------------------------
# Emojis and icons
ROCKET := 🚀
GEAR := ⚙️
TEST := 🧪
PACKAGE := 📦
DOCKER := 🐳
CLEAN := 🧹
HELP := ❓
INFO := ℹ️
SUCCESS := ✅
WARNING := ⚠️
ERROR := ❌
SKYWALKING := 🌟
SONAR := 🔍
# 颜色变量（用于 printf）
RED=\033[31m
GREEN=\033[32m
YELLOW=\033[33m
BLUE=\033[34m
CYAN=\033[36m
BOLD=\033[1m
RESET=\033[0m
# ----------------------------- colors >-----------------------------

# ----------------------------- variables <-----------------------------
# unit test flag
SKIP_TEST ?= false
# mingsha-service包内应用名，简写。例如：provider
APPNAME ?= provider
# jar包版本
VERSION ?= 1.0.0
# SonarQube
SONAR_TOKEN ?= sqp_5dea11320be00b624828d5bab974092557debadf
SONAR_KEY ?= cloud
SONAR_URL ?= http://101.0.0.26:9000
# docker容器映射端口
PORT ?= false
# docker容器IP
IP ?= false
# ----------------------------- variables >-----------------------------

# ----------------------------- help <-----------------------------
.PHONY: help
help: ## $(HELP) 显示帮助信息
	@printf "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}\n"
	@printf "${BOLD}${CYAN}║                    ${ROCKET} 鸣沙云平台构建工具 ${ROCKET}                    ║${RESET}\n"
	@printf "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}\n"
	@printf "\n"
	@printf "${BOLD}${YELLOW}%-8s:${RESET}\n" "使用方法"
	@printf "  make <target> [APPNAME=service] [VERSION=version] [SKIP_TEST=true|false]\n"
	@printf "\n"

	@printf "${BOLD}${YELLOW}%-8s:${RESET}\n" "环境变量"
	@printf "  ${GREEN}%-22s${RESET} %s\n" "APPNAME" "- 服务名称 (默认: provider)"
	@printf "  ${GREEN}%-22s${RESET} %s\n" "VERSION" "- 版本号 (默认: 1.0.0)"
	@printf "  ${GREEN}%-22s${RESET} %s\n" "SKIP_TEST" "- 跳过测试 (默认: false)"
	@printf "  ${GREEN}%-22s${RESET} %s\n" "PORT" "- Docker端口映射"
	@printf "  ${GREEN}%-22s${RESET} %s\n" "IP" "- Docker容器IP"
	@printf "\n"

	@printf "${BOLD}${YELLOW}%-8s:${RESET}\n" "可用目标"
	@awk 'BEGIN {FS = ":.*?## "; max=25} /^[a-zA-Z0-9_.-]+:.*?## / {cmd=$$1; desc=$$2; printf "  ${GREEN}%-*s${RESET} %s\n", max, cmd, desc}' max=25 $(MAKEFILE_LIST) | \
		sed 's/\$$(HELP)/$(HELP)/g' | sed 's/\$$(CLEAN)/$(CLEAN)/g' | sed 's/\$$(TEST)/$(TEST)/g' | sed 's/\$$(PACKAGE)/$(PACKAGE)/g' | sed 's/\$$(DOCKER)/$(DOCKER)/g' | sed 's/\$$(SKYWALKING)/$(SKYWALKING)/g' | sed 's/\$$(SONAR)/$(SONAR)/g'
	@printf "\n"

	@printf "${BOLD}${YELLOW}%-8s:${RESET}\n" "示例"
	@printf "  ${GREEN}%-25s${RESET} %s\n" "make help" "${HELP} 显示此帮助信息"
	@printf "  ${GREEN}%-25s${RESET} %s\n" "make clean" "${CLEAN} 清理构建文件"
	@printf "  ${GREEN}%-25s${RESET} %s\n" "make package APPNAME=gateway" "${PACKAGE} 构建网关服务"
	@printf "  ${GREEN}%-25s${RESET} %s\n" "make docker.all" "${DOCKER} 一键部署所有服务"
	@printf "  ${GREEN}%-25s${RESET} %s\n" "make docker.all-skywalking" "${SKYWALKING} 带链路追踪部署"
	@printf "\n"
	@printf "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${RESET}\n"
	@printf "${BOLD}${CYAN}║                    ${SUCCESS} 构建愉快！${SUCCESS}                              ║${RESET}\n"
	@printf "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${RESET}\n"

.DEFAULT_GOAL := help
# ----------------------------- help >-----------------------------

# ----------------------------- maven <-----------------------------
clean: ## $(CLEAN) 清理Maven构建文件
	@printf "${BLUE}${CLEAN} 清理构建文件...${RESET}\n"
	$(BASE_PATH)/mvnw --batch-mode --errors -f ${BASE_PATH}/pom.xml clean
	@printf "${GREEN}${SUCCESS} 清理完成！${RESET}\n"

test: ## $(TEST) 运行单元测试
	@printf "${BLUE}${TEST} 运行单元测试...${RESET}\n"
	$(BASE_PATH)/mvnw --batch-mode --errors --fail-at-end -f ${BASE_PATH}/pom.xml clean test -D maven.test.skip=false
	@printf "${GREEN}${SUCCESS} 测试完成！${RESET}\n"

package: ## $(PACKAGE) 构建应用包
	@printf "${BLUE}${PACKAGE} 构建应用包 (服务: ${APPNAME}, 版本: ${VERSION})...${RESET}\n"
	$(BASE_PATH)/mvnw --batch-mode --errors --fail-at-end -f ${BASE_PATH}/pom.xml clean package -D maven.test.skip=$(SKIP_TEST)
	@printf "${GREEN}${SUCCESS} 构建完成！${RESET}\n"

test-sonarqube: ## $(SONAR) SonarQube代码质量检查
	@printf "${BLUE}${SONAR} 执行SonarQube代码质量检查...${RESET}\n"
	$(BASE_PATH)/mvnw --batch-mode --errors --fail-at-end -f ${BASE_PATH}/pom.xml clean verify sonar:sonar -Dsonar.projectKey=${SONAR_KEY} -Dsonar.host.url=${SONAR_URL} -Dsonar.login=${SONAR_TOKEN}
	@printf "${GREEN}${SUCCESS} SonarQube检查完成！${RESET}\n"

startup: ## $(GEAR) 本地部署应用
	@printf "${BLUE}${GEAR} 启动本地应用 (服务: ${APPNAME}, 版本: ${VERSION})...${RESET}\n"
	sh ${BASE_PATH}/deploy/deploy/startup.sh ${APPNAME} ${VERSION}
	@printf "${GREEN}${SUCCESS} 应用启动完成！${RESET}\n"

startup-skywalking: ## $(SKYWALKING) 本地部署应用(带SkyWalking)
	@printf "${BLUE}${SKYWALKING} 启动本地应用(带链路追踪) (服务: ${APPNAME}, 版本: ${VERSION})...${RESET}\n"
	sh ${BASE_PATH}/deploy/deploy/startup-skywalking.sh ${APPNAME} ${VERSION}
	@printf "${GREEN}${SUCCESS} 应用启动完成！${RESET}\n"
# ----------------------------- maven >-----------------------------

# ----------------------------- docker <-----------------------------
docker.build: ## $(DOCKER) 构建Docker镜像
	@printf "${BLUE}${DOCKER} 构建Docker镜像 (服务: ${APPNAME}, 版本: ${VERSION})...${RESET}\n"
	sh ${BASE_PATH}/deploy/bin/build.sh ${APPNAME} ${VERSION}
	@printf "${GREEN}${SUCCESS} Docker镜像构建完成！${RESET}\n"

docker.build-skywalking: ## $(SKYWALKING) 构建Docker镜像(带SkyWalking)
	@printf "${BLUE}${SKYWALKING} 构建Docker镜像(带链路追踪) (服务: ${APPNAME}, 版本: ${VERSION})...${RESET}\n"
	sh ${BASE_PATH}/deploy/bin/build-skywalking.sh ${APPNAME} ${VERSION}
	@printf "${GREEN}${SUCCESS} Docker镜像构建完成！${RESET}\n"

docker.run: ## $(DOCKER) 运行Docker容器
	@printf "${BLUE}${DOCKER} 运行Docker容器 (服务: ${APPNAME}, 版本: ${VERSION})...${RESET}\n"
	sh ${BASE_PATH}/deploy/bin/run.sh ${APPNAME} ${VERSION} ${PORT} ${IP}
	@printf "${GREEN}${SUCCESS} Docker容器启动完成！${RESET}\n"

docker.remove: ## 🗑️ 移除Docker容器
	@printf "${RED}🗑️ 移除Docker容器 (服务: ${APPNAME})...${RESET}\n"
	sh ${BASE_PATH}/deploy/bin/remove.sh ${APPNAME}
	@printf "${GREEN}${SUCCESS} Docker容器已移除！${RESET}\n"

docker.all: package ## $(DOCKER) 一键部署所有服务
	@printf "${BLUE}${DOCKER} 一键部署所有微服务...${RESET}\n"
	@printf "${YELLOW}${INFO} 部署网关服务 (8001)...${RESET}\n"
	make docker.build docker.run VERSION=${VERSION} APPNAME=gateway      IP=101.0.0.101 PORT=8001
	@printf "${YELLOW}${INFO} 部署认证服务 (8002)...${RESET}\n"
	make docker.build docker.run VERSION=${VERSION} APPNAME=auth         IP=101.0.0.102 PORT=8002
	@printf "${YELLOW}${INFO} 部署系统服务 (8003)...${RESET}\n"
	make docker.build docker.run VERSION=${VERSION} APPNAME=system       IP=101.0.0.103 PORT=8003
	@printf "${YELLOW}${INFO} 部署文件服务 (8004)...${RESET}\n"
	make docker.build docker.run VERSION=${VERSION} APPNAME=file         IP=101.0.0.104 PORT=8004
	@printf "${YELLOW}${INFO} 部署代码生成服务 (8005)...${RESET}\n"
	make docker.build docker.run VERSION=${VERSION} APPNAME=generator    IP=101.0.0.105 PORT=8005
	@printf "${YELLOW}${INFO} 部署消息服务 (8006)...${RESET}\n"
	make docker.build docker.run VERSION=${VERSION} APPNAME=message      IP=101.0.0.106 PORT=8006
	@printf "${YELLOW}${INFO} 部署服务提供方 (8007)...${RESET}\n"
	make docker.build docker.run VERSION=${VERSION} APPNAME=provider     IP=101.0.0.107 PORT=8007
	@printf "${YELLOW}${INFO} 部署服务消费方 (8008)...${RESET}\n"
	make docker.build docker.run VERSION=${VERSION} APPNAME=consumer     IP=101.0.0.108 PORT=8008
	@printf "${YELLOW}${INFO} 部署监控服务 (8009)...${RESET}\n"
	make docker.build docker.run VERSION=${VERSION} APPNAME=monitor      IP=101.0.0.109 PORT=8009
	@printf "${GREEN}${SUCCESS} 所有服务部署完成！${RESET}\n"

docker.all-skywalking: package ## $(SKYWALKING) 一键部署所有服务(带SkyWalking)
	@printf "${BLUE}${SKYWALKING} 一键部署所有微服务(带链路追踪)...${RESET}\n"
	@printf "${YELLOW}${INFO} 部署网关服务 (8001)...${RESET}\n"
	make docker.build-skywalking docker.run VERSION=${VERSION} APPNAME=gateway    IP=101.0.0.101 PORT=8001
	@printf "${YELLOW}${INFO} 部署认证服务 (8002)...${RESET}\n"
	make docker.build-skywalking docker.run VERSION=${VERSION} APPNAME=auth       IP=101.0.0.102 PORT=8002
	@printf "${YELLOW}${INFO} 部署系统服务 (8003)...${RESET}\n"
	make docker.build-skywalking docker.run VERSION=${VERSION} APPNAME=system     IP=101.0.0.103 PORT=8003
	@printf "${YELLOW}${INFO} 部署文件服务 (8004)...${RESET}\n"
	make docker.build-skywalking docker.run VERSION=${VERSION} APPNAME=file       IP=101.0.0.104 PORT=8004
	@printf "${YELLOW}${INFO} 部署代码生成服务 (8005)...${RESET}\n"
	make docker.build-skywalking docker.run VERSION=${VERSION} APPNAME=generator  IP=101.0.0.105 PORT=8005
	@printf "${YELLOW}${INFO} 部署消息服务 (8006)...${RESET}\n"
	make docker.build-skywalking docker.run VERSION=${VERSION} APPNAME=message    IP=101.0.0.106 PORT=8006
	@printf "${YELLOW}${INFO} 部署服务提供方 (8007)...${RESET}\n"
	make docker.build-skywalking docker.run VERSION=${VERSION} APPNAME=provider   IP=101.0.0.107 PORT=8007
	@printf "${YELLOW}${INFO} 部署服务消费方 (8008)...${RESET}\n"
	make docker.build-skywalking docker.run VERSION=${VERSION} APPNAME=consumer   IP=101.0.0.108 PORT=8008
	@printf "${YELLOW}${INFO} 部署监控服务 (8009)...${RESET}\n"
	make docker.build-skywalking docker.run VERSION=${VERSION} APPNAME=monitor    IP=101.0.0.109 PORT=8009
	@printf "${GREEN}${SUCCESS} 所有服务部署完成！${RESET}\n"
# ----------------------------- docker >-----------------------------
