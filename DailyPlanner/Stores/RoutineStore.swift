import Foundation

@MainActor
final class RoutineStore: ObservableObject {
    @Published private(set) var items: [RoutineItem] = [] {
        didSet { saveItems() }
    }

    @Published private(set) var completedIDs: Set<String> = [] {
        didSet { saveCompletion() }
    }

    private let defaults: UserDefaults
    private let itemsKey = "familyRoutineItems.v2"
    private let completionKey = "completedRoutineItemIDs"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        if let data = defaults.data(forKey: itemsKey),
           let decoded = try? JSONDecoder().decode([RoutineItem].self, from: data) {
            items = decoded
        } else {
            items = FamilyRoutine.items
        }

        completedIDs = Set(defaults.stringArray(forKey: completionKey) ?? [])
            .intersection(Set(items.map(\.id)))
    }

    func items(for schedule: ScheduleKind, owner: FamilyMember? = nil) -> [RoutineItem] {
        items
            .filter { item in
                item.schedule == schedule && (owner == nil || item.owner == owner || item.owner == .shared)
            }
            .sorted {
                if $0.startMinutes == $1.startMinutes { return $0.owner.rawValue < $1.owner.rawValue }
                return $0.startMinutes < $1.startMinutes
            }
    }

    func conflicts(for schedule: ScheduleKind) -> [ScheduleConflict] {
        ScheduleValidator.conflicts(in: items, schedule: schedule)
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

    func save(_ item: RoutineItem) {
        guard item.endMinutes > item.startMinutes else { return }

        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }

    func delete(_ item: RoutineItem) {
        items.removeAll { $0.id == item.id }
        completedIDs.remove(item.id)
    }

    func move(_ item: RoutineItem, direction: Int) {
        let ordered = items(for: item.schedule).filter { $0.owner == item.owner }
        guard let position = ordered.firstIndex(where: { $0.id == item.id }) else { return }
        let targetPosition = position + direction
        guard ordered.indices.contains(targetPosition),
              let sourceIndex = items.firstIndex(where: { $0.id == item.id }),
              let targetIndex = items.firstIndex(where: { $0.id == ordered[targetPosition].id })
        else { return }

        let target = items[targetIndex]
        items[sourceIndex].startMinutes = target.startMinutes
        items[sourceIndex].endMinutes = target.endMinutes
        items[targetIndex].startMinutes = item.startMinutes
        items[targetIndex].endMinutes = item.endMinutes
    }

    func resetCompletion(for schedule: ScheduleKind) {
        let ids = Set(items.filter { $0.schedule == schedule }.map(\.id))
        completedIDs.subtract(ids)
    }

    func restoreTemplates() {
        items = FamilyRoutine.items
        completedIDs.removeAll()
    }

    private func saveItems() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: itemsKey)
    }

    private func saveCompletion() {
        defaults.set(completedIDs.sorted(), forKey: completionKey)
    }
}
