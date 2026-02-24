#!/usr/bin/env bash

set -u

THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/waybar-power.rasi"
ROFI_BIN="${ROFI_BIN:-rofi}"

is_cmd() {
  command -v "$1" >/dev/null 2>&1
}

detect_compositor() {
  local desktop="${XDG_CURRENT_DESKTOP:-}"
  desktop="${desktop,,}"

  if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || [[ "$desktop" == *hyprland* ]]; then
    printf '%s\n' "hyprland"
    return
  fi

  if [ -n "${NIRI_SOCKET:-}" ] || [[ "$desktop" == *niri* ]]; then
    printf '%s\n' "niri"
    return
  fi

  printf '%s\n' "unknown"
}

lock_screen() {
  if is_cmd hyprlock; then
    if ! pidof hyprlock >/dev/null 2>&1; then
      hyprlock >/dev/null 2>&1 &
      disown || true
    fi
    if is_cmd hyprctl; then
      hyprctl dispatch dpms off >/dev/null 2>&1 || true
    fi
    return
  fi

  if is_cmd swaylock; then
    swaylock
    return
  fi

  loginctl lock-session
}

lock_screen_nonblocking() {
  if is_cmd hyprlock; then
    if ! pidof hyprlock >/dev/null 2>&1; then
      hyprlock >/dev/null 2>&1 &
      disown || true
    fi
    return
  fi

  if is_cmd swaylock; then
    if ! pidof swaylock >/dev/null 2>&1; then
      swaylock >/dev/null 2>&1 &
      disown || true
    fi
    return
  fi

  loginctl lock-session
}

suspend_system() {
  lock_screen_nonblocking
  sleep 0.5
  systemctl suspend
}

logout_session() {
  case "$(detect_compositor)" in
    hyprland)
      if is_cmd hyprctl; then
        hyprctl dispatch exit && return
      fi
      ;;
    niri)
      if is_cmd niri; then
        niri msg -y action quit && return
      fi
      ;;
  esac

  if is_cmd uwsm; then
    uwsm stop && return
  fi

  if [ -n "${XDG_SESSION_ID:-}" ]; then
    loginctl terminate-session "$XDG_SESSION_ID" && return
  fi

  loginctl terminate-user "$USER"
}

show_menu() {
  cat <<EOF | "$ROFI_BIN" -dmenu -i -no-custom -p "" -theme "$THEME"
󰍁  Lock
󰤄  Suspend
󰜉  Reboot
󰐥  Shutdown
󰍃  Logout
EOF
}

main() {
  local selection
  selection="$(show_menu)"

  case "$selection" in
    *Lock*) lock_screen ;;
    *Suspend*) suspend_system ;;
    *Reboot*) systemctl reboot ;;
    *Shutdown*) systemctl poweroff ;;
    *Logout*) logout_session ;;
    *) exit 0 ;;
  esac
}

main "$@"
