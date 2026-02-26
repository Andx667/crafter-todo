# Crafter Todo - Development & Release Checklist

## Pre-Release Checklist

### Code Quality
- [ ] All Lua files have proper syntax (no errors on `/reload`)
- [ ] No console errors or warnings appear
- [ ] Code follows style guide (consistent indentation, naming)
- [ ] Comments are clear and helpful
- [ ] No debug print statements left in code

### Testing
- [ ] Test on clean WoW installation (no other addons)
- [ ] Test all slash commands (`/ctt`, `/ctt show`, etc.)
- [ ] Create/edit/delete todos - all work correctly
- [ ] Material tracking - quantities update correctly
- [ ] SavedVariables persist after reload
- [ ] Window position persists after reload
- [ ] UI elements render correctly at different scales
- [ ] Shift+click functionality works in inventory

### Documentation
- [ ] README.md is complete and accurate
- [ ] CHANGELOG.md is updated with new version
- [ ] CONTRIBUTING.md reflects current process
- [ ] Comments in code are clear
- [ ] Example usage is documented

### Version & Metadata
- [ ] Update version in `CrafterTodo.toc`
- [ ] Update version in `CHANGELOG.md`
- [ ] Verify Interface number is correct (20400 for TBC)
- [ ] Check SavedVariables naming is consistent

### Compatibility
- [ ] Test on Burning Crusade Classic (Interface 20400)
- [ ] Verify no deprecated API usage
- [ ] No external dependencies required
- [ ] Works with no other addons enabled

## Release Process

### Before Packaging
1. Run `build.bat` (Windows) or `build.sh` (Linux/macOS)
2. Extract zip and test once more in fresh WoW installation
3. Verify all files are present and correct

### CurseForge Upload

#### First-Time Upload
1. Go to https://www.curseforge.com/wow/addons/create
2. Fill in addon details:
   - **Name**: Crafter Todo
   - **Summary**: Crafting todo list and note-taking addon
   - **Description**: Use full README.md content
   - **Primary Category**: Professions
   - **Secondary Category**: Quest Helpers
   - **Tags**: crafting, materials, todo-list, burning-crusade

3. Upload the built .zip file
4. Select game versions: The Burning Crusade Classic
5. Set release type: Release
6. Publish

#### Subsequent Updates
1. Go to addon page
2. Click "Upload new file"
3. Upload new .zip
4. Add changelog entry
5. Publish

### GitHub Setup (Optional but Recommended)

#### Initial Setup

```bash
# First time
git init
git add .
git commit -m "Initial commit: Crafter Todo v1.0.0"
git branch -M main
git remote add origin https://github.com/yourusername/CrafterTodo.git
git push -u origin main
```

#### Creating a Release (Automated Build)

The addon includes GitHub Actions workflows that automatically build and package the addon:

1. **Create a version tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Create a Release on GitHub**:
   - Go to your repository on GitHub
   - Click "Releases" → "Create a new release"
   - Select the tag you just created (e.g., `v1.0.0`)
   - Add a release title and description (paste from CHANGELOG)
   - Click "Publish release"

3. **Automated Build**:
   - GitHub Actions automatically detects the release
   - The `build-release.yml` workflow runs and builds the addon
   - A ZIP file (`CrafterTodo-v1.0.0.zip`) is automatically attached to the release
   - No manual build step needed!

#### GitHub Actions Workflows

The addon includes two automatic workflows:

**`build-release.yml`** (Automatic Release Builds)
- Triggers when a release is published
- Builds the addon package
- Attaches the ZIP file to the release
- No configuration needed

**`build-test.yml`** (Pull Request & Commit Validation)
- Triggers on commits and pull requests
- Validates addon files are present
- Validates .toc file format
- Builds test artifact for verification
- Ensures code quality before merging
Build Workflow Issues

**"GitHub Actions failing to build"**
- Check that all `.lua` and `.toc` files exist in the repo
- Verify the workflow file is in `.github/workflows/`
- Check GitHub Actions is enabled in repository settings
- View the failed workflow logs on GitHub's Actions tab

**"Release artifact not showing"**
- Ensure release is "Published", not "Draft"
- Allow 1-2 minutes for Actions to complete
- Check the Actions tab for workflow status
- Verify the repository has public access for Actions

### 
#### Manual Upload to CurseForge

After the release is created and artifacts are available:

1. Download the ZIP from the GitHub release
2. Go to CurseForge addon page
3. Click "Upload new file"
4. Select the ZIP file
5. Add changelog from CHANGELOG.md
6. Publish

Or use CurseForge API for automated uploads (advanced)

### Announcement (Optional)

- Post in WoW addon forums
- Share in relevant Discord communities
- Reddit: /r/wow, /r/classicwow

## Maintenance Checklist

### Regular Updates
- [ ] Monitor CurseForge comments for issues
- [ ] Respond to user feedback
- [ ] Fix reported bugs promptly
- [ ] Test with WoW patches

### Major Version Updates
- [ ] Plan features carefully
- [ ] Implement with proper testing
- [ ] Update documentation
- [ ] Create detailed changelog
- [ ] Tag release with version number

### Version Numbering

Use Semantic Versioning (MAJOR.MINOR.PATCH):
- **MAJOR**: Breaking changes, major features
- **MINOR**: New features, backwards compatible
- **PATCH**: Bug fixes, minor improvements

Examples:
- 1.0.0 - Initial release
- 1.1.0 - New feature added
- 1.1.1 - Bug fix
- 2.0.0 - Major rewrite/incompatible changes

## Common Issues & Solutions

### "Addon won't load"
- Verify .toc file has correct interface number
- Check filename matches folder name exactly
- Verify no syntax errors in Lua files

### "SavedVariables not persisting"
- Check SavedVariables name in .toc
- Verify SavedVariables directory exists
- Check file permissions in WoW directory

### "UI appears broken"
- Test at different UI scales
- Clear interface cache and reload
- Verify no conflicting addons

### "Shift+click not working"
- Ensure window is open
- Verify selected todo is materials type
- Check clicking valid item sources

## Release History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-02-26 | Initial release |
|  |  | - Core todo functionality |
|  |  | - Material tracking |
|  |  | - SavedVariables support |

---

**Last Updated**: 2025-02-26
**Maintainers**: Crafter Todo Team
