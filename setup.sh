#!/bin/bash
ZELLIJ_VERSION=0.39.2

# Install base stuff
sudo apt update && sudo apt dist-upgrade
sudo apt install -y apt-transport-https go python3 python3-dev pipx git wget curl gpg zsh yank btop jq pgcli neofetch lsd

# Install kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /usr/share/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/kubernetes.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Install Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg >/dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# Install Linux brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/nils/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install jdtls
brew install xo/xo/usql
brew install k9s
brew install jesseduffield/lazydocker/lazydocker
brew tap yakitrak/yakitrak
brew install yakitrak/yakitrak/obs
brew install kdabir/tap/has
brew install ffsend
brew install jesseduffield/lazygit/lazygit

# Install Tilt
curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo groupadd docker
sudo usermod -aG docker $USER

# Install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Terraform stuff
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform terraform-ls

# Install zellij
wget https://github.com/zellij-org/zellij/releases/download/v$ZELLIJ_VERSION/zellij-x86_64-unknown-linux-musl.tar.gz
tar -xvf zellij*.tar.gz
chmod +x zellij
sudo mv zellij /usr/bin/

# Install Helix editor
git clone https://github.com/helix-editor/helix
cd helix
cargo install --path helix-term --locked
rm -r ~/.config/helix/runtime
cd ~/.config/helix
hx --grammar fetch
hx --grammar build

# Install Geist Mono font
cd ~/
wget https://github.com/vercel/geist-font/releases/download/1.1.0/Geist.Mono.zip
tar -xvf Geist.Mono.zip
mkdir -p .local/share/fonts
mv Geist.Mono/*.otf .local/share/fonts

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
	yaml-language-server@next \
	undollar \
	iola \
	git-lab-cli

# Rust
rustup component add rust-analyzer
cargo install --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide
cargo install taplo-cli --locked --features lsp

# Elixir
# curl -fLO https://github.com/elixir-lsp/elixir-ls/releases/latest/download/elixir-ls.zip

# Install Python stuff
pipx install ruff-lsp
pipx install black
pipx install sqlparse
pipx install --include-deps ansible
pipx install yq
pipx install iredis
pipx ensurepath
pipx completions
autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"
