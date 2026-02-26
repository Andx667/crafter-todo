# Crafter Todo - Contributing Guide

Thank you for your interest in contributing to Crafter Todo! This guide will help you get started.

## How to Contribute

### Reporting Bugs

1. Check existing [GitHub Issues](https://github.com/yourusername/CrafterTodo/issues) to avoid duplicates
2. Create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - Your WoW version and addon version

### Suggesting Features

1. Open a new issue with the `feature request` label
2. Describe the feature and use case
3. Explain why this feature would be valuable
4. Provide mockups if it's UI-related

### Code Contributions

1. **Fork** the repository
2. **Create a branch**: `git checkout -b feature/your-feature-name`
3. **Write clean code** following the style guide below
4. **Test thoroughly** in WoW (both Burning Crusade and Retail if applicable)
5. **Commit** with clear messages: `git commit -m "Add feature: description"`
6. **Push** to your fork
7. **Submit a Pull Request** with a detailed description

## Code Style Guide

### Lua Conventions

- **Indentation**: Use tabs (4 spaces)
- **Naming**: 
  - `camelCase` for local variables and functions: `myVariable`, `doSomething()`
  - `UPPER_CASE` for globals and constants: `GLOBAL_TABLE`, `MAX_ITEMS`
  - Addon prefixes for globals: `CRAFTER_TODO_*`
- **Comments**: Use `--` for single-line, `--[[ ]]` for multi-line
- **Functions**: Document complex functions with comments

```lua
-- Good
local function GetTodoById(id)
  for _, todo in ipairs(CRAFTER_TODO.db.todos) do
    if todo.id == id then
      return todo
    end
  end
  return nil
end

-- Bad
function gettodoid(id)
  for _,t in ipairs(db.t)do if t.i==id then return t end end
end
```

### File Organization

- `core.lua` - Main addon initialization and events
- `data.lua` - Data models and SavedVariables management
- `ui.lua` - UI frame creation and rendering
- `localization.lua` - String localization

### UI Development

- Use WoW's default textures and colors for consistency
- Follow the game's visual style (Burning Crusade era)
- Test at different UI scales
- Ensure keyboard accessibility where possible

## Testing Checklist

Before submitting a PR, verify:

- [ ] Addon loads without errors (`/reload`)
- [ ] All new features work as intended
- [ ] No console errors appear
- [ ] SavedVariables persist correctly after reload
- [ ] UI elements are properly positioned
- [ ] Code follows the style guide
- [ ] Changes are documented in comments

## Commit Message Guidelines

```
[Feature/Fix/Docs] Brief one-line description

- Detailed explanation of changes
- Include why this change was made
- Reference issue numbers: Closes #123
```

Examples:
```
[Feature] Add material sorting to todo lists

[Fix] Correct window positioning after UI scale change

[Docs] Update README with new slash commands
```

## Pull Request Process

1. Update the CHANGELOG.md with your changes
2. Reference any related issues
3. Provide a clear description of what changed and why
4. Include testing notes
5. Wait for review and address feedback
6. Maintainers will merge once approved

## Development Environment

### Setting Up

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/CrafterTodo.git
   ```

2. Install into your WoW AddOns folder:
   ```bash
   cp -r CrafterTodo "C:\Program Files\World of Warcraft\_classic_\Interface\AddOns\"
   ```

3. Enable in game or through addon manager

### Debugging

- Use `/reload` to reload addon changes
- Check console for error messages (ESC → System → Error Messages)
- Use `print()` for debugging output (appears in chat)
- Use `/script` to test Lua commands in-game

## Questions?

- Open a GitHub Discussion
- Leave a comment on the addon page
- Email the maintainers

## Code of Conduct

- Be respectful to all contributors
- Provide constructive feedback
- Avoid spam or self-promotion
- Help others learn and grow

---

Thank you for making Crafter Todo better! 🎉
