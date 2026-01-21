#!/bin/bash

ARCH_TYPE=""
OS_TYPE=""

function detect_machine_type ()
{
	local ARCH=$(uname -m)
	case "$ARCH" in
		x86_64)  ARCH_TYPE="x86" ;;
		aarch64) ARCH_TYPE="aarch64" ;;
		*)       ARCH_TYPE="Unknown ($ARCH)" || exit 1 ;;
	esac

	if [ -f /etc/os-release ]; then
		. /etc/os-release
		case "$ID" in
			ubuntu) OS_TYPE="Ubuntu" ;;
			rocky)  OS_TYPE="Rocky" ;;
			*)      OS_TYPE="Unknown ($ID)" ;;
		esac
	else
		OS_TYPE="Unknown"
		exit 1
	fi

	echo "Detection Result:"
	echo "  OS:   $OS_TYPE"
	echo "  Arch: $ARCH_TYPE"

	if [[ "$OS_TYPE" == "Ubuntu" ]]; then
		echo "Installing for Ubuntu..."
	elif [[ "$OS_TYPE" == "Rocky" ]]; then
		echo "Installing for Rocky Linux..."
	fi
}

function ubuntu_package_install ()
{
	sudo apt -y install ripgrep fd-find shellcheck g++ fzf clangd
}

function rocky_package_install ()
{
	sudo dnf install -y ripgrep fd-find shellcheck g++ fzf clang clang-tools-extra
}

function x86_package_install ()
{
	wget https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz
	tar xf nvim-linux-x86_64.tar.gz
	echo 'alias vi="/home/${USER}/workspace/oss/nvim-linux-x86_64/bin/nvim"' >> ~/.bash_aliases
	rm nvim-linux-x86_64.tar.gz
}

function aarch64_package_install ()
{
	wget https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-arm64.tar.gz
	tar xf nvim-linux-arm64.tar.gz
	echo 'alias vi="/home/${USER}/workspace/oss/nvim-linux-arm64/bin/nvim"' >> ~/.bash_aliases
	rm nvim-linux-arm64.tar.gz
}

function main ()
{
	mkdir -p ~/workspace/oss
	cd ~/workspace/oss

	detect_machine_type
	if [[ "$OS_TYPE" == "Ubuntu" ]]; then
		ubuntu_package_install
	elif [[ "$OS_TYPE" == "Rocky" ]]; then
		rocky_package_install
	else
		exit 1
	fi
	if [[ "$ARCH_TYPE" == "x86" ]]; then
		x86_package_install
	elif [[ "$ARCH_TYPE" == "aarch64" ]]; then
		aarch64_package_install
	else
		exit 1
	fi
	echo "package download complete"
	cd -

	mkdir -p ~/.config/nvim
	cp coc-settings.json ~/.config/nvim/
	cp init.lua ~/.config/nvim/
	cp -r lua ~/.config/nvim/

	# cocの設定
	curl -sL install-node.vercel.app/lts | sudo bash
	# 危険なので、ローカル環境にインストールして、パスを追加するように変更
	sudo ln -s /usr/local/bin/node /usr/bin/node

	# tmux環境下でカラースキームを使用するための設定
	echo 'set-option -sa terminal-overrides ",xterm*:Tc"' >> ~/.tmux.conf

	echo "install complete"
}

main

