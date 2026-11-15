import BoringCore
import SwiftUI

/// Wires each tab's view to the stores it needs.
struct MainTabView: View {
    let content: AppContent
    let progress: ProgressStore
    let delays: AppDelayStore

    @State private var isShowingHelp = false

    var body: some View {
        TabView {
            guideTab
                .tabItem { Label("Guide", systemImage: "checklist") }
            delaysTab
                .tabItem { Label("App Delays", systemImage: "hourglass") }
            WidgetsView(library: content.widgets)
                .tabItem { Label("Widgets", systemImage: "square.text.square") }
            FeaturesView(articles: content.features.articles)
                .tabItem { Label("Features", systemImage: "book") }
        }
        .sheet(isPresented: $isShowingHelp) {
            OnboardingView(
                slides: content.onboarding.slides,
                finishTitle: "Done",
                onFinish: { isShowingHelp = false }
            )
        }
    }

    private func isComplete(_ task: GuideTask) -> Bool {
        TaskCompletion.isComplete(task, markedDone: progress.markedDone)
    }

    private var guideTab: some View {
        GuideView(
            groups: content.guide.groups,
            isComplete: isComplete,
            onHelp: { isShowingHelp = true }
        ) { task in
            TaskDetailView(
                task: task,
                isComplete: isComplete(task),
                onSetDone: { progress.setDone(task, to: $0) },
                onOpenSettings: task.opensSettings ? { SettingsLink.open() } : nil
            )
        }
    }

    private var delaysTab: some View {
        AppDelaysView(
            settings: delays.settings,
            authorization: delays.authorization,
            errorMessage: delays.lastError,
            targetApps: delays.targetApps,
            targetCategories: delays.targetCategories,
            excludedApps: delays.excludedApps,
            targets: Binding(get: { delays.targets }, set: delays.setTargets),
            exclusions: Binding(get: { delays.exclusions }, set: delays.setExclusions),
            onRequestAuthorization: { Task { await delays.requestAuthorization() } },
            onUpdate: delays.update
        )
    }
}
