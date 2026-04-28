# 🌊 Wave Random BG

Zero-latency random background images for [Wave Terminal](https://www.waveterm.dev/) tabs.

Each new tab gets a random image from your collection, applied instantly — before the shell prompt even appears.

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

## License

MIT
