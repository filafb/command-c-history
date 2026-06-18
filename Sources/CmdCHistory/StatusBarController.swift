import AppKit
import ServiceManagement

final class StatusBarController: NSObject, NSMenuDelegate {
    private var statusItem: NSStatusItem?
    private let store = ClipboardStore()
    private let monitor = ClipboardMonitor()
    private let menu = NSMenu()

    func start() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Clipboard History")
        }
        menu.delegate = self
        statusItem?.menu = menu

        monitor.onNewClip = { [weak self] text in
            self?.store.add(text)
        }
        monitor.start()
    }

    func stop() {
        monitor.stop()
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()

        let clips = store.all
        if clips.isEmpty {
            let item = NSMenuItem(title: "No clips yet — copy something!", action: nil, keyEquivalent: "")
            item.isEnabled = false
            menu.addItem(item)
        } else {
            for (index, text) in clips.enumerated() {
                let preview = text
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "\n", with: " ")
                let title = index < 9
                    ? "[\(index + 1)] \(preview.prefix(60))"
                    : "      \(preview.prefix(60))"
                let item = NSMenuItem(title: String(title), action: #selector(clipSelected(_:)), keyEquivalent: index < 9 ? "\(index + 1)" : "")
                item.target = self
                item.representedObject = text
                menu.addItem(item)
            }
        }

        menu.addItem(.separator())

        let clear = NSMenuItem(title: "Clear History", action: #selector(clearHistory), keyEquivalent: "")
        clear.target = self
        menu.addItem(clear)

        let loginItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        loginItem.target = self
        loginItem.state = (SMAppService.mainApp.status == .enabled) ? .on : .off
        menu.addItem(loginItem)

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit CmdCHistory", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }

    @objc private func clipSelected(_ sender: NSMenuItem) {
        guard let text = sender.representedObject as? String else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    @objc private func clearHistory() {
        store.clear()
    }

    @objc private func toggleLaunchAtLogin() {
        let service = SMAppService.mainApp
        do {
            if service.status == .enabled {
                try service.unregister()
            } else {
                try service.register()
            }
        } catch {
            NSLog("CmdCHistory: launch-at-login toggle failed: %@", error.localizedDescription)
        }
    }
}
