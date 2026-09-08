> 🌐 本文档由 [oven-sh/bun](https://github.com/oven-sh/bun) 翻译,英文原版见原项目。
>
> 📝 注:原文超过 10000 字符,本翻译覆盖核心章节;各代码块保持原样。

为 Bun 配置开发环境大约需要 10-30 分钟,具体取决于你的网络和电脑性能。仓库和构建产物大约需要 ~10GB 可用磁盘空间。

如果你使用 Windows,请参阅[这份指南](https://bun.com/docs/project/building-windows)。

## 使用 Nix(可选方案)

我们提供了 Nix flake 作为手动安装依赖的替代方案:

```bash
nix develop
# or explicitly use the pure shell
# nix develop .#pure
export CMAKE_SYSTEM_PROCESSOR=$(uname -m)
bun bd
```

它会在一个隔离、可复现的环境中提供全部依赖,且不需要 sudo。

## 安装依赖(手动)

使用系统包管理器安装 Bun 的依赖:

{% codetabs group="os" %}

```bash#macOS (Homebrew)
$ brew install automake ccache cmake coreutils gnu-sed go icu4c libiconv libtool ninja pkg-config rustup-init ruby
```

```bash#Ubuntu/Debian
$ sudo apt install curl wget lsb-release software-properties-common cmake git golang libtool ninja-build pkg-config ruby-full xz-utils
```

```bash#Arch
$ sudo pacman -S base-devel cmake git go libiconv libtool make ninja pkg-config python rustup sed unzip ruby
```

```bash#Fedora
$ sudo dnf install clang21 llvm21 lld21 cmake git golang libtool ninja-build pkg-config ruby libatomic-static libstdc++-static sed unzip which libicu-devel 'perl(Math::BigInt)'
```

```bash#openSUSE Tumbleweed
$ sudo zypper install go cmake ninja automake git icu rustup
```

{% /codetabs %}

Bun 使用 Rust 编写,需要特定的 nightly 工具链(版本固定在 [`rust-toolchain.toml`](/rust-toolchain.toml) 中)。请通过 [rustup](https://rustup.rs) 安装 Rust,而不要使用发行版自带的 `rust`/`cargo` 包——构建脚本会用 rustup 自动安装并更新固定的 nightly 版本:

```bash
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

开始之前,你需要已经安装了一个正式发布版的 Bun,因为我们使用自己的打包器对代码进行转译和压缩,代码生成脚本也依赖它。

{% codetabs %}

```bash#Native
$ curl -fsSL https://bun.com/install | bash
```

```bash#npm
$ npm install -g bun
```

```bash#Homebrew
$ brew tap oven-sh/bun
$ brew install bun
```

{% /codetabs %}

### 可选:安装 `ccache`

ccache 用于缓存编译产物,能显著加快构建速度:

```bash
# For macOS
$ brew install ccache

# For Ubuntu/Debian
$ sudo apt install ccache

# For Arch
$ sudo pacman -S ccache

# For Fedora
$ sudo dnf install ccache

# For openSUSE
$ sudo zypper install ccache
```

构建脚本会自动检测并使用 `ccache`(如果可用)。可以用 `ccache --show-stats` 查看缓存统计。

## 安装 LLVM

Bun 需要 LLVM 21.1.8(`clang` 是 LLVM 的一部分)。构建系统会强制校验该版本——版本不匹配会导致运行时内存分配失败。多数情况下,你可以通过系统包管理器安装 LLVM:

{% codetabs group="os" %}

```bash#macOS (Homebrew)
$ brew install llvm@21
```

```bash#Ubuntu/Debian
$ # LLVM has an automatic installation script that is compatible with all versions of Ubuntu
$ wget https://apt.llvm.org/llvm.sh -O - | sudo bash -s -- 21 all
```

```bash#Arch
$ sudo pacman -S llvm clang lld
```

```bash#Fedora
$ sudo dnf install llvm clang lld-devel
```

```bash#openSUSE Tumbleweed
$ sudo zypper install clang21 lld21 llvm21
```

{% /codetabs %}

如果以上方案都不适用,则需要[手动安装](https://github.com/llvm/llvm-project/releases/tag/llvmorg-21.1.8)。

确保 Clang/LLVM 21 在你的 PATH 中:

```bash
$ which clang-21
```

如果不在,运行以下命令手动添加:

{% codetabs group="os" %}

```bash#macOS (Homebrew)
# use fish_add_path if you're using fish
# use path+="$(brew --prefix llvm@21)/bin" if you are using zsh
$ export PATH="$(brew --prefix llvm@21)/bin:$PATH"
```

```bash#Arch
# use fish_add_path if you're using fish
$ export PATH="$PATH:/usr/lib/llvm21/bin"
```

{% /codetabs %}

> ⚠️ Ubuntu 发行版(<= 20.04)可能需要单独安装 C++ 标准库。详见下方[故障排查](#span-file-not-found-on-ubuntu)一节。

## 构建 Bun

克隆仓库后,运行以下命令进行构建。这一步可能耗时较长,因为它会克隆子模块并构建依赖。

```bash
$ bun run build
```

构建产物位于 `./build/debug/bun-debug`。建议把它加入 `$PATH`。要验证构建是否成功,打印开发版 Bun 的版本号即可:

```bash
$ build/debug/bun-debug --version
x.y.z_debug
```

## VSCode

VSCode 是开发 Bun 的推荐 IDE,项目已完成相关配置。打开项目后,运行 `Extensions: Show Recommended Extensions` 安装推荐的 Rust 和 C++ 扩展。rust-analyzer 会自动识别工作区 `Cargo.toml`;分析时使用 `rust-toolchain.toml` 中固定的工具链,因此诊断结果与构建一致。

如果你使用其他编辑器,将 rust-analyzer(或编辑器的 Rust 插件)指向仓库根目录即可——Cargo workspace 和 `rust-toolchain.toml` 会被自动发现。

建议把 `./build/debug` 加入 `$PATH`,这样就可以在终端中直接运行 `bun-debug`:

```sh
$ bun-debug
```

## 运行 debug 构建

`bd` 这个 package.json 脚本会编译并运行 Bun 的 debug 构建,只有构建失败时才打印完整的构建输出。

```sh
$ bun bd <args>
$ bun bd test foo.test.ts
$ bun bd ./foo.ts
```

Rust 或 C++ 有改动时,完整的 debug 构建可能需要几分钟;cargo 的增量编译让后续仅 Rust 的重建快得多。如果你的工作流是"改一行、保存、重新构建",仍然会在链接步骤上浪费大量时间。替代做法:

- 攒一批改动再构建
- 用 `cargo check -p <crate>`(或对整个 workspace 用 `bun run rust:check`)对 Rust 改动做类型检查而无需链接。`bun run watch` 会在每次保存时运行 `cargo check`。
- 保持 rust-analyzer 运行以获得内联诊断(如果你用 VSCode 并安装了推荐扩展,开箱即用)
- 优先使用调试器单步调试(VSCode 中为 "CodeLLDB")。
- 使用 debug 日志。`BUN_DEBUG_<scope>=1` 会启用对应 `declare_scope!(<scope>, ...)` / `scoped_log!(<scope>, ...)` 的调试日志。也可以设置 `BUN_DEBUG_QUIET_LOGS=1` 关闭所有未显式启用的调试日志。要把调试日志转储到文件,设置 `BUN_DEBUG=<path-to-file>.log`。release 构建会彻底移除调试日志。
- src/js/\*\*.ts 的改动几乎可以瞬时重建。单 crate 的 Rust 改动和 C++ 改动都是增量的;只有最后的链接无法避免。

## 代码生成脚本

Bun 的构建过程会使用多个代码生成脚本。当特定文件被修改时,它们会自动运行。

主要包括:

- `./src/codegen/generate-jssink.ts` -- 生成 `build/debug/codegen/JSSink.cpp`、`build/debug/codegen/JSSink.h`,实现与 `ReadableStream` 交互的各类类。`FileSink`、`ArrayBufferSink`、`"type": "direct"` 流等与流相关的代码内部都依赖它。
- `./src/codegen/generate-classes.ts` -- 为用 Rust 实现的 JavaScriptCore 类生成 Rust 和 C++ 绑定。我们在 `**/*.classes.ts` 文件中定义各类、方法、原型、getter/setter 的接口,代码生成器读取这些定义,生成在 C++ 中实现 JavaScript 对象并接线到 Rust 的样板代码。
- `./src/codegen/cppbind.ts` -- 扫描 C++ 绑定中标记了导出属性的函数,并为其生成自动的 Rust FFI 包装(`cpp.rs`)。
- `./src/codegen/bundle-modules.ts` -- 把 `node:fs`、`bun:ffi` 等内置模块打包进最终二进制可包含的文件。开发时这些模块无需重建原生代码即可重新加载(仍需运行 `bun run build`,但它之后会从磁盘重新读取转译后的文件)。release 构建则把它们嵌入二进制。
- `./src/codegen/bundle-functions.ts` -- 打包用 JavaScript/TypeScript 实现的全局函数,如 `ReadableStream`、`WritableStream` 等。用法与内置模块类似,但输出更贴近 WebKit/Safari 对其内置函数的处理方式,便于我们直接复制 WebKit 的实现作为起点。

## 修改 ESM 模块

`node:fs`、`node:stream`、`bun:sqlite`、`ws` 等部分模块由 JavaScript 实现。它们位于 `src/js/{node,bun,thirdparty}` 目录,并预先用 Bun 打包。

## Release 构建

编译 release 版 Bun:

```bash
$ bun run build:release
```

构建产物位于 `./build/release/bun` 和 `./build/release/bun-profile`。

### 从 pull request 下载 release 构建

为了节省本地构建 release 版的时间,我们提供了直接运行 PR 中 release 构建的方式,适合在合并前用 release 构建手动验证改动。

可以通过 `bun-pr` npm 包运行某个 PR 的 release 构建:

```sh
bunx bun-pr <pr-number>
bunx bun-pr <branch-name>
bunx bun-pr "https://github.com/oven-sh/bun/pull/1234566"
bunx bun-pr --asan <pr-number> # Linux x64 only
```

它会从 PR 下载 release 构建并以 `bun-${pr-number}` 的名字加入 `$PATH`,然后即可运行:

```sh
bun-1234566 --version
```

其原理是下载对应 PR 的 GitHub Actions 构建产物。你可能需要安装 `gh` CLI 来完成 GitHub 认证。

### 在终端查看 CI 失败

Bun 的 CI 运行在 BuildKite 上。安装 [BuildKite CLI](https://github.com/buildkite/cli)(`brew install buildkite/buildkite/bk`)并把 `BUILDKITE_API_TOKEN` 设为只读权限的 [API token](https://buildkite.com/user/api-access-tokens)。仓库自带 `.bk.yaml`,`bk` 命令默认使用 `bun` pipeline。

```sh
bun run ci:status         # progress summary for the current branch's latest build
bun run ci:errors         # rendered test-failure output, tagged [new] vs [also on main]
bun run ci:logs           # save full logs for each failed job to ./tmp/ci-<build>/
bun run ci:watch          # watch until the build finishes
bun run ci:find           # print the build number (compose with raw `bk`)
```

以上命令均接受目标参数:`#1234`(PR 编号)、PR 链接、分支名或构建编号;不带参数时使用当前 git 分支。

## AddressSanitizer

[AddressSanitizer](https://en.wikipedia.org/wiki/AddressSanitizer) 用于发现内存问题,在 Linux 和 macOS 的 Bun debug 构建中默认开启,覆盖 Rust 代码、C++ 绑定及全部依赖。它会让构建耗时约增加一倍;如果影响效率,可用 `bun run build:debug:noasan` 关闭(或给 `scripts/build.ts` 传 `--asan=off`),但我们一般建议攒批改动再构建。

要构建带 Address Sanitizer 的 release 版,运行:

```bash
$ bun run build:asan
```

CI 中至少有一个测试目标会以 Address Sanitizer 构建运行。

## 本地构建 WebKit + JSC 调试模式

默认不克隆 WebKit(为节省时间和磁盘)。要在本地克隆并构建 WebKit,运行:

```bash
# Clone WebKit into ./vendor/WebKit
$ git clone https://github.com/oven-sh/WebKit vendor/WebKit

# Check out the version pinned in WEBKIT_VERSION in scripts/build/deps/webkit.ts
# (a commit sha or an autobuild-* release tag; this handles both)
$ bun sync-webkit-source

# Build bun with the local JSC build — this automatically configures and builds JSC
$ bun run build:local
```

`bun run build:local` 会包办一切:配置 JSC、构建 JSC、构建 Bun。后续运行时,若 WebKit 源码有变动,JSC 会增量重建。首次构建之后 `ninja -Cbuild/debug-local` 也可用,会同时构建 Bun 和 JSC。

构建输出在 `./build/debug-local`(而非 `./build/debug`),因此需要调整几处:

- [`src/js/builtins.d.ts`](/src/js/builtins.d.ts) 的第一行
- [`.clangd` 配置](/.clangd)中的 `CompilationDatabase` 行应改为 `CompilationDatabase: build/debug-local`
- [`.vscode/launch.json`](/.vscode/launch.json) 中许多配置使用 `./build/debug/`,按需修改

注意 WebKit 目录(含构建产物)体积超过 8GB。

如果你使用 JSC debug 构建且用 VSCode,请运行 `C/C++: Select a Configuration` 命令,让智能感知找到 debug 头文件。

注意:如果你修改了我们的 [WebKit fork](https://github.com/oven-sh/WebKit),还需把 [`scripts/build/deps/webkit.ts`](/scripts/build/deps/webkit.ts) 中的 `WEBKIT_VERSION` 改为指向你的 commit hash 或 release tag。

## 故障排查

### Ubuntu 上找不到 'span' 文件

> ⚠️ 请注意,以下说明仅针对 Ubuntu 上出现的问题,其他 Linux 发行版一般不会遇到。

Clang 编译器默认通常使用 `libstdc++` C++ 标准库。`libstdc++` 是 GNU 编译器套件(GCC)提供的默认 C++ 标准库实现。Clang 也可以链接 `libc++` 库,但需要在运行 Clang 时显式指定 `-stdlib` 参数。

Bun 依赖 `std::span` 等 C++20 特性,而 GCC 11 以下版本不支持。GCC 10 没有实现全部 C++20 特性,因此运行 `make setup` 可能报以下错误:

```
fatal error: 'span' file not found
#include <span>
         ^~~~~~
```

初次运行 `bun setup` 时,问题可能表现为 Clang 无法编译一个简单程序:

```
The C++ compiler

  "/usr/bin/clang++-21"

is not able to compile a simple test program.
```

要修复,需要把 GCC 升级到 11。先检查发行版官方仓库是否提供最新版,或使用提供 GCC 11 包的第三方仓库。通用步骤如下:

```bash
$ sudo apt update
$ sudo apt install gcc-11 g++-11
# If the above command fails with `Unable to locate package gcc-11` we need
# to add the APT repository
$ sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
# Now run `apt install` again
$ sudo apt install gcc-11 g++-11
```

然后把 GCC 11 设为默认编译器:

```bash
$ sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
$ sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100
```

### libarchive

如果在 macOS 上编译 `libarchive` 报错,运行:

```bash
$ brew install pkg-config
```

### macOS `library not found for -lSystem`

编译时若出现此错误,运行:

```bash
$ xcode-select --install
```

### 找不到 `libatomic.a`

Bun 默认静态链接 `libatomic`,因为并非所有系统都有它。如果你的发行版没有静态 libatomic,可运行以下命令启用动态链接:

```bash
$ bun run build -DUSE_STATIC_LIBATOMIC=OFF
```

以此方式编译出的 Bun 可能无法在其他系统上运行。

## 使用 bun-debug

- 关闭日志:`BUN_DEBUG_QUIET_LOGS=1 bun-debug ...`(关闭所有调试日志)
- 启用特定作用域日志:`BUN_DEBUG_EventLoop=1 bun-debug ...`(启用 `scoped_log!(EventLoop, ...)` 输出)
- Bun 会转译它运行的每个文件;要在 debug 构建中查看实际执行的源码,可在 `/tmp/bun-debug-src/...path/to/file` 找到,例如 `/home/bun/index.ts` 转译后的版本位于 `/tmp/bun-debug-src/home/bun/index.ts`
