# Crafter Todo

Crafter Todo is a clean and intuitive World of Warcraft Burning Crusade addon for crafting notes and todo lists. Track projects, required materials, and progress in one place.

## Features

- **Easy todo management**: Create, edit, and delete todos in the GUI
- **Two todo types**:
  - **Plain Text** for quick reminders
  - **Materials List** with quantities and inventory counts
- **Persistent storage**: Todos automatically save between sessions
- **Quick item addition**: Shift+click items to add them to material lists
- **Clean UI**: Simple, uncluttered window
- **Moveable window**: Drag anywhere on screen
- **Minimap button**: Optional, draggable quick access

## Installation

### Manual Install

1. Download from [CurseForge](https://www.curseforge.com/wow/addons/crafter-todo) or [GitHub](https://github.com/Andx667/crafter-todo)
2. Extract the `CrafterTodo` folder to your WoW `Interface/AddOns/` directory
   - **Path**: `C:\Program Files\World of Warcraft\_classic_\Interface\AddOns\` (Burning Crusade Classic)
3. Restart WoW or type `/reload` in chat
4. Enable the addon in the AddOns menu if needed

### CurseForge Client

Search for "Crafter Todo" in the CurseForge app and install.

## Quick Start

- Type `/ctt` or `/craftertodo` to toggle the window
- Click **Add Todo** to create your first list
- Use **Shift+Click** on items to add them to a materials list

## Usage

### Open and Close

- `/ctt` or `/craftertodo` toggles the window
- `/ctt show` opens, `/ctt hide` closes
- Click the minimap button to toggle

### Minimap Button

- **Left-click** to toggle the window
- **Drag** to reposition
- Position saves between sessions
- Use `/ctt minimap` to show or hide it

### Create, Edit, Delete

1. Click **Add Todo**
2. Enter a title and choose a type
3. Click **Save**

To edit or delete, click the buttons next to a todo and confirm the action.

### Materials Lists

1. Select a materials-type todo
2. Add materials and quantities
3. **Shift+Click** items in your inventory, bank, or auction house to add them
4. Inventory counts update automatically

### Progress Tracking

- Check a todo to mark it complete
- Completed todos appear dimmed
- Uncheck to mark it incomplete again

## Commands

| Command | Description |
|---------|-------------|
| `/ctt` | Toggle the todo window |
| `/ctt show` | Open the todo window |
| `/ctt hide` | Close the todo window |
| `/ctt help` | Show all available commands |
| `/ctt minimap` | Toggle the minimap button |

## Saved Data

Todos and settings are stored in `SavedVariables\CrafterTodo.lua` in your WoW directory. Editing this file is possible but not recommended.

## Compatibility

- **Game Version**: Burning Crusade Classic (Patch 2.4.3)
- **Interface Version**: 20400
- **Dependencies**: None

## Troubleshooting

**Addon does not appear in the AddOns list**
- Confirm the folder is named `CrafterTodo`
- Verify it is placed in `Interface/AddOns/`
- Type `/reload` and check again

**Todos disappeared**
- Check `SavedVariables/CrafterTodo.lua` for corruption
- Confirm you are on the same WoW account and realm

**Shift+click is not working**
- Make sure the todo window is open
- Select a materials-type todo
- Shift+click works in inventory, bank, and auction house windows

**Window is off-screen**
- Type `/ctt show`
- The window should reappear at its last known position

## Support

- GitHub Issues: [Report a bug or request a feature](https://github.com/Andx667/crafter-todo/issues)
- CurseForge Comments: Leave a comment on the addon page

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for issue reporting, PR workflow, and development guidance.

## License

Licensed under the MIT License. See LICENSE for details.

## Credits

- **Author**: Crafter Todo Team
- **Contributors**: See [CONTRIBUTING.md](CONTRIBUTING.md)
- Icons and textures use default Blizzard Entertainment WoW assets

---

This is a fan-made addon not affiliated with or endorsed by Blizzard Entertainment.
World of Warcraft(R) is a trademark of Blizzard Entertainment, Inc.
