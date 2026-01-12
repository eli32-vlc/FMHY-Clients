# FMHY-Clients

Multi-platform client applications for [FMHY.net](https://fmhy.net) (FreeMediaHeckYeah). These are simple iframe-based clients that provide a native application experience across desktop and mobile platforms.

## Platforms Supported

- **Desktop**: Windows, macOS, Linux (via Electron)
- **Mobile**: iOS, Android (via Capacitor)

## Prerequisites

### For Desktop Builds
- Node.js (v20 or higher)
- npm or yarn

### For iOS Builds
- macOS with Xcode installed
- CocoaPods (`sudo gem install cocoapods`)

### For Android Builds
- Android Studio
- Java Development Kit (JDK) 17 or higher
- Android SDK

## Installation

1. Clone the repository:
```bash
git clone https://github.com/eli32-vlc/FMHY-Clients.git
cd FMHY-Clients
```

2. Install dependencies:
```bash
npm install
```

## Desktop Application

### Running Desktop App (Development)

```bash
npm start
```

### Building Desktop Apps

#### Build for all platforms:
```bash
npm run build
```

#### Build for specific platforms:

**Windows:**
```bash
npm run build:win
```
This creates installers in the `dist/` directory:
- NSIS installer (.exe)
- Portable executable

**macOS:**
```bash
npm run build:mac
```
This creates:
- DMG installer
- ZIP archive

**Linux:**
```bash
npm run build:linux
```
This creates:
- AppImage (universal Linux package)
- DEB package (Debian/Ubuntu)
- RPM package (Fedora/RedHat)

Built applications will be available in the `dist/` directory.

## Mobile Applications

### iOS

1. Sync Capacitor files:
```bash
npm run cap:sync
```

2. Open in Xcode:
```bash
npm run cap:open:ios
```

3. In Xcode:
   - Select your development team
   - Connect an iOS device or select a simulator
   - Click the Run button

### Android

1. Sync Capacitor files:
```bash
npm run cap:sync
```

2. Open in Android Studio:
```bash
npm run cap:open:android
```

3. In Android Studio:
   - Wait for Gradle sync to complete
   - Connect an Android device or start an emulator
   - Click the Run button

### Alternative: Build from Command Line

**iOS** (requires macOS):
```bash
npm run cap:run:ios
```

**Android**:
```bash
npm run cap:run:android
```

## Project Structure

```
FMHY-Clients/
├── desktop/              # Electron desktop application
│   ├── main.js          # Electron main process
│   ├── index.html       # Main window with iframe
│   └── icon.png         # Application icon (placeholder)
├── mobile/              # Capacitor mobile web assets
│   └── index.html       # Mobile web view with iframe
├── ios/                 # iOS native project (generated)
├── android/             # Android native project (generated)
├── capacitor.config.json # Capacitor configuration
└── package.json         # Node.js project configuration
```

## Features

- Simple iframe wrapper for FMHY.net
- Native window controls and system integration
- Responsive design for all screen sizes
- Content Security Policy for enhanced security
- Cross-platform consistency

## Security Note

This application uses iframes to display content from https://fmhy.net. The Content Security Policy is configured to only allow framing from the official FMHY domain.

## Customization

### Changing the Icon

Replace the placeholder `desktop/icon.png` with your custom icon:
- Desktop: 512x512 PNG file
- iOS: Update icon in Xcode project
- Android: Update icon in Android Studio (res/mipmap directories)

### Modifying the URL

To point to a different URL, edit:
- Desktop: `desktop/index.html` - change the iframe `src` attribute
- Mobile: `mobile/index.html` - change the iframe `src` attribute

## Troubleshooting

### Desktop Build Issues
- Ensure you have the latest version of Node.js
- Clear node_modules and reinstall: `rm -rf node_modules && npm install`
- Check that icon files exist (or remove icon references from package.json)

### iOS Build Issues
- Run `pod install` in the `ios/App` directory
- Ensure you have a valid Apple Developer account for device deployment
- Check Xcode version compatibility

### Android Build Issues
- Ensure JAVA_HOME is set correctly
- Update Android SDK via Android Studio
- Run `./gradlew clean` in the `android/` directory

## License

ISC

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
