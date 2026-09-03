import Charts
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: RoutineStore
    @State private var schedule: ScheduleKind = .weekday
    @State private var owner: FamilyMember?
    @State private var editingItem: RoutineItem?

    private var visibleItems: [RoutineItem] {
        store.items(for: schedule, owner: owner)
    }

    private var scheduleItems: [RoutineItem] {
        store.items(for: schedule)
    }

    private var completedCount: Int {
        scheduleItems.filter(store.isCompleted).count
    }

    private var progress: Double {
        guard !scheduleItems.isEmpty else { return 0 }
        return Double(completedCount) / Double(scheduleItems.count)
    }

    private var categoryTotals: [(category: RoutineItem.Category, minutes: Int)] {
        RoutineItem.Category.allCases.map { category in
            (category, scheduleItems.filter { $0.category == category }.reduce(0) { $0 + $1.minutes })
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    hero
                    schedulePicker
                    ownerFilters

                    if !store.conflicts(for: schedule).isEmpty {
                        conflictCard
                    }

                    allocation

                    LazyVStack(spacing: 12) {
                        ForEach(visibleItems) { item in
                            RoutineRow(
                                item: item,
                                moveUp: { store.move(item, direction: -1) },
                                moveDown: { store.move(item, direction: 1) },
                                edit: { editingItem = item }
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Family rhythm")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Reset today's progress") {
                            store.resetCompletion(for: schedule)
                        }
                        Button("Restore family templates", role: .destructive) {
                            store.restoreTemplates()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .accessibilityLabel("Routine options")
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editingItem = .draft(for: schedule)
                    } label: {
                        Label("Add activity", systemImage: "plus")
                    }
                }
            }
        }
        .tint(Color(red: 0.19, green: 0.37, blue: 0.39))
        .sheet(item: $editingItem) { item in
            ActivityEditor(item: item) { updated in
                store.save(updated)
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("\(schedule.title.uppercased()) · MELBOURNE")
                .font(.caption.bold())
                .tracking(1.4)
                .foregroundStyle(.white.opacity(0.72))
            Text("Make the family plan\nwork for everyone.")
                .font(.system(.largeTitle, design: .serif, weight: .medium))
            Text("See who owns each part of the day, adjust the plan, and notice clashes before they become stress.")
                .foregroundStyle(.white.opacity(0.78))
            ProgressView(value: progress).tint(.orange)
            Text("\(completedCount) of \(scheduleItems.count) moments complete")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.72))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(Color(red: 0.13, green: 0.30, blue: 0.31), in: RoundedRectangle(cornerRadius: 24))
        .foregroundStyle(.white)
    }

    private var schedulePicker: some View {
        Picker("Schedule", selection: $schedule) {
            ForEach(ScheduleKind.allCases) { kind in
                Text(kind.title).tag(kind)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: schedule) {
            owner = nil
        }
    }

    private var ownerFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                filterButton("Everyone", member: nil, image: "person.3.fill")
                ForEach(FamilyMember.allCases) { member in
                    filterButton(member.title, member: member, image: member.systemImage)
                }
            }
        }
        .accessibilityLabel("Filter family members")
    }

    private func filterButton(_ title: String, member: FamilyMember?, image: String) -> some View {
        Button {
            owner = member
        } label: {
            Label(title, systemImage: image)
        }
        .buttonStyle(.borderedProminent)
        .tint(owner == member ? Color(red: 0.19, green: 0.37, blue: 0.39) : Color(.tertiarySystemFill))
        .foregroundStyle(owner == member ? .white : .primary)
        .clipShape(Capsule())
    }

    private var conflictCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Schedule needs attention", systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundStyle(.orange)

            ForEach(store.conflicts(for: schedule)) { conflict in
                Text(conflict.message)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 18))
        .accessibilityElement(children: .combine)
    }

    private var allocation: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Time allocation").font(.title2.bold())
            Chart(categoryTotals, id: \.category) { item in
                SectorMark(
                    angle: .value("Minutes", item.minutes),
                    innerRadius: .ratio(0.62),
                    angularInset: 2
                )
                .foregroundStyle(item.category.color)
                .cornerRadius(5)
            }
            .frame(height: 190)
            .chartLegend(.hidden)
            .accessibilityLabel("Time allocation by category")

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

    private func duration(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainder = minutes % 60
        if hours == 0 { return "\(remainder)m" }
        return remainder == 0 ? "\(hours)h" : "\(hours)h \(remainder)m"
    }
}

private struct RoutineRow: View {
    @EnvironmentObject private var store: RoutineStore
    let item: RoutineItem
    let moveUp: () -> Void
    let moveDown: () -> Void
    let edit: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                withAnimation(.snappy) { store.toggle(item) }
            } label: {
                Image(systemName: store.isCompleted(item) ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(store.isCompleted(item) ? item.owner.color : .secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(store.isCompleted(item) ? "Mark incomplete" : "Mark complete")

            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text("\(item.start) – \(item.end)")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Spacer()
                    Label(item.owner.title, systemImage: item.owner.systemImage)
                        .font(.caption2.bold())
                        .foregroundStyle(item.owner.color)
                }

                Text(item.title)
                    .font(.headline)
                    .strikethrough(store.isCompleted(item))

                if !item.note.isEmpty {
                    Text(item.note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text("\(item.category.title) · \(item.durationText)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Menu {
                Button("Edit", systemImage: "pencil", action: edit)
                Button("Move earlier", systemImage: "arrow.up", action: moveUp)
                Button("Move later", systemImage: "arrow.down", action: moveDown)
                Button("Delete", systemImage: "trash", role: .destructive) {
                    store.delete(item)
                }
            } label: {
                Image(systemName: "ellipsis")
                    .frame(width: 32, height: 32)
            }
            .accessibilityLabel("Actions for \(item.title)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
        .opacity(store.isCompleted(item) ? 0.62 : 1)
        .accessibilityElement(children: .contain)
    }
}

private struct ActivityEditor: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: RoutineItem
    let onSave: (RoutineItem) -> Void

    init(item: RoutineItem, onSave: @escaping (RoutineItem) -> Void) {
        _draft = State(initialValue: item)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Activity") {
                    TextField("Title", text: $draft.title)
                    TextField("Notes", text: $draft.note, axis: .vertical)
                        .lineLimit(2...5)
                    Picker("Category", selection: $draft.category) {
                        ForEach(RoutineItem.Category.allCases) { category in
                            Text(category.title).tag(category)
                        }
                    }
                }

                Section("Family plan") {
                    Picker("Schedule", selection: $draft.schedule) {
                        ForEach(ScheduleKind.allCases) { schedule in
                            Text(schedule.title).tag(schedule)
                        }
                    }
                    Picker("Owner", selection: $draft.owner) {
                        ForEach(FamilyMember.allCases) { member in
                            Text(member.title).tag(member)
                        }
                    }
                }

                Section("Time") {
                    DatePicker("Starts", selection: startBinding, displayedComponents: .hourAndMinute)
                    DatePicker("Ends", selection: endBinding, displayedComponents: .hourAndMinute)

                    if draft.endMinutes <= draft.startMinutes {
                        Label("End time must be later than start time.", systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(draft.title.isEmpty ? "New activity" : "Edit activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        draft.title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
                        onSave(draft)
                        dismiss()
                    }
                    .disabled(draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || draft.endMinutes <= draft.startMinutes)
                }
            }
        }
    }

    private var startBinding: Binding<Date> {
        Binding(
            get: { date(minutes: draft.startMinutes) },
            set: { draft.startMinutes = minutes(date: $0) }
        )
    }

    private var endBinding: Binding<Date> {
        Binding(
            get: { date(minutes: draft.endMinutes) },
            set: { draft.endMinutes = minutes(date: $0) }
        )
    }

    private func date(minutes: Int) -> Date {
        Calendar.current.date(from: DateComponents(hour: minutes / 60, minute: minutes % 60)) ?? .now
    }

    private func minutes(date: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        return (components.hour ?? 0) * 60 + (components.minute ?? 0)
    }
}

#Preview {
    DashboardView().environmentObject(RoutineStore())
}
