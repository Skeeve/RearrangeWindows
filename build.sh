#!/bin/bash
APP_NAME="RearrangeWindows"
SOURCE="${APP_NAME}.applescript"
DEST="${APP_NAME}.app"

# App erstellen
osacompile -o "$DEST" "$SOURCE"

# Quarantäne entfernen und signieren
xattr -cr "$DEST"
codesign --force --deep --sign - "$DEST"

echo "✓ ${APP_NAME}.app wurde erstellt und signiert."
