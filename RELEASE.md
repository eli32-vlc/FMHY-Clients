# Release Guide

This document explains how to create and publish releases for FMHY Clients.

## Automated Releases via GitHub Actions

The repository includes a GitHub Actions workflow that automatically builds all platforms when you push a git tag.

### Creating a Release

1. **Update version in package.json** (if needed):
```bash
npm version patch  # or minor, or major
```

2. **Create and push a tag**:
```bash
git tag v1.0.0
git push origin v1.0.0
```

3. **GitHub Actions will automatically**:
   - Build Linux AppImage
   - Build Windows portable EXE
   - Build macOS DMG
   - Build Android APK
   - Create a GitHub Release with all artifacts

### Manual Release

If you prefer to build manually:

```bash
# Run the build script
./build.sh

# Or build individual platforms
npm run build:linux    # Linux AppImage
npm run build:win      # Windows EXE (requires Wine on Linux)
npm run build:mac      # macOS DMG (macOS only)

# Android APK
npm run cap:sync
cd android && ./gradlew assembleRelease

# iOS IPA (macOS only)
npm run cap:open:ios
# Then in Xcode: Product → Archive → Export IPA
```

### Uploading to GitHub

1. Go to: https://github.com/eli32-vlc/FMHY-Clients/releases/new
2. Create a new tag (e.g., `v1.0.0`)
3. Set release title (e.g., "FMHY Client v1.0.0")
4. Add release notes
5. Upload the following files:
   - `dist/FMHY Client-*.AppImage` (Linux)
   - `dist/FMHY Client *.exe` (Windows)
   - `dist/FMHY Client-*.dmg` (macOS)
   - `android/app/build/outputs/apk/release/app-release.apk` (Android)
   - iOS IPA file (if built)
6. Click "Publish release"

## Download Icon from FMHY

Before building, ensure you have the correct icon:

```bash
# The prepare_icons.py script will attempt to download from:
# https://fmhy.net/test.png

python3 prepare_icons.py
```

If the download fails, the script creates a placeholder. You can manually download the icon and replace `desktop/icon.png`.

## Platform-Specific Notes

### Windows
- Requires Wine if building on Linux/macOS
- The portable EXE is unsigned (users may see warnings)
- To sign: Get a code signing certificate and use `electron-builder` options

### macOS
- Can only be built on macOS
- The DMG is unsigned (users may see warnings)
- To sign: Use an Apple Developer ID certificate
- To notarize: Use Apple's notarization service

### Linux
- AppImage works on most distributions
- No signing required for Linux

### Android
- APK is unsigned (for development)
- To sign for production: Generate a keystore and configure in `android/app/build.gradle`
- Users need to enable "Unknown Sources" to install

### iOS
- Can only be built on macOS with Xcode
- IPA requires signing with a provisioning profile
- For distribution: Use enterprise certificate or ad-hoc distribution
- Users need sideloading tools like AltStore or Sideloadly

## Version Management

Update version number in these files:
- `package.json` - Desktop app version
- `android/app/build.gradle` - Android version code and name
- `ios/App/App/Info.plist` - iOS version

Use consistent versioning across all platforms.

## Release Checklist

Before creating a release:

- [ ] Update version numbers
- [ ] Update CHANGELOG (if you have one)
- [ ] Test desktop app on at least one platform
- [ ] Test mobile build process
- [ ] Run icon preparation script
- [ ] Update documentation if needed
- [ ] Create git tag
- [ ] Push tag to trigger GitHub Actions
- [ ] Verify all builds complete successfully
- [ ] Download and test at least one build from each platform
- [ ] Write release notes
- [ ] Publish release on GitHub

## Continuous Deployment

The GitHub Actions workflow (`.github/workflows/build-release.yml`) handles:
- Multi-platform builds
- Artifact collection
- Automatic release creation

To modify the build process, edit `.github/workflows/build-release.yml`.

## Troubleshooting

**Build fails in GitHub Actions:**
- Check the Actions logs for specific errors
- Ensure all dependencies are correctly specified
- Test the build locally first

**Icon not showing:**
- Verify `desktop/icon.png` exists and is 512x512
- Run `python3 prepare_icons.py` to regenerate platform icons
- For iOS/Android, icons may be cached - clean and rebuild

**Android build fails:**
- Ensure Gradle can access Maven repositories
- Check Java version (JDK 17+ required)
- Clear Gradle cache: `cd android && ./gradlew clean`

**iOS build fails:**
- Verify Xcode is up to date
- Check provisioning profile and signing certificate
- Run `pod install` in `ios/App` directory
