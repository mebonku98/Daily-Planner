import Charts
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: RoutineStore
    @State private var selection: RoutineItem.Category?

    private var visibleItems: [RoutineItem] {
        guard let selection else { return WinterRoutine.items }
        return WinterRoutine.items.filter { $0.category == selection }
    }

    private var categoryTotals: [(category: RoutineItem.Category, minutes: Int)] {
        RoutineItem.Category.allCases.map { category in
            (category, WinterRoutine.items.filter { $0.category == category }.reduce(0) { $0 + $1.minutes })
        }
    }

    private var progress: Double {
        Double(store.completedIDs.count) / Double(WinterRoutine.items.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    hero
                    allocation
                    filters
                    LazyVStack(spacing: 12) {
                        ForEach(visibleItems) { RoutineRow(item: $0) }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Daylight")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset", action: store.reset)
                        .disabled(store.completedIDs.isEmpty)
                }
            }
        }
        .tint(Color(red: 0.19, green: 0.37, blue: 0.39))
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("WINTER WEEKDAY · MELBOURNE")
                .font(.caption.bold())
                .tracking(1.4)
                .foregroundStyle(.white.opacity(0.72))
            Text("A routine that begins\nwith the sun.")
                .font(.system(.largeTitle, design: .serif, weight: .medium))
            Text("A realistic rhythm for focused work, caring for your children, and making room for the creative life you're building.")
                .foregroundStyle(.white.opacity(0.78))
            ProgressView(value: progress).tint(.orange)
            Text("\(store.completedIDs.count) of \(WinterRoutine.items.count) moments complete")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.72))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(Color(red: 0.13, green: 0.30, blue: 0.31), in: RoundedRectangle(cornerRadius: 24))
        .foregroundStyle(.white)
    }

    private var allocation: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Time allocation").font(.title2.bold())
            Chart(categoryTotals, id: \.category) { item in
                SectorMark(angle: .value("Minutes", item.minutes), innerRadius: .ratio(0.62), angularInset: 2)
                    .foregroundStyle(item.category.color)
                    .cornerRadius(5)
            }
            .frame(height: 210)
            .chartLegend(.hidden)
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], alignment: .leading) {
                ForEach(categoryTotals, id: \.category) { item in
                    HStack {
                        Circle().fill(item.category.color).frame(width: 8, height: 8)
                        Text(item.category.title).font(.caption)
                        Spacer()
                        Text(duration(item.minutes)).font(.caption.bold())
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 22))
    }

    private var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                filterButton("All", category: nil)
                ForEach(RoutineItem.Category.allCases) { category in
                    filterButton(category.title, category: category)
                }
            }
        }
    }

    private func filterButton(_ title: String, category: RoutineItem.Category?) -> some View {
        Button(title) { selection = category }
            .buttonStyle(.borderedProminent)
            .tint(selection == category ? Color(red: 0.19, green: 0.37, blue: 0.39) : Color(.tertiarySystemFill))
            .foregroundStyle(selection == category ? .white : .primary)
            .clipShape(Capsule())
    }

    private func duration(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainder = minutes % 60
        return remainder == 0 ? "\(hours)h" : "\(hours)h \(remainder)m"
    }
}

private struct RoutineRow: View {
    @EnvironmentObject private var store: RoutineStore
    let item: RoutineItem

    var body: some View {
        Button {
            withAnimation(.snappy) { store.toggle(item) }
        } label: {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: store.isCompleted(item) ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(store.isCompleted(item) ? item.category.color : .secondary)
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(item.start) – \(item.end)")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Text(item.title).font(.headline).strikethrough(store.isCompleted(item))
                    Text(item.note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Text(item.durationText)
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(Color(.tertiarySystemFill), in: Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
            .opacity(store.isCompleted(item) ? 0.58 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(item.title), \(item.start) to \(item.end), \(item.durationText)")
        .accessibilityHint(store.isCompleted(item) ? "Marks this activity incomplete" : "Marks this activity complete")
    }
}

#Preview {
    DashboardView().environmentObject(RoutineStore())
}
