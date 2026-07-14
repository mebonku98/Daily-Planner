import XCTest
@testable import DailyPlanner

@MainActor
final class RoutineStoreTests: XCTestCase {
    func testToggleResetAndPersistence() {
        let suite = "RoutineStoreTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        var store: RoutineStore? = RoutineStore(defaults: defaults)
        let item = store!.items(for: .weekday)[0]

        store!.toggle(item)
        XCTAssertTrue(store!.isCompleted(item))

        store = RoutineStore(defaults: defaults)
        XCTAssertTrue(store!.isCompleted(item))

        store!.resetCompletion(for: .weekday)
        XCTAssertFalse(store!.isCompleted(item))
    }

    func testEditedRoutinePersists() {
        let suite = "RoutineStoreEditTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        var store: RoutineStore? = RoutineStore(defaults: defaults)
        var item = RoutineItem.draft(for: .weekend)
        item.title = "Family picnic"
        item.owner = .shared
        item.startMinutes = 720
        item.endMinutes = 810
        store!.save(item)

        store = RoutineStore(defaults: defaults)
        XCTAssertEqual(store!.items.first(where: { $0.id == item.id })?.title, "Family picnic")
    }

    func testInvalidTimeRangeIsRejected() {
        let suite = "RoutineStoreValidationTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        let store = RoutineStore(defaults: defaults)
        var item = RoutineItem.draft(for: .weekday)
        item.title = "Impossible activity"
        item.endMinutes = item.startMinutes

        store.save(item)

        XCTAssertFalse(store.items.contains(where: { $0.id == item.id }))
    }

    func testValidatorFindsDirectAndSharedConflicts() {
        let direct = RoutineItem(
            id: "direct",
            schedule: .weekday,
            owner: .mum,
            startMinutes: 600,
            endMinutes: 660,
            title: "Work",
            note: "",
            category: .work
        )
        let shared = RoutineItem(
            id: "shared",
            schedule: .weekday,
            owner: .shared,
            startMinutes: 630,
            endMinutes: 690,
            title: "Appointment",
            note: "",
            category: .family
        )

        let conflicts = ScheduleValidator.conflicts(in: [direct, shared], schedule: .weekday)

        XCTAssertEqual(conflicts.count, 1)
        XCTAssertEqual(conflicts.first?.owner, .mum)
    }

    func testTemplatesHaveUniqueIDsAndNoConflicts() {
        let ids = FamilyRoutine.items.map(\.id)

        XCTAssertEqual(ids.count, Set(ids).count)
        XCTAssertTrue(ScheduleValidator.conflicts(in: FamilyRoutine.items, schedule: .weekday).isEmpty)
        XCTAssertTrue(ScheduleValidator.conflicts(in: FamilyRoutine.items, schedule: .weekend).isEmpty)
    }

    func testMemberFilterIncludesSharedActivities() {
        let suite = "RoutineStoreFilterTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        let store = RoutineStore(defaults: defaults)
        let mumItems = store.items(for: .weekday, owner: .mum)

        XCTAssertTrue(mumItems.contains(where: { $0.owner == .mum }))
        XCTAssertTrue(mumItems.contains(where: { $0.owner == .shared }))
        XCTAssertFalse(mumItems.contains(where: { $0.owner == .dad }))
    }
}
