import BoringCore
import Foundation
import Observation

/// Onboarding and guide-task progress, persisted across launches.
@MainActor
@Observable
final class ProgressStore {
    private(set) var hasCompletedOnboarding: Bool
    private(set) var markedDone: Set<String>

    init() {
        hasCompletedOnboarding = StorageKeys.hasCompletedOnboarding.read()
        markedDone = StorageKeys.completedTaskIDs.read()
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        StorageKeys.hasCompletedOnboarding.write(true)
    }

    func setDone(_ task: GuideTask, to done: Bool) {
        markedDone = TaskCompletion.toggling(task.id, in: markedDone, to: done)
        StorageKeys.completedTaskIDs.write(markedDone)
    }
}
