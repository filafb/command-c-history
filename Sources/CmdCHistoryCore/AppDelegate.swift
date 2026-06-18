import AppKit

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public override init() { super.init() }
    private var statusBar: StatusBarController?

    public func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusBar = StatusBarController()
        statusBar?.start()
    }

    public func applicationWillTerminate(_ notification: Notification) {
        statusBar?.stop()
    }
}
