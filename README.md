# Linux Dotfiles

Opinionated configuration for a Hyprland-first workspace that keeps Zsh snappy, Powerlevel10k expressive, and Wayland utilities consistent.

## What this repo provides

- One-click shell: [.zshrc](.zshrc) wired up to Oh My Zsh plus autosuggestions and syntax highlighting, with a [.p10k.zsh](.p10k.zsh) prompt that highlights git status, battery, and the current host.
- Wayland essentials: themed [.config/kitty](.config/kitty) terminal, searchable [.config/rofi](.config/rofi) menus, and composited widgets via [.config/waybar](.config/waybar).
- Hyprland desktop glue: configuration for Hyprland, hyprpaper, and sway-like helpers living under [.config/hypr](.config/hypr) and [.config/swaync](.config/swaync).

## Arch Linux quick start

### 1. Update the base system

```bash
sudo pacman -Syyu
```

### 2. Install the upstream dependencies

```bash
sudo pacman -S --needed \
 zsh git curl unzip \
 hyprland hyprpaper waybar kitty rofi swaync \
 wayland-protocols wlroots xorg-xwayland \
 xdg-desktop-portal-hyprland libinput grim slurp wl-clipboard
```

#### Using yay to install extras

```bash
yay -Syyu
```

If you already have `yay`, you can install SwayNC and the other helpers directly with it so the packages stay aligned with AUR releases.

```bash
yay -S --needed \
 swaync hyprshutdown-git
```

If you do not yet have an AUR helper, install one (such as `yay`) so you can keep `swaync` and Nerd Fonts up to date. The [.config/swaync](.config/swaync) scripts expect a working `swaync` binary, so install it via `yay -S swayncrc` or by building from <https://github.com/ermeschmidt/swaync>.

### 3. Install the recommended fonts

```bash
mkdir -p ~/.local/share/fonts/FiraCodeNerdFont
wget -P ~/.local/share/fonts/FiraCodeNerdFont \
 https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
unzip ~/.local/share/fonts/FiraCodeNerdFont/FiraCode.zip -d ~/.local/share/fonts/FiraCodeNerdFont/
fc-cache -fv
```

Alternatively, keep things simple with your AUR helper:

```bash
yay -S nerd-fonts-fira-code
```

### 4. Install Oh My Zsh + Powerlevel10k

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 5. Clone this repository and deploy the files

```bash
git clone --depth 1 https://github.com/jezza5400/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Back up any existing shell configuration before copying the new ones:

```bash
mv ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
mv ~/.p10k.zsh ~/.p10k.zsh.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
```

Copy the repository config into place:

```bash
cp [.zshrc](.zshrc) ~/.zshrc
cp [.p10k.zsh](.p10k.zsh) ~/.p10k.zsh
cp -r .config/* ~/.config/
chmod 644 ~/.zshrc ~/.p10k.zsh
```

### 6. Final polish

- Set Zsh as your default shell:

 ```bash
 chsh -s $(command -v zsh)
 ```

- Reload Hyprland when you make compositor changes:

 ```bash
 hyprctl reload
 ```

- Restart your terminal or run `exec zsh` so Oh My Zsh picks up the fresh prompt.

## Configuration highlights

- Hyprland lives under [.config/hypr](.config/hypr) and references hyprpaper, wallpaper scripts, and keybindings tailored to multiple monitors.
- Kitty themes and keybindings are organized in [.config/kitty](.config/kitty) to match the Powerlevel10k palette.
- Rofi’s search and application menus can be tweaked inside [.config/rofi](.config/rofi).
- Waybar widgets (battery, backlight, layout indicators) are defined in [.config/waybar](.config/waybar).
- SwayNC helpers under [.config/swaync](.config/swaync) provide notifications and system controls in the Hyprland session.

## Contributing

Use issues or pull requests for improvements to the prompt, Hyprland layout, or scripts. Keep your patches small and document any extra packages you introduce.

## License

These configuration files are provided as-is. Underlying software (Oh My Zsh, Powerlevel10k, Hyprland, etc.) follow their own licenses.
