# Linux Dotfiles

Opinionated configuration for a Hyprland-first workspace that keeps Zsh snappy, Powerlevel10k expressive, and Wayland utilities consistent.

This repo is managed as a **bare git repository checked out against `$HOME`** — files live in their real locations (`~/.zshrc`, `~/.config/hypr/`, etc.), not copied or symlinked from a separate clone. Git metadata is kept out of `$HOME` so it doesn't interfere with git status/gitignore in unrelated projects.

## What this repo provides

- Shell: [`.zshrc`](.zshrc) wired up to Oh My Zsh plus autosuggestions and syntax highlighting, with a [`.p10k.zsh`](.p10k.zsh) prompt that highlights git status, battery, and the current host.
- Wayland essentials: themed [`.config/kitty`](.config/kitty) terminal, searchable [`.config/rofi`](.config/rofi) menus (plus [`.config/rofimoji.rc`](.config/rofimoji.rc)), and composited widgets via [`.config/waybar`](.config/waybar).
- Hyprland desktop config under [`.config/hypr`](.config/hypr): Lua-based compositor config (`hyprland.lua`), screen locking (`hyprlock.conf`), and wallpaper (`hyprpaper.conf`).
- Graceful power controls: a rofi power menu ([`.config/rofi/bin/powermenu.bash`](.config/rofi/bin/powermenu.bash)) driving `hyprlock` and `hyprshutdown` for lock/logout/reboot/shutdown.
- Notifications via [`.config/swaync`](.config/swaync).

## Arch Linux quick start

### 1. Update the base system

```bash
sudo pacman -Syu
```

### 2. Install the upstream dependencies

```bash
sudo pacman -S --needed zsh git curl unzip hyprland hyprlock hyprpaper hyprpicker hyprshot waybar kitty rofi swaync wayland-protocols xorg-xwayland xdg-desktop-portal-hyprland libinput grim slurp wl-clipboard
```

#### Using yay for AUR extras

```bash
yay -S --needed hyprshutdown
```

#### Install a Nerd Font manually

Nerd Font glyphs (used by the Powerlevel10k prompt, Waybar, and rofi icons) aren't packaged in the AUR here, so grab the latest release directly:

```bash
mkdir -p ~/.local/share/fonts
curl -fLo /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip -o /tmp/FiraCode.zip -d ~/.local/share/fonts
fc-cache -fv
```

Then set your terminal (Kitty) and any font pickers to a "FiraCode Nerd Font" variant.

### 3. Install Oh My Zsh + Powerlevel10k

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 4. Deploy the dotfiles (bare repo method)

Rather than cloning into a subfolder and copying files out, this repo is checked out directly against `$HOME` as a bare repo. This keeps every file in its real, expected location while git metadata stays isolated in `~/.dotfiles`.

```bash
git clone --bare https://github.com/jezza5400/dotfiles.git $HOME/.dotfiles
```

Add an alias so git commands run against this repo instead of a normal `.git` folder:

```bash
echo "alias dotfiles='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.zshrc
source ~/.zshrc
```

Prevent `dotfiles status` from listing every untracked file in `$HOME`:

```bash
dotfiles config --local status.showUntrackedFiles no
```

Check out the tracked files into `$HOME`:

```bash
dotfiles checkout
```

If it refuses because of pre-existing local configs, back up the conflicting files first, then retry:

```bash
mkdir -p ~/.dotfiles-backup
dotfiles checkout 2>&1 | egrep "\s+\." | awk '{print $1}' | \
  xargs -I{} sh -c 'mkdir -p ~/.dotfiles-backup/$(dirname {}) && mv {} ~/.dotfiles-backup/{}'
dotfiles checkout
```

### 5. Final polish

- Set Zsh as your default shell:

```bash
chsh -s $(command -v zsh)
```

- Reload Hyprland when you make compositor changes:

```bash
hyprctl reload
```

- Restart your terminal or run `exec zsh` so Oh My Zsh picks up the fresh prompt.

## Day-to-day usage

Once set up, use the `dotfiles` alias exactly like `git`, from anywhere on the system:

```bash
dotfiles status
dotfiles add -u                  # stage changes to already-tracked files
dotfiles add path/to/new/file    # track a new file explicitly
dotfiles commit -m "message"
dotfiles push
```

Plain `git` in any other project directory behaves normally — it's completely unaffected by this repo.

## Configuration highlights

- Hyprland lives under [`.config/hypr`](.config/hypr): `hyprland.lua` is the core compositor config (Lua-based, replacing the old `.conf` format), plus `hyprlock.conf` for the lock screen and `hyprpaper.conf` for wallpaper.
- Power menu: [`.config/rofi/bin/powermenu.bash`](.config/rofi/bin/powermenu.bash) presents Lock/Logout/Reboot/Shutdown through rofi, calling `hyprlock` for locking and `hyprshutdown` for graceful logout/reboot/shutdown.
- Kitty themes and keybindings are organized in [`.config/kitty`](.config/kitty) to match the Powerlevel10k palette.
- Rofi's search and application menus can be tweaked inside [`.config/rofi`](.config/rofi), with emoji picker config in [`.config/rofimoji.rc`](.config/rofimoji.rc).
- Waybar widgets (battery/power-profile, backlight, layout indicators) are defined in [`.config/waybar`](.config/waybar).
- SwayNC helpers under [`.config/swaync`](.config/swaync) provide notifications and system controls in the Hyprland session.

## Contributing

Use issues or pull requests for improvements to the prompt, Hyprland layout, or scripts. Keep your patches small and document any extra packages you introduce.

## License

These configuration files are provided as-is. Underlying software (Oh My Zsh, Powerlevel10k, Hyprland, etc.) follow their own licenses.
