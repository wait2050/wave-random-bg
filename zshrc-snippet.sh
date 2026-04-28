# Wave Terminal: random tab background (must be first in .zshrc for minimal latency)
if [[ "$WAVETERM" == "1" ]]; then
  IMAGE_DIR="${WAVE_BG_DIR:-$HOME/Pictures/wallpapers}"
  OPACITY="${WAVE_BG_OPACITY:-0.3}"
  setopt NULL_GLOB 2>/dev/null
  IMAGES=("$IMAGE_DIR"/*.(jpg|jpeg|png|webp)(N))
  if (( ${#IMAGES} > 0 )); then
    IMG="${IMAGES[$(( RANDOM % ${#IMAGES} + 1 ))]}"
    wsh setbg --opacity "$OPACITY" "$IMG" 2>/dev/null
  fi
  # Rotate tab:background preset for next tab (zero-latency at creation time)
  python3 -c "
import json, random, os
d = os.environ.get('WAVE_BG_DIR', os.path.expanduser('~/Pictures/wallpapers'))
files = sorted([f for f in os.listdir(d) if f.lower().endswith(('.jpg','.jpeg','.png','.webp'))])
if files:
    with open(os.path.expanduser('$HOME/.config/waveterm/settings.json')) as f:
        cfg = json.load(f)
    cfg['tab:background'] = f'bg@custom{random.randint(1, len(files)):03d}'
    with open(os.path.expanduser('$HOME/.config/waveterm/settings.json'), 'w') as f:
        json.dump(cfg, f, indent=2)
" 2>/dev/null &
fi
