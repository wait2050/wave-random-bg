#!/bin/zsh
# Pre-warm Wave Terminal browser cache by cycling through all backgrounds.
# Opens a temporary tab, cycles through all images, then auto-closes.
# Usage:  wave-cache-warmer.sh <image-dir>
# Example: wave-cache-warmer.sh ~/Pictures/wallpapers

IMAGE_DIR="${1:?Usage: wave-cache-warmer.sh <image-directory>}"
OPACITY="${2:-0.3}"

if [[ ! -d "$IMAGE_DIR" ]]; then
  echo "Error: directory not found: $IMAGE_DIR"
  exit 1
fi

setopt NULL_GLOB 2>/dev/null
IMAGES=("$IMAGE_DIR"/*.(jpg|jpeg|png|webp)(N))

if (( ${#IMAGES} == 0 )); then
  echo "No images found in $IMAGE_DIR" >&2
  exit 1
fi

echo "Warming cache for ${#IMAGES} images..."
echo "A temporary tab will open and cycle through all backgrounds."

TMP_SCRIPT=$(mktemp /tmp/wave-warmup-XXXXXX.sh)
{
  echo '#!/bin/zsh'
  echo 'IMAGES=('
  for img in "${IMAGES[@]}"; do
    printf "  '%s'\n" "$img"
  done
  echo ')'
  echo "OPACITY='$OPACITY'"
  echo 'for img in "${IMAGES[@]}"; do'
  echo '  wsh setbg --opacity "$OPACITY" "$img" 2>/dev/null'
  echo 'done'
} > "$TMP_SCRIPT"

chmod +x "$TMP_SCRIPT"
wsh run -x -- zsh "$TMP_SCRIPT" 2>/dev/null
echo "Done. Warmup tab will auto-close once finished."
