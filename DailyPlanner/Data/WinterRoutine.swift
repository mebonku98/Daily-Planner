import Foundation

enum FamilyRoutine {
    static let items: [RoutineItem] = weekday + weekend

    static let weekday: [RoutineItem] = [
        item("weekday-dad-exercise", .weekday, .dad, 360, 390, "Morning exercise", "A short workout before the household wakes.", .personal),
        item("weekday-family-breakfast", .weekday, .shared, 450, 480, "Breakfast together", "Start the day connected and ready.", .morning),
        item("weekday-dad-dropoff", .weekday, .dad, 480, 520, "School + daycare drop-off", "Dad handles bags, lunchboxes, and drop-off by 8:30.", .family),
        item("weekday-mum-ready", .weekday, .mum, 480, 520, "Prepare for work", "Finish getting ready while Dad handles drop-off.", .morning),
        item("weekday-mum-commute-in", .weekday, .mum, 520, 540, "Commute to work", "Leave at 8:40 and arrive for a 9:00 start.", .work),
        item("weekday-mum-work", .weekday, .mum, 540, 1000, "iOS workday", "Seven focused hours plus a forty-minute lunch and reset.", .work),
        item("weekday-dad-work", .weekday, .dad, 540, 960, "Business analysis", "Protect focus time and finish in time for pickup.", .work),
        item("weekday-dad-pickup", .weekday, .dad, 960, 1020, "School + daycare pickup", "Dad brings both children home.", .family),
        item("weekday-mum-commute-home", .weekday, .mum, 1000, 1020, "Commute home", "Close the workday and arrive by 5:00.", .work),
        item("weekday-kids-bath", .weekday, .mum, 1035, 1065, "Kids' bath time", "Freshen up after school and daycare.", .family),
        item("weekday-study", .weekday, .mum, 1065, 1110, "Study + reading", "Homework with the eldest and a quiet activity for the youngest.", .family),
        item("weekday-dad-dinner", .weekday, .dad, 1020, 1110, "Prepare dinner", "Dad prepares a practical family meal.", .family),
        item("weekday-family-dinner", .weekday, .shared, 1110, 1150, "Family dinner", "Eat together and share the day's stories.", .family),
        item("weekday-bedtime", .weekday, .shared, 1150, 1210, "Kids' bedtime", "Stories, connection, and settling both children.", .family),
        item("weekday-mum-creative", .weekday, .mum, 1210, 1260, "Creative practice", "Rotate embroidery, sewing, and new-home planning.", .personal),
        item("weekday-dad-garden", .weekday, .dad, 1210, 1260, "Garden + reset", "Water, tend plants, or plan the garden.", .personal),
        item("weekday-wind-down", .weekday, .shared, 1260, 1320, "Wind down together", "Prepare for tomorrow and protect sleep.", .personal)
    ]

    static let weekend: [RoutineItem] = [
        item("weekend-slow-start", .weekend, .shared, 450, 510, "Slow family breakfast", "A calm start without the weekday rush.", .morning),
        item("weekend-dad-garden", .weekend, .dad, 510, 600, "Gardening", "A longer focused garden session.", .personal),
        item("weekend-mum-craft", .weekend, .mum, 510, 600, "Embroidery or sewing", "Protected creative practice while Dad gardens.", .personal),
        item("weekend-family-active", .weekend, .shared, 630, 750, "Cycling or swimming", "Build confidence and enjoy movement with the children.", .family),
        item("weekend-lunch", .weekend, .shared, 750, 810, "Lunch together", "Refuel and choose the afternoon rhythm.", .family),
        item("weekend-home-planning", .weekend, .mum, 840, 930, "New-home planning", "Review rooms, finishes, storage, and decorating decisions.", .personal),
        item("weekend-dad-exercise", .weekend, .dad, 840, 900, "Exercise", "A ride, run, swim, or strength session.", .personal),
        item("weekend-family-free", .weekend, .shared, 960, 1080, "Family free time", "Play, visit friends, or take a relaxed outing.", .family),
        item("weekend-dinner", .weekend, .dad, 1080, 1140, "Prepare dinner", "Dad cooks while the children wind down.", .family),
        item("weekend-bedtime", .weekend, .shared, 1140, 1230, "Dinner + bedtime", "Close the day together.", .family)
    ]

    private static func item(
        _ id: String,
        _ schedule: ScheduleKind,
        _ owner: FamilyMember,
        _ start: Int,
        _ end: Int,
        _ title: String,
        _ note: String,
        _ category: RoutineItem.Category
    ) -> RoutineItem {
        .init(
            id: id,
            schedule: schedule,
            owner: owner,
            startMinutes: start,
            endMinutes: end,
            title: title,
            note: note,
            category: category
        )
    }
}
