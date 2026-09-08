# 中文注释:本文件由 [oven-sh/bun](https://github.com/oven-sh/bun) 汉化注释,原版见原项目。
# Simple shell.nix for users without flakes enabled
# For reproducible builds with locked dependencies, use: nix develop
# This uses unpinned <nixpkgs> for simplicity; flake.nix provides version pinning via flake.lock
# 中文说明:这是给未启用 flakes 的用户准备的简易 shell.nix。
# 需要锁定依赖的可复现构建,请使用 `nix develop`(flake.nix + flake.lock 提供版本固定)。
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell rec {
  packages = with pkgs; [
    # Core build tools (matching bootstrap.sh)
    # 中文注释:核心构建工具(与 bootstrap.sh 保持一致)
    cmake
    ninja
    clang_21
    llvm_21
    lld_21
    nodejs_24
    bun
    rustc
    cargo
    go
    python3
    ccache
    pkg-config
    gnumake
    libtool
    ruby
    perl

    # Libraries
    # 中文注释:依赖库
    openssl
    zlib
    libxml2

    # Development tools
    # 中文注释:开发工具
    git
    curl
    wget
    unzip
    xz

    # Linux-specific: gdb and Chromium deps for testing
    # 中文注释:Linux 专属——gdb 及运行测试所需的 Chromium 依赖
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    gdb
    # Chromium dependencies for Puppeteer tests
    # 中文注释:Puppeteer 测试所需的 Chromium 运行依赖
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    libxkbcommon
    mesa
    nspr
    nss
    cups
    dbus
    expat
    fontconfig
    freetype
    glib
    gtk3
    pango
    cairo
    alsa-lib
    at-spi2-atk
    at-spi2-core
    libgbm
    liberation_ttf
    atk
    libdrm
    xorg.libxshmfence
    gdk-pixbuf
  ];

  # 中文注释:进入 shell 时注入的环境变量:
  # 统一使用 LLVM/Clang 21 作为 C/C++ 编译器、ar、ranlib,
  # 并同步写入 CMake 变量;CMAKE_SYSTEM_PROCESSOR 按宿主架构设置。
  shellHook = ''
    export CC="${pkgs.lib.getExe pkgs.clang_21}"
    export CXX="${pkgs.lib.getExe' pkgs.clang_21 "clang++"}"
    export AR="${pkgs.llvm_21}/bin/llvm-ar"
    export RANLIB="${pkgs.llvm_21}/bin/llvm-ranlib"
    export CMAKE_C_COMPILER="$CC"
    export CMAKE_CXX_COMPILER="$CXX"
    export CMAKE_AR="$AR"
    export CMAKE_RANLIB="$RANLIB"
    export CMAKE_SYSTEM_PROCESSOR=$(uname -m)
    export TMPDIR=''${TMPDIR:-/tmp}
  '' + pkgs.lib.optionalString pkgs.stdenv.isLinux ''
    # 中文注释:仅 Linux——强制使用 lld 链接器,并把依赖库路径加入 LD_LIBRARY_PATH
    export LD="${pkgs.lib.getExe' pkgs.lld_21 "ld.lld"}"
    export NIX_CFLAGS_LINK="''${NIX_CFLAGS_LINK:+$NIX_CFLAGS_LINK }-fuse-ld=lld"
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath packages}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '' + ''

    echo "====================================="
    echo "Bun Development Environment (Nix)"
    echo "====================================="
    echo "To build: bun bd"
    echo "To test:  bun bd test <test-file>"
    echo "====================================="
  '';
}
