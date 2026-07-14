import SwiftUI

@main
struct DailyPlannerApp: App {
    @StateObject private var store = RoutineStore()

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(store)
        }
    }
}
