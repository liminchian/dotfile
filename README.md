# Dot Files

使用 **Nix Flakes + home-manager** 管理的 dotfiles，環境設定如下：

1. Operating system: Arch Linux
2. Wayland compositer: Niri
3. Terminal: Alacritty
4. Shell: Fish
5. Web browser: Zen
6. Text editor: Helix / Zed
7. App launcher: Anyrun

## 結構

```
.
├── flake.nix           # Flake 入口（nixpkgs + home-manager + ags inputs）
├── home.nix            # home-manager 主設定
├── modules/            # 模組化 home-manager 設定
│   ├── shell.nix       # fish / starship / atuin
│   ├── terminal.nix    # alacritty
│   ├── editor.nix      # helix
│   ├── tools.nix       # zathura 等工具
│   ├── wm/             # niri / hyprland
│   ├── desktop/        # waybar / mako / wlogout / ags
│   └── launcher/       # anyrun / rofi
├── config/             # 原始設定檔（被 modules 引用）
└── scripts/            # 使用者腳本（會被安裝到 ~/.local/bin）
```

## 安裝

首次安裝 Nix（非 NixOS 系統）：

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

啟用 flakes：

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

套用設定：

```bash
nix run home-manager/master -- switch --flake .#sei
```

之後更新只需：

```bash
home-manager switch --flake .#sei
```

## 切換 home-manager 設定名稱

`flake.nix` 中的 `homeConfigurations."sei"` 是給帳號 `sei` 用的；
若 username 不同，請修改 `flake.nix` 與 `home.nix` 中的 `home.username` / `home.homeDirectory`。
