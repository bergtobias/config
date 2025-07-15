#!/bin/bash
set -e

echo "🚀 Provisioning Ubuntu environment..."
sudo -v

echo "🔄 Updating package list..."
sudo apt-get update -qq

if command -v docker >/dev/null 2>&1; then
  echo "✅ Docker already installed, skipping."
else
  echo "🔀 Installing Docker..."
  sudo apt-get install -y docker.io > /dev/null
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
fi

if ! command -v jq &> /dev/null; then
  echo "jq not found. Installing jq..."
  sudo apt-get update
  sudo apt-get install -y jq
fi

echo "🔀 Installing Zsh, fonts, curl, git..."
sudo apt-get install -y zsh fonts-powerline curl git > /dev/null

if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "✅ Oh My Zsh already installed, skipping."
else
  echo "🔀 Installing Oh My Zsh..."
  export RUNZSH=no
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null
fi

THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$THEME_DIR" ]; then
  echo "✅ Powerlevel10k theme already installed, skipping."
else
  echo "🔀 Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR" > /dev/null
fi

echo "🔧 Disabling Powerlevel10k config wizard..."
grep -qxF 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' ~/.zshrc || \
  echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >> ~/.zshrc

echo "🔧 Setting Powerlevel10k as ZSH_THEME..."
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

echo "🔄 Changing default shell to zsh for user $USER..."
sudo chsh -s "$(which zsh)" "$USER"



echo "📄 Appending custom .zshrc settings..."
cat ./.zshrc >> ~/.zshrc


echo "📄 Appending custom .gitconfig settings..."
if [ -f ~/.gitconfig ]; then
  cat ./.gitconfig >> ~/.gitconfig
else
  cp ./.gitconfig ~/.gitconfig
fi

 

echo "🎉 Setup complete!"
