#!/bin/bash
#
#  unity-nvim.sh
#  Neovim Launcher for Unity (macOS)
#

FILE_PATH="$1"
LINE_NUM="$2"

# Find nvim executable path
NVIM_PATH=$(which nvim 2>/dev/null || echo "/opt/homebrew/bin/nvim")

# Escape double quotes and backslashes for the zsh -c command string
ESC_FILE_PATH=$(echo "$FILE_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')

# Determine the project root (parent directory of Assets/)
if [[ "$FILE_PATH" == *"/Assets/"* ]]; then
    PROJECT_ROOT="${FILE_PATH%%/Assets/*}"
else
    PROJECT_ROOT=$(dirname "$FILE_PATH")
fi

# Run the command in a login shell (zsh -l), changing to the project root first
# to ensure OmniSharp/LSP detects the correct project root instead of scanning the home directory.
if [ -n "$LINE_NUM" ]; then
    open -na Ghostty --args -e zsh -l -c "cd \"$PROJECT_ROOT\" && $NVIM_PATH +$LINE_NUM \"$ESC_FILE_PATH\""
else
    open -na Ghostty --args -e zsh -l -c "cd \"$PROJECT_ROOT\" && $NVIM_PATH \"$ESC_FILE_PATH\""
fi
