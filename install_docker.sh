#!/bin/bash

# 获取当前系统版本
OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')

# 安装 Docker 函数
install_docker_ubuntu() {
    echo "安装 Docker for Ubuntu 系统..."

    # 卸载旧版本 Docker
    sudo apt-get remove -y docker docker-engine docker.io containerd runc

    # 更新 apt 包索引
    sudo apt-get update

    # 安装依赖
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # 添加 Docker 官方 GPG 密钥
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # 添加 Docker 仓库
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # 更新包索引并安装 Docker
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # 启动 Docker 并设置开机自启
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $USER
    newgrp docker
    # 检查 Docker 版本
    docker --version

    echo "Docker 安装完成！"
}

install_docker_centos() {
    echo "安装 Docker for CentOS 系统..."

    # 卸载旧版本 Docker
    sudo yum remove -y docker docker-common docker-selinux docker-engine-selinux docker-engine

    # 安装依赖包
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2

    # 设置 Docker 官方仓库
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # 安装 Docker
    sudo yum install -y docker-ce docker-ce-cli containerd.io

    # 启动 Docker 并设置开机自启
    sudo systemctl enable docker
    sudo systemctl start docker

    # 检查 Docker 版本
    docker --version

    echo "Docker 安装完成！"
}

# 判断系统类型并执行相应操作
if [[ "$OS" == *"Ubuntu"* ]]; then
    install_docker_ubuntu
elif [[ "$OS" == *"CentOS"* ]]; then
    install_docker_centos
else
    echo "当前系统不支持自动安装 Docker。只支持 Ubuntu 和 CentOS。"
    exit 1
fi

# 测试 Docker 是否安装成功
docker run hello-world
