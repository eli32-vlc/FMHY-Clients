# Android Loading Fix - Technical Summary

## Problem Statement

The FMHY mobile application was experiencing loading issues on Android and macOS:

1. **Android**: App failed to load with "blocked by response error"
2. **macOS**: White screen on launch (already partially fixed in previous PR)
3. **APK Signing**: No configuration for signing release APKs

## Root Cause Analysis

### Android Issue
The primary issue was caused by Capacitor's `androidScheme: "https"` configuration in `capacitor.config.json`. This setting caused:
- CORS (Cross-Origin Resource Sharing) errors when loading external HTTPS content in iframes
- WebView blocking the iframe content due to mixed content policies
- The WebView treating the local app content and remote iframe content as having incompatible security contexts

### macOS Issue
The macOS white screen issue was already addressed in a previous PR #7 with:
- Window hidden until `ready-to-show` event
- Dark background color to prevent white flash
- `webSecurity: false` to bypass X-Frame-Options restrictions

## Solutions Implemented

### 1. Android Scheme Configuration
**File**: `capacitor.config.json`

Changed from `https` to `http` scheme:
```json
{
  "server": {
    "androidScheme": "http",
    "allowNavigation": [
      "https://fmhy.net",
      "https://*.fmhy.net"
    ]
  }
}
```

**Why this works**:
- The `http` scheme is Capacitor's default and bypasses CORS restrictions for iframe content
- The app content is still served locally and securely by the Capacitor runtime
- External HTTPS content (fmhy.net) can be loaded without CORS issues

### 2. Network Security Configuration
**File**: `android/app/src/main/res/xml/network_security_config.xml` (new)

Created a network security configuration that:
- Allows cleartext traffic for localhost (the Capacitor server)
- Explicitly allows HTTPS traffic to fmhy.net and subdomains
- Uses system certificate authorities for HTTPS validation
- Denies cleartext traffic for other domains by default

### 3. AndroidManifest Updates
**File**: `android/app/src/main/AndroidManifest.xml`

Added:
```xml
android:usesCleartextTraffic="true"
android:networkSecurityConfig="@xml/network_security_config"
```

### 4. MainActivity WebView Configuration
**File**: `android/app/src/main/java/net/fmhy/mobile/MainActivity.java`

Enhanced the WebView with:
- `MIXED_CONTENT_ALWAYS_ALLOW`: Allows HTTPS content in HTTP scheme WebView
- Hardware acceleration for better performance
- DOM storage and database support for web app functionality

### 5. APK Signing Configuration

#### Build System Changes
**File**: `android/app/build.gradle`

Added signing configuration that:
- Reads signing credentials from `keystore.properties` (git-ignored)
- Automatically signs release builds when credentials are available
- Falls back to unsigned builds if credentials are missing

#### Helper Scripts
Created two bash scripts:

1. **`setup-signing.sh`**: Interactive keystore generation
   - Guides users through creating a release keystore
   - Provides clear instructions for next steps
   - Warns about security best practices

2. **`build-android.sh`**: Simplified build process
   - Syncs Capacitor files automatically
   - Builds debug or release APKs
   - Provides clear output about signing status
   - Shows APK location after successful build

### 6. Documentation Updates

#### New Documentation
- **`ANDROID_SIGNING.md`**: Comprehensive APK signing guide
  - Step-by-step signing setup
  - Security best practices
  - Troubleshooting tips
  - Distribution options

#### Updated Documentation
- **`BUILD.md`**: Added Android signing section and troubleshooting
- **`README.md`**: Updated troubleshooting with Android-specific fixes
- **`.gitignore`**: Added patterns to exclude signing credentials

## Security Considerations

### What Changed
1. Android scheme changed from `https` to `http` (for local app content only)
2. Mixed content mode enabled to allow HTTPS iframes in HTTP scheme WebView
3. Network security configuration controls cleartext traffic

### Security Mitigations
1. **Network Security Config**: Only localhost gets cleartext, external traffic uses HTTPS
2. **Allow Navigation**: Restricts navigation to fmhy.net domains
3. **WebView Security**: Standard WebView security features remain active
4. **No Node Integration**: Desktop app maintains `nodeIntegration: false`
5. **Context Isolation**: Desktop app maintains `contextIsolation: true`
6. **Signing Keys**: Git-ignored to prevent accidental exposure

### Risk Assessment
- **Low Risk**: The app is a simple iframe wrapper without sensitive data handling
- **Controlled Environment**: Network security config limits security exceptions to necessary domains
- **Standard Practice**: Using `http` scheme is Capacitor's recommended approach for CORS avoidance
- **Desktop Unchanged**: Desktop security settings remain as previously configured

## Testing Recommendations

### Android Testing
1. Build debug APK: `./build-android.sh debug`
2. Install on Android device or emulator
3. Verify app loads and displays fmhy.net content
4. Test navigation within the site
5. Test orientation changes
6. Verify no console errors in logcat

### Signed APK Testing
1. Run `./setup-signing.sh` to create keystore
2. Create `android/keystore.properties` with credentials
3. Build signed APK: `./build-android.sh release`
4. Verify APK is signed: `jarsigner -verify -verbose android/app/build/outputs/apk/release/app-release.apk`
5. Install on device and test functionality

### macOS Testing
1. Run desktop app: `npm start`
2. Verify no white screen on launch
3. Verify iframe loads fmhy.net content
4. Test window resize and navigation

## Files Modified

### Configuration Files
- `capacitor.config.json` - Changed androidScheme, added allowNavigation
- `.gitignore` - Added signing credential patterns

### Android Files
- `android/app/build.gradle` - Added signing configuration
- `android/app/src/main/AndroidManifest.xml` - Added network security config reference
- `android/app/src/main/java/net/fmhy/mobile/MainActivity.java` - Enhanced WebView settings
- `android/app/src/main/res/xml/network_security_config.xml` - New file

### Scripts
- `setup-signing.sh` - New helper script
- `build-android.sh` - New build script

### Documentation
- `ANDROID_SIGNING.md` - New comprehensive guide
- `BUILD.md` - Updated with signing instructions
- `README.md` - Updated troubleshooting section

## Expected Results

### Android
- ✅ App loads successfully without CORS errors
- ✅ iframe displays fmhy.net content
- ✅ No "blocked by response" errors
- ✅ Smooth navigation and interaction
- ✅ Can build signed release APKs

### macOS/Desktop
- ✅ No white screen on launch (already fixed)
- ✅ iframe loads correctly
- ✅ Proper error handling and logging

## Future Improvements

Potential enhancements for future consideration:
1. Add automated testing for Android builds
2. Consider implementing App Bundle (AAB) support for Play Store
3. Add CI/CD pipeline for automated APK building
4. Consider implementing update notifications
5. Add analytics or error reporting (if desired)

## Rollback Plan

If issues occur, revert these commits:
1. The Android scheme and configuration changes
2. Restore previous `capacitor.config.json`
3. Run `npm run cap:sync` to reset Android project
4. The signing configuration is additive and can be left in place

## References

- [Capacitor Android Configuration](https://capacitorjs.com/docs/android/configuration)
- [Android Network Security Config](https://developer.android.com/training/articles/security-config)
- [Capacitor iOS/Android Differences](https://capacitorjs.com/docs/guides/deploying-updates)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
