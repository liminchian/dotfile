# Dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理的個人設定檔（Arch Linux + Wayland）。

## 環境

| 類別 | 工具 |
| --- | --- |
| 作業系統 | Arch Linux |
| 合成器 | Niri（主要）、Hyprland |
| 終端機 | Alacritty |
| Shell | Fish + Starship + Atuin |
| 編輯器 | Neovim（Neovide） |
| 啟動器 | Anyrun、Rofi |
| 狀態列 / 小工具 | Waybar、AGS、Eww |
| 通知 | Mako |
| 登出選單 | wlogout |
| PDF 閱讀器 | Zathura |

## 結構

```
dot_config/
├── niri/ hypr/          # Wayland 合成器
├── alacritty/ fish/     # 終端機與 Shell
├── starship.toml        # 提示字元
├── private_atuin/       # Shell 歷史紀錄
├── nvim-think/          # Neovim 設定（think）
├── nvim-pair/           # Neovim 設定（pair）
├── anyrun/ rofi/        # 應用程式啟動器
├── waybar/ ags/ eww/    # 狀態列與桌面小工具
├── mako/ wlogout/       # 通知、電源選單
└── zathura/             # PDF 閱讀器
dot_local/bin/scripts/   # 啟動器、鎖屏、音量、桌布等腳本
```

## 兩套 Neovim

透過 `NVIM_APPNAME` 分離設定，於 `fish/config.fish` 定義別名：

```fish
think  # NVIM_APPNAME=nvim-think neovide
pair   # NVIM_APPNAME=nvim-pair  neovide
```

## 安裝

```sh
chezmoi init --apply liminchian/dotfile
```

更新：

```sh
chezmoi update
```

## 授權

[MIT](LICENSE)
