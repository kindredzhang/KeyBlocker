#!/bin/bash

LOGO_FILE="Resources/logo.png"
ICONSET_DIR="Resources/icon.iconset"
ICNS_FILE="Resources/icon.icns"

if [ ! -f "$LOGO_FILE" ]; then
    echo "Error: $LOGO_FILE not found."
    exit 1
fi

mkdir -p "$ICONSET_DIR"

sips -z 16 16     "$LOGO_FILE" --out "$ICONSET_DIR/icon_16x16.png"
sips -z 32 32     "$LOGO_FILE" --out "$ICONSET_DIR/icon_16x16@2x.png"
sips -z 32 32     "$LOGO_FILE" --out "$ICONSET_DIR/icon_32x32.png"
sips -z 64 64     "$LOGO_FILE" --out "$ICONSET_DIR/icon_32x32@2x.png"
sips -z 128 128   "$LOGO_FILE" --out "$ICONSET_DIR/icon_128x128.png"
sips -z 256 256   "$LOGO_FILE" --out "$ICONSET_DIR/icon_128x128@2x.png"
sips -z 256 256   "$LOGO_FILE" --out "$ICONSET_DIR/icon_256x256.png"
sips -z 512 512   "$LOGO_FILE" --out "$ICONSET_DIR/icon_256x256@2x.png"
sips -z 512 512   "$LOGO_FILE" --out "$ICONSET_DIR/icon_512x512.png"
sips -z 1024 1024 "$LOGO_FILE" --out "$ICONSET_DIR/icon_512x512@2x.png"

iconutil -c icns "$ICONSET_DIR" -o "$ICNS_FILE"
rm -rf "$ICONSET_DIR"

echo "Icons generated: $ICNS_FILE"
