# Quick Start Guide

Get up and running with FMHY-Clients in minutes!

## 🚀 For Desktop Users (Windows, macOS, Linux)

### Option 1: Run from Source
```bash
# Clone the repository
git clone https://github.com/eli32-vlc/FMHY-Clients.git
cd FMHY-Clients

# Install dependencies
npm install

# Launch the application
npm start
```

### Option 2: Download Pre-built Binaries
_(Coming soon - once releases are published)_

1. Go to [Releases](https://github.com/eli32-vlc/FMHY-Clients/releases)
2. Download the appropriate file for your platform:
   - **Windows**: `.exe` installer or portable
   - **macOS**: `.dmg` installer
   - **Linux**: `.AppImage`, `.deb`, or `.rpm`
3. Install and run!

---

## 📱 For Mobile Users (iOS, Android)

### For Developers

#### iOS
1. **Requirements**: macOS with Xcode installed
2. Clone the repo and install dependencies:
   ```bash
   git clone https://github.com/eli32-vlc/FMHY-Clients.git
   cd FMHY-Clients
   npm install
   ```
3. Sync and open in Xcode:
   ```bash
   npm run cap:sync
   cd ios/App && pod install && cd ../..
   npm run cap:open:ios
   ```
4. In Xcode: Select your team, device/simulator, and click Run ▶

#### Android
1. **Requirements**: Android Studio installed
2. Clone the repo and install dependencies:
   ```bash
   git clone https://github.com/eli32-vlc/FMHY-Clients.git
   cd FMHY-Clients
   npm install
   ```
3. Sync and open in Android Studio:
   ```bash
   npm run cap:sync
   npm run cap:open:android
   ```
4. In Android Studio: Wait for Gradle sync, select device/emulator, click Run ▶

### For End Users
_(Coming soon - once published to app stores)_
- **iOS**: Download from the App Store
- **Android**: Download from Google Play Store or sideload the APK

---

## ✨ What You Get

A simple, lightweight native application that displays [FMHY.net](https://fmhy.net) in a clean interface:

- ✅ Native window/app experience
- ✅ Full functionality of FMHY.net
- ✅ Responsive design for all screen sizes
- ✅ Secure iframe implementation
- ✅ Cross-platform consistency

---

## 🛠 Building Your Own

Want to customize or build distribution packages?

### Desktop
```bash
# Build for your current platform
npm run build

# Or build for specific platforms
npm run build:win      # Windows
npm run build:mac      # macOS
npm run build:linux    # Linux
```

### Mobile
See the detailed [BUILD.md](BUILD.md) guide for iOS and Android build instructions.

---

## 📚 Need More Help?

- **Full Documentation**: [README.md](README.md)
- **Detailed Build Instructions**: [BUILD.md](BUILD.md)
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **Issues/Questions**: [GitHub Issues](https://github.com/eli32-vlc/FMHY-Clients/issues)

---

## 🔐 Security Note

This application displays https://fmhy.net in an iframe with proper Content Security Policy. No user data is collected or stored by the application itself.

---

**Enjoy your native FMHY experience! 🎉**
