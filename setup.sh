#!/bin/bash
ZELLIJ_VERSION=0.39.2
# Install base stuff
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source /etc/os-release

if [[ $ID == "arch" ]]; then
  echo "Detected Arch"
  sudo pacman -Syu
  sudo pacman -S --needed base-devel git wget curl
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  paru -S zsh go python python-pip pipx jdtls markdown-oxide-git taplo-cli lldb zellij helix ansible terraform terraform-ls
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
elif [[ $ID == "debian" || $ID_LIKE == "debian" ]]; then
  echo "Detected Debian"
  sudo apt update && sudo apt dist-upgrade
  sudo apt install -y go python3 python3-dev pipx git wget curl gpg zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/nils/.zshrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update
  sudo apt install terraform terraform-ls
  pipx install --include-deps ansible
  wget https://github.com/zellij-org/zellij/releases/download/v$ZELLIJ_VERSION/zellij-x86_64-unknown-linux-musl.tar.gz
  tar -xvf zellij*.tar.gz
  chmod +x zellij
  sudo mv zellij /usr/bin/
  git clone https://github.com/helix-editor/helix
  cd helix
  cargo install --path helix-term --locked
  hx --grammar fetch
  hx --grammar build
  rm ~/.config/helix/runtime
  ln -Ts $PWD/helix/runtime ~/.config/helix/runtime
  cargo install --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide
  brew install jdtls
  cargo install taplo-cli --locked --features lsp 
else
  echo "Could not reliably determine distribution, some features will be missing"
fi

# Install Geist Mono font
cd ~/
wget https://github.com/vercel/geist-font/releases/download/1.1.0/Geist.Mono.zip
tar -xvf Geist.Mono.zip

# Install Go stuff
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Install Bun runtime
curl -fsSL https://bun.sh/install | bash

# Install Deno as JS / TS LSP
curl -fsSL https://deno.land/install.sh | sh

# Install Node based LSP
bun i -g @ansible/ansible-language-server \
         "awk-language-server@>=0.5.2" \
         bash-language-server \
         vscode-langservers-extracted \
         dockerfile-language-server-nodejs \
         graphql-language-service-cli \
         sql-language-server \
         @prisma/language-server \
         pyright \
         svelte-language-server \
         typescript-svelte-plugin \
         @tailwindcss/language-server \
         typescript \
         typescript-language-server \
         yaml-language-server@next

# Rust
rustup component add rust-analyzer

# Elixir
curl -fLO https://github.com/elixir-lsp/elixir-ls/releases/latest/download/elixir-ls.zip

# Install Python stuff
pipx install ruff-lsp black sqlparse
pipx ensurepath 
pipx completions
autoload -U bashcompinit 
bashcompinit 
eval "$(register-python-argcomplete pipx)"
