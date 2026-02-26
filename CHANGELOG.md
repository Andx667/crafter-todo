# CrafterTodo Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-02-26

### Added
- Initial release of Crafter Todo addon
- Core todo list functionality (Create, Read, Update, Delete)
- Two todo types: Plain Text and Materials List
- Persistent storage using WoW SavedVariables
- Clean, moveable UI with draggable window
- Material quantity tracking with inventory count
- Shift+click item addition to material lists
- Completion status marking for todos
- Slash commands (`/ctt`, `/craftertodo`)
- Window position and size persistence
- Basic localization framework (English)
- Confirmation dialogs for destructive actions
- Full UI respecting WoW 2.4.3 aesthetic

### Features
- **Todo Management**: Create, edit, delete, and mark todos complete
- **Material Tracking**: Track required materials and current inventory
- **Auto-save**: All changes persist between game sessions
- **Quick Add**: Shift+click items to add to current material list
- **UI Polish**: Moveable window with backdrop and proper styling

### Technical Details
- Compatible with WoW Burning Crusade (Interface 20400)
- Lua-based implementation with pure WoW API
- Clean file structure separating concerns
- Follows WoW addon conventions and standards

---

## Future Releases

### [1.1.0] - Planned
- [ ] Material shopping list export to chat
- [ ] Right-click context menu in todo list
- [ ] Drag-and-drop todo reordering
- [ ] Search/filter functionality
- [ ] Material templates for common recipes

### [1.2.0] - Planned
- [ ] Multiple profiles per character
- [ ] Category/folder organization
- [ ] Recipe links and integration
- [ ] Cooldown tracking for timed crafts
- [ ] Enhanced material tracking with sources

### [2.0.0] - Long-term
- [ ] Full localization support (deDE, frFR, esES, zhCN, etc.)
- [ ] Database of common recipes with material lists
- [ ] Guild-wide crafting board
- [ ] Cross-character todo sync
- [ ] Settings panel with customization options

---

## Contributing

To suggest features or report bugs, please open an issue on our GitHub repository.
