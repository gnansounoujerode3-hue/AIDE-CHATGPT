#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$ROOT_DIR/.video-tools/bin"

if [[ $# -eq 0 ]]; then
  echo "Usage: scripts/video-tools.sh COMMAND [ARG ...]" >&2
  exit 2
fi
if [[ ! -x "$BIN_DIR/ffmpeg" || ! -x "$BIN_DIR/ffprobe" ]]; then
  echo "FFmpeg tools are not installed. Run scripts/setup_video_tools.sh first." >&2
  exit 127
fi

export PATH="$BIN_DIR:$PATH"
exec "$@"
