#!/bin/bash

# ubuntu20.04はfzfが古いので、githubから直接バイナリを持ってこないといけない
# ubuntu20.04であればclangdが古いので、apt install clangd-12として、clangdへのシンボリックリンクを作る
sudo apt -y install ripgrep fd-find shellcheck g++ fzf clangd

mkdir -p ~/workspace/oss
cd ~/workspace/oss
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
tar xf nvim-linux64.tar.gz
echo 'alias vi="/home/${USER}/workspace/oss/nvim-linux64/bin/nvim"' >> ~/.bash_aliases
rm nvim-linux64.tar.gz

mkdir -p ~/.config/nvim
cp coc-settings.json ~/.config/nvim/
cp init.lua ~/.config/nvim/
cp -r lua ~/.config/nvim/

# cocの設定
curl -sL install-node.vercel.app/lts | sudo bash
# 危険なので、ローカル環境にインストールして、パスを追加するように変更
sudo ln -s /usr/local/bin/node /usr/bin/node

# nvim開いて、:CocInstall coc-clangd

# coc-bashに必要なプラグイン
sudo snap install bash-language-server --classic

# coc-pyrightの設定
# nvim開いて、:CocInstall coc-pyright

# tmux環境下でカラースキームを使用するための設定
echo 'set-option -sa terminal-overrides ",xterm*:Tc"' >> ~/.tmux.conf

