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

# Determine the project root (traversing up to find Assets and ProjectSettings)
START_DIR=$(dirname "$FILE_PATH")
PROJECT_ROOT=""
CURRENT_DIR="$START_DIR"
while [[ "$CURRENT_DIR" != "/" ]]; do
    if [[ -d "$CURRENT_DIR/Assets" && -d "$CURRENT_DIR/ProjectSettings" ]]; then
        PROJECT_ROOT="$CURRENT_DIR"
        break
    fi
    CURRENT_DIR=$(dirname "$CURRENT_DIR")
done

if [ -z "$PROJECT_ROOT" ]; then
    PROJECT_ROOT="$START_DIR"
fi

# Determine the package directory to locate init.lua
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Run the command in a login shell (zsh -l), changing to the project root first
# to ensure OmniSharp/LSP detects the correct project root instead of scanning the home directory.
if [ -n "$LINE_NUM" ]; then
    open -na Ghostty --args -e zsh -l -c "cd \"$PROJECT_ROOT\" && $NVIM_PATH -u \"$SCRIPT_DIR/init.lua\" +$LINE_NUM \"$ESC_FILE_PATH\""
else
    open -na Ghostty --args -e zsh -l -c "cd \"$PROJECT_ROOT\" && $NVIM_PATH -u \"$SCRIPT_DIR/init.lua\" \"$ESC_FILE_PATH\""
fi
