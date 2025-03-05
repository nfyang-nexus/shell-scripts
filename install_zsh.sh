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

# 安装 zsh
echo "Installing Zsh..."
if [[ "$OS" == *"Ubuntu"* ]]; then
    sudo apt-get install -y zsh curl git
elif [[ "$OS" == *"CentOS"* ]]; then
    sudo yum install -y zsh curl git
fi

# 设置 Zsh 为默认 shell
echo "Setting Zsh as the default shell..."
chsh -s $(which zsh)

# 安装 Oh My Zsh（一个流行的 Zsh 配置框架）
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装插件：zsh-autosuggestions 和 zsh-syntax-highlighting
echo "Installing Zsh plugins..."

# 克隆插件仓库
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 更新 Zsh 配置文件以启用插件
echo "Configuring Zsh plugins..."
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# 刷新 Zsh 配置
source ~/.zshrc

# 提示完成
echo "Zsh and plugins have been installed and configured successfully!"

# 重启 Zsh
echo "Please restart your terminal to start using Zsh with plugins!"
