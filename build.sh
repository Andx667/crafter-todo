#!/bin/bash
# Crafter Todo - Build Script for CurseForge (Linux/macOS)

# Get version from .toc file
VERSION=$(grep "^## Version:" CrafterTodo.toc | awk '{print $3}')

if [ -z "$VERSION" ]; then
    echo "Error: Could not find version in CrafterTodo.toc"
    exit 1
fi

echo "Building Crafter Todo v$VERSION..."

# Create build directory
rm -rf build
mkdir -p build/CrafterTodo

# Copy addon files
cp CrafterTodo.toc build/CrafterTodo/
cp core.lua build/CrafterTodo/
cp data.lua build/CrafterTodo/
cp ui.lua build/CrafterTodo/
cp localization.lua build/CrafterTodo/
cp LICENSE build/CrafterTodo/
cp README.md build/CrafterTodo/
cp CHANGELOG.md build/CrafterTodo/
cp CONTRIBUTING.md build/CrafterTodo/

# Create distribution zip
mkdir -p dist
cd build
zip -r ../dist/CrafterTodo-v${VERSION}.zip CrafterTodo/
cd ..

echo ""
echo "Build complete!"
echo "Output: dist/CrafterTodo-v${VERSION}.zip"
echo ""
echo "Next steps:"
echo "1. Test the addon in WoW"
echo "2. Upload to CurseForge"
echo "3. Create GitHub release with version tag"
