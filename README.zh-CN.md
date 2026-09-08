# bun 中文文档

[![原项目](https://img.shields.io/badge/原项目-oven-sh--bun-blue?style=flat-square&logo=github)](https://github.com/oven-sh/bun)
[![README](https://img.shields.io/badge/返回-README.md-green?style=flat-square)](README.md)
[![微信联系](https://img.shields.io/badge/微信-uaycar-brightgreen?style=flat-square&logo=wechat)](#)

> 本文是 [oven-sh/bun](https://github.com/oven-sh/bun) 官方 README 的中文汉化文档。
> 代部署 / 定制服务 / 技术咨询 请添加微信:**uaycar**

## Bun 是什么?

Bun 是一套面向 JavaScript 与 TypeScript 应用的一体化工具箱,以单个名为 `bun` 的可执行文件发布。

它的核心是 **Bun 运行时**——一个专为取代 Node.js 而设计的高速 JavaScript 运行时。Bun 使用 Rust 编写,底层由 JavaScriptCore 引擎驱动,显著降低了启动时间与内存占用。

```bash
bun run index.tsx             # 原生支持 TS 和 JSX,零配置
```

`bun` 命令行工具同时还是一个测试运行器、脚本运行器和 Node.js 兼容的包管理器。开发时不再需要上千个 node_modules 工具组合,只需要一个 `bun`。Bun 内置工具的速度远超现有方案,并且几乎不用改动就能用于现有 Node.js 项目。

```bash
bun test                      # 运行测试
bun run start                 # 运行 package.json 中的 start 脚本
bun install <pkg>             # 安装依赖包
bunx cowsay 'Hello, world!'   # 直接执行一个包
```

## 安装

Bun 支持 Linux(x64 & arm64)、macOS(x64 & Apple Silicon)和 Windows(x64 & arm64)。

> **Linux 用户**:强烈建议内核版本 5.6 及以上,最低要求 5.1。

> **x64 用户**:如果遇到 "illegal instruction" 或类似错误,请查阅原项目的 CPU 要求说明。

```sh
# 官方安装脚本(推荐)
curl -fsSL https://bun.com/install | bash

# Windows 下安装
powershell -c "irm bun.sh/install.ps1 | iex"

# 通过 npm 安装
npm install -g bun

# 通过 Homebrew 安装
brew tap oven-sh/bun
brew install bun

# 通过 Docker 安装
docker pull oven/bun
docker run --rm --init --ulimit memlock=-1:-1 oven/bun
```

### 升级

升级到最新版本的 Bun:

```sh
bun upgrade
```

Bun 在每次提交到 `main` 分支时都会自动发布 canary 构建,升级到最新 canary 版本:

```sh
bun upgrade --canary
```

## 快速上手

```bash
bun init                      # 初始化新项目
bun run index.tsx             # 直接运行 TS/JSX
bun install                   # 安装项目依赖
bun add <pkg>                 # 添加依赖
bun remove <pkg>              # 移除依赖
bun test                      # 运行测试
bun build ./entry.ts          # 打包项目
```

更多文档(Docs、Discord、Roadmap 等)请访问原项目:https://github.com/oven-sh/bun

---

本项目为 [oven-sh/bun](https://github.com/oven-sh/bun) 的中文翻译版本,版权归原作者所有,遵循其原始许可证。

**代部署 / 定制服务 / 技术咨询 请添加微信:uaycar**

**如果觉得有用,请给原项目点个 Star!** ⭐
