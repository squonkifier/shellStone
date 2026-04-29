- Prefer editing over rewriting whole files.
- Keep solutions simple and direct.
- User instructions always override this file.

# PROJECT DETAILS
This is a zero-dependency ncurses TUI for Linux system administration, with `shellstone.py` as the main entry point. Key features:
- Discovers executable `.sh` and `.py` scripts in the `./scripts` subdirectory and its subdirectories.
- Parses optional `Admin-Meta:` headers (Title, Description, Category) from script files (case-insensitive).
- Parses script summaries from comment lines after the Admin-Meta Description line until the next `#` line.
- Displays scripts in a tabbed, categorized main menu with real-time output streaming when scripts are executed.
- For `.py` scripts, checks for a system Python interpreter (`python3` or `python`) before execution; shows a soft error if not found.
- Visual effects: animated particle background system, spinner selection indicator.
- Bottom section displays script summaries for the currently selected item.

# Modular Architecture

The application has been refactored into modular components under `shellstone_modules/`:

## Module Overview

### `shellstone.py` (Entry Point)
- Minimal entry point that imports from `shellstone_ui` and launches the application via `curses.wrapper(main)`.

### `shellstone_modules/shellstone_core.py` (Core Data & Discovery)
**Settings Data:** (loaded from `shell.json` at runtime)
- `SCRIPTS_DIR`: Path to scripts directory (derived from project location: parent of `shellstone_modules/`)
- `PANES`: List of (display_name, directory, color_pair) tuples defining tabs (directory is relative to SCRIPTS_DIR)
- `META_*_RE`: Regex patterns for parsing Admin-Meta headers
- `SPINNER_FRAMES`, `PARTICLE_*`: Visual effect configuration
- `BOTTOM_HEIGHT`: Height of script summary section (14 lines)

**Data Structures:**
- `ScriptInfo` dataclass: Stores `path`, `title`, `description`, `category`, `summary`, and derived `name` property

**Functions:**
- `discover_scripts(directory)`: Finds .sh/.py files, parses metadata, sets defaults for missing fields
- `_parse_metadata(info, path)`: Parses Admin-Meta headers from script files
- `_parse_script_summary(path)`: Extracts summary from Admin-Meta Description until next `#` line
- `categorize(scripts)`: Groups scripts by Category metadata

### `shellstone_modules/shellstone_output.py` (Output Window)
- `OutputWindow` class: Full-screen curses overlay for real-time subprocess output
  - Supports scrolling (Home/End, PageUp/PageDown, Up/Down arrows)
  - Scrollbar visualization
  - Word-wrap for long lines
  - ANSI escape sequence parsing and stripping (including DEC private mode sequences)

### `shellstone_modules/shellstone_execution.py` (Script Execution)
- `PYTHON_BIN`: Path to available Python interpreter (detected at import time)
- `python_available()`: Checks if Python interpreter exists
- `run_script(stdscr, info)`: Launches scripts via pty for TTY support
  - Supports interactive input (sudo, etc.)
  - Streams stdout/stderr in real-time
  - Can terminate running scripts
- `show_error(stdscr, message)`: Displays error box and waits for keypress

### `shellstone_modules/shellstone_visual.py` (Visual Effects)
- `Spinner` class: Animated selection indicator using spinner characters
- `ParticleSystem` class: Pseudo-3D 'Celestial Flow' engine with parallax, depth scaling, and menu repulsion
  - Configurable particle layers, colors, and density
  - Supports meteor effects and twinkle animation

### `shellstone_modules/shellstone_ui.py` (User Interface)
- `main(stdscr)`: Initializes curses, validates scripts dir, launches main_menu
- `main_menu(stdscr)`: Core TUI loop
  - Pane/tab navigation (arrow keys, vi keys h/l)
  - Category sub-tabs within panes
  - Script list with scrollbar
  - Bottom section showing script summary
  - Keyboard shortcuts:
    - ↑↓/jk: Navigate scripts
    - ←→/hl: Switch panes/tabs
    - Enter: Run selected script
    - R: Refresh all panes
    - Q: Quit
    - PageUp/PageDown: Page scroll
    - Home/End: Jump to top/bottom

### `shellstone_modules/__init__.py` (Package Exports)
- Re-exports all public components for convenient imports

# DIRECTORY STRUCTURE
```
shellStone/
├── shellstone.py                    # Main entry point (minimal)
├── AGENTS.md                    # This file
├── README.md                    # Project documentation
├── shellstone_modules/              # Modular components
│   ├── __init__.py             # Package exports
│   ├── shellstone_core.py          # Constants, data models, script discovery
│   ├── shellstone_output.py        # OutputWindow class
│   ├── shellstone_execution.py     # Script execution functions
│   ├── shellstone_visual.py        # Visual effects (Spinner, ParticleSystem)
│   └── shellstone_ui.py            # Main menu and UI functions
└── scripts/                    # Main storage folder (organized by category)
    ├── system/                 # System management scripts
    ├── packages/               # Package management scripts
    ├── filesystem/             # File system utilities
    ├── networking/             # Network-related scripts
    ├── extras/                 # Miscellaneous utilities
    └── help/                   # Help/documentation scripts
```

# Code Style Notes
- Variables and functions use `snake_case` for readability
- Classes use `PascalCase`
- Private functions (internal helpers) are prefixed with `_`
- Constants use `UPPER_SNAKE_CASE`
- Comments explain "why" not "what" where the code is non-obvious
