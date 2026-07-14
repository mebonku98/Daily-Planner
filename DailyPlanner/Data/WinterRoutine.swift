import Foundation

enum WinterRoutine {
    static let items: [RoutineItem] = [
        .init(id: "wake", start: "7:30 AM", end: "7:40 AM", title: "Wake gently", note: "Open the curtains, hydrate, and begin after sunrise.", minutes: 10, category: .morning),
        .init(id: "ready", start: "7:40 AM", end: "8:10 AM", title: "Get ready + breakfast", note: "A simple breakfast and an unhurried start.", minutes: 30, category: .morning),
        .init(id: "prep", start: "8:10 AM", end: "8:40 AM", title: "Final preparation", note: "Pack essentials and prepare to leave after the kids' drop-off.", minutes: 30, category: .morning),
        .init(id: "commute-in", start: "8:40 AM", end: "9:00 AM", title: "Commute to work", note: "Use the transition for music, a podcast, or quiet.", minutes: 20, category: .work),
        .init(id: "work-am", start: "9:00 AM", end: "12:00 PM", title: "Focused work", note: "Protect this block for your highest-value iOS work.", minutes: 180, category: .work),
        .init(id: "lunch", start: "12:00 PM", end: "12:30 PM", title: "Lunch break", note: "Eat away from the desk and reset.", minutes: 30, category: .personal),
        .init(id: "work-pm", start: "12:30 PM", end: "4:40 PM", title: "Work + wrap-up", note: "Write tomorrow's first step before leaving.", minutes: 250, category: .work),
        .init(id: "commute-home", start: "4:40 PM", end: "5:00 PM", title: "Commute home", note: "Close the workday and arrive by 5:00 PM.", minutes: 20, category: .work),
        .init(id: "reconnect", start: "5:00 PM", end: "5:15 PM", title: "Reconnect", note: "Greet the kids, change, and have a quick snack.", minutes: 15, category: .family),
        .init(id: "bath", start: "5:15 PM", end: "5:45 PM", title: "Kids' bath time", note: "Freshen up after school and daycare.", minutes: 30, category: .family),
        .init(id: "study", start: "5:45 PM", end: "6:30 PM", title: "Study + reading", note: "Homework with your son; a quiet activity for your daughter.", minutes: 45, category: .family),
        .init(id: "creative", start: "6:30 PM", end: "7:00 PM", title: "Creative pocket", note: "Rotate embroidery, sewing practice, and home design.", minutes: 30, category: .personal),
        .init(id: "dinner", start: "7:00 PM", end: "7:30 PM", title: "Family dinner", note: "Dinner is prepared by your husband; enjoy it together.", minutes: 30, category: .family),
        .init(id: "bedtime", start: "7:30 PM", end: "8:30 PM", title: "Kids' bedtime", note: "Wind down, share stories, and settle both children.", minutes: 60, category: .family),
        .init(id: "restore", start: "8:30 PM", end: "9:15 PM", title: "Restore yourself", note: "Choose creativity, reading, or simply rest.", minutes: 45, category: .personal),
        .init(id: "sleep", start: "9:15 PM", end: "9:30 PM", title: "Bedtime routine", note: "Prepare for sleep and protect tomorrow's energy.", minutes: 15, category: .personal)
    ]
}
