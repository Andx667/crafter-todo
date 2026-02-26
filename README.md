# Crafter Todo

A clean and intuitive World of Warcraft Burning Crusade addon that serves as a crafting note-taking and todo list manager. Keep track of your crafting projects, required materials, and progress all in one place.

## Features

- **Easy Todo Management**: Create, edit, and delete todos directly through the GUI
- **Two Todo Types**: 
  - **Plain Text**: Simple text notes for quick reminders
  - **Materials List**: Track required materials with quantities and current inventory counts
- **Persistent Storage**: All todos are automatically saved between game sessions
- **Quick Item Addition**: Shift+click items in your inventory to add them to material lists
- **Clean UI**: Intuitive interface that doesn't clutter your screen
- **Moveable Window**: Drag the window anywhere on your screen
- **Minimap Button**: Convenient minimap button for quick access (draggable and optional)

## Installation

### Manual Installation

1. Download the addon from [CurseForge](https://www.curseforge.com/wow/addons/crafter-todo) or [GitHub](https://github.com/yourusername/CrafterTodo)
2. Extract the `CrafterTodo` folder to your World of Warcraft `Interface/AddOns/` directory
   - **Path**: `C:\Program Files\World of Warcraft\_classic_/Interface/AddOns/` (for Burning Crusade Classic)
3. Restart World of Warcraft or type `/reload` in chat
4. Enable the addon in the AddOns menu if it's not already enabled

### CurseForge Client

If you use the CurseForge app, simply search for "Crafter Todo" and install it directly from within the app.

## Usage

### Opening the Addon

- Type `/ctt` or `/craftertodo` in game chat to toggle the todo list window
- Or use `/ctt show` to open and `/ctt hide` to close
- **Click the minimap button** (blue "ToDo" button on your minimap) to toggle the window
- Use `/ctt help` for command list

### Minimap Button

The addon includes a convenient minimap button that lets you quickly access your todo list:
- **Left-click** the minimap button to toggle the window open/closed
- **Drag** the button to reposition it on your minimap
- The button position is automatically saved between sessions
- Use `/ctt minimap` to show/hide the minimap button

### Creating a Todo

1. Click the **"Add Todo"** button in the bottom-left of the window
2. Enter a title for your todo
3. Choose the todo type:
   - **Plain Text**: For simple text notes
   - **Materials List**: For tracking crafting materials
4. Click **"Save"** to create the todo

### Editing a Todo

1. Click the **"Edit"** button next to the todo you want to modify
2. Update the title or change the type
3. Click **"Save"** to apply changes

### Deleting a Todo

1. Click the **"Delete"** button next to the todo
2. Confirm the deletion in the popup

### Managing Materials

For material-type todos:

1. Create or edit a materials-type todo
2. In the main window, you can add specific materials with quantities
3. **Shift+Click** items in your inventory, bank, or auction house to quickly add them to the current todo
4. The addon automatically tracks how many of each item you own

### Tracking Progress

- Check the checkbox next to a todo to mark it as complete
- Completed todos appear dimmed in the list
- Unchecminimap` | Toggle the minimap button visibility |
| `/ctt k to mark as incomplete again

## Commands

| Command | Description |
|---------|-------------|
| `/ctt` | Toggle the todo window open/closed |
| `/ctt show` | Open the todo window |
| `/ctt hide` | Close the todo window |
| `/ctt help` | Display all available commands |

## Compatibility

- **Game Version**: World of Warcraft Burning Crusade (The Burning Crusade Classic & Patch 2.4.3)
- **Interface Version**: 20400
- **Dependencies**: None (Optional: Ace3 for advanced features in future versions)

## Saved Data

All todos and settings are stored in the `SavedVariables\CrafterTodo.lua` file in your WoW directory. You can manually edit this file if needed, but it's recommended to manage all data through the addon UI.

## Troubleshooting

**Q: The addon doesn't show up in my AddOns list**
- Make sure the folder is named exactly `CrafterTodo` (case-sensitive)
- Verify it's in the correct `Interface/AddOns/` directory
- Try typing `/reload` to reload your UI

**Q: My todos disappeared!**
- Check your `SavedVariables/CrafterTodo.lua` file hasn't been corrupted
- Make sure you're on the same WoW account/realm
- Classic and Retail use different addon folders

**Q: Shift+click isn't working**
- Make sure the todo window is open
- Make sure you've selected a materials-type todo
- Shift+click works in inventory, bank, and auction house windows

**Q: The window is off-screen**
- Type `/ctt show` to reopen it
- The window should appear in its last known position

## Development

This addon is open-source! To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly in-game
5. Submit a pull request

### Project Structure

- `CrafterTodo.toc` - Addon manifest/descriptor file
- `core.lua` - Main addon logic and command handlers
- `data.lua` - SavedVariables and data management
- `ui.lua` - User interface and frame creation
- `localization.lua` - String localization

## Known Limitations

- Shift+click item linking is limited to item tooltips (future versions may expand this)
- UI scaling is limited to default WoW scaling
- Max todos stored is limited by SavedVariables size (generally not a concern)

## Future Features

- [x] Create/Edit/Delete todos
- [x] Material tracking
- [x] Persistent storage
- [ ] Category/folder organization
- [ ] Material shopping list export
- [ ] Cooldown tracking for crafts
- [ ] Recipe integration with links
- [ ] Multiple profiles/characters
- [ ] Localization for multiple languages

## Support

Found a bug? Have a suggestion? 

- GitHub Issues: [Report on GitHub](https://github.com/yourusername/CrafterTodo/issues)
- CurseForge Comments: Leave a comment on the addon page
- Discord: Join our community server for support

## License

This addon is licensed under the MIT License - see the LICENSE file for details.

## Credits

- **Author**: Crafter Todo Team
- **Contributors**: See [CONTRIBUTING.md](CONTRIBUTING.md)
- Icons and textures use default Blizzard Entertainment WoW assets

---

**Note**: This is a fan-made addon not affiliated with or endorsed by Blizzard Entertainment.
World of Warcraft® is a trademark of Blizzard Entertainment, Inc.
