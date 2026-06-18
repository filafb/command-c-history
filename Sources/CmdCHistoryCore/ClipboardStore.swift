import Foundation

public final class ClipboardStore {
    private let maxClips: Int
    private let key = "clipHistory"
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard, maxClips: Int = 20) {
        self.defaults = defaults
        self.maxClips = maxClips
    }

    public var all: [String] {
        defaults.stringArray(forKey: key) ?? []
    }

    public func add(_ text: String) {
        var clips = all
        clips.removeAll { $0 == text }
        clips.insert(text, at: 0)
        if clips.count > maxClips {
            clips = Array(clips.prefix(maxClips))
        }
        defaults.set(clips, forKey: key)
    }

    public func clear() {
        defaults.removeObject(forKey: key)
    }
}
