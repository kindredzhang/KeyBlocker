#!/bin/bash

# Configuration
APP_NAME="KeyBlocker"
DMG_NAME="KeyBlocker.dmg"
VOLUME_NAME="KeyBlocker"
SOURCE_DIR="dmg_source"
ICON_FILE="Resources/icon.icns"
SWIFT_FILE="Sources/KeyBlocker.swift"

# Clean up
rm -rf "$SOURCE_DIR"
rm -rf "$APP_NAME.app"
mkdir -p "$SOURCE_DIR"
rm -f "$DMG_NAME"

# Build App Bundle
mkdir -p "$APP_NAME.app/Contents/MacOS"
mkdir -p "$APP_NAME.app/Contents/Resources"

# Compile
swiftc "$SWIFT_FILE" -o "$APP_NAME.app/Contents/MacOS/$APP_NAME"

# Copy Icon
cp "$ICON_FILE" "$APP_NAME.app/Contents/Resources/AppIcon.icns"

# Create Info.plist
cat > "$APP_NAME.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.kindredzhang.KeyBlocker</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
EOF

# Copy App to source dir for DMG
cp -R "$APP_NAME.app" "$SOURCE_DIR/"
ln -s /Applications "$SOURCE_DIR/Applications"

# Create a temporary read-write DMG
TEMP_DMG="temp.dmg"
hdiutil create -volname "$VOLUME_NAME" -srcfolder "$SOURCE_DIR" -ov -format UDRW "$TEMP_DMG"

# Set DMG Icon
echo "Mounting DMG to set icon..."
MOUNT_DIR=$(hdiutil attach "$TEMP_DMG" | grep -o "/Volumes/.*" | head -n 1)

if [ -n "$MOUNT_DIR" ]; then
    cp "$ICON_FILE" "$MOUNT_DIR/.VolumeIcon.icns"
    # Set the custom icon flag
    /usr/bin/SetFile -a C "$MOUNT_DIR"
    # Hide the icon file
    /usr/bin/SetFile -a V "$MOUNT_DIR/.VolumeIcon.icns"
    # Unmount
    hdiutil detach "$MOUNT_DIR"
fi

# Convert to final compressed DMG
hdiutil convert "$TEMP_DMG" -format UDZO -o "$DMG_NAME"
rm "$TEMP_DMG"

# Clean up source dir
rm -rf "$SOURCE_DIR"

echo "DMG created: $DMG_NAME"
