#!/bin/zsh
# Generate Wave Terminal backgrounds.json from an image directory.
# Usage:  wave-gen-presets.sh <image-dir> [opacity]
# Example: wave-gen-presets.sh ~/Pictures/wallpapers 0.3

set -e

IMAGE_DIR="${1:?Usage: wave-gen-presets.sh <image-directory> [opacity]}"
OPACITY="${2:-0.3}"
OUT="$HOME/.config/waveterm/backgrounds.json"

if [[ ! -d "$IMAGE_DIR" ]]; then
  echo "Error: directory not found: $IMAGE_DIR"
  exit 1
fi

python3 -c "
import json, os, sys

img_dir = '$IMAGE_DIR'
opacity = float('$OPACITY')

files = sorted([
    f for f in os.listdir(img_dir)
    if f.lower().endswith(('.jpg', '.jpeg', '.png', '.webp'))
])

if not files:
    print('Error: no images found in', img_dir, file=sys.stderr)
    sys.exit(1)

presets = {}
for i, f in enumerate(files):
    key = f'bg@custom{i+1:03d}'
    path = os.path.join(img_dir, f)
    presets[key] = {
        'display:name': f'Custom {f}',
        'display:order': i + 1,
        'bg': f\"url('file://{path}') center/cover no-repeat\",
        'bg:opacity': opacity
    }

with open('$OUT', 'w') as fp:
    json.dump(presets, fp, indent=2, ensure_ascii=False)

print(f'Generated {len(presets)} presets in $OUT')
"
