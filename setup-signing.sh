#!/bin/bash

# APK Signing Setup Script for FMHY Android App
# This script helps configure APK signing for release builds

# Configuration
KEY_ALIAS="fmhy-release-key"
KEYSTORE_PATH="android/app/fmhy-release-key.keystore"

echo "=================================="
echo "FMHY Android APK Signing Setup"
echo "=================================="
echo ""

# Check if keystore already exists
if [ -f "$KEYSTORE_PATH" ]; then
    echo "⚠️  Keystore already exists at: $KEYSTORE_PATH"
    read -p "Do you want to create a new keystore? This will overwrite the existing one. (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting without creating a new keystore."
        exit 0
    fi
fi

# Generate keystore
echo "Generating new keystore..."
echo ""
echo "You will be asked to enter:"
echo "  1. Keystore password (remember this!)"
echo "  2. Key alias (default: $KEY_ALIAS)"
echo "  3. Key password (can be same as keystore password)"
echo "  4. Your name, organization, etc."
echo ""
read -p "Press Enter to continue..."

keytool -genkey -v -keystore "$KEYSTORE_PATH" -alias "$KEY_ALIAS" -keyalg RSA -keysize 2048 -validity 10000

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Keystore created successfully!"
    echo ""
    echo "📝 Next steps:"
    echo "  1. Keep your keystore file safe and backed up"
    echo "  2. Remember your passwords (keystore and key passwords)"
    echo "  3. Create android/keystore.properties with your signing details"
    echo ""
    echo "Example keystore.properties content:"
    echo "-----------------------------------"
    echo "storePassword=YOUR_KEYSTORE_PASSWORD"
    echo "keyPassword=YOUR_KEY_PASSWORD"
    echo "keyAlias=$KEY_ALIAS"
    echo "storeFile=fmhy-release-key.keystore"
    echo "-----------------------------------"
    echo ""
    echo "⚠️  IMPORTANT: Do NOT commit keystore.properties or the .keystore file to git!"
    echo "              These files contain sensitive information."
else
    echo ""
    echo "❌ Failed to create keystore"
    exit 1
fi
