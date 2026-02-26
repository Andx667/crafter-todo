# GitHub Repository Setup Instructions

The CrafterTodo addon has been initialized as a local git repository. Follow these steps to push it to GitHub:

## Step 1: Create Repository on GitHub

1. Go to https://github.com/new
2. Enter repository name: `CrafterTodo`
3. Enter description: `A World of Warcraft Burning Crusade addon for crafting todo lists and note-taking`
4. Choose visibility: **Public** (for addon distribution)
5. **Do NOT** initialize with README, .gitignore, or license (we already have these)
6. Click **Create repository**

## Step 2: Add Remote and Push

Copy and run these commands in PowerShell (from the CrafterTodo folder):

```powershell
# Replace 'yourusername' with your actual GitHub username!
git remote add origin https://github.com/yourusername/CrafterTodo.git
git branch -M main
git push -u origin main
```

## Step 3: Create Initial Release Tag (Optional)

After pushing, create the first release:

```powershell
git tag v1.0.0
git push origin v1.0.0
```

Then go to GitHub and create a release from the `v1.0.0` tag. The GitHub Actions workflow will automatically build and attach the addon ZIP file.

## Automated Features Ready

Once pushed, your repository will have:

✅ **GitHub Actions Workflows**
- Automatic build on release publication
- Pull request validation
- Test builds on commits

✅ **Issue Templates**
- Bug report form
- Feature request form

✅ **PR Template**
- Standardized pull request checklist

✅ **Documentation**
- DEVELOPMENT.md - Development guide
- RELEASE.md - Release process
- CONTRIBUTING.md - Contribution guidelines

## Quick Command Summary

```powershell
cd c:\Users\andyb\Workspace\TTT\CrafterTodo

# After creating repo on GitHub:
git remote add origin https://github.com/yourusername/CrafterTodo.git
git branch -M main
git push -u origin main

# To create releases:
git tag v1.0.0
git push origin v1.0.0
# Then create release on GitHub website
```

**Note**: Replace `yourusername` with your actual GitHub username!
