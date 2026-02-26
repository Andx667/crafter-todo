@echo off
REM Crafter Todo - Build Script for CurseForge
REM This script packages the addon for release

setlocal enabledelayedexpansion

REM Get version from .toc file
for /f "tokens=2" %%A in ('findstr /R "## Version:" CrafterTodo.toc') do set VERSION=%%A

if "%VERSION%"=="" (
    echo Error: Could not find version in CrafterTodo.toc
    exit /b 1
)

echo Building Crafter Todo v%VERSION%...

REM Create build directory
if exist "build" rmdir /s /q build
mkdir build\CrafterTodo

REM Copy addon files
copy CrafterTodo.toc build\CrafterTodo\
copy core.lua build\CrafterTodo\
copy data.lua build\CrafterTodo\
copy ui.lua build\CrafterTodo\
copy localization.lua build\CrafterTodo\
copy LICENSE build\CrafterTodo\
copy README.md build\CrafterTodo\
copy CHANGELOG.md build\CrafterTodo\
copy CONTRIBUTING.md build\CrafterTodo\

REM Create distribution zip
if exist "dist" rmdir /s /q dist
mkdir dist

cd build
powershell -Command "Compress-Archive -Path CrafterTodo -DestinationPath ..\dist\CrafterTodo-v%VERSION%.zip -Force"
cd ..

echo.
echo Build complete!
echo Output: dist\CrafterTodo-v%VERSION%.zip
echo.
echo Next steps:
echo 1. Test the addon in WoW
echo 2. Upload to CurseForge
echo 3. Create GitHub release with version tag
pause
