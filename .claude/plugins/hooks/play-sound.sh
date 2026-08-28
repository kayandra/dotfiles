#!/usr/bin/env bash
# Play a notification sound when Claude Code completes a task or needs attention.
# Usage: play-sound.sh [complete|permission|reset]
#
# Configuration via environment variables:
#   CLAUDE_SOUND_DISABLED=1       - Disable all sounds
#   CLAUDE_SOUND_COMPLETE=<path>   - Custom sound file for task completion
#   CLAUDE_SOUND_PERMISSION=<path> - Custom sound file for permission prompts
#   CLAUDE_ATTENTION_PREFIX=<text> - Prefix added to tab title when Claude needs attention

set -euo pipefail

EVENT_TYPE="${1:-complete}"
ATTENTION_PREFIX="${CLAUDE_ATTENTION_PREFIX:-🔔 }"

if [ "${CLAUDE_SOUND_DISABLED:-}" = "1" ]; then
  exit 0
fi

play_sound() {
  local sound_file="$1"

  if [ "$(uname)" = "Darwin" ]; then
    afplay "$sound_file" &>/dev/null &
  elif command -v paplay &>/dev/null; then
    paplay "$sound_file" &>/dev/null &
  elif command -v aplay &>/dev/null; then
    aplay -q "$sound_file" &>/dev/null &
  elif command -v powershell.exe &>/dev/null; then
    powershell.exe -c "(New-Object Media.SoundPlayer '$sound_file').PlaySync()" &>/dev/null &
  fi
}

play_bell() {
  printf '\a'
}

get_tab_title() {
  if [ -n "${KITTY_LISTEN_ON:-}" ] && [ -n "${KITTY_WINDOW_ID:-}" ] && command -v kitty &>/dev/null; then
    kitty @ --to "${KITTY_LISTEN_ON}" ls 2>/dev/null | python3 -c '
import json, sys

window_id = sys.argv[1]

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

for os_window in data:
    for tab in os_window.get("tabs", []):
        for window in tab.get("windows", []):
            if str(window.get("id")) == window_id:
                print(tab.get("title", ""))
                raise SystemExit(0)
' "${KITTY_WINDOW_ID}" || true
  fi
}

set_tab_title() {
  local title="$1"

  if [ -n "${KITTY_LISTEN_ON:-}" ] && command -v kitty &>/dev/null; then
    kitty @ --to "${KITTY_LISTEN_ON}" set-tab-title "$title" 2>/dev/null || true
  elif [ -e /dev/tty ]; then
    printf '\033]0;%s\007' "$title" >/dev/tty 2>/dev/null || true
  fi
}

set_attention_title() {
  local current
  current="$(get_tab_title)"

  # Don't double-prefix
  if [[ "$current" != "${ATTENTION_PREFIX}"* ]]; then
    set_tab_title "${ATTENTION_PREFIX}${current}"
  fi
}

reset_attention_title() {
  local current
  current="$(get_tab_title)"

  # Strip the prefix if present
  if [[ "$current" == "${ATTENTION_PREFIX}"* ]]; then
    set_tab_title "${current#"$ATTENTION_PREFIX"}"
  fi
}

case "$EVENT_TYPE" in
  reset)
    reset_attention_title
    ;;
  complete)
    set_attention_title
    if [ -n "${CLAUDE_SOUND_COMPLETE:-}" ] && [ -f "${CLAUDE_SOUND_COMPLETE}" ]; then
      play_sound "$CLAUDE_SOUND_COMPLETE"
    elif [ "$(uname)" = "Darwin" ]; then
      play_sound "/System/Library/Sounds/Glass.aiff"
    else
      play_bell
    fi
    ;;
  permission)
    set_attention_title
    if [ -n "${CLAUDE_SOUND_PERMISSION:-}" ] && [ -f "${CLAUDE_SOUND_PERMISSION}" ]; then
      play_sound "$CLAUDE_SOUND_PERMISSION"
    elif [ "$(uname)" = "Darwin" ]; then
      play_sound "/System/Library/Sounds/Ping.aiff"
    else
      play_bell
    fi
    ;;
esac
