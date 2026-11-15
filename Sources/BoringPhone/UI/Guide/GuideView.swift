import BoringCore
import SwiftUI

/// Tab 1: tasks grouped by topic.
struct GuideView<Detail: View>: View {
    let groups: [TaskGroup]
    let isComplete: (GuideTask) -> Bool
    let onHelp: () -> Void
    @ViewBuilder let detail: (GuideTask) -> Detail

    var body: some View {
        NavigationStack {
            List(groups) { group in
                Section(group.title) {
                    ForEach(group.tasks) { task in
                        NavigationLink(value: task) {
                            TaskRow(task: task, isComplete: isComplete(task))
                        }
                    }
                }
            }
            .navigationTitle("Guide")
            .navigationDestination(for: GuideTask.self, destination: detail)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Help", systemImage: "questionmark.circle", action: onHelp)
                }
            }
        }
    }
}

struct TaskRow: View {
    let task: GuideTask
    let isComplete: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: task.symbol)
                .frame(width: 28)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                Text(task.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isComplete ? Color.accentColor : Color.secondary)
                .accessibilityLabel(isComplete ? "Done" : "Not done")
        }
    }
}
