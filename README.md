# Neovim Unity Integration

A self-contained, offline-ready Neovim configuration and integration package for C# and Unity development.

## Features

- **Offline & Self-Contained:** All Neovim plugins are bundled locally in the `.lazy/` directory. No internet connection or external repository downloads are required at startup.
- **Embedded OmniSharp LSP:** Includes platform-specific OmniSharp binaries for macOS (ARM64/x64), Windows, and Linux under the `bin/omnisharp/` directory.
- **Dynamic Platform Resolution:** Automatically detects the host operating system and CPU architecture (Apple Silicon, Intel Mac, Windows, Linux) to invoke the correct bundled OmniSharp binary.
- **Accurate Project Root Resolution:** Automatically determines the correct Unity project root (by looking for `Assets/` and `ProjectSettings/`) even when opening scripts located in `Packages/` or `Library/PackageCache/`.
- **Ghostty Integration:** Launch script is preconfigured to open in the [Ghostty](https://ghostty.org/) terminal emulator.

## Project Structure

```
├── .lazy/                 # Bundled Neovim plugins (fully offline)
├── bin/
│   └── omnisharp/         # Platform-specific OmniSharp binaries
│       ├── osx-arm64/
│       ├── osx-x64/
│       ├── win-x64/
│       └── linux-x64/
├── lua/
│   ├── config/            # Neovim options, keymaps, and lazy bootstrap
│   └── plugins/           # OmniSharp, Smear Cursor, and Discord Rich Presence configs
├── init.lua               # Neovim initialization entry point
├── unity-nvim.sh          # Launcher script called from Unity
└── package.json           # Unity package manifest (com.pedro.neovim)
```

## Installation & Setup

### 1. Configure Unity

1. Open your project in the **Unity Editor**.
2. Navigate to **Unity > Preferences** (macOS) or **Edit > Preferences** (Windows) > **External Tools**.
3. Under **External Script Editor**, click **Browse...** and select the [unity-nvim.sh](unity-nvim.sh) script located in this folder.
4. If available, verify that **External Script Editor Args** are set to:
   ```bash
   "$(File)" "$(Line)"
   ```
5. Click **Regenerate project files** to ensure Unity updates the `.csproj` and `.sln` files.

### 2. Manual Testing

You can verify the integration manually by opening a C# script:
```bash
./unity-nvim.sh /path/to/unity-project/Assets/Scripts/PlayerController.cs
```

## Adding Plugins or Updating Configs

To update plugins or install new ones:
1. Run Neovim headlessly to sync changes:
   ```bash
   nvim --headless -u init.lua "+Lazy! sync" +qa
   ```
2. If you added new plugins, commit the updated `.lazy/` directory to git.
