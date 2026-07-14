import Foundation
import SwiftUI

struct RoutineItem: Identifiable, Hashable {
    enum Category: String, CaseIterable, Identifiable {
        case morning, work, family, personal

        var id: String { rawValue }

        var title: String {
            switch self {
            case .morning: "Morning"
            case .work: "Work & travel"
            case .family: "Family care"
            case .personal: "You"
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

    let id: String
    let start: String
    let end: String
    let title: String
    let note: String
    let minutes: Int
    let category: Category

    var durationText: String {
        let hours = minutes / 60
        let remainder = minutes % 60
        if hours == 0 { return "\(minutes) min" }
        if remainder == 0 { return "\(hours) hr" }
        return "\(hours) hr \(remainder) min"
    }
}
