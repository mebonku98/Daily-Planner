import Foundation

@MainActor
final class RoutineStore: ObservableObject {
    @Published private(set) var completedIDs: Set<String> = [] {
        didSet { save() }
    }

    private let defaults: UserDefaults
    private let storageKey = "completedRoutineItemIDs"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        completedIDs = Set(defaults.stringArray(forKey: storageKey) ?? [])
    }

    func isCompleted(_ item: RoutineItem) -> Bool {
        completedIDs.contains(item.id)
    }

    func toggle(_ item: RoutineItem) {
        if completedIDs.contains(item.id) {
            completedIDs.remove(item.id)
        } else {
            completedIDs.insert(item.id)
        }
    }

    func reset() {
        completedIDs.removeAll()
    }

    private func save() {
        defaults.set(completedIDs.sorted(), forKey: storageKey)
    }
}
