#!/bin/bash
# Build script for FMHY Clients
# This script builds all desktop and mobile versions

set -e

echo "======================================"
echo "FMHY Clients Build Script"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Prepare icons
echo "📦 Preparing icons..."
python3 prepare_icons.py
echo ""

# Sync mobile assets
echo "📱 Syncing mobile assets..."
npm run cap:sync
echo ""

# Build desktop platforms
echo "💻 Building desktop applications..."

# Linux AppImage
echo -e "${YELLOW}Building Linux AppImage...${NC}"
if npx electron-builder --linux AppImage; then
    echo -e "${GREEN}✓ Linux AppImage built successfully${NC}"
else
    echo -e "${RED}✗ Linux AppImage build failed${NC}"
fi
echo ""

# Windows (requires Wine on Linux)
echo -e "${YELLOW}Building Windows portable...${NC}"
if command -v wine &> /dev/null; then
    if npx electron-builder --win portable --x64; then
        echo -e "${GREEN}✓ Windows portable built successfully${NC}"
    else
        echo -e "${RED}✗ Windows portable build failed${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Wine not installed, skipping Windows build${NC}"
    echo "  Install Wine to build Windows apps on Linux"
fi
echo ""

# macOS (only on macOS)
echo -e "${YELLOW}Building macOS DMG...${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    if npx electron-builder --mac dmg; then
        echo -e "${GREEN}✓ macOS DMG built successfully${NC}"
    else
        echo -e "${RED}✗ macOS DMG build failed${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Not on macOS, skipping macOS build${NC}"
    echo "  Run this script on macOS to build DMG"
fi
echo ""

# Android APK
echo "🤖 Building Android APK..."
if command -v gradle &> /dev/null || [ -f android/gradlew ]; then
    cd android
    if ./gradlew assembleRelease; then
        echo -e "${GREEN}✓ Android APK built successfully${NC}"
        echo "  Location: android/app/build/outputs/apk/release/app-release.apk"
    else
        echo -e "${RED}✗ Android APK build failed${NC}"
    fi
    cd ..
else
    echo -e "${YELLOW}⚠ Gradle not found, skipping Android build${NC}"
fi
echo ""

# iOS IPA
echo "🍎 Building iOS IPA..."
if [[ "$OSTYPE" == "darwin"* ]] && command -v xcodebuild &> /dev/null; then
    echo "Please build iOS app through Xcode:"
    echo "  1. Run: npm run cap:open:ios"
    echo "  2. In Xcode: Product → Archive"
    echo "  3. Export IPA file"
else
    echo -e "${YELLOW}⚠ Not on macOS with Xcode, skipping iOS build${NC}"
    echo "  iOS apps can only be built on macOS with Xcode installed"
fi
echo ""

# Summary
echo "======================================"
echo "Build Summary"
echo "======================================"
echo ""
echo "Built artifacts are in:"
echo "  Desktop: ./dist/"
echo "  Android: ./android/app/build/outputs/apk/release/"
echo "  iOS: Build through Xcode"
echo ""

if [ -d dist ]; then
    echo "Desktop builds:"
    ls -lh dist/*.AppImage dist/*.exe dist/*.dmg 2>/dev/null || echo "  (none found)"
fi

echo ""
echo "✨ Build process complete!"
