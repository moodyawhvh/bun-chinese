<div align="center">

# bun 中文翻译版

**[中文版] bun — 速度极快的 JavaScript 运行时、打包器、测试运行器与包管理器**

[![原项目](https://img.shields.io/badge/原项目-oven-sh--bun-blue?style=flat-square&logo=github)](https://github.com/oven-sh/bun)
[![中文文档](https://img.shields.io/badge/中文文档-README.zh--CN.md-orange?style=flat-square)](README.zh-CN.md)
[![GitHub Stars](https://img.shields.io/github/stars/oven-sh/bun?style=flat-square&label=原项目Stars)](https://github.com/oven-sh/bun/stargazers)
[![微信联系](https://img.shields.io/badge/微信-uaycar-brightgreen?style=flat-square&logo=wechat)](#)

</div>

---

> 这是 [oven-sh/bun](https://github.com/oven-sh/bun) 的中文翻译版本。
> 完整源代码请访问原项目:https://github.com/oven-sh/bun

**代部署 / 定制服务 / 技术咨询 请添加微信:uaycar**

---

## 📖 项目简介

Bun 是一套面向 JavaScript 和 TypeScript 应用的全家桶式工具链,整个工具以单个可执行文件 `bun` 的形式发布。它的核心是 Bun 运行时——一个以 Rust 编写、底层采用 JavaScriptCore 引擎的高速 JavaScript 运行时,定位为 Node.js 的即插即用替代品,能大幅降低启动时间和内存占用。除了运行时,`bun` 命令行还内置了测试运行器、脚本运行器和兼容 Node.js 的包管理器,一个 `bun` 就能取代开发中常见的上千个依赖工具组合。

## ✨ 主要特性

- **极速运行时**:基于 JavaScriptCore 引擎与 Rust 实现,启动速度和内存占用远低于传统方案。
- **Node.js 即插即用替代**:兼容 Node.js 生态,现有项目几乎无需改动即可迁移。
- **开箱即用的 TS/JSX**:TypeScript 与 JSX 无需任何配置,直接运行。
- **内置测试运行器**:`bun test` 提供与 Jest 兼容的 API,速度极快。
- **内置打包器**:高速打包 JavaScript 与 TypeScript 项目,支持代码分割等能力。
- **兼容 Node.js 的包管理器**:`bun install` 安装依赖速度显著领先,支持 lockfile 与 workspaces。
- **`bunx` 直接执行包**:无需全局安装即可运行 npm 包中的可执行文件。
- **脚本运行器**:替代 `npm run` / `yarn run`,执行 `package.json` 中的脚本更快。
- **单可执行文件**:一个 `bun` 覆盖运行、测试、打包、装包全流程,告别工具链拼装。
- **全平台支持**:Linux(x64 & arm64)、macOS(x64 & Apple Silicon)、Windows(x64 & arm64)。

## 📁 文件说明

| 文件 | 说明 |
|:-----|:-----|
| README.md | 本文件(中文简介) |
| README.zh-CN.md | 详细中文文档(完整汉化) |

## 🚀 快速开始

1. 安装 Bun(Linux / macOS 推荐脚本安装):

```sh
curl -fsSL https://bun.com/install | bash
```

2. Windows 下用 PowerShell 安装:

```sh
powershell -c "irm bun.sh/install.ps1 | iex"
```

3. 也可以通过 npm 或 Homebrew 安装:

```sh
npm install -g bun
# 或
brew tap oven-sh/bun
brew install bun
```

4. Docker 用户直接拉取镜像:

```sh
docker pull oven/bun
```

5. 初始化一个新项目:

```sh
bun init
```

6. 运行 TypeScript / JSX 文件,无需任何配置:

```sh
bun run index.tsx
```

7. 安装依赖并执行包:

```sh
bun install <pkg>
bunx cowsay 'Hello, world!'
```

8. 运行测试与升级版本:

```sh
bun test
bun upgrade
```

完整源代码与最新版本请访问原项目:https://github.com/oven-sh/bun

## 📞 联系方式

**代部署 / 定制服务 / 技术咨询 请添加微信:uaycar**

---

本项目为 [oven-sh/bun](https://github.com/oven-sh/bun) 的中文翻译版本,所有代码版权归原项目作者所有,遵循其原始许可证。

**如果觉得有用,请给原项目点个 Star!** ⭐
