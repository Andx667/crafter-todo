# GitHub Configuration

This directory contains GitHub-specific configuration files for the Crafter Todo addon project.

## Contents

### Workflows (`.github/workflows/`)

**`build-release.yml`**
- Automatically builds the addon when a release is published
- Creates a ZIP package with all addon files
- Attaches the ZIP to the GitHub release
- No manual configuration needed - just publish a release!

**`build-test.yml`**
- Validates addon files on every push and pull request
- Checks .toc file format
- Ensures all required files are present
- Stores build artifacts for testing

### Issue & PR Templates

**Issue Templates**
- `ISSUE_TEMPLATE/bug_report.md` - Template for bug reports
- `ISSUE_TEMPLATE/feature_request.md` - Template for feature requests

**PR Template**
- `pull_request_template.md` - Template for pull requests

These templates help maintainers and contributors follow a consistent format.

## Quick Start for Releases

1. Update version in `CrafterTodo.toc` and `CHANGELOG.md`
2. Commit changes: `git commit -m "Release v1.1.0"`
3. Tag the commit: `git tag v1.1.0`
4. Push: `git push origin main --tags`
5. Create release on GitHub from the tag
6. GitHub Actions automatically builds and attaches the ZIP!

## Workflow Status

You can monitor workflow status at:
- `https://github.com/yourusername/CrafterTodo/actions`

## Security Notes

- Workflows use `secrets.GITHUB_TOKEN` for authentication
- No personal credentials stored
- Release artifacts are publicly accessible
- Only maintainers can trigger releases

## Customization

To customize workflows:
1. Edit `.github/workflows/*.yml`
2. Use [GitHub Actions documentation](https://docs.github.com/en/actions)
3. Test changes in a feature branch first
