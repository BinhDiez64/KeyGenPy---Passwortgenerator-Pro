
#!/bin/bash
set -e  # Bei Fehlern sofort abbrechen

echo "╔════════════════════════════════════════=====════╗"
echo "║     KeyGenPy Build Script v2.0.0 für Mac         ║"
echo "║     (Apple Silicon (M1/M2/M3/M4..) = arm64 und  ║"
echo "║     Intel = x86_64)                             ║"
echo "╚═══════════════=====═════════════════════════════╝"
echo ""


echo "📁 Aktuelles Verzeichnis: $(pwd)"

# Prüfen, ob die wichtigsten Dateien existieren
if [ ! -f "KeyGenPy.py" ]; then
    echo "❌ KeyGenPy.py nicht gefunden! Bitte im richtigen Verzeichnis ausführen."
    exit 1
fi
if [ ! -f "KeyGenPy.png" ]; then
    echo "❌ KeyGenPy.png nicht gefunden! Wird als App‑Icon benötigt."
    exit 1
fi
if [ ! -f "BinhDiez.png" ]; then
    echo "⚠️  BinhDiez.png nicht gefunden – wird ignoriert, falls nicht benötigt."
fi

# PyInstaller ggf. installieren
if ! command -v pyinstaller &> /dev/null; then
    echo "📦 PyInstaller wird installiert ..."
    pip install pyinstaller
fi

echo "🚀 Starte PyInstaller Build ..."
pyinstaller --clean \
            --windowed \
            --onedir \
            --name "KeyGenPy" \
            --icon "KeyGenPy.png" \
            --add-data "BinhDiez.png:." \
            --add-data "KeyGenPy.png:." \
            --osx-bundle-identifier "com.binhdiez.keygen" \
            KeyGenPy.py

# Nach /Applications kopieren
APP_SOURCE="dist/KeyGenPy.app"
APP_DEST="/Applications/KeyGenPy.app"

if [ ! -d "$APP_SOURCE" ]; then
    echo "❌ Build fehlgeschlagen – $APP_SOURCE nicht gefunden."
    exit 1
fi

echo "📦 Kopiere $APP_SOURCE nach $APP_DEST ..."
if [ -d "$APP_DEST" ]; then
    read -p "⚠️  KeyGenPy.app existiert bereits. Überschreiben? (j/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Jj]$ ]]; then
        rm -rf "$APP_DEST"
        cp -R "$APP_SOURCE" "$APP_DEST"
        echo "✅ Ersetzt."
    else
        echo "❌ Kopiervorgang abgebrochen."
    fi
else
    cp -R "$APP_SOURCE" "$APP_DEST"
    echo "✅ Erfolgreich kopiert."
fi


echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  ✅ BUILD ERFOLGREICH!                                     ║"
echo "║                                                            ║"
echo "║                                                            ║"
echo "║  📦 OPTIONAL: MANUELLES SETZEN DES ICONS                   ║"
echo "║                                                            ║"
echo "║  1. Rechtsklick auf die App → Informationen                ║"
echo "║  2. Ziehe SyNasPy_icon.png (im Projektordner)              ║"
echo "║     auf das kleine Icon oben links in der Info-Box der App ║"
echo "║  3. App ausführen und im Dock behalten                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
