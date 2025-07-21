# My Personal Dotfiles

This repository contains my personal configuration files (dotfiles) for various tools I use in my development environment.

## Tools Configured

This setup includes configurations for:

- **[Neovim (AstroNvim)](https://astronvim.com/):** A highly customized Neovim setup based on the AstroNvim distribution. Includes LSP support, completion, theming (Catppuccin, Astrotheme), and various plugins managed by `lazy.nvim`.
- **[Hyprland](https://hyprland.org/):** A dynamic tiling Wayland compositor with custom themes (including Wallbash integration), animations, keybindings, and window rules. Managed with HyDE.
- **[Tmux](https://github.com/tmux/tmux/wiki):** Using the [Oh My Tmux!](https://github.com/gpakosz/.tmux) configuration framework for enhanced terminal multiplexing.
- **[Lazygit](https://github.com/jesseduffield/lazygit):** Custom commands integrated, potentially leveraging AI for commit message generation (`lumen draft`).

## Installation

1.  **Backup:** Before proceeding, back up your existing configuration files (e.g., `~/.config/nvim`, `~/.config/hypr`, `~/.tmux.conf`, etc.).
2.  **Clone:** Clone this repository to your desired location. A common practice is to clone it to `~/.dotfiles` or directly into `~/.config`.
    ```bash
    git clone https://github.com/Yorizel/dotfiles.git ~/.config
    ```
3.  **Dependencies:** Ensure you have the necessary base tools installed (e.g., `neovim`, `hyprland`, `tmux`, `git`, `lazygit`, `stow` if used, Nerd Fonts). Specific plugin managers or dependencies (like `mason-tool-installer` for Neovim) might install further requirements automatically upon first run.

## Key Features

- **AstroNvim:** Modern Neovim setup with extensive plugin support, LSP integration, and UI enhancements.
- **Hyprland:** Dynamic tiling, eye-candy animations, Wallbash theming, custom keybindings for efficient workflow management.
- **Tmux:** Enhanced session management and navigation via Oh My Tmux!.
- **Lazygit:** Streamlined Git operations with potential AI-assisted commit messages.

## Usage

- **Neovim:** Launch `nvim`. Plugins should install automatically via `lazy.nvim`.
- **Hyprland:** Start Hyprland from your display manager or TTY. Configurations should apply automatically.
- **Tmux:** Launch `tmux`. The configuration will be sourced automatically if linked correctly.
- **Lazygit:** Launch `lazygit`. Custom commands should be available (e.g., `G` or `Ctrl+g` in the files view).
