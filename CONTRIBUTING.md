# Crafter Todo - Contributing Guide

Thanks for helping improve Crafter Todo. This guide covers issue reporting, feature requests, development setup, and the PR process.

## Before You Start

- Search existing issues to avoid duplicates
- Keep reports focused and actionable
- Include context (game version, addon version, steps to reproduce)

## Reporting Bugs

1. Check existing issues: https://github.com/Andx667/crafter-todo/issues
2. Open a new issue with:
   - Clear title
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if helpful
   - Game version and addon version

## Suggesting Features

1. Open a new issue with a clear use case
2. Explain why it helps crafters or reduces friction
3. Add mockups if it is UI-related

## Development Setup

1. Clone the repo:
   ```bash
   git clone https://github.com/Andx667/crafter-todo.git
   ```

2. Install into your WoW AddOns folder:
   ```bash
   cp -r CrafterTodo "C:\Program Files\World of Warcraft\_classic_\Interface\AddOns\"
   ```

3. Enable the addon in-game or via your addon manager

### Debugging Tips

- Use `/reload` to reload addon changes
- Check console errors (ESC -> System -> Error Messages)
- Use `print()` for quick debug output (appears in chat)
- Use `/script` to test Lua commands in-game

## Code Style Guide

### Lua Conventions

- **Indentation**: Tabs (4 spaces)
- **Naming**:
  - `camelCase` for locals and functions: `myVariable`, `doSomething()`
  - `UPPER_CASE` for globals and constants: `GLOBAL_TABLE`, `MAX_ITEMS`
  - Prefix globals with `CRAFTER_TODO_`
- **Comments**: Use `--` for single-line, `--[[ ]]` for multi-line
- **Functions**: Document complex logic with short comments

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

- Use WoW default textures and colors
- Follow the Burning Crusade era visual style
- Test at multiple UI scales

## Testing Checklist

Before submitting a PR, verify:

- [ ] Addon loads without errors (`/reload`)
- [ ] New features work as intended
- [ ] No console errors appear
- [ ] SavedVariables persist after reload
- [ ] UI elements render correctly
- [ ] Code follows the style guide

## Commit Messages

```
[Feature/Fix/Docs] Brief one-line description

- Why this change was made
- Reference issues: Closes #123
```

Examples:
```
[Feature] Add material sorting to todo lists

[Fix] Correct window positioning after UI scale change

[Docs] Update README with new slash commands
```

## Pull Request Process

1. Fork the repo and create a branch: `git checkout -b feature/your-feature-name`
2. Make your changes and test in-game
3. Update documentation and CHANGELOG.md if user-facing behavior changed
4. Commit and push to your fork
5. Open a PR with:
   - Summary of changes
   - Related issue links
   - Testing notes
6. Address review feedback

## Release Process (Maintainers)

### Pre-Release Checklist

- [ ] No Lua errors on `/reload`
- [ ] Commands and UI flows tested
- [ ] SavedVariables persist correctly
- [ ] README, CHANGELOG, and CONTRIBUTING updated
- [ ] Version updated in `CrafterTodo.toc`

### Create the Release

1. Update version in `CrafterTodo.toc`
2. Update CHANGELOG.md with the new version
3. Commit and push
4. Tag the release:
   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   ```
5. Create a GitHub release using the tag and changelog text
6. GitHub Actions will build and attach the ZIP
7. Upload the ZIP to CurseForge

### Build Scripts

- Windows: `build.bat`
- Linux/macOS: `build.sh`

## Questions

- Open a GitHub Discussion or issue
- Leave a comment on the CurseForge page

## Code of Conduct

- Be respectful
- Keep feedback constructive
- Help others learn

---

Thanks for making Crafter Todo better.
