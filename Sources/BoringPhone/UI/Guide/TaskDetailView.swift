import BoringCore
import SwiftUI

/// A task's walkthrough slideshow with completion and Settings shortcuts.
struct TaskDetailView: View {
    let task: GuideTask
    let isComplete: Bool
    let onSetDone: (Bool) -> Void
    /// Nil when the task has nothing to change in Settings.
    let onOpenSettings: (() -> Void)?

    var body: some View {
        SlideshowView(slides: task.slides) {
            VStack(spacing: 12) {
                completionControl
                onOpenSettings.map { open in
                    Button(action: open) {
                        Label("Open Settings", systemImage: "gear")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
            }
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var completionControl: some View {
        Button { onSetDone(!isComplete) } label: {
            Label(
                isComplete ? "Done — tap to undo" : "Mark as done",
                systemImage: isComplete ? "checkmark.circle.fill" : "circle"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}
