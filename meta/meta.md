# Crafter Todo Addon Metadata

This file contains metadata for addon distribution platforms like CurseForge.

## CurseForge Information

**Project Slug**: crafter-todo
**Game**: World of Warcraft
**Game Versions**:
  - The Burning Crusade Classic (2.4.3)
  - WoW Classic Era (1.14.4) - Compatible with patches 1.13+
  - Retail WoW (11.0.0+) - Future compatibility

**Release Types**: Release
**Categories**: Professions, Crafting, Productivity, Tools, Quest Helpers

**Tags**: 
  - crafting
  - materials
  - todo-list
  - notes
  - productivity
  - burning-crusade
  - classic

## Curse Forge API

When submitting to CurseForge, update the `.toc` file version:

```
## Version: 1.0.0
```

The project uses automatic versioning based on GitHub releases.

## GitHub Releases

Release format for GH Releases:
```
v1.0.0 - Initial Release
v1.1.0 - Feature updates
v2.0.0 - Major version with breaking changes
```

## Distribution Files

When creating release archives:

```
CrafterTodo/
├── CrafterTodo.toc
├── core.lua
├── data.lua
├── ui.lua
├── localization.lua
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
└── meta/
    └── metadata.md (this file)
```

**Do NOT include**:
- `.git` folder
- `.gitignore` file
- Development scripts
- IDE configuration files
- `README.md` (CurseForge has its own description)
- `CONTRIBUTING.md` (link in main description)

## Changelog Format for CurseForge

Use the following format when posting changelog on CurseForge:

```
## Version 1.0.0
- Initial release
- Complete core functionality
- Support for two todo types
- Material tracking
- Persistent storage
```

## Installation Instructions

Display in CurseForge description:

```
1. Install via CurseForge app (recommended)
2. Or manually extract to Interface/AddOns/
3. Enable addon in AddOns menu
4. Type /ctt in-game to open
```

## Trademark/Legal

- WoW is trademarked by Blizzard Entertainment
- Not affiliated with or endorsed by Blizzard
- Licensed under MIT License

## Future Platform Support

Potential future distribution:
- WowInterface.com (.zip + .toc versioning)
- GitHub Releases (.zip downloads)
- Wago.io (individual profile)
- Direct website downloads

## Version History for Records

| Version | Date | Status | Platform |
|---------|------|--------|----------|
| 1.0.0 | 2025-02-26 | Released | GitHub, CurseForge |

---

For questions about distribution, contact the project maintainers.
