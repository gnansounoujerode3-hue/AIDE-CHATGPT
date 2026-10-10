#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TOOL_DIR="$ROOT_DIR/.video-tools"
BIN_DIR="$TOOL_DIR/bin"

if [[ "$(uname -s)" != "Linux" || "$(uname -m)" != "x86_64" ]]; then
  echo "This setup script currently supports Linux x86_64 only." >&2
  exit 2
fi

mkdir -p "$BIN_DIR"
if [[ -x "$BIN_DIR/ffmpeg" && -x "$BIN_DIR/ffprobe" ]]; then
  echo "Local FFmpeg tools are already installed in $BIN_DIR"
  "$BIN_DIR/ffmpeg" -version | head -n 1
  "$BIN_DIR/ffprobe" -version | head -n 1
  exit 0
fi

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/aide-video-tools.XXXXXX")"
cleanup() { rm -rf -- "$TMP_DIR"; }
trap cleanup EXIT

# The PyPI wheel bundles a local FFmpeg binary; install into a temporary target,
# not the system Python environment. Pin versions and do not run remote media services.
python3 -m pip install --quiet --no-deps --target "$TMP_DIR/python" "imageio-ffmpeg==0.6.0"
FFMPEG_SRC="$(PYTHONPATH="$TMP_DIR/python${PYTHONPATH:+:$PYTHONPATH}" python3 -c 'import imageio_ffmpeg; print(imageio_ffmpeg.get_ffmpeg_exe())')"
cp "$FFMPEG_SRC" "$BIN_DIR/ffmpeg"
chmod 0755 "$BIN_DIR/ffmpeg"

# Download only the pinned Linux ffprobe package from npm and disable lifecycle scripts.
NPM_PACK="$(npm pack --silent --ignore-scripts --pack-destination "$TMP_DIR" "@ffprobe-installer/linux-x64@5.2.0")"
tar -xOzf "$TMP_DIR/$NPM_PACK" package/ffprobe > "$BIN_DIR/ffprobe"
chmod 0755 "$BIN_DIR/ffprobe"

"$BIN_DIR/ffmpeg" -version | head -n 1
"$BIN_DIR/ffprobe" -version | head -n 1
printf '\nLocal tools installed. Run commands through scripts/video-tools.sh to put them on PATH.\n'
printf 'For capability checks: scripts/video-tools.sh python3 .agents/skills/ffmpeg-skill/scripts/_contract.py doctor --json\n'
