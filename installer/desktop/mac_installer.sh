#!/usr/bin/env bash
# FILE: /installer/desktop/mac_installer.sh
# LearnIt3D – Plumbing Foundations Apprenticeship Prep
# macOS Desktop Installer Script
# --------------------------------------------------
# Requirements: macOS 12 Monterey or later (Apple Silicon & Intel)
# Usage:  chmod +x mac_installer.sh && ./mac_installer.sh
#         Pass --uninstall to remove the application.
# --------------------------------------------------

set -euo pipefail
IFS=$'\n\t'

# ── Constants ─────────────────────────────────────────────────────────────────
readonly APP_NAME="LearnIt3D – Plumbing Foundations Apprenticeship Prep"
readonly APP_BUNDLE="LearnIt3DPlumbing.app"
readonly APP_VERSION="1.0.0"
readonly BUNDLE_ID="com.learnit3d.plumbingprep"
readonly INSTALL_DIR="/Applications"
readonly DATA_DIR="$HOME/Library/Application Support/LearnIt3D/PlumbingPrep"
readonly LOG_DIR="$HOME/Library/Logs/LearnIt3D"
readonly LOG_FILE="$LOG_DIR/install.log"
readonly LAUNCH_AGENT_PLIST="$HOME/Library/LaunchAgents/${BUNDLE_ID}.plist"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ICON_SRC="$SCRIPT_DIR/../../src/assets/icons/learnit3d_icon.icns"

# ── Helpers ───────────────────────────────────────────────────────────────────
log() {
    local level="${1:-INFO}"
    shift
    local message="$*"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    mkdir -p "$LOG_DIR"
    printf "[%s] [%s] %s\n" "$timestamp" "$level" "$message" | tee -a "$LOG_FILE"
}

require_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log ERROR "This installer is for macOS only."
        exit 1
    fi
    local macos_major
    macos_major=$(sw_vers -productVersion | cut -d. -f1)
    if (( macos_major < 12 )); then
        log WARN "macOS 12 Monterey or later is recommended (detected $macos_major)."
    fi
}

check_sudo() {
    # Only needed when writing to /Applications
    if [[ "$INSTALL_DIR" == /Applications* ]] && [[ $EUID -ne 0 ]]; then
        log INFO "Administrator privileges required. Re-running with sudo..."
        exec sudo bash "$0" "$@"
    fi
}

# ── Detect architecture ───────────────────────────────────────────────────────
detect_arch() {
    local arch
    arch="$(uname -m)"
    case "$arch" in
        arm64)  echo "apple_silicon" ;;
        x86_64) echo "intel" ;;
        *)      log WARN "Unknown architecture: $arch"; echo "unknown" ;;
    esac
}

# ── Build minimal .app bundle stub ───────────────────────────────────────────
build_app_bundle() {
    local bundle_path="$INSTALL_DIR/$APP_BUNDLE"
    local contents="$bundle_path/Contents"
    local macos_dir="$contents/MacOS"
    local resources_dir="$contents/Resources"

    log INFO "Building .app bundle at $bundle_path"

    mkdir -p "$macos_dir" "$resources_dir"

    # Info.plist
    cat > "$contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>              <string>LearnIt3D Plumbing Prep</string>
    <key>CFBundleDisplayName</key>       <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>        <string>${BUNDLE_ID}</string>
    <key>CFBundleVersion</key>           <string>${APP_VERSION}</string>
    <key>CFBundleShortVersionString</key><string>${APP_VERSION}</string>
    <key>CFBundleExecutable</key>        <string>LearnIt3DPlumbing</string>
    <key>CFBundleIconFile</key>          <string>learnit3d_icon</string>
    <key>CFBundlePackageType</key>       <string>APPL</string>
    <key>NSHighResolutionCapable</key>   <true/>
    <key>LSMinimumSystemVersion</key>    <string>12.0</string>
    <key>NSHumanReadableCopyright</key>  <string>Copyright © 2026 LearnIt3D. All rights reserved.</string>
</dict>
</plist>
PLIST
    log INFO "Created Info.plist"

    # Launcher stub executable
    cat > "$macos_dir/LearnIt3DPlumbing" <<'LAUNCHER'
#!/usr/bin/env bash
# LearnIt3D Plumbing Prep – launcher stub
# Replace this script with the actual compiled binary in production.
BUNDLE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="$HOME/Library/Application Support/LearnIt3D/PlumbingPrep"
mkdir -p "$DATA_DIR"
osascript -e 'display dialog "LearnIt3D Plumbing Foundations is launching…" buttons {"OK"} default button "OK" with title "LearnIt3D"' &>/dev/null || true
LAUNCHER
    chmod +x "$macos_dir/LearnIt3DPlumbing"
    log INFO "Created launcher stub"

    # Copy icon if available
    if [[ -f "$ICON_SRC" ]]; then
        cp "$ICON_SRC" "$resources_dir/learnit3d_icon.icns"
        log INFO "Copied icon to bundle resources"
    else
        log WARN "Icon not found at $ICON_SRC – skipping"
    fi

    # Fix permissions
    chown -R root:wheel "$bundle_path" 2>/dev/null || true
    chmod -R 755 "$bundle_path"
    log INFO ".app bundle created successfully"
}

# ── Create user data directory ────────────────────────────────────────────────
setup_data_dir() {
    mkdir -p "$DATA_DIR"/{saves,config,cache}
    log INFO "User data directory ready: $DATA_DIR"
}

# ── Optional: register a LaunchAgent (auto-start on login) ───────────────────
register_launch_agent() {
    # Disabled by default – uncomment to enable auto-start
    : <<'DISABLED'
    cat > "$LAUNCH_AGENT_PLIST" <<PLIST_AGENT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>            <string>${BUNDLE_ID}</string>
    <key>ProgramArguments</key>
    <array>
        <string>${INSTALL_DIR}/${APP_BUNDLE}/Contents/MacOS/LearnIt3DPlumbing</string>
    </array>
    <key>RunAtLoad</key>        <false/>
    <key>KeepAlive</key>        <false/>
</dict>
</plist>
PLIST_AGENT
    launchctl load "$LAUNCH_AGENT_PLIST" 2>/dev/null || true
    log INFO "LaunchAgent registered"
DISABLED
    :
}

# ── Quarantine removal (Gatekeeper) ──────────────────────────────────────────
clear_quarantine() {
    local bundle_path="$INSTALL_DIR/$APP_BUNDLE"
    if command -v xattr &>/dev/null; then
        xattr -rd com.apple.quarantine "$bundle_path" 2>/dev/null || true
        log INFO "Cleared quarantine attribute"
    fi
}

# ── Uninstall ─────────────────────────────────────────────────────────────────
do_uninstall() {
    log INFO "Starting uninstall of $APP_NAME v$APP_VERSION"

    # Kill running instance
    pkill -f "LearnIt3DPlumbing" 2>/dev/null || true

    # Remove .app
    local bundle_path="$INSTALL_DIR/$APP_BUNDLE"
    if [[ -d "$bundle_path" ]]; then
        rm -rf "$bundle_path"
        log INFO "Removed $bundle_path"
    fi

    # Remove LaunchAgent
    if [[ -f "$LAUNCH_AGENT_PLIST" ]]; then
        launchctl unload "$LAUNCH_AGENT_PLIST" 2>/dev/null || true
        rm -f "$LAUNCH_AGENT_PLIST"
        log INFO "Removed LaunchAgent"
    fi

    # Ask about user data
    read -rp "Remove user data at $DATA_DIR? [y/N] " answer
    if [[ "${answer,,}" == "y" ]] && [[ -d "$DATA_DIR" ]]; then
        rm -rf "$DATA_DIR"
        log INFO "Removed user data"
    fi

    log INFO "Uninstall complete."
}

# ── Install ───────────────────────────────────────────────────────────────────
do_install() {
    local arch
    arch="$(detect_arch)"
    log INFO "Starting install of $APP_NAME v$APP_VERSION (arch: $arch)"

    setup_data_dir
    build_app_bundle
    clear_quarantine
    register_launch_agent

    log INFO "Installation complete."
    log INFO "Launch from: $INSTALL_DIR/$APP_BUNDLE"

    # Notify user via macOS notification
    osascript -e "display notification \"$APP_NAME has been installed successfully.\" with title \"LearnIt3D\" subtitle \"Version $APP_VERSION\"" 2>/dev/null || true
}

# ── Entry point ───────────────────────────────────────────────────────────────
require_macos

case "${1:-}" in
    --uninstall|-u)
        check_sudo "$@"
        do_uninstall
        ;;
    --help|-h)
        cat <<HELP
Usage: $0 [--uninstall] [--help]

  (no flag)    Install $APP_NAME
  --uninstall  Remove the application
  --help       Show this help message
HELP
        ;;
    *)
        check_sudo "$@"
        do_install
        ;;
esac
