#!/bin/bash

# Build Script for FMHY Android App
# Builds both debug and release APKs

set -e  # Exit on error

echo "=================================="
echo "FMHY Android APK Build Script"
echo "=================================="
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the project root."
    exit 1
fi

# Sync Capacitor files
echo "📦 Syncing Capacitor files..."
npm run cap:sync

if [ $? -ne 0 ]; then
    echo "❌ Failed to sync Capacitor files"
    exit 1
fi

echo ""
echo "✅ Capacitor sync complete"
echo ""

# Navigate to Android directory
cd android

# Check what to build
if [ "$1" == "release" ] || [ "$1" == "signed" ]; then
    # Check if keystore properties exist
    if [ ! -f "keystore.properties" ]; then
        echo "⚠️  WARNING: keystore.properties not found!"
        echo ""
        echo "To build a signed release APK, you need to:"
        echo "  1. Run ./setup-signing.sh to create a keystore"
        echo "  2. Create android/keystore.properties with your signing details"
        echo ""
        echo "Building unsigned release APK instead..."
        BUILD_TYPE="release"
    else
        echo "🔐 Building signed release APK..."
        BUILD_TYPE="release"
    fi
    
    ./gradlew assembleRelease
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Release APK built successfully!"
        echo ""
        echo "📦 Output location:"
        echo "   app/build/outputs/apk/release/app-release.apk"
        echo ""
        
        # Check if APK is signed
        if [ -f "keystore.properties" ]; then
            echo "✅ APK is SIGNED and ready for distribution"
        else
            echo "⚠️  APK is UNSIGNED - you need to sign it before distribution"
            echo "   Run ./setup-signing.sh to configure signing"
        fi
    else
        echo ""
        echo "❌ Failed to build release APK"
        exit 1
    fi
    
elif [ "$1" == "debug" ] || [ "$1" == "" ]; then
    echo "🔨 Building debug APK..."
    ./gradlew assembleDebug
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Debug APK built successfully!"
        echo ""
        echo "📦 Output location:"
        echo "   app/build/outputs/apk/debug/app-debug.apk"
        echo ""
        echo "ℹ️  This is a debug build - use 'release' for production"
    else
        echo ""
        echo "❌ Failed to build debug APK"
        exit 1
    fi
else
    echo "❌ Unknown build type: $1"
    echo ""
    echo "Usage: ./build-android.sh [debug|release]"
    echo "  debug   - Build debug APK (default)"
    echo "  release - Build signed release APK (requires keystore setup)"
    exit 1
fi

cd ..
