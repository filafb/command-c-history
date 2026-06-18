# CmdCHistory

A privacy-first clipboard history manager for macOS. Lives in the menu bar, stores your last 20 copied texts, click any entry to put it back on the clipboard.

**No network access.** The App Sandbox is signed without `com.apple.security.network.client`, so the kernel blocks all outbound connections at the OS level — not just by convention.

## Requirements

- macOS 13 or later
- Xcode Command Line Tools (`xcode-select --install`)

## Build & Install

```bash
# 1. Clone
git clone <repo-url>
cd cmd_c_history

# 2. Build and package into CmdCHistory.app
make bundle

# 3. Install to ~/Applications
make install

# 4. Launch
open ~/Applications/CmdCHistory.app
```

The app icon appears in the menu bar. Click it to browse history.

## Verify no network access

```bash
make verify
```

The output should show `com.apple.security.app-sandbox = true` and no `com.apple.security.network.client`. That absence is enforced by the kernel — the app cannot open a socket regardless of what the code does.

You can also confirm at runtime:

```bash
lsof -p $(pgrep CmdCHistory) -i
# Expected: no output (no open network file descriptors)
```

## Launch at Login

Click the menu bar icon → **Launch at Login**. A checkmark indicates it's enabled. Click again to disable. This writes to System Settings → General → Login Items, which you can also manage from there.

## How it works

| Component | Detail |
|---|---|
| Clipboard polling | `NSPasteboard.changeCount` checked every 0.5 s |
| Storage | `UserDefaults` in the sandboxed container (`~/Library/Containers/com.local.cmdchistory/`) |
| History limit | 20 entries; oldest is dropped when the 21st arrives |
| Password safety | Clips marked `org.nspasteboard.ConcealedType` (1Password, Bitwarden, etc.) are silently skipped |
| Paste | Click-to-copy only — selected clip goes to clipboard, you press Cmd-V |

## Project structure

```
Sources/CmdCHistory/
  main.swift               Entry point
  AppDelegate.swift        App lifecycle
  ClipboardMonitor.swift   NSPasteboard polling + blocked-type filtering
  ClipboardStore.swift     UserDefaults persistence, 20-item cap
  StatusBarController.swift  Menu bar item, NSMenu delegate, login-item toggle
Info.plist                 Bundle metadata (LSUIElement = true, no NSAllowsArbitraryLoads)
entitlements.plist         app-sandbox only, no network.client
Makefile                   build / bundle / install / verify targets
```
