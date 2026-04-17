# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**mingsha-template-cloud** (鸣沙微服务平台) is a Spring Cloud Alibaba microservices platform forked from RuoYi-Cloud. It provides a complete microservices solution with service governance, flow control, monitoring, APM, logging, MQ, code quality, and CI/CD.

**Stack**: Java 8 · Spring Boot 2.7.18 · Spring Cloud 2021.0.8 · Spring Cloud Alibaba 2021.0.5.0 · Vue.js 2.6 + Element UI

## Build Commands

```bash
# Backend (Maven via Makefile)
make help                  # Show all available targets
make clean                 # Clean build artifacts
make test                  # Run unit tests
make package               # Build all JAR packages
make package APPNAME=gateway SKIP_TEST=true   # Build single service, skip tests

# Frontend
cd mingsha-ui && npm install
npm run dev                # Dev server (port 8000)
npm run build:prod          # Production build
npm run build:stage         # Staging build
npm run lint                # ESLint check

# Docker
make docker.build APPNAME=gateway VERSION=1.0.0   # Build Docker image
make docker.all                                      # Deploy all 9 services
make docker.all-skywalking                          # Deploy with SkyWalking APM
```

## Architecture

```
mingsha-ui (8000) → mingsha-service-gateway (8001) → mingsha-service-{auth,system,file,generator,message,provider,consumer,monitor}
                                    ↓
                         Nacos (registry + config) + Sentinel (flow control)
```

### Module Structure

- **mingsha-common/** — 10 reusable Spring Boot starters (core, security, redis, rocketmq, log, datascope, datasource, swagger, actuator, prometheus)
- **mingsha-facade/** — Feign client interfaces for inter-service calls (file, system, provider)
- **mingsha-service/** — 9 microservice applications:
  - `gateway` (8001) — Routing, JWT auth, CAPTCHA, XSS filter
  - `auth` (8002) — Authentication with Spring Security + JWT + Redis
  - `system` (8003) — User/Role/Menu/Dept management, MyBatis Plus, data scope
  - `file` (8004) — MinIO file storage
  - `generator` (8005) — Code generation via Velocity from DB tables
  - `message` (8006) — RocketMQ producer/consumer
  - `provider` (8007) / `consumer` (8008) — Business service pair
  - `monitor` (8009) — Spring Boot Admin monitoring

### Service Communication

- **Feign** for synchronous inter-service calls; mingsha-facade modules define the client interfaces
- **RocketMQ** for asynchronous messaging (mingsha-common-rocketmq starter)
- **Nacos** for registry (101.0.0.14:8848) and external config — all services share `application-${profile}.yml`

### Auth Flow

Gateway validates JWT token → forwards to Auth service → Auth service validates via Spring Security + Redis

### Frontend

Vue.js 2.6 admin template with RBAC, dynamic routing, Element UI, ECharts, Axios. API base URL defaults to localhost:8001 (gateway).

## Key Conventions

- All service modules depend on `mingsha-common-core` and their corresponding `mingsha-facade-*` client
- Swagger doc at `/swagger-ui/index.html` on each service
- Operation logs via AOP (`mingsha-common-log`)
- Data permission filtering via MyBatis Plus plugin (`mingsha-common-datascope`)
- Prometheus metrics exposed at `/actuator/prometheus`
- SonarQube analysis: `make test-sonarqube` (runs against `sqp_5dea11320be00b624828d5bab974092557debadf@101.0.0.26:9000`)
