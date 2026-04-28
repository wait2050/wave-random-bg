#!/bin/zsh
# Manually apply a random background image to the current Wave tab.
# Usage:  wave-random-bg.sh <image-dir> [opacity]
# Example: wave-random-bg.sh ~/Pictures/wallpapers 0.3

IMAGE_DIR="${1:?Usage: wave-random-bg.sh <image-directory> [opacity]}"
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

IMG="${IMAGES[$(( RANDOM % ${#IMAGES} + 1 ))]}"
wsh setbg --opacity "$OPACITY" "$IMG" 2>/dev/null && echo "Background: $(basename "$IMG")"
