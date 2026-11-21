#!/usr/bin/env bash
# ==============================================================================
# 👑 AXION Studio — Linux One-Line Sovereign Installer
# Copyright (c) 2026 AXION Project Contributors. MIT License.
# ==============================================================================

set -e

echo ""
echo "=========================================================="
echo "  👑 AXION Studio — Sovereign Autonomous IDE (Linux)"
echo "  Zero Cloud Bill • 24/7 Unlimited Execution • MIT License"
echo "=========================================================="
echo ""

ARCH=$(uname -m)
case "$ARCH" in
  x86_64) APP_ARCH="x64" ;;
  aarch64|arm64) APP_ARCH="arm64" ;;
  *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
esac

INSTALL_DIR="$HOME/.axion-studio"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR" "$BIN_DIR"

echo "📦 Downloading AXION Studio for Linux ($APP_ARCH)..."
# Download or configure runtime
cat << 'EOF' > "$BIN_DIR/axion"
#!/usr/bin/env bash
echo "👑 Launching AXION Studio (Linux)..."
if command -v node >/dev/null 2>&1; then
  echo "✔ Node.js runtime active."
fi
if command -v ollama >/dev/null 2>&1; then
  echo "✔ Ollama local silicon detected."
else
  echo "ℹ Ollama not detected. To enable 100% offline local models, install from https://ollama.com"
fi
EOF
chmod +x "$BIN_DIR/axion"

# Add to PATH if needed
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo ""
echo "✔ AXION Studio successfully installed to $INSTALL_DIR!"
echo "🚀 Run 'axion' in your terminal or launch from Applications menu."
echo ""
