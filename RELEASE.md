# Release Guide for Crafter Todo

This guide explains how to create releases for the Crafter Todo addon.

## Pre-Release Checklist

Before creating a release, ensure:

- [ ] All features are complete and tested
- [ ] No open critical bugs
- [ ] Code has been reviewed
- [ ] Tests pass (check GitHub Actions)
- [ ] Documentation is updated (README, CONTRIBUTING, etc.)
- [ ] User-facing changes are clear and documented

## Version Numbering

Use [Semantic Versioning](https://semver.org/):

- **MAJOR.MINOR.PATCH** (e.g., 1.2.3)
  - **MAJOR**: Breaking changes or major overhauls
  - **MINOR**: New features, backwards compatible
  - **PATCH**: Bug fixes, minor improvements

Examples:
- `1.0.0` - Initial release
- `1.1.0` - New feature(s) added
- `1.1.1` - Bug fix
- `2.0.0` - Major rewrite with breaking changes

## Release Process

### 1. Update Version Number

#### Update `CrafterTodo.toc`
```
## Version: 1.1.0
```

#### Update `CHANGELOG.md`
Add new section at the top:
```markdown
## [1.1.0] - 2025-02-26

### Added
- New materialslist management feature
- Improved UI responsiveness

### Fixed
- Issue with window positioning
```

### 2. Commit Changes

```bash
git add CrafterTodo.toc CHANGELOG.md
git commit -m "Bump version to 1.1.0"
git push origin main
```

### 3. Create Git Tag

```bash
git tag v1.1.0
git push origin v1.1.0
```

### 4. Create GitHub Release

**Option A: Via Web Interface (Recommended)**

1. Go to your repository: `https://github.com/yourusername/CrafterTodo`
2. Click **"Releases"** in the sidebar
3. Click **"Create a new release"**
4. Select tag: `v1.1.0`
5. Fill in release details:
   - **Title**: `Version 1.1.0 - Feature Release`
   - **Description**: Copy from CHANGELOG.md
6. Click **"Publish release"**

**Option B: Via GitHub CLI**

```bash
gh release create v1.1.0 \
  --title "Version 1.1.0" \
  --notes-file CHANGELOG.md
```

### 5. Automated Build

Once the release is published:
- GitHub Actions triggers automatically
- `build-release.yml` workflow runs
- Addon is built and packaged
- ZIP file is attached to the release (wait 1-2 minutes)

**Monitor progress:**
- Go to **"Actions"** tab on GitHub
- Watch the workflow run complete
- Check that the artifact is attached to the release

### 6. Upload to CurseForge (Optional but Recommended)

1. **Download the ZIP** from the release page
2. **Go to CurseForge:**
   - https://www.curseforge.com/wow/addons/crafter-todo
   - Click **"Upload new file"**
3. **Select the ZIP** file
4. **Add changelog:**
   - Copy from CHANGELOG.md
5. **Release type:** Select "Release"
6. **Game versions:** Select "The Burning Crusade Classic"
7. **Click "Upload"**

### 7. Mark as Latest Release (If Applicable)

- Go to Releases page
- Older releases can be marked as "pre-release" if needed
- Ensure latest version is clearly marked

## Automated Build Details

### What Gets Built

The GitHub Actions workflow includes:
- `CrafterTodo.toc` - Addon manifest
- `core.lua` - Core functionality
- `data.lua` - Data management
- `ui.lua` - User interface
- `localization.lua` - Localization
- `LICENSE` - MIT License
- `README.md` - User documentation
- `CHANGELOG.md` - Version history
- `CONTRIBUTING.md` - Contributing guide

### Build Output

File: `CrafterTodo-v1.1.0.zip`
- Automatically created
- Automatically attached to release
- Ready for distribution

## Rollback (If Needed)

If a release has critical issues:

```bash
# Delete the release on GitHub (via web interface)
# Keep the tag for reference or:
git tag -d v1.1.0
git push origin :v1.1.0
```

Then fix issues and create a new release.

## Release Announcement

After successful release:

- [ ] Post announcement in WoW forums
- [ ] Share in relevant Discord communities
- [ ] Update project website/wiki if applicable
- [ ] Monitor for user feedback/bug reports

## Troubleshooting

### GitHub Actions Failed

1. Check the failed workflow in the **"Actions"** tab
2. Review error logs
3. Common issues:
   - File paths incorrect
   - Missing ZIP utility
   - Token permissions
4. Fix and re-tag if needed

### Artifact Not Attached

- Wait 2-3 minutes after publishing release
- Refresh the release page
- Check Actions tab for workflow status
- If still missing, manually download build artifact and attach

### CurseForge Upload Issues

- Verify account permissions
- Check file size limits
- Ensure ZIP is valid and not corrupted
- Try uploading again or try web interface

## Maintenance Note

The automated build workflow ensures every release has a production-ready ZIP file. This eliminates manual build errors and keeps releases consistent.

---

**Need help?** Check [DEVELOPMENT.md](./DEVELOPMENT.md) for more details.
