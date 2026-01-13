# Testing Instructions

This document provides step-by-step instructions for testing the Android loading fixes and APK signing features.

## Prerequisites

- Node.js v20+ and npm installed
- Android Studio with Android SDK
- Java JDK 17+ (for APK signing)
- An Android device or emulator

## Part 1: Test Android App Loading (Debug Build)

### Step 1: Setup and Sync

```bash
# Install dependencies
npm install

# Sync Capacitor files to apply new configuration
npm run cap:sync
```

**Expected Result**: Sync should complete without errors, showing updates to Android project.

### Step 2: Build Debug APK

Option A - Using the build script:
```bash
./build-android.sh debug
```

Option B - Manual build:
```bash
cd android
./gradlew assembleDebug
cd ..
```

**Expected Result**: 
- Build completes successfully
- APK created at: `android/app/build/outputs/apk/debug/app-debug.apk`

### Step 3: Install on Android Device

1. Enable "Install from Unknown Sources" in Android Settings
2. Transfer the APK to your device or use ADB:
   ```bash
   adb install android/app/build/outputs/apk/debug/app-debug.apk
   ```

### Step 4: Test the App

Launch the FMHY app on your Android device and verify:

- ✅ App launches without white screen
- ✅ fmhy.net content loads in the iframe
- ✅ No "blocked by response" error
- ✅ Content is interactive (can click links, scroll, etc.)
- ✅ Navigation within fmhy.net works
- ✅ App survives orientation changes
- ✅ App can be reopened after being closed

### Step 5: Check Logcat (Optional)

To see detailed logs:
```bash
adb logcat | grep -i fmhy
```

**Expected Result**: No CORS errors, no "net::ERR_ACCESS_DENIED" errors

---

## Part 2: Test APK Signing (Release Build)

### Step 1: Generate Keystore

```bash
./setup-signing.sh
```

Follow the prompts to create a keystore. When asked, provide:
- Keystore password (e.g., "MySecurePassword123")
- Key password (can be the same as keystore password)
- Your details (name, organization, city, country)

**Expected Result**: 
- Keystore created at: `android/app/fmhy-release-key.keystore`
- Script displays next steps

### Step 2: Create keystore.properties

Create the file `android/keystore.properties`:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=fmhy-release-key
storeFile=app/fmhy-release-key.keystore
```

Replace `YOUR_KEYSTORE_PASSWORD` and `YOUR_KEY_PASSWORD` with the passwords you set in Step 1.

### Step 3: Build Signed Release APK

```bash
./build-android.sh release
```

**Expected Result**:
- Build completes successfully
- APK created at: `android/app/build/outputs/apk/release/app-release.apk`
- Script confirms APK is SIGNED

### Step 4: Verify APK Signature

```bash
jarsigner -verify -verbose -certs android/app/build/outputs/apk/release/app-release.apk
```

**Expected Result**: Output should say "jar verified"

### Step 5: Test Signed APK

1. Install the signed APK on your device:
   ```bash
   adb install android/app/build/outputs/apk/release/app-release.apk
   ```

2. Test all functionality (same as Part 1, Step 4)

**Expected Result**: Signed APK works identically to debug APK

---

## Part 3: Test macOS/Desktop App (Optional)

### Step 1: Run Desktop App

```bash
npm start
```

**Expected Result**:
- Electron window opens with dark background (no white flash)
- fmhy.net content loads in the iframe
- No white screen issue

### Step 2: Test Desktop Functionality

Verify:
- ✅ Window can be resized
- ✅ Content loads and is interactive
- ✅ Navigation within fmhy.net works
- ✅ No console errors (check with Ctrl+Shift+I or Cmd+Option+I)

---

## Troubleshooting

### Build Errors

**Error: "npm: command not found"**
- Install Node.js from https://nodejs.org/

**Error: "gradlew: Permission denied"**
```bash
chmod +x android/gradlew
```

**Error: "JAVA_HOME not set"**
- Install JDK 17+ and set JAVA_HOME environment variable

**Error: "SDK location not found"**
- Open Android Studio and install Android SDK
- Or set ANDROID_HOME environment variable

### Installation Errors

**Error: "App not installed"**
- Enable "Install from Unknown Sources" in Android Settings
- Uninstall any previous version of the app first
- Clear Google Play Store cache

**Error: "Unsigned APK cannot be installed"**
- This shouldn't happen with our configuration
- Check that keystore.properties exists for release builds
- Use debug APK for testing if signing fails

### Runtime Errors

**White screen on Android**
- Check internet connection
- Check logcat for errors: `adb logcat | grep -i error`
- Try clearing app data in Android Settings

**"net::ERR_CLEARTEXT_NOT_PERMITTED"**
- This shouldn't happen with our network security config
- Verify `network_security_config.xml` exists
- Verify AndroidManifest references the network security config

**Content not loading**
- Check internet connection
- Verify fmhy.net is accessible in a browser
- Check if device has DNS issues

---

## Success Criteria

All tests pass if:

1. ✅ Debug APK builds successfully
2. ✅ Debug APK installs on Android device
3. ✅ App launches and loads fmhy.net content without errors
4. ✅ No white screen or "blocked by response" errors
5. ✅ Keystore can be generated with setup script
6. ✅ Signed release APK builds successfully
7. ✅ Signed APK signature can be verified
8. ✅ Signed APK works identically to debug APK
9. ✅ Desktop app works without white screen (macOS)

---

## Reporting Issues

If you encounter any issues during testing, please provide:

1. **Environment Details**:
   - Operating system (for building)
   - Android version (on device)
   - Node.js version (`node --version`)
   - Java version (`java -version`)

2. **Error Messages**:
   - Complete error output from build commands
   - Logcat output from device (`adb logcat`)
   - Screenshots of any error screens

3. **Steps to Reproduce**:
   - Exact commands you ran
   - What you expected to happen
   - What actually happened

4. **Build Artifacts**:
   - Build log files
   - Gradle output
   - APK if possible (for debugging)

---

## Additional Testing (Optional)

### Memory and Performance Testing

1. Open Android Studio Profiler
2. Connect device and launch app
3. Monitor:
   - Memory usage (should be stable)
   - CPU usage (should be low when idle)
   - Network activity (should only connect to fmhy.net)

### Security Testing

1. Check network traffic with proxy (e.g., Charles, mitmproxy)
2. Verify HTTPS is used for fmhy.net
3. Verify no sensitive data is transmitted
4. Verify app doesn't make unexpected network requests

### Compatibility Testing

Test on multiple Android versions if possible:
- Android 8.0 (API 26) - minimum supported
- Android 10 (API 29)
- Android 12 (API 31)
- Android 13+ (API 33+) - latest

---

## Cleanup

After testing, you may want to keep or backup:
- ✅ Keep: `android/keystore.properties` (backed up securely)
- ✅ Keep: `android/app/fmhy-release-key.keystore` (backed up securely)
- ❌ Delete: `android/app/build/` (build artifacts, can be regenerated)
- ❌ Delete: Debug APKs (after testing complete)

**NEVER commit these to git:**
- `android/keystore.properties`
- `android/app/*.keystore`
- These are already in `.gitignore`
