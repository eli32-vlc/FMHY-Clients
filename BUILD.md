# Build Instructions

This document provides detailed instructions for building the FMHY client for each platform.

## Desktop Platforms

### Prerequisites
- Node.js v20+ and npm installed
- Git

### Quick Start
```bash
# Clone and install
git clone https://github.com/eli32-vlc/FMHY-Clients.git
cd FMHY-Clients
npm install

# Run in development mode
npm start
```

### Building for Distribution

#### Windows
```bash
npm run build:win
```
**Outputs** (in `dist/` directory):
- `FMHY Client Setup x.x.x.exe` - NSIS installer
- `FMHY Client x.x.x.exe` - Portable executable

#### macOS
```bash
npm run build:mac
```
**Outputs** (in `dist/` directory):
- `FMHY Client-x.x.x.dmg` - DMG installer
- `FMHY Client-x.x.x-mac.zip` - ZIP archive

**Note**: On macOS, you may need to sign the app with a Developer ID for distribution.

#### Linux
```bash
npm run build:linux
```
**Outputs** (in `dist/` directory):
- `FMHY Client-x.x.x.AppImage` - Universal Linux package
- `fmhy-client_x.x.x_amd64.deb` - Debian/Ubuntu package
- `fmhy-client-x.x.x.x86_64.rpm` - Fedora/RedHat package

### Custom Icon
To add a custom icon:
1. Create a 512x512 PNG file
2. Replace `desktop/icon.png.txt` with `desktop/icon.png`
3. Update the icon references in `package.json` if needed

---

## Mobile Platforms

### iOS

#### Prerequisites
- macOS with Xcode 14+ installed
- CocoaPods: `sudo gem install cocoapods`
- iOS Developer account (for device deployment)

#### Building for iOS

1. **Sync Capacitor files**:
```bash
npm run cap:sync
```

2. **Install CocoaPods dependencies**:
```bash
cd ios/App
pod install
cd ../..
```

3. **Open in Xcode**:
```bash
npm run cap:open:ios
```

4. **Configure in Xcode**:
   - Select the App target
   - Go to "Signing & Capabilities"
   - Select your development team
   - Choose a unique bundle identifier if needed

5. **Build and Run**:
   - Select a device or simulator
   - Click the Run button (▶) or press Cmd+R

#### Distribution (iOS)
1. In Xcode, select "Any iOS Device"
2. Product → Archive
3. Export IPA for ad-hoc distribution or enterprise deployment

---

### Android

#### Prerequisites
- Android Studio installed
- Java Development Kit (JDK) 17+
- Android SDK with API level 33+

#### Building for Android

1. **Sync Capacitor files**:
```bash
npm run cap:sync
```

2. **Open in Android Studio**:
```bash
npm run cap:open:android
```

3. **Wait for Gradle sync** (first time may take several minutes)

4. **Configure signing** (for release builds):
   - Generate a keystore: Tools → Generate Signed Bundle/APK
   - Or use an existing keystore

5. **Build and Run**:
   - Select a device/emulator from the dropdown
   - Click Run (▶) or press Shift+F10

#### Build APK (Debug)
```bash
cd android
./gradlew assembleDebug
```
Output: `android/app/build/outputs/apk/debug/app-debug.apk`

#### Build APK (Release)
```bash
cd android
./gradlew assembleRelease
```
Output: `android/app/build/outputs/apk/release/app-release.apk`

---

---

## Platform-Specific Notes

### Windows
- The first build may take longer as electron-builder downloads dependencies
- Windows Defender may flag the portable executable - this is normal for unsigned apps

### macOS
- Unsigned apps will show a security warning on first launch
- Users need to right-click → Open to bypass Gatekeeper
- For proper distribution, sign with an Apple Developer ID

### Linux
- AppImage works on most distributions without installation
- DEB packages work on Debian, Ubuntu, Linux Mint, etc.
- RPM packages work on Fedora, RedHat, CentOS, etc.

### iOS
- Requires a Mac for building
- Free Apple ID allows testing on personal devices (7-day limit)
- For distribution, export IPA for sideloading or enterprise deployment

### Android
- Can be built on any platform (Windows, macOS, Linux)
- APK builds can be sideloaded on any Android device
- Enable "Install from Unknown Sources" in Android settings to install APK

---

## Testing the Applications

### Desktop
After building, test the application by:
1. Running the built executable
2. Verifying the iframe loads https://fmhy.net
3. Testing window resize and basic navigation

### Mobile
After installing on device:
1. Launch the app
2. Verify the webview loads https://fmhy.net
3. Test orientation changes
4. Verify safe area handling on devices with notches

---

## Troubleshooting

### Desktop Build Errors
- **Error: "Cannot find module electron"**: Run `npm install`
- **Build fails with icon error**: Remove icon references from `package.json` temporarily

### iOS Build Errors
- **CocoaPods errors**: Delete `ios/App/Pods` and `ios/App/Podfile.lock`, then run `pod install`
- **Signing errors**: Ensure you have a valid development team selected
- **Build fails**: Try cleaning (Cmd+Shift+K) and rebuilding

### Android Build Errors
- **Gradle sync fails**: Check that JDK 17+ is installed and JAVA_HOME is set
- **SDK not found**: Open Android Studio SDK Manager and install required components
- **Build fails**: Try `./gradlew clean` in the android directory

---

## Advanced Configuration

### Changing the URL
To point to a different website:
1. Edit `desktop/index.html` - change the iframe `src`
2. Edit `mobile/index.html` - change the iframe `src`
3. Update the CSP in both files to allow the new domain
4. Run `npm run cap:sync` for mobile platforms

### Customizing the App Name
- **Desktop**: Edit `productName` in `package.json`
- **iOS**: Edit in Xcode project settings
- **Android**: Edit `strings.xml` in `android/app/src/main/res/values/`

### Enabling Developer Tools
For desktop app, uncomment this line in `desktop/main.js`:
```javascript
mainWindow.webContents.openDevTools();
```
