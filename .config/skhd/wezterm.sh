#!/bin/sh

wezterm () {
  osascript<<EOD
  tell application "wezterm" to activate "$@"

  EOD
}
