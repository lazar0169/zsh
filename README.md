# Zsh + JetBrains Mono Nerd Font Setup

A simple guide and configuration reference for setting up a modern Zsh environment with syntax highlighting, autosuggestions, and consistent JetBrains Mono Nerd Font visuals across your terminal and VS Code.

---

## ⚙️ What This Setup Includes

This setup gives you:

- **Zsh** as your default shell  
- **Oh My Zsh** for shell management  
- **Syntax highlighting** (`zsh-syntax-highlighting`)  
- **Autosuggestions** (`zsh-autosuggestions`)  
- **JetBrains Mono Nerd Font** for clean icons and ligatures  
- A **minimal theme** (`agnoster` or Powerlevel10k if you prefer later)  

---

## 🧩 Font Configuration for VS Code

Make sure this is set up correctly:
```json
{
  "terminal.integrated.fontFamily": "JetBrains Mono Nerd Font",
  "editor.fontFamily": "JetBrains Mono NL, SF Mono, Menlo, Monaco, 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 14,
  "terminal.integrated.fontSize": 13
}
```

