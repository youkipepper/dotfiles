# 🚀 Dotfiles Setup

A minimal and reproducible development environment setup.

---

## 📦 What this script does

### 🔧 Configuration

- Symlinks all configs from `~/.config/`, including:
  - `nvim`
  - `kitty`
  - `btop`
  - `fish`
  - `ghostty`
  - and others

- Sets up shell configuration:
  - `~/.zshrc`
  - `~/.zprofile`

---

### 🐚 Zsh Environment

- Installs **Oh My Zsh**
- Installs plugins:
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`

---

### 🔗 Symlink Behavior

This script **does NOT overwrite existing files by default**.

| Case | Behavior |
|------|--------|
| File does not exist | ✅ Create symlink |
| Already a symlink | 🔄 Update symlink |
| Regular file exists | ⚠️ Skip and warn |

Example:

```bash
⚠️ skip ~/.zshrc (exists and not symlink)