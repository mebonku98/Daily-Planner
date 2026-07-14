import Foundation
import SwiftUI

enum FamilyMember: String, CaseIterable, Codable, Identifiable {
    case mum, dad, shared

    var id: String { rawValue }

    var title: String {
        switch self {
        case .mum: "Mum"
        case .dad: "Dad"
        case .shared: "Together"
        }
    }

    var systemImage: String {
        switch self {
        case .mum: "person.fill"
        case .dad: "person"
        case .shared: "person.2.fill"
        }
    }

    var color: Color {
        switch self {
        case .mum: Color(red: 0.63, green: 0.35, blue: 0.55)
        case .dad: Color(red: 0.23, green: 0.45, blue: 0.64)
        case .shared: Color(red: 0.22, green: 0.50, blue: 0.39)
        }
    }
}

enum ScheduleKind: String, CaseIterable, Codable, Identifiable {
    case weekday, weekend

    var id: String { rawValue }
    var title: String { rawValue.capitalized }
}

struct RoutineItem: Identifiable, Hashable, Codable {
    enum Category: String, CaseIterable, Codable, Identifiable {
        case morning, work, family, personal

        var id: String { rawValue }

        var title: String {
            switch self {
            case .morning: "Morning"
            case .work: "Work & travel"
            case .family: "Family care"
            case .personal: "Personal"
            }
        }

        var color: Color {
            switch self {
            case .morning: Color(red: 0.91, green: 0.72, blue: 0.42)
            case .work: Color(red: 0.19, green: 0.37, blue: 0.39)
            case .family: Color(red: 0.84, green: 0.47, blue: 0.39)
            case .personal: Color(red: 0.54, green: 0.66, blue: 0.47)
            }
        }
    }

    var id: String
    var schedule: ScheduleKind
    var owner: FamilyMember
    var startMinutes: Int
    var endMinutes: Int
    var title: String
    var note: String
    var category: Category

    var minutes: Int { max(0, endMinutes - startMinutes) }
    var start: String { Self.timeFormatter.string(from: date(minutes: startMinutes)) }
    var end: String { Self.timeFormatter.string(from: date(minutes: endMinutes)) }

    var durationText: String {
        let hours = minutes / 60
        let remainder = minutes % 60
        if hours == 0 { return "\(minutes) min" }
        if remainder == 0 { return "\(hours) hr" }
        return "\(hours) hr \(remainder) min"
    }

    static func draft(for schedule: ScheduleKind) -> RoutineItem {
        RoutineItem(
            id: UUID().uuidString,
            schedule: schedule,
            owner: .shared,
            startMinutes: 9 * 60,
            endMinutes: 9 * 60 + 30,
            title: "",
            note: "",
            category: .family
        )
    }

    private func date(minutes: Int) -> Date {
        Calendar.current.date(from: DateComponents(hour: minutes / 60, minute: minutes % 60)) ?? .now
    }

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

struct ScheduleConflict: Identifiable, Equatable {
    let owner: FamilyMember
    let firstTitle: String
    let secondTitle: String

    var id: String { "\(owner.rawValue)-\(firstTitle)-\(secondTitle)" }
    var message: String { "\(owner.title) is double-booked: \(firstTitle) and \(secondTitle)." }
}

enum ScheduleValidator {
    static func conflicts(in items: [RoutineItem], schedule: ScheduleKind) -> [ScheduleConflict] {
        let scheduled = items.filter { $0.schedule == schedule && $0.endMinutes > $0.startMinutes }
        var results: [ScheduleConflict] = []

        for owner in [FamilyMember.mum, .dad] {
            let owned = scheduled
                .filter { $0.owner == owner || $0.owner == .shared }
                .sorted { $0.startMinutes < $1.startMinutes }

            for index in owned.indices {
                for laterIndex in owned.index(after: index)..<owned.endIndex {
                    let first = owned[index]
                    let second = owned[laterIndex]
                    if second.startMinutes >= first.endMinutes { break }
                    results.append(.init(owner: owner, firstTitle: first.title, secondTitle: second.title))
                }
            }
        }
        return results
    }
}
