# 🚀 Dotfiles Setup

A minimal, reproducible, and modular development environment setup for Linux/macOS.

---

## ⚡ Quick Start

```bash
git clone https://github.com/yourname/dotfiles.git
cd dotfiles
bash setup.sh
```

💡 Recommended: run on a fresh system or test VM first

---

📦 What this setup does

This repository automatically configures your development environment in a reproducible way.

---

🔧 System Configuration

📁 Dotfiles management

All configs are symlinked into ~/.config/:
- nvim → Neovim configuration
- kitty → Terminal emulator config
- btop → System monitor config
- ghostty → Terminal config
- zsh → Shell configuration
- and more…

---

🐚 Shell Environment (Zsh)

Automatically configures:
- Installs Oh My Zsh (if missing)
- Sets up:
  - ~/.zshrc
  - ~/.zprofile
- Installs plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting

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
├── setup.sh
├── zsh/
├── nvim/
├── kitty/
├── btop/
└── ghostty/
```

---

⚙️ Requirements

Before running:
- git
- bash
- Internet connection

Optional (auto-installed if missing):
- zsh
- curl

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