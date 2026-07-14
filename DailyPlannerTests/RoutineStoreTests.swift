import XCTest
@testable import DailyPlanner

@MainActor
final class RoutineStoreTests: XCTestCase {
    func testToggleAndReset() {
        let suite = "RoutineStoreTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        let store = RoutineStore(defaults: defaults)
        let item = WinterRoutine.items[0]

        store.toggle(item)
        XCTAssertTrue(store.isCompleted(item))

        store.reset()
        XCTAssertFalse(store.isCompleted(item))
    }

    func testRoutineHasNoDuplicateIDs() {
        let ids = WinterRoutine.items.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count)
    }
}
