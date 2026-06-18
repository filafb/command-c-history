import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBar: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusBar = StatusBarController()
        statusBar?.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        statusBar?.stop()
    }
}
