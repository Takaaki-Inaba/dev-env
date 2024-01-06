#!/bin/bash

sudo apt install ripgrep clangd fd-find shellcheck g++
mkdir -p ~/workspace/oss
cd ~/workspace/oss
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
tar xf nvim-linux64.tar.gz
echo 'alias vi="/home/${USER}/workspace/oss/nvim-linux64/bin/nvim"' >> ~/.bash_aliases
rm nvim-linux64.tar.gz

mkdir -p ~/.config/nvim
git clone https://github.com/Takaaki-Inaba/dev-env.git
cp dev-env/coc-settings.json ~/.config/nvim/
cp dev-env/init.lua ~/.config/nvim/
cp -r dev-env/lua ~/.config/nvim/


# cocの設定
sudo curl -sL install-node.vercel.app/lts | bash
# 危険なので、ローカル環境にインストールして、パスを追加するように変更
sudo ln -s /usr/local/bin/node /usr/bin/node

# nvim開いて、:CocInstall coc-clangd

# coc-bashに必要なプラグイン
sudo snap install bash-language-server --classic

# coc-pyrightの設定

