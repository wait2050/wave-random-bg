#!/bin/zsh
# Wave Random BG — one-command installer
# Usage:  zsh install.sh <image-directory> [opacity]
# Example: zsh install.sh ~/Pictures/wallpapers 0.3

set -e

SCRIPT_DIR="${0:A:h}"
IMAGE_DIR="${1:?Usage: zsh install.sh <image-directory> [opacity]}"
OPACITY="${2:-0.3}"

if [[ ! -d "$IMAGE_DIR" ]]; then
  echo "Error: directory not found: $IMAGE_DIR"
  exit 1
fi

echo "=== Wave Random BG Installer ==="
echo "Image directory: $IMAGE_DIR"
echo "Opacity: $OPACITY"
echo ""

# 1. Generate backgrounds.json presets
echo "[1/4] Generating presets..."
zsh "$SCRIPT_DIR/wave-gen-presets.sh" "$IMAGE_DIR" "$OPACITY"

# 2. Set seed tab:background in settings.json
echo "[2/4] Setting seed config..."
python3 -c "
import json, os, random
d = '$IMAGE_DIR'
files = sorted([f for f in os.listdir(d) if f.lower().endswith(('.jpg','.jpeg','.png','.webp'))])
if not files:
    print('No images found!')
    exit(1)
cfg_path = os.path.expanduser('$HOME/.config/waveterm/settings.json')
try:
    with open(cfg_path) as f:
        cfg = json.load(f)
except:
    cfg = {}
cfg['tab:background'] = f'bg@custom{random.randint(1, len(files)):03d}'
with open(cfg_path, 'w') as f:
    json.dump(cfg, f, indent=2)
print(f'Seed set.')
"

# 3. Install scripts to ~/.local/bin
echo "[3/4] Installing scripts..."
mkdir -p "$HOME/.local/bin"
cp "$SCRIPT_DIR/wave-gen-presets.sh" "$HOME/.local/bin/"
cp "$SCRIPT_DIR/wave-random-bg.sh" "$HOME/.local/bin/"
cp "$SCRIPT_DIR/wave-cache-warmer.sh" "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/wave-gen-presets.sh"
chmod +x "$HOME/.local/bin/wave-random-bg.sh"
chmod +x "$HOME/.local/bin/wave-cache-warmer.sh"
echo "Scripts installed to ~/.local/bin/"

# 4. Update .zshrc
echo "[4/4] Updating .zshrc..."
ZSH_PLUGIN_DIR="$HOME/.zsh"
mkdir -p "$ZSH_PLUGIN_DIR"
cp "$SCRIPT_DIR/zshrc-snippet.sh" "$ZSH_PLUGIN_DIR/wave-random-bg.zsh"

if grep -q "wave-random-bg" "$HOME/.zshrc" 2>/dev/null; then
  echo ".zshrc already configured, skipping."
else
  # Insert at top of .zshrc
  ZSHRC="$HOME/.zshrc"
  if [[ -f "$ZSHRC" ]]; then
    echo -e "# Wave random background (auto-generated)\n[[ -f \"\$HOME/.zsh/wave-random-bg.zsh\" ]] && source \"\$HOME/.zsh/wave-random-bg.zsh\"\n\n$(cat "$ZSHRC")" > "$ZSHRC"
  else
    echo '[[ -f "$HOME/.zsh/wave-random-bg.zsh" ]] && source "$HOME/.zsh/wave-random-bg.zsh"' > "$ZSHRC"
  fi
  echo ".zshrc updated."
fi

echo ""
echo "=== Installation complete ==="
echo "Open a new tab in Wave to test!"
echo ""
echo "Quick reference:"
echo "  wave-random-bg.sh <dir>     — manual random background"
echo "  wave-gen-presets.sh <dir>   — regenerate presets"
echo "  wave-cache-warmer.sh <dir>  — warm browser cache"
echo "  wsh setbg --clear           — remove background"
