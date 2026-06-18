import XCTest
@testable import CmdCHistoryCore

final class ClipboardStoreTests: XCTestCase {
    private var store: ClipboardStore!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: "CmdCHistoryTests-\(UUID().uuidString)")!
        store = ClipboardStore(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: defaults.description)
        super.tearDown()
    }

    func testStartsEmpty() {
        XCTAssertTrue(store.all.isEmpty)
    }

    func testAddSingleClip() {
        store.add("hello")
        XCTAssertEqual(store.all, ["hello"])
    }

    func testNewestClipIsFirst() {
        store.add("first")
        store.add("second")
        XCTAssertEqual(store.all.first, "second")
    }

    func testAddDuplicateMovesItToFront() {
        store.add("a")
        store.add("b")
        store.add("a")
        XCTAssertEqual(store.all, ["a", "b"])
    }

    func testCapDropsOldest() {
        let store = ClipboardStore(defaults: defaults, maxClips: 3)
        store.add("one")
        store.add("two")
        store.add("three")
        store.add("four")
        XCTAssertEqual(store.all, ["four", "three", "two"])
        XCTAssertFalse(store.all.contains("one"))
    }

    func testCapExactlyAtLimit() {
        let store = ClipboardStore(defaults: defaults, maxClips: 3)
        store.add("a")
        store.add("b")
        store.add("c")
        XCTAssertEqual(store.all.count, 3)
    }

    func testClearEmptiesHistory() {
        store.add("hello")
        store.add("world")
        store.clear()
        XCTAssertTrue(store.all.isEmpty)
    }

    func testPersistsAcrossInstances() {
        store.add("persisted")
        let store2 = ClipboardStore(defaults: defaults)
        XCTAssertEqual(store2.all, ["persisted"])
    }

    func testWhitespaceOnlyClipsAreNotFiltered() {
        // Store itself doesn't filter whitespace — ClipboardMonitor does.
        store.add("   ")
        XCTAssertEqual(store.all, ["   "])
    }

    func testOrderAfterMultipleAdds() {
        ["c", "b", "a"].forEach { store.add($0) }
        XCTAssertEqual(store.all, ["a", "b", "c"])
    }
}
