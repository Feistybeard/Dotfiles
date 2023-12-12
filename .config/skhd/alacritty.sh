#!/bin/sh

alacritty () {
  osascript<<EOD
  tell application "alacritty" to activate "$@"

  EOD
}