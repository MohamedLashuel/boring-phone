import Foundation

/// Every task is marked done by hand; completion is just membership in the marked set.
public enum TaskCompletion {
    public static func isComplete(_ task: GuideTask, markedDone: Set<String>) -> Bool {
        markedDone.contains(task.id)
    }

    public static func toggling(_ id: String, in markedDone: Set<String>, to done: Bool) -> Set<String> {
        done ? markedDone.union([id]) : markedDone.subtracting([id])
    }
}
