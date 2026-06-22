# 🚀 Dotfiles Setup

A minimal, reproducible, and modular development environment setup for Linux/macOS.

---

## ⚡ Quick Start

```bash
git clone https://github.com/youkipepper/dotfiles.git
## or, when using the GitHub proxy
git clone https://gh-proxy.org/https://github.com/youkipepper/dotfiles.git

cd dotfiles
bash setup.sh
# Use proxy URLs when installing Zsh plugins:
bash setup.sh --proxy
```

💡 Recommended: run on a fresh system or test VM first

---

📦 What this setup does

This repository automatically configures your development environment in a reproducible way.

---

🔧 System Configuration

📁 Dotfiles management

Configurations under `.config/` are symlinked into `~/.config/`:
- fastfetch
- ghostty
- kitty
- lsd
- nvim
- wezterm

The script also links the Zsh and Bash configuration when the destination does not contain a regular file.

---

🐚 Shell Environment (Zsh)

Automatically configures:
- Links `~/.zshrc`
- Sets Zsh as the default login shell
- Installs plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
- Initializes Starship only when it is installed

---

🔗 Symlink Behavior (Important)

This setup is non-destructive by default.

Case	Behavior
File does not exist	✅ Create symlink
Already a symlink	🔄 Update to new target
Regular file exists	⚠️ Skip and show warning

Example output:

```bash
⚠️ skip ~/.zshrc (exists and is not a symlink)
```

---

📁 Expected Directory Structure

```bash
dotfiles/
├── .config/
├── bash/
├── gnome/
├── pkg/
├── source/
├── setup.sh
├── tools/
└── zsh/
```

`gnome/extensions.list` records preferred GNOME Shell extensions without installing or restoring them automatically.

---

⚙️ Requirements

Before running:
- git
- bash
- zsh
- Internet connection

Optional:
- starship
- lsd
- fastfetch

Install package groups on macOS, Ubuntu, Fedora, or Arch Linux:

```bash
bash pkg/install.sh cli
bash pkg/install.sh gui
bash pkg/install.sh all
```

Packages without a configured source for the current platform are skipped.

---

⚠️ Safety Notes
- This script will NOT overwrite existing files
- It will only create symlinks or skip safely
- Always review the script before running from unknown sources

---

🧠 Design Philosophy
- Reproducible environment
- No destructive operations
- Modular and easy to extend
- Works across machines

---

🚀 Example Output

```bash
✔ zsh configured
✔ kitty linked
⚠️ skip ~/.zshrc (already exists)
✔ setup complete
```

---

🔗 Proxy Projects
- [clash-for-linux-install](https://github.com/nelvko/clash-for-linux-install?tab=readme-ov-file)
- [clash-verge-rev](https://github.com/clash-verge-rev/clash-verge-rev)

```bash
## clash-for-linux-install
git clone --branch master --depth 1 https://github.com/nelvko/clash-for-linux-install.git \
  && cd clash-for-linux-install \
  && bash install.sh

## clash-verge-rev
wget https://ghproxy.com/https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v2.4.7/Clash.Verge_2.4.7_arm64.deb
```

---

🔧 Tools 

```bash
## Install selected fonts
bash tools/font.sh
bash tools/font.sh --proxy

## Configure Raspberry Pi OS sources
curl -fsSL "https://gh-proxy.org/https://raw.githubusercontent.com/youkipepper/dotfiles/main/source/RaspberryPiOS.sh?$(date +%s)" | sudo bash
```
