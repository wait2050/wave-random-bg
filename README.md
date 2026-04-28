# 🌊 Wave Random BG · 波浪终端随机背景

[![English](https://img.shields.io/badge/docs-English-blue)](README.md)
[![中文文档](https://img.shields.io/badge/文档-中文-red)](README_zh.md)
![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)
![shell](https://img.shields.io/badge/shell-zsh-yellow)
![license](https://img.shields.io/badge/license-MIT-green)

**Wave 终端** | **随机背景图** | **零延迟** | **波浪终端美化**

Zero-latency random background images for [Wave Terminal](https://www.waveterm.dev/) tabs.

每次新建标签页自动随机背景图，Shell 出现前已渲染完成。

## How it works

Two mechanisms run in parallel:

1. **Tab creation time** — Wave reads `tab:background` from `settings.json` (set by the previous tab) and applies the preset CSS before rendering the terminal → **zero latency**
2. **Shell startup** — `.zshrc` runs at the very top, picks a random image, applies it via `wsh setbg`, and rotates `tab:background` for the next tab

```
 Tab 1 opens ──→ gets preset bg@custom042 (instant)
      │
      └── .zshrc: wsh setbg random.jpg + set tab:background = bg@custom123
                                                                      │
 Tab 2 opens ──→ gets preset bg@custom123 (instant) ◄─────────────────┘
      │
      └── .zshrc: wsh setbg random.jpg + set tab:background = bg@custom307
                                                                      │
 Tab 3 opens ──→ gets preset bg@custom307 (instant) ◄─────────────────┘
```

## Quick start

```bash
git clone https://github.com/YOUR_USER/wave-random-bg.git
cd wave-random-bg
zsh install.sh ~/Pictures/wallpapers 0.3
```

Open a new tab in Wave. That's it.

## Requirements

- [Wave Terminal](https://www.waveterm.dev/) (v0.14.4+)
- macOS / Linux
- zsh
- Python 3
- A directory of images (jpg, png, webp)

## Manual setup

If you prefer to configure manually:

### 1. Generate presets

```bash
./wave-gen-presets.sh ~/Pictures/wallpapers 0.3
```

Creates `~/.config/waveterm/backgrounds.json` with one preset per image.

### 2. Set seed config

Add `tab:background` to `~/.config/waveterm/settings.json`:

```json
{
  "tab:background": "bg@custom001"
}
```

### 3. Add to .zshrc

Insert the contents of `zshrc-snippet.sh` at the **very top** of your `~/.zshrc`.

Set the env var to point to your image directory:

```bash
export WAVE_BG_DIR="$HOME/Pictures/wallpapers"
```

## Scripts

| Script | Purpose |
|--------|---------|
| `wave-gen-presets.sh <dir> [opacity]` | Generate backgrounds.json from image directory |
| `wave-random-bg.sh <dir> [opacity]` | Manually set a random background on current tab |
| `wave-cache-warmer.sh <dir> [opacity]` | Pre-warm browser cache for all images |
| `install.sh <dir> [opacity]` | One-command full installation |

## Tips

- **Opacity**: default 0.3. Adjust with `wsh setbg --opacity 0.5`
- **Clear background**: `wsh setbg --clear`
- **New images**: re-run `wave-gen-presets.sh` after adding/removing images
- **Cache warming**: optional, run `wave-cache-warmer.sh` after first install

## Acknowledgments · 致谢

Built with the assistance of [Claude](https://claude.ai) and [DeepSeek](https://deepseek.com).

本项目由 Claude 与 DeepSeek 共同协助完成。

## License · 许可证

MIT
