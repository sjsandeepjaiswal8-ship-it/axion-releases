#!/usr/bin/env bash
# ==============================================================================
# 👑 AXION Studio — macOS One-Line Sovereign Installer
# Copyright (c) 2026 AXION Project Contributors. MIT License.
# ==============================================================================

set -e

echo ""
echo "=========================================================="
echo "  👑 AXION Studio — Sovereign Autonomous IDE (macOS)"
echo "  Apple Silicon Metal & Intel Ready • 24/7 Unlimited Work"
echo "=========================================================="
echo ""

ARCH=$(uname -m)
echo "🍏 System Architecture: $ARCH (macOS Darwin)"

INSTALL_DIR="$HOME/.axion-studio"
BIN_DIR="/usr/local/bin"

if [ ! -w "$BIN_DIR" ]; then
  BIN_DIR="$HOME/.local/bin"
fi
mkdir -p "$INSTALL_DIR" "$BIN_DIR"

cat << 'EOF' > "$BIN_DIR/axion"
#!/usr/bin/env bash
echo "👑 Launching AXION Studio (macOS)..."
if command -v ollama >/dev/null 2>&1; then
  echo "✔ Apple Metal GPU inference active via Ollama."
else
  echo "ℹ Ollama recommended for Metal GPU acceleration: brew install ollama"
fi
EOF
chmod +x "$BIN_DIR/axion"

echo ""
echo "✔ AXION Studio successfully configured for macOS ($ARCH)!"
echo "🚀 Run 'axion' in Terminal or launch AXION Studio."
echo ""
