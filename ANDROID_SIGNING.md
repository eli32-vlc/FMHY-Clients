# Android APK Signing Guide

This guide explains how to sign your Android APK for distribution.

## Why Sign Your APK?

Android requires all APKs to be digitally signed before they can be installed on devices. A signed APK:
- Verifies the app's authenticity
- Allows users to install it on their devices
- Is required for distribution on app stores or direct download

## Quick Start

### 1. Generate a Keystore

Run the setup script from the project root:

```bash
./setup-signing.sh
```

This will guide you through creating a keystore. You'll be asked to provide:
- **Keystore password**: Choose a strong password and remember it!
- **Key alias**: Default is `fmhy-release-key` (recommended)
- **Key password**: Can be the same as keystore password
- **Your details**: Name, organization, city, country, etc.

The keystore will be created at: `android/app/fmhy-release-key.keystore`

### 2. Create keystore.properties

Create a file named `keystore.properties` in the `android/` directory with the following content:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=fmhy-release-key
storeFile=app/fmhy-release-key.keystore
```

Replace:
- `YOUR_KEYSTORE_PASSWORD` with the password you set for the keystore
- `YOUR_KEY_PASSWORD` with the password you set for the key
- Keep the alias and storeFile as shown (unless you used different values)

### 3. Build Signed APK

Run the build script:

```bash
./build-android.sh release
```

The signed APK will be created at:
```
android/app/build/outputs/apk/release/app-release.apk
```

## Important Security Notes

⚠️ **Keep these files safe and NEVER commit them to git:**
- `android/app/fmhy-release-key.keystore` - Your keystore file
- `android/keystore.properties` - Contains your passwords

These files are already in `.gitignore` to prevent accidental commits.

✅ **Back up your keystore!**
- Store it in a secure location (encrypted backup, password manager, etc.)
- You'll need it to update your app in the future
- If you lose it, you won't be able to update your published app

## Verifying Your Signed APK

To verify that your APK is properly signed, run:

```bash
jarsigner -verify -verbose -certs android/app/build/outputs/apk/release/app-release.apk
```

You should see "jar verified" in the output.

## Troubleshooting

### "keytool: command not found"

Make sure Java JDK is installed and in your PATH:
```bash
java -version
keytool -help
```

### "keystore.properties not found" when building

Make sure you've created the `android/keystore.properties` file with your signing details.

### "Keystore file does not exist"

Check that the `storeFile` path in `keystore.properties` is correct. It should be relative to the `android/` directory.

### Forgot keystore password

Unfortunately, there's no way to recover a lost keystore password. You'll need to create a new keystore, which means:
- Users with the old version won't be able to update to the new version
- You'll need to distribute as a completely new app

This is why backing up your keystore and passwords is critical!

## Manual Signing (Alternative Method)

If you prefer to sign manually or the automated process doesn't work:

### 1. Build unsigned release APK

```bash
cd android
./gradlew assembleRelease
```

### 2. Sign with jarsigner

```bash
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
  -keystore app/fmhy-release-key.keystore \
  app/build/outputs/apk/release/app-release-unsigned.apk \
  fmhy-release-key
```

### 3. Align with zipalign

```bash
zipalign -v 4 \
  app/build/outputs/apk/release/app-release-unsigned.apk \
  app/build/outputs/apk/release/app-release.apk
```

## Distribution

Once you have a signed APK:

1. **Direct Distribution**: Share the APK file directly with users
   - Users need to enable "Install from Unknown Sources" in Android settings
   - Can be distributed via website, email, or file sharing

2. **GitHub Releases**: Upload to your GitHub releases page
   - Users can download directly from GitHub
   - Provides version tracking and release notes

3. **App Stores**: Submit to alternative Android app stores
   - F-Droid (requires open source and additional configuration)
   - Amazon Appstore
   - Other third-party stores

Note: Google Play Store requires additional setup and review process.

## Additional Resources

- [Android App Signing Documentation](https://developer.android.com/studio/publish/app-signing)
- [Capacitor Android Documentation](https://capacitorjs.com/docs/android)
