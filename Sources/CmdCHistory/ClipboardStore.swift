import Foundation

// Stores up to maxClips text entries, most-recent first, using UserDefaults.
// Under App Sandbox this lands in ~/Library/Containers/com.local.cmdchistory/Data/
// and never leaves the machine.
final class ClipboardStore {
    private let maxClips = 20
    private let key = "clipHistory"

    var all: [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func add(_ text: String) {
        var clips = all
        clips.removeAll { $0 == text }
        clips.insert(text, at: 0)
        if clips.count > maxClips {
            clips = Array(clips.prefix(maxClips))
        }
        UserDefaults.standard.set(clips, forKey: key)
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
