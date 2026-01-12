#!/usr/bin/env python3
"""
Download and prepare the FMHY icon for all platforms
"""
import os
import sys
import urllib.request
from PIL import Image

def download_icon(url, output_path):
    """Download icon from URL"""
    print(f"Downloading icon from {url}...")
    try:
        urllib.request.urlretrieve(url, output_path)
        print(f"✓ Downloaded to {output_path}")
        return True
    except Exception as e:
        print(f"✗ Failed to download: {e}")
        return False

def create_placeholder(output_path, size=512):
    """Create a simple placeholder icon if download fails"""
    print(f"Creating placeholder icon {size}x{size}...")
    img = Image.new('RGB', (size, size), color='#1a1a1a')
    img.save(output_path, 'PNG')
    print(f"✓ Created placeholder at {output_path}")

def prepare_desktop_icon():
    """Prepare icon for desktop (Electron)"""
    icon_url = "https://fmhy.net/test.png"
    desktop_icon = "desktop/icon.png"
    
    # Remove placeholder text file
    if os.path.exists("desktop/icon.png.txt"):
        os.remove("desktop/icon.png.txt")
    
    # Try to download, fallback to placeholder
    if not download_icon(icon_url, desktop_icon):
        create_placeholder(desktop_icon, 512)
    
    # Verify the image
    try:
        img = Image.open(desktop_icon)
        print(f"✓ Desktop icon ready: {img.size[0]}x{img.size[1]}")
    except Exception as e:
        print(f"✗ Error with desktop icon: {e}")
        return False
    
    return True

def prepare_ios_icon():
    """Prepare icon for iOS"""
    source_icon = "desktop/icon.png"
    ios_icon_path = "ios/App/App/Assets.xcassets/AppIcon.appiconset/AppIcon-512@2x.png"
    
    try:
        img = Image.open(source_icon)
        # iOS needs 1024x1024 for AppIcon
        ios_img = img.resize((1024, 1024), Image.Resampling.LANCZOS)
        ios_img.save(ios_icon_path, 'PNG')
        print(f"✓ iOS icon ready: {ios_icon_path}")
        return True
    except Exception as e:
        print(f"✗ Error preparing iOS icon: {e}")
        return False

def prepare_android_icon():
    """Prepare icons for Android (multiple resolutions)"""
    source_icon = "desktop/icon.png"
    
    # Android icon sizes
    sizes = {
        'mdpi': 48,
        'hdpi': 72,
        'xhdpi': 96,
        'xxhdpi': 144,
        'xxxhdpi': 192
    }
    
    try:
        img = Image.open(source_icon)
        for density, size in sizes.items():
            output_dir = f"android/app/src/main/res/mipmap-{density}"
            os.makedirs(output_dir, exist_ok=True)
            
            # Create launcher icons
            resized = img.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(f"{output_dir}/ic_launcher.png", 'PNG')
            resized.save(f"{output_dir}/ic_launcher_round.png", 'PNG')
            resized.save(f"{output_dir}/ic_launcher_foreground.png", 'PNG')
        
        print("✓ Android icons ready")
        return True
    except Exception as e:
        print(f"✗ Error preparing Android icons: {e}")
        return False

if __name__ == "__main__":
    print("=" * 50)
    print("FMHY Icon Preparation Script")
    print("=" * 50)
    
    success = True
    success &= prepare_desktop_icon()
    success &= prepare_ios_icon()
    success &= prepare_android_icon()
    
    print("=" * 50)
    if success:
        print("✅ All icons prepared successfully!")
        print("\nNote: If you see placeholder icons, they will be replaced")
        print("when https://fmhy.net/test.png becomes accessible.")
        sys.exit(0)
    else:
        print("⚠️  Some icons may not be ready. Check errors above.")
        sys.exit(1)
