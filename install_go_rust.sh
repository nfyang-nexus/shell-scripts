#!/bin/bash

# 获取操作系统类型
OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')

# 更新系统
echo "Updating the system..."
if [[ "$OS" == *"Ubuntu"* ]]; then
    sudo apt-get update -y
    sudo apt-get upgrade -y
elif [[ "$OS" == *"CentOS"* ]]; then
    sudo yum update -y
fi

# 安装 Go
echo "Installing Go..."
if [[ "$OS" == *"Ubuntu"* ]]; then
    sudo apt-get install -y golang curl git
elif [[ "$OS" == *"CentOS"* ]]; then
    sudo yum install -y golang curl git
fi

# 配置 Go 国内镜像源
echo "Configuring Go domestic mirrors..."
echo "export GOPROXY=https://goproxy.cn,direct" >> ~/.env

# 安装 Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 配置 Rust 国内镜像源
echo "Configuring Rust domestic mirrors..."
echo '[source.crates-io]' >> ~/.env
echo 'replace-with = "rustic"' >> ~/.env
echo '[source.rustic]' >> ~/.env
echo 'registry = "https://mirrors.ustc.edu.cn/crates.io-index"' >> ~/.env

# 处理 Shell 配置文件，添加 source ~/.env
SHELL_CONFIG="~/.bashrc"
if [[ -n "$ZSH_VERSION" ]]; then
    SHELL_CONFIG="~/.zshrc"
fi

# 将 source ~/.env 添加到 ~/.bashrc 或 ~/.zshrc 中
if ! grep -q "source ~/.env" "$SHELL_CONFIG"; then
    echo "source ~/.env" >> "$SHELL_CONFIG"
fi

# 刷新环境配置
source ~/.env

# 提示完成
echo "Go and Rust installation and mirror configuration complete!"
echo "Environment variables have been added to ~/.env and sourced in your shell configuration."

# 测试 Go 和 Rust 是否安装成功
echo "Testing Go installation..."
go version
echo "Testing Rust installation..."
rustc --version

# 重新加载配置以使更改生效
source "$SHELL_CONFIG"
